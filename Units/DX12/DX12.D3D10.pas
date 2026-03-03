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
   this ALWAYS GENERATED file contains the definitions for the interfaces

   This unit consists of the following header files
   File name: d3d10.h
   Header version: 10.0.26100.6584

  ************************************************************************** }
unit DX12.D3D10;


{$IFDEF FPC}
{$mode delphiunicode}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}
{$ENDIF}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCommon,
    DX12.DXGI,
    DX12.DXGICommon,
    DX12.DXGIFormat;

    {$Z4}

const

    IID_ID3D10DeviceChild: TGUID = '{9B7E4C00-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10DepthStencilState: TGUID = '{2B4B1CC8-A4AD-41F8-8322-CA86FC3EC675}';
    IID_ID3D10BlendState: TGUID = '{EDAD8D19-8A35-4D6D-8566-2EA276CDE161}';
    IID_ID3D10RasterizerState: TGUID = '{A2A07292-89AF-4345-BE2E-C53D9FBB6E9F}';
    IID_ID3D10Resource: TGUID = '{9B7E4C01-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10Buffer: TGUID = '{9B7E4C02-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10Texture1D: TGUID = '{9B7E4C03-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10Texture2D: TGUID = '{9B7E4C04-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10Texture3D: TGUID = '{9B7E4C05-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10View: TGUID = '{C902B03F-60A7-49BA-9936-2A3AB37A7E33}';
    IID_ID3D10ShaderResourceView: TGUID = '{9B7E4C07-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10RenderTargetView: TGUID = '{9B7E4C08-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10DepthStencilView: TGUID = '{9B7E4C09-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10VertexShader: TGUID = '{9B7E4C0A-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10GeometryShader: TGUID = '{6316BE88-54CD-4040-AB44-20461BC81F68}';
    IID_ID3D10PixelShader: TGUID = '{4968B601-9D00-4CDE-8346-8E7F675819B6}';
    IID_ID3D10InputLayout: TGUID = '{9B7E4C0B-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10SamplerState: TGUID = '{9B7E4C0C-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10Asynchronous: TGUID = '{9B7E4C0D-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10Query: TGUID = '{9B7E4C0E-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10Predicate: TGUID = '{9B7E4C10-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10Counter: TGUID = '{9B7E4C11-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10Device: TGUID = '{9B7E4C0F-342C-4106-A19F-4F2704F689F0}';
    IID_ID3D10Multithread: TGUID = '{9B7E4E00-342C-4106-A19F-4F2704F689F0}';


    D3D10_16BIT_INDEX_STRIP_CUT_VALUE = ($ffff);

    D3D10_32BIT_INDEX_STRIP_CUT_VALUE = ($ffffffff);

    D3D10_8BIT_INDEX_STRIP_CUT_VALUE = ($ff);

    D3D10_ARRAY_AXIS_ADDRESS_RANGE_BIT_COUNT = (9);

    D3D10_CLIP_OR_CULL_DISTANCE_COUNT = (8);

    D3D10_CLIP_OR_CULL_DISTANCE_ELEMENT_COUNT = (2);

    D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT = (14);

    D3D10_COMMONSHADER_CONSTANT_BUFFER_COMPONENTS = (4);

    D3D10_COMMONSHADER_CONSTANT_BUFFER_COMPONENT_BIT_COUNT = (32);

    D3D10_COMMONSHADER_CONSTANT_BUFFER_HW_SLOT_COUNT = (15);

    D3D10_COMMONSHADER_CONSTANT_BUFFER_REGISTER_COMPONENTS = (4);

    D3D10_COMMONSHADER_CONSTANT_BUFFER_REGISTER_COUNT = (15);

    D3D10_COMMONSHADER_CONSTANT_BUFFER_REGISTER_READS_PER_INST = (1);

    D3D10_COMMONSHADER_CONSTANT_BUFFER_REGISTER_READ_PORTS = (1);

    D3D10_COMMONSHADER_FLOWCONTROL_NESTING_LIMIT = (64);

    D3D10_COMMONSHADER_IMMEDIATE_CONSTANT_BUFFER_REGISTER_COMPONENTS = (4);

    D3D10_COMMONSHADER_IMMEDIATE_CONSTANT_BUFFER_REGISTER_COUNT = (1);

    D3D10_COMMONSHADER_IMMEDIATE_CONSTANT_BUFFER_REGISTER_READS_PER_INST = (1);

    D3D10_COMMONSHADER_IMMEDIATE_CONSTANT_BUFFER_REGISTER_READ_PORTS = (1);

    D3D10_COMMONSHADER_IMMEDIATE_VALUE_COMPONENT_BIT_COUNT = (32);

    D3D10_COMMONSHADER_INPUT_RESOURCE_REGISTER_COMPONENTS = (1);

    D3D10_COMMONSHADER_INPUT_RESOURCE_REGISTER_COUNT = (128);

    D3D10_COMMONSHADER_INPUT_RESOURCE_REGISTER_READS_PER_INST = (1);

    D3D10_COMMONSHADER_INPUT_RESOURCE_REGISTER_READ_PORTS = (1);

    D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT = (128);

    D3D10_COMMONSHADER_SAMPLER_REGISTER_COMPONENTS = (1);

    D3D10_COMMONSHADER_SAMPLER_REGISTER_COUNT = (16);

    D3D10_COMMONSHADER_SAMPLER_REGISTER_READS_PER_INST = (1);

    D3D10_COMMONSHADER_SAMPLER_REGISTER_READ_PORTS = (1);

    D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT = (16);

    D3D10_COMMONSHADER_SUBROUTINE_NESTING_LIMIT = (32);

    D3D10_COMMONSHADER_TEMP_REGISTER_COMPONENTS = (4);

    D3D10_COMMONSHADER_TEMP_REGISTER_COMPONENT_BIT_COUNT = (32);

    D3D10_COMMONSHADER_TEMP_REGISTER_COUNT = (4096);

    D3D10_COMMONSHADER_TEMP_REGISTER_READS_PER_INST = (3);

    D3D10_COMMONSHADER_TEMP_REGISTER_READ_PORTS = (3);

    D3D10_COMMONSHADER_TEXCOORD_RANGE_REDUCTION_MAX = (10);

    D3D10_COMMONSHADER_TEXCOORD_RANGE_REDUCTION_MIN = (-10);

    D3D10_COMMONSHADER_TEXEL_OFFSET_MAX_NEGATIVE = (-8);

    D3D10_COMMONSHADER_TEXEL_OFFSET_MAX_POSITIVE = (7);

    D3D10_DEFAULT_BLEND_FACTOR_ALPHA = (1.0);
    D3D10_DEFAULT_BLEND_FACTOR_BLUE = (1.0);
    D3D10_DEFAULT_BLEND_FACTOR_GREEN = (1.0);
    D3D10_DEFAULT_BLEND_FACTOR_RED = (1.0);
    D3D10_DEFAULT_BORDER_COLOR_COMPONENT = (0.0);
    D3D10_DEFAULT_DEPTH_BIAS = (0);

    D3D10_DEFAULT_DEPTH_BIAS_CLAMP = (0.0);
    D3D10_DEFAULT_MAX_ANISOTROPY = (16.0);
    D3D10_DEFAULT_MIP_LOD_BIAS = (0.0);
    D3D10_DEFAULT_RENDER_TARGET_ARRAY_INDEX = (0);

    D3D10_DEFAULT_SAMPLE_MASK = ($ffffffff);

    D3D10_DEFAULT_SCISSOR_ENDX = (0);

    D3D10_DEFAULT_SCISSOR_ENDY = (0);

    D3D10_DEFAULT_SCISSOR_STARTX = (0);

    D3D10_DEFAULT_SCISSOR_STARTY = (0);

    D3D10_DEFAULT_SLOPE_SCALED_DEPTH_BIAS = (0.0);
    D3D10_DEFAULT_STENCIL_READ_MASK = ($ff);

    D3D10_DEFAULT_STENCIL_REFERENCE = (0);

    D3D10_DEFAULT_STENCIL_WRITE_MASK = ($ff);

    D3D10_DEFAULT_VIEWPORT_AND_SCISSORRECT_INDEX = (0);

    D3D10_DEFAULT_VIEWPORT_HEIGHT = (0);

    D3D10_DEFAULT_VIEWPORT_MAX_DEPTH = (0.0);
    D3D10_DEFAULT_VIEWPORT_MIN_DEPTH = (0.0);
    D3D10_DEFAULT_VIEWPORT_TOPLEFTX = (0);

    D3D10_DEFAULT_VIEWPORT_TOPLEFTY = (0);

    D3D10_DEFAULT_VIEWPORT_WIDTH = (0);

    D3D10_FLOAT16_FUSED_TOLERANCE_IN_ULP = (0.6);
    D3D10_FLOAT32_MAX = (3.402823466e+38);
    D3D10_FLOAT32_TO_INTEGER_TOLERANCE_IN_ULP = (0.6);
    D3D10_FLOAT_TO_SRGB_EXPONENT_DENOMINATOR = (2.4);
    D3D10_FLOAT_TO_SRGB_EXPONENT_NUMERATOR = (1.0);
    D3D10_FLOAT_TO_SRGB_OFFSET = (0.055);
    D3D10_FLOAT_TO_SRGB_SCALE_1 = (12.92);
    D3D10_FLOAT_TO_SRGB_SCALE_2 = (1.055);
    D3D10_FLOAT_TO_SRGB_THRESHOLD = (0.0031308);
    D3D10_FTOI_INSTRUCTION_MAX_INPUT = (2147483647.999);
    D3D10_FTOI_INSTRUCTION_MIN_INPUT = (-2147483648.999);
    D3D10_FTOU_INSTRUCTION_MAX_INPUT = (4294967295.999);
    D3D10_FTOU_INSTRUCTION_MIN_INPUT = (0.0);
    D3D10_GS_INPUT_PRIM_CONST_REGISTER_COMPONENTS = (1);

    D3D10_GS_INPUT_PRIM_CONST_REGISTER_COMPONENT_BIT_COUNT = (32);

    D3D10_GS_INPUT_PRIM_CONST_REGISTER_COUNT = (1);

    D3D10_GS_INPUT_PRIM_CONST_REGISTER_READS_PER_INST = (2);

    D3D10_GS_INPUT_PRIM_CONST_REGISTER_READ_PORTS = (1);

    D3D10_GS_INPUT_REGISTER_COMPONENTS = (4);

    D3D10_GS_INPUT_REGISTER_COMPONENT_BIT_COUNT = (32);

    D3D10_GS_INPUT_REGISTER_COUNT = (16);

    D3D10_GS_INPUT_REGISTER_READS_PER_INST = (2);

    D3D10_GS_INPUT_REGISTER_READ_PORTS = (1);

    D3D10_GS_INPUT_REGISTER_VERTICES = (6);

    D3D10_GS_OUTPUT_ELEMENTS = (32);

    D3D10_GS_OUTPUT_REGISTER_COMPONENTS = (4);

    D3D10_GS_OUTPUT_REGISTER_COMPONENT_BIT_COUNT = (32);

    D3D10_GS_OUTPUT_REGISTER_COUNT = (32);

    D3D10_IA_DEFAULT_INDEX_BUFFER_OFFSET_IN_BYTES = (0);

    D3D10_IA_DEFAULT_PRIMITIVE_TOPOLOGY = (0);

    D3D10_IA_DEFAULT_VERTEX_BUFFER_OFFSET_IN_BYTES = (0);

    D3D10_IA_INDEX_INPUT_RESOURCE_SLOT_COUNT = (1);

    D3D10_IA_INSTANCE_ID_BIT_COUNT = (32);

    D3D10_IA_INTEGER_ARITHMETIC_BIT_COUNT = (32);

    D3D10_IA_PRIMITIVE_ID_BIT_COUNT = (32);

    D3D10_IA_VERTEX_ID_BIT_COUNT = (32);

    D3D10_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT = (16);

    D3D10_IA_VERTEX_INPUT_STRUCTURE_ELEMENTS_COMPONENTS = (64);

    D3D10_IA_VERTEX_INPUT_STRUCTURE_ELEMENT_COUNT = (16);

    D3D10_1_IA_VERTEX_INPUT_STRUCTURE_ELEMENT_COUNT = D3D10_IA_VERTEX_INPUT_STRUCTURE_ELEMENT_COUNT;
    D3D10_1_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT = D3D10_IA_VERTEX_INPUT_STRUCTURE_ELEMENT_COUNT;

    D3D10_INTEGER_DIVIDE_BY_ZERO_QUOTIENT = ($ffffffff);

    D3D10_INTEGER_DIVIDE_BY_ZERO_REMAINDER = ($ffffffff);

    D3D10_LINEAR_GAMMA = (1.0);
    D3D10_MAX_BORDER_COLOR_COMPONENT = (1.0);
    D3D10_MAX_DEPTH = (1.0);
    D3D10_MAX_MAXANISOTROPY = (16);

    D3D10_MAX_MULTISAMPLE_SAMPLE_COUNT = (32);

    D3D10_MAX_POSITION_VALUE = (3.402823466e+34);
    D3D10_MAX_TEXTURE_DIMENSION_2_TO_EXP = (17);

    D3D10_MIN_BORDER_COLOR_COMPONENT = (0.0);
    D3D10_MIN_DEPTH = (0.0);
    D3D10_MIN_MAXANISOTROPY = (0);

    D3D10_MIP_LOD_BIAS_MAX = (15.99);
    D3D10_MIP_LOD_BIAS_MIN = (-16.0);
    D3D10_MIP_LOD_FRACTIONAL_BIT_COUNT = (6);

    D3D10_MIP_LOD_RANGE_BIT_COUNT = (8);

    D3D10_MULTISAMPLE_ANTIALIAS_LINE_WIDTH = (1.4);
    D3D10_NONSAMPLE_FETCH_OUT_OF_RANGE_ACCESS_RESULT = (0);

    D3D10_PIXEL_ADDRESS_RANGE_BIT_COUNT = (13);

    D3D10_PRE_SCISSOR_PIXEL_ADDRESS_RANGE_BIT_COUNT = (15);

    D3D10_PS_FRONTFACING_DEFAULT_VALUE = ($ffffffff);

    D3D10_PS_FRONTFACING_FALSE_VALUE = (0);

    D3D10_PS_FRONTFACING_TRUE_VALUE = ($ffffffff);

    D3D10_PS_INPUT_REGISTER_COMPONENTS = (4);

    D3D10_PS_INPUT_REGISTER_COMPONENT_BIT_COUNT = (32);

    D3D10_PS_INPUT_REGISTER_COUNT = (32);

    D3D10_PS_INPUT_REGISTER_READS_PER_INST = (2);

    D3D10_PS_INPUT_REGISTER_READ_PORTS = (1);

    D3D10_PS_LEGACY_PIXEL_CENTER_FRACTIONAL_COMPONENT = (0.0);
    D3D10_PS_OUTPUT_DEPTH_REGISTER_COMPONENTS = (1);

    D3D10_PS_OUTPUT_DEPTH_REGISTER_COMPONENT_BIT_COUNT = (32);

    D3D10_PS_OUTPUT_DEPTH_REGISTER_COUNT = (1);

    D3D10_PS_OUTPUT_REGISTER_COMPONENTS = (4);

    D3D10_PS_OUTPUT_REGISTER_COMPONENT_BIT_COUNT = (32);

    D3D10_PS_OUTPUT_REGISTER_COUNT = (8);

    D3D10_PS_PIXEL_CENTER_FRACTIONAL_COMPONENT = (0.5);
    D3D10_REQ_BLEND_OBJECT_COUNT_PER_CONTEXT = (4096);

    D3D10_REQ_BUFFER_RESOURCE_TEXEL_COUNT_2_TO_EXP = (27);

    D3D10_REQ_CONSTANT_BUFFER_ELEMENT_COUNT = (4096);

    D3D10_REQ_DEPTH_STENCIL_OBJECT_COUNT_PER_CONTEXT = (4096);

    D3D10_REQ_DRAWINDEXED_INDEX_COUNT_2_TO_EXP = (32);

    D3D10_REQ_DRAW_VERTEX_COUNT_2_TO_EXP = (32);

    D3D10_REQ_FILTERING_HW_ADDRESSABLE_RESOURCE_DIMENSION = (8192);

    D3D10_REQ_GS_INVOCATION_32BIT_OUTPUT_COMPONENT_LIMIT = (1024);

    D3D10_REQ_IMMEDIATE_CONSTANT_BUFFER_ELEMENT_COUNT = (4096);

    D3D10_REQ_MAXANISOTROPY = (16);

    D3D10_REQ_MIP_LEVELS = (14);

    D3D10_REQ_MULTI_ELEMENT_STRUCTURE_SIZE_IN_BYTES = (2048);

    D3D10_REQ_RASTERIZER_OBJECT_COUNT_PER_CONTEXT = (4096);

    D3D10_REQ_RENDER_TO_BUFFER_WINDOW_WIDTH = (8192);

    D3D10_REQ_RESOURCE_SIZE_IN_MEGABYTES = (128);

    D3D10_REQ_RESOURCE_VIEW_COUNT_PER_CONTEXT_2_TO_EXP = (20);

    D3D10_REQ_SAMPLER_OBJECT_COUNT_PER_CONTEXT = (4096);

    D3D10_REQ_TEXTURE1D_ARRAY_AXIS_DIMENSION = (512);

    D3D10_REQ_TEXTURE1D_U_DIMENSION = (8192);

    D3D10_REQ_TEXTURE2D_ARRAY_AXIS_DIMENSION = (512);

    D3D10_REQ_TEXTURE2D_U_OR_V_DIMENSION = (8192);

    D3D10_REQ_TEXTURE3D_U_V_OR_W_DIMENSION = (2048);

    D3D10_REQ_TEXTURECUBE_DIMENSION = (8192);

    D3D10_RESINFO_INSTRUCTION_MISSING_COMPONENT_RETVAL = (0);

    D3D10_SHADER_MAJOR_VERSION = (4);

    D3D10_SHADER_MINOR_VERSION = (0);

    D3D10_SHIFT_INSTRUCTION_PAD_VALUE = (0);

    D3D10_SHIFT_INSTRUCTION_SHIFT_VALUE_BIT_COUNT = (5);

    D3D10_SIMULTANEOUS_RENDER_TARGET_COUNT = (8);

    D3D10_SO_BUFFER_MAX_STRIDE_IN_BYTES = (2048);

    D3D10_SO_BUFFER_MAX_WRITE_WINDOW_IN_BYTES = (256);

    D3D10_SO_BUFFER_SLOT_COUNT = (4);

    D3D10_SO_DDI_REGISTER_INDEX_DENOTING_GAP = ($ffffffff);

    D3D10_SO_MULTIPLE_BUFFER_ELEMENTS_PER_BUFFER = (1);

    D3D10_SO_SINGLE_BUFFER_COMPONENT_LIMIT = (64);

    D3D10_SRGB_GAMMA = (2.2);
    D3D10_SRGB_TO_FLOAT_DENOMINATOR_1 = (12.92);
    D3D10_SRGB_TO_FLOAT_DENOMINATOR_2 = (1.055);
    D3D10_SRGB_TO_FLOAT_EXPONENT = (2.4);
    D3D10_SRGB_TO_FLOAT_OFFSET = (0.055);
    D3D10_SRGB_TO_FLOAT_THRESHOLD = (0.04045);
    D3D10_SRGB_TO_FLOAT_TOLERANCE_IN_ULP = (0.5);
    D3D10_STANDARD_COMPONENT_BIT_COUNT = (32);

    D3D10_STANDARD_COMPONENT_BIT_COUNT_DOUBLED = (64);

    D3D10_STANDARD_MAXIMUM_ELEMENT_ALIGNMENT_BYTE_MULTIPLE = (4);

    D3D10_STANDARD_PIXEL_COMPONENT_COUNT = (128);

    D3D10_STANDARD_PIXEL_ELEMENT_COUNT = (32);

    D3D10_STANDARD_VECTOR_SIZE = (4);

    D3D10_STANDARD_VERTEX_ELEMENT_COUNT = (16);

    D3D10_STANDARD_VERTEX_TOTAL_COMPONENT_COUNT = (64);

    D3D10_SUBPIXEL_FRACTIONAL_BIT_COUNT = (8);

    D3D10_SUBTEXEL_FRACTIONAL_BIT_COUNT = (6);

    D3D10_TEXEL_ADDRESS_RANGE_BIT_COUNT = (18);

    D3D10_UNBOUND_MEMORY_ACCESS_RESULT = (0);

    D3D10_VIEWPORT_AND_SCISSORRECT_MAX_INDEX = (15);

    D3D10_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE = (16);

    D3D10_VIEWPORT_BOUNDS_MAX = (16383);

    D3D10_VIEWPORT_BOUNDS_MIN = (-16384);

    D3D10_VS_INPUT_REGISTER_COMPONENTS = (4);

    D3D10_VS_INPUT_REGISTER_COMPONENT_BIT_COUNT = (32);

    D3D10_VS_INPUT_REGISTER_COUNT = (16);

    D3D10_VS_INPUT_REGISTER_READS_PER_INST = (2);

    D3D10_VS_INPUT_REGISTER_READ_PORTS = (1);

    D3D10_VS_OUTPUT_REGISTER_COMPONENTS = (4);

    D3D10_VS_OUTPUT_REGISTER_COMPONENT_BIT_COUNT = (32);

    D3D10_VS_OUTPUT_REGISTER_COUNT = (16);

    D3D10_WHQL_CONTEXT_COUNT_FOR_RESOURCE_LIMIT = (10);

    D3D10_WHQL_DRAWINDEXED_INDEX_COUNT_2_TO_EXP = (25);

    D3D10_WHQL_DRAW_VERTEX_COUNT_2_TO_EXP = (25);

    D3D_MAJOR_VERSION = (10);

    D3D_MINOR_VERSION = (0);

    D3D_SPEC_DATE_DAY = (8);

    D3D_SPEC_DATE_MONTH = (8);

    D3D_SPEC_DATE_YEAR = (2006);

    D3D_SPEC_VERSION = (1.050005);

    (* Direct3D errors are now found in winerror.h *)
    _FACD3D10 = ($879);

    _FACD3D10DEBUG = ((_FACD3D10 + 1));


    D3D10_FILTER_TYPE_MASK = ($3);

    D3D10_MIN_FILTER_SHIFT = (4);

    D3D10_MAG_FILTER_SHIFT = (2);

    D3D10_MIP_FILTER_SHIFT = (0);

    D3D10_COMPARISON_FILTERING_BIT = ($80);

    D3D10_ANISOTROPIC_FILTERING_BIT = ($40);

    D3D10_TEXT_1BIT_BIT = ($80000000);

    D3D10_APPEND_ALIGNED_ELEMENT = ($ffffffff);

    D3D10_SDK_VERSION = (29);


type


    (* Forward Declarations *)


    ID3D10DeviceChild = interface;
    PID3D10DeviceChild = ^ID3D10DeviceChild;


    ID3D10DepthStencilState = interface;
    PID3D10DepthStencilState = ^ID3D10DepthStencilState;


    ID3D10BlendState = interface;
    PID3D10BlendState = ^ID3D10BlendState;


    ID3D10RasterizerState = interface;
    PID3D10RasterizerState = ^ID3D10RasterizerState;


    ID3D10Resource = interface;
    PID3D10Resource = ^ID3D10Resource;

    ID3D10Buffer = interface;
    PID3D10Buffer = ^ID3D10Buffer;

    ID3D10Texture1D = interface;
    PID3D10Texture1D = ^ID3D10Texture1D;

    ID3D10Texture2D = interface;
    PID3D10Texture2D = ^ID3D10Texture2D;

    ID3D10Texture3D = interface;
    PID3D10Texture3D = ^ID3D10Texture3D;

    ID3D10View = interface;
    PID3D10View = ^ID3D10View;

    ID3D10ShaderResourceView = interface;
    PID3D10ShaderResourceView = ^ID3D10ShaderResourceView;

    ID3D10RenderTargetView = interface;
    PID3D10RenderTargetView = ^ID3D10RenderTargetView;

    ID3D10DepthStencilView = interface;
    PID3D10DepthStencilView = ^ID3D10DepthStencilView;

    ID3D10VertexShader = interface;
    PID3D10VertexShader = ^ID3D10VertexShader;

    ID3D10GeometryShader = interface;
    PID3D10GeometryShader = ^ID3D10GeometryShader;

    ID3D10PixelShader = interface;
    PID3D10PixelShader = ^ID3D10PixelShader;

    ID3D10InputLayout = interface;
    PID3D10InputLayout = ^ID3D10InputLayout;

    ID3D10SamplerState = interface;
    PID3D10SamplerState = ^ID3D10SamplerState;

    ID3D10Asynchronous = interface;
    PID3D10Asynchronous = ^ID3D10Asynchronous;

    ID3D10Query = interface;
    PID3D10Query = ^ID3D10Query;

    ID3D10Predicate = interface;
    PID3D10Predicate = ^ID3D10Predicate;

    ID3D10Counter = interface;
    PID3D10Counter = ^ID3D10Counter;

    ID3D10Device = interface;
    PID3D10Device = ^ID3D10Device;

    ID3D10Multithread = interface;
    PID3D10Multithread = ^ID3D10Multithread;

    TD3D10_INPUT_CLASSIFICATION = (
        D3D10_INPUT_PER_VERTEX_DATA = 0,
        D3D10_INPUT_PER_INSTANCE_DATA = 1);

    PD3D10_INPUT_CLASSIFICATION = ^TD3D10_INPUT_CLASSIFICATION;


    TD3D10_INPUT_ELEMENT_DESC = record
        SemanticName: LPCSTR;
        SemanticIndex: UINT;
        Format: TDXGI_FORMAT;
        InputSlot: UINT;
        AlignedByteOffset: UINT;
        InputSlotClass: TD3D10_INPUT_CLASSIFICATION;
        InstanceDataStepRate: UINT;
    end;
    PD3D10_INPUT_ELEMENT_DESC = ^TD3D10_INPUT_ELEMENT_DESC;


    TD3D10_FILL_MODE = (
        D3D10_FILL_WIREFRAME = 2,
        D3D10_FILL_SOLID = 3);

    PD3D10_FILL_MODE = ^TD3D10_FILL_MODE;


    TD3D10_PRIMITIVE_TOPOLOGY = TD3D_PRIMITIVE_TOPOLOGY;
    PD3D10_PRIMITIVE_TOPOLOGY = ^TD3D10_PRIMITIVE_TOPOLOGY;

    TD3D10_PRIMITIVE = TD3D_PRIMITIVE;
    PD3D10_PRIMITIVE = ^TD3D10_PRIMITIVE;

    TD3D10_CULL_MODE = (
        D3D10_CULL_NONE = 1,
        D3D10_CULL_FRONT = 2,
        D3D10_CULL_BACK = 3);

    PD3D10_CULL_MODE = ^TD3D10_CULL_MODE;


    TD3D10_SO_DECLARATION_ENTRY = record
        SemanticName: LPCSTR;
        SemanticIndex: UINT;
        StartComponent: TBYTE;
        ComponentCount: TBYTE;
        OutputSlot: TBYTE;
    end;
    PD3D10_SO_DECLARATION_ENTRY = ^TD3D10_SO_DECLARATION_ENTRY;


    TD3D10_VIEWPORT = record
        TopLeftX: int32;
        TopLeftY: int32;
        Width: UINT;
        Height: UINT;
        MinDepth: single;
        MaxDepth: single;
    end;
    PD3D10_VIEWPORT = ^TD3D10_VIEWPORT;


    TD3D10_RESOURCE_DIMENSION = (
        D3D10_RESOURCE_DIMENSION_UNKNOWN = 0,
        D3D10_RESOURCE_DIMENSION_BUFFER = 1,
        D3D10_RESOURCE_DIMENSION_TEXTURE1D = 2,
        D3D10_RESOURCE_DIMENSION_TEXTURE2D = 3,
        D3D10_RESOURCE_DIMENSION_TEXTURE3D = 4);

    PD3D10_RESOURCE_DIMENSION = ^TD3D10_RESOURCE_DIMENSION;


    TD3D10_SRV_DIMENSION = TD3D_SRV_DIMENSION;

    TD3D10_DSV_DIMENSION = (
        D3D10_DSV_DIMENSION_UNKNOWN = 0,
        D3D10_DSV_DIMENSION_TEXTURE1D = 1,
        D3D10_DSV_DIMENSION_TEXTURE1DARRAY = 2,
        D3D10_DSV_DIMENSION_TEXTURE2D = 3,
        D3D10_DSV_DIMENSION_TEXTURE2DARRAY = 4,
        D3D10_DSV_DIMENSION_TEXTURE2DMS = 5,
        D3D10_DSV_DIMENSION_TEXTURE2DMSARRAY = 6);

    PD3D10_DSV_DIMENSION = ^TD3D10_DSV_DIMENSION;


    TD3D10_RTV_DIMENSION = (
        D3D10_RTV_DIMENSION_UNKNOWN = 0,
        D3D10_RTV_DIMENSION_BUFFER = 1,
        D3D10_RTV_DIMENSION_TEXTURE1D = 2,
        D3D10_RTV_DIMENSION_TEXTURE1DARRAY = 3,
        D3D10_RTV_DIMENSION_TEXTURE2D = 4,
        D3D10_RTV_DIMENSION_TEXTURE2DARRAY = 5,
        D3D10_RTV_DIMENSION_TEXTURE2DMS = 6,
        D3D10_RTV_DIMENSION_TEXTURE2DMSARRAY = 7,
        D3D10_RTV_DIMENSION_TEXTURE3D = 8);

    PD3D10_RTV_DIMENSION = ^TD3D10_RTV_DIMENSION;


    TD3D10_USAGE = (
        D3D10_USAGE_DEFAULT = 0,
        D3D10_USAGE_IMMUTABLE = 1,
        D3D10_USAGE_DYNAMIC = 2,
        D3D10_USAGE_STAGING = 3);

    PD3D10_USAGE = ^TD3D10_USAGE;


    TD3D10_BIND_FLAG = (
        D3D10_BIND_VERTEX_BUFFER = $1,
        D3D10_BIND_INDEX_BUFFER = $2,
        D3D10_BIND_CONSTANT_BUFFER = $4,
        D3D10_BIND_SHADER_RESOURCE = $8,
        D3D10_BIND_STREAM_OUTPUT = $10,
        D3D10_BIND_RENDER_TARGET = $20,
        D3D10_BIND_DEPTH_STENCIL = $40);

    PD3D10_BIND_FLAG = ^TD3D10_BIND_FLAG;


    TD3D10_CPU_ACCESS_FLAG = (
        D3D10_CPU_ACCESS_WRITE = $10000,
        D3D10_CPU_ACCESS_READ = $20000);

    PD3D10_CPU_ACCESS_FLAG = ^TD3D10_CPU_ACCESS_FLAG;


    TD3D10_RESOURCE_MISC_FLAG = (
        D3D10_RESOURCE_MISC_GENERATE_MIPS = $1,
        D3D10_RESOURCE_MISC_SHARED = $2,
        D3D10_RESOURCE_MISC_TEXTURECUBE = $4,
        D3D10_RESOURCE_MISC_SHARED_KEYEDMUTEX = $10,
        D3D10_RESOURCE_MISC_GDI_COMPATIBLE = $20);

    PD3D10_RESOURCE_MISC_FLAG = ^TD3D10_RESOURCE_MISC_FLAG;


    TD3D10_MAP = (
        D3D10_MAP_READ = 1,
        D3D10_MAP_WRITE = 2,
        D3D10_MAP_READ_WRITE = 3,
        D3D10_MAP_WRITE_DISCARD = 4,
        D3D10_MAP_WRITE_NO_OVERWRITE = 5);

    PD3D10_MAP = ^TD3D10_MAP;


    TD3D10_MAP_FLAG = (
        D3D10_MAP_FLAG_DO_NOT_WAIT = $100000);

    PD3D10_MAP_FLAG = ^TD3D10_MAP_FLAG;


    TD3D10_RAISE_FLAG = (
        D3D10_RAISE_FLAG_DRIVER_INTERNAL_ERROR = $1);

    PD3D10_RAISE_FLAG = ^TD3D10_RAISE_FLAG;


    TD3D10_CLEAR_FLAG = (
        D3D10_CLEAR_DEPTH = $1,
        D3D10_CLEAR_STENCIL = $2);

    PD3D10_CLEAR_FLAG = ^TD3D10_CLEAR_FLAG;


    TD3D10_RECT = TRECT;
    PD3D10_RECT = ^TD3D10_RECT;

    TD3D10_BOX = record
        left: UINT;
        top: UINT;
        front: UINT;
        right: UINT;
        bottom: UINT;
        back: UINT;
    end;
    PD3D10_BOX = ^TD3D10_BOX;


    ID3D10DeviceChild = interface(IUnknown)
        ['{9B7E4C00-342C-4106-A19F-4F2704F689F0}']
        procedure GetDevice(
        {_Out_  }  out ppDevice: ID3D10Device); stdcall;

        function GetPrivateData(
        {_In_  } guid: REFGUID;
        {_Inout_  } pDataSize: PUINT;
        {_Out_writes_bytes_opt_(*pDataSize)  } pData: Pvoid): HRESULT; stdcall;

        function SetPrivateData(
        {_In_  } guid: REFGUID;
        {_In_  } DataSize: UINT;
        {_In_reads_bytes_opt_(DataSize)  } pData: Pvoid): HRESULT; stdcall;

        function SetPrivateDataInterface(
        {_In_  } guid: REFGUID;
        {_In_opt_  } pData: IUnknown): HRESULT; stdcall;

    end;


    TD3D10_COMPARISON_FUNC = (
        D3D10_COMPARISON_NEVER = 1,
        D3D10_COMPARISON_LESS = 2,
        D3D10_COMPARISON_EQUAL = 3,
        D3D10_COMPARISON_LESS_EQUAL = 4,
        D3D10_COMPARISON_GREATER = 5,
        D3D10_COMPARISON_NOT_EQUAL = 6,
        D3D10_COMPARISON_GREATER_EQUAL = 7,
        D3D10_COMPARISON_ALWAYS = 8);

    PD3D10_COMPARISON_FUNC = ^TD3D10_COMPARISON_FUNC;


    TD3D10_DEPTH_WRITE_MASK = (
        D3D10_DEPTH_WRITE_MASK_ZERO = 0,
        D3D10_DEPTH_WRITE_MASK_ALL = 1);

    PD3D10_DEPTH_WRITE_MASK = ^TD3D10_DEPTH_WRITE_MASK;


    TD3D10_STENCIL_OP = (
        D3D10_STENCIL_OP_KEEP = 1,
        D3D10_STENCIL_OP_ZERO = 2,
        D3D10_STENCIL_OP_REPLACE = 3,
        D3D10_STENCIL_OP_INCR_SAT = 4,
        D3D10_STENCIL_OP_DECR_SAT = 5,
        D3D10_STENCIL_OP_INVERT = 6,
        D3D10_STENCIL_OP_INCR = 7,
        D3D10_STENCIL_OP_DECR = 8);

    PD3D10_STENCIL_OP = ^TD3D10_STENCIL_OP;


    TD3D10_DEPTH_STENCILOP_DESC = record
        StencilFailOp: TD3D10_STENCIL_OP;
        StencilDepthFailOp: TD3D10_STENCIL_OP;
        StencilPassOp: TD3D10_STENCIL_OP;
        StencilFunc: TD3D10_COMPARISON_FUNC;
    end;
    PD3D10_DEPTH_STENCILOP_DESC = ^TD3D10_DEPTH_STENCILOP_DESC;


    TD3D10_DEPTH_STENCIL_DESC = record
        DepthEnable: boolean;
        DepthWriteMask: TD3D10_DEPTH_WRITE_MASK;
        DepthFunc: TD3D10_COMPARISON_FUNC;
        StencilEnable: boolean;
        StencilReadMask: uint8;
        StencilWriteMask: uint8;
        FrontFace: TD3D10_DEPTH_STENCILOP_DESC;
        BackFace: TD3D10_DEPTH_STENCILOP_DESC;
    end;
    PD3D10_DEPTH_STENCIL_DESC = ^TD3D10_DEPTH_STENCIL_DESC;


    ID3D10DepthStencilState = interface(ID3D10DeviceChild)
        ['{2B4B1CC8-A4AD-41f8-8322-CA86FC3EC675}']
        procedure GetDesc(
        {_Out_  } pDesc: PD3D10_DEPTH_STENCIL_DESC); stdcall;

    end;


    TD3D10_BLEND = (
        D3D10_BLEND_ZERO = 1,
        D3D10_BLEND_ONE = 2,
        D3D10_BLEND_SRC_COLOR = 3,
        D3D10_BLEND_INV_SRC_COLOR = 4,
        D3D10_BLEND_SRC_ALPHA = 5,
        D3D10_BLEND_INV_SRC_ALPHA = 6,
        D3D10_BLEND_DEST_ALPHA = 7,
        D3D10_BLEND_INV_DEST_ALPHA = 8,
        D3D10_BLEND_DEST_COLOR = 9,
        D3D10_BLEND_INV_DEST_COLOR = 10,
        D3D10_BLEND_SRC_ALPHA_SAT = 11,
        D3D10_BLEND_BLEND_FACTOR = 14,
        D3D10_BLEND_INV_BLEND_FACTOR = 15,
        D3D10_BLEND_SRC1_COLOR = 16,
        D3D10_BLEND_INV_SRC1_COLOR = 17,
        D3D10_BLEND_SRC1_ALPHA = 18,
        D3D10_BLEND_INV_SRC1_ALPHA = 19);

    PD3D10_BLEND = ^TD3D10_BLEND;


    TD3D10_BLEND_OP = (
        D3D10_BLEND_OP_ADD = 1,
        D3D10_BLEND_OP_SUBTRACT = 2,
        D3D10_BLEND_OP_REV_SUBTRACT = 3,
        D3D10_BLEND_OP_MIN = 4,
        D3D10_BLEND_OP_MAX = 5);

    PD3D10_BLEND_OP = ^TD3D10_BLEND_OP;


    TD3D10_COLOR_WRITE_ENABLE = (
        D3D10_COLOR_WRITE_ENABLE_RED = 1,
        D3D10_COLOR_WRITE_ENABLE_GREEN = 2,
        D3D10_COLOR_WRITE_ENABLE_BLUE = 4,
        D3D10_COLOR_WRITE_ENABLE_ALPHA = 8,
        D3D10_COLOR_WRITE_ENABLE_ALL = Ord(D3D10_COLOR_WRITE_ENABLE_RED) or Ord(D3D10_COLOR_WRITE_ENABLE_GREEN) or Ord(D3D10_COLOR_WRITE_ENABLE_BLUE) or Ord(D3D10_COLOR_WRITE_ENABLE_ALPHA));

    PD3D10_COLOR_WRITE_ENABLE = ^TD3D10_COLOR_WRITE_ENABLE;


    TD3D10_BLEND_DESC = record
        AlphaToCoverageEnable: boolean;
        BlendEnable: array [0..7] of boolean;
        SrcBlend: TD3D10_BLEND;
        DestBlend: TD3D10_BLEND;
        BlendOp: TD3D10_BLEND_OP;
        SrcBlendAlpha: TD3D10_BLEND;
        DestBlendAlpha: TD3D10_BLEND;
        BlendOpAlpha: TD3D10_BLEND_OP;
        RenderTargetWriteMask: array [0..7] of uint8;
    end;
    PD3D10_BLEND_DESC = ^TD3D10_BLEND_DESC;


    ID3D10BlendState = interface(ID3D10DeviceChild)
        ['{EDAD8D19-8A35-4d6d-8566-2EA276CDE161}']
        procedure GetDesc(
        {_Out_  } pDesc: PD3D10_BLEND_DESC); stdcall;

    end;


    TD3D10_RASTERIZER_DESC = record
        FillMode: TD3D10_FILL_MODE;
        CullMode: TD3D10_CULL_MODE;
        FrontCounterClockwise: boolean;
        DepthBias: int32;
        DepthBiasClamp: single;
        SlopeScaledDepthBias: single;
        DepthClipEnable: boolean;
        ScissorEnable: boolean;
        MultisampleEnable: boolean;
        AntialiasedLineEnable: boolean;
    end;
    PD3D10_RASTERIZER_DESC = ^TD3D10_RASTERIZER_DESC;


    ID3D10RasterizerState = interface(ID3D10DeviceChild)
        ['{A2A07292-89AF-4345-BE2E-C53D9FBB6E9F}']
        procedure GetDesc(
        {_Out_  } pDesc: PD3D10_RASTERIZER_DESC); stdcall;

    end;


    TD3D10_SUBRESOURCE_DATA = record
        pSysMem: Pvoid;
        SysMemPitch: UINT;
        SysMemSlicePitch: UINT;
    end;
    PD3D10_SUBRESOURCE_DATA = ^TD3D10_SUBRESOURCE_DATA;


    ID3D10Resource = interface(ID3D10DeviceChild)
        ['{9B7E4C01-342C-4106-A19F-4F2704F689F0}']
        procedure GetType(
        {_Out_  } rType: PD3D10_RESOURCE_DIMENSION); stdcall;

        procedure SetEvictionPriority(
        {_In_  } EvictionPriority: UINT); stdcall;

        function GetEvictionPriority(): UINT; stdcall;

    end;


    { TD3D10_BUFFER_DESC }

    TD3D10_BUFFER_DESC = record
        ByteWidth: UINT;
        Usage: TD3D10_USAGE;
        BindFlags: UINT;
        CPUAccessFlags: UINT;
        MiscFlags: UINT;
        class operator Initialize(var aRec: TD3D10_BUFFER_DESC);
        constructor Create(byteWidth: UINT; bindFlags: UINT; usage: TD3D10_USAGE = D3D10_USAGE_DEFAULT; cpuaccessFlags: UINT = 0; miscFlags: UINT = 0);
    end;
    PD3D10_BUFFER_DESC = ^TD3D10_BUFFER_DESC;


    ID3D10Buffer = interface(ID3D10Resource)
        ['{9B7E4C02-342C-4106-A19F-4F2704F689F0}']
        function Map(
        {_In_  } MapType: TD3D10_MAP;
        {_In_  } MapFlags: UINT;
        {_Out_  }  out ppData): HRESULT; stdcall;

        procedure Unmap(); stdcall;

        procedure GetDesc(
        {_Out_  } pDesc: PD3D10_BUFFER_DESC); stdcall;

    end;


    { TD3D10_TEXTURE1D_DESC }

    TD3D10_TEXTURE1D_DESC = record
        Width: UINT;
        MipLevels: UINT;
        ArraySize: UINT;
        Format: TDXGI_FORMAT;
        Usage: TD3D10_USAGE;
        BindFlags: UINT;
        CPUAccessFlags: UINT;
        MiscFlags: UINT;
        class operator Initialize(var aRec: TD3D10_TEXTURE1D_DESC);
        constructor Create(format: TDXGI_FORMAT; Width: UINT; arraySize: UINT = 1; mipLevels: UINT = 0; bindFlags: UINT = Ord(D3D10_BIND_SHADER_RESOURCE); usage: TD3D10_USAGE = D3D10_USAGE_DEFAULT; cpuaccessFlags: UINT = 0; miscFlags: UINT = 0);

    end;
    PD3D10_TEXTURE1D_DESC = ^TD3D10_TEXTURE1D_DESC;


    ID3D10Texture1D = interface(ID3D10Resource)
        ['{9B7E4C03-342C-4106-A19F-4F2704F689F0}']
        function Map(
        {_In_  } Subresource: UINT;
        {_In_  } MapType: TD3D10_MAP;
        {_In_  } MapFlags: UINT;
        {_Out_  }  out ppData): HRESULT; stdcall;

        procedure Unmap(
        {_In_  } Subresource: UINT); stdcall;

        procedure GetDesc(
        {_Out_  } pDesc: PD3D10_TEXTURE1D_DESC); stdcall;

    end;


    { TD3D10_TEXTURE2D_DESC }

    TD3D10_TEXTURE2D_DESC = record
        Width: UINT;
        Height: UINT;
        MipLevels: UINT;
        ArraySize: UINT;
        Format: TDXGI_FORMAT;
        SampleDesc: TDXGI_SAMPLE_DESC;
        Usage: TD3D10_USAGE;
        BindFlags: UINT;
        CPUAccessFlags: UINT;
        MiscFlags: UINT;
        class operator Initialize(var aRec: TD3D10_TEXTURE2D_DESC);
        constructor Create(format: TDXGI_FORMAT; Width: UINT; Height: UINT; arraySize: UINT = 1; mipLevels: UINT = 0; bindFlags: UINT = Ord(D3D10_BIND_SHADER_RESOURCE); usage: TD3D10_USAGE = D3D10_USAGE_DEFAULT;
            cpuaccessFlags: UINT = 0; sampleCount: UINT = 1; sampleQuality: UINT = 0; miscFlags: UINT = 0);

    end;
    PD3D10_TEXTURE2D_DESC = ^TD3D10_TEXTURE2D_DESC;


    TD3D10_MAPPED_TEXTURE2D = record
        pData: Pvoid;
        RowPitch: UINT;
    end;
    PD3D10_MAPPED_TEXTURE2D = ^TD3D10_MAPPED_TEXTURE2D;


    ID3D10Texture2D = interface(ID3D10Resource)
        ['{9B7E4C04-342C-4106-A19F-4F2704F689F0}']
        function Map(
        {_In_  } Subresource: UINT;
        {_In_  } MapType: TD3D10_MAP;
        {_In_  } MapFlags: UINT;
        {_Out_  } pMappedTex2D: PD3D10_MAPPED_TEXTURE2D): HRESULT; stdcall;

        procedure Unmap(
        {_In_  } Subresource: UINT); stdcall;

        procedure GetDesc(
        {_Out_  } pDesc: PD3D10_TEXTURE2D_DESC); stdcall;

    end;


    { TD3D10_TEXTURE3D_DESC }

    TD3D10_TEXTURE3D_DESC = record
        Width: UINT;
        Height: UINT;
        Depth: UINT;
        MipLevels: UINT;
        Format: TDXGI_FORMAT;
        Usage: TD3D10_USAGE;
        BindFlags: UINT;
        CPUAccessFlags: UINT;
        MiscFlags: UINT;
        class operator Initialize(var aRec: TD3D10_TEXTURE3D_DESC);
        constructor Create(format: TDXGI_FORMAT; Width: UINT; Height: UINT; depth: UINT; mipLevels: UINT = 0; bindFlags: UINT = Ord(D3D10_BIND_SHADER_RESOURCE); usage: TD3D10_USAGE = D3D10_USAGE_DEFAULT;
            cpuaccessFlags: UINT = 0; miscFlags: UINT = 0);

    end;
    PD3D10_TEXTURE3D_DESC = ^TD3D10_TEXTURE3D_DESC;


    TD3D10_MAPPED_TEXTURE3D = record
        pData: Pvoid;
        RowPitch: UINT;
        DepthPitch: UINT;
    end;
    PD3D10_MAPPED_TEXTURE3D = ^TD3D10_MAPPED_TEXTURE3D;


    ID3D10Texture3D = interface(ID3D10Resource)
        ['{9B7E4C05-342C-4106-A19F-4F2704F689F0}']
        function Map(
        {_In_  } Subresource: UINT;
        {_In_  } MapType: TD3D10_MAP;
        {_In_  } MapFlags: UINT;
        {_Out_  } pMappedTex3D: PD3D10_MAPPED_TEXTURE3D): HRESULT; stdcall;

        procedure Unmap(
        {_In_  } Subresource: UINT); stdcall;

        procedure GetDesc(
        {_Out_  } pDesc: PD3D10_TEXTURE3D_DESC); stdcall;

    end;


    TD3D10_TEXTURECUBE_FACE = (
        D3D10_TEXTURECUBE_FACE_POSITIVE_X = 0,
        D3D10_TEXTURECUBE_FACE_NEGATIVE_X = 1,
        D3D10_TEXTURECUBE_FACE_POSITIVE_Y = 2,
        D3D10_TEXTURECUBE_FACE_NEGATIVE_Y = 3,
        D3D10_TEXTURECUBE_FACE_POSITIVE_Z = 4,
        D3D10_TEXTURECUBE_FACE_NEGATIVE_Z = 5);

    PD3D10_TEXTURECUBE_FACE = ^TD3D10_TEXTURECUBE_FACE;


    ID3D10View = interface(ID3D10DeviceChild)
        ['{C902B03F-60A7-49BA-9936-2A3AB37A7E33}']
        procedure GetResource(
        {_Out_  }  out ppResource: ID3D10Resource); stdcall;

    end;


    TD3D10_BUFFER_SRV = record
        case integer of
            0: (
                FirstElement: UINT;
                NumElements: UINT;
            );
            1: (
                ElementOffset: UINT;
                ElementWidth: UINT;
            );
    end;
    PD3D10_BUFFER_SRV = ^TD3D10_BUFFER_SRV;


    TD3D10_TEX1D_SRV = record
        MostDetailedMip: UINT;
        MipLevels: UINT;
    end;
    PD3D10_TEX1D_SRV = ^TD3D10_TEX1D_SRV;


    TD3D10_TEX1D_ARRAY_SRV = record
        MostDetailedMip: UINT;
        MipLevels: UINT;
        FirstArraySlice: UINT;
        ArraySize: UINT;
    end;
    PD3D10_TEX1D_ARRAY_SRV = ^TD3D10_TEX1D_ARRAY_SRV;


    TD3D10_TEX2D_SRV = record
        MostDetailedMip: UINT;
        MipLevels: UINT;
    end;
    PD3D10_TEX2D_SRV = ^TD3D10_TEX2D_SRV;


    TD3D10_TEX2D_ARRAY_SRV = record
        MostDetailedMip: UINT;
        MipLevels: UINT;
        FirstArraySlice: UINT;
        ArraySize: UINT;
    end;
    PD3D10_TEX2D_ARRAY_SRV = ^TD3D10_TEX2D_ARRAY_SRV;


    TD3D10_TEX3D_SRV = record
        MostDetailedMip: UINT;
        MipLevels: UINT;
    end;
    PD3D10_TEX3D_SRV = ^TD3D10_TEX3D_SRV;


    TD3D10_TEXCUBE_SRV = record
        MostDetailedMip: UINT;
        MipLevels: UINT;
    end;
    PD3D10_TEXCUBE_SRV = ^TD3D10_TEXCUBE_SRV;


    TD3D10_TEX2DMS_SRV = record
        UnusedField_NothingToDefine: UINT;
    end;
    PD3D10_TEX2DMS_SRV = ^TD3D10_TEX2DMS_SRV;


    TD3D10_TEX2DMS_ARRAY_SRV = record
        FirstArraySlice: UINT;
        ArraySize: UINT;
    end;
    PD3D10_TEX2DMS_ARRAY_SRV = ^TD3D10_TEX2DMS_ARRAY_SRV;


    TD3D10_SHADER_RESOURCE_VIEW_DESC = record
        Format: TDXGI_FORMAT;
        ViewDimension: TD3D10_SRV_DIMENSION;
        case integer of
            0: (
                Buffer: TD3D10_BUFFER_SRV;
            );
            1: (
                Texture1D: TD3D10_TEX1D_SRV;
            );
            2: (
                Texture1DArray: TD3D10_TEX1D_ARRAY_SRV;
            );
            3: (
                Texture2D: TD3D10_TEX2D_SRV;
            );
            4: (
                Texture2DArray: TD3D10_TEX2D_ARRAY_SRV;
            );
            5: (
                Texture2DMS: TD3D10_TEX2DMS_SRV;
            );
            6: (
                Texture2DMSArray: TD3D10_TEX2DMS_ARRAY_SRV;
            );
            7: (
                Texture3D: TD3D10_TEX3D_SRV;
            );
            8: (
                TextureCube: TD3D10_TEXCUBE_SRV;
            );

    end;
    PD3D10_SHADER_RESOURCE_VIEW_DESC = ^TD3D10_SHADER_RESOURCE_VIEW_DESC;


    ID3D10ShaderResourceView = interface(ID3D10View)
        ['{9B7E4C07-342C-4106-A19F-4F2704F689F0}']
        procedure GetDesc(
        {_Out_  } pDesc: PD3D10_SHADER_RESOURCE_VIEW_DESC); stdcall;

    end;


    TD3D10_BUFFER_RTV = record
        case integer of
            0: (
                FirstElement: UINT;
                NumElements: UINT;
            );
            1: (
                ElementOffset: UINT;
                ElementWidth: UINT;
            );
    end;
    PD3D10_BUFFER_RTV = ^TD3D10_BUFFER_RTV;


    TD3D10_TEX1D_RTV = record
        MipSlice: UINT;
    end;
    PD3D10_TEX1D_RTV = ^TD3D10_TEX1D_RTV;


    TD3D10_TEX1D_ARRAY_RTV = record
        MipSlice: UINT;
        FirstArraySlice: UINT;
        ArraySize: UINT;
    end;
    PD3D10_TEX1D_ARRAY_RTV = ^TD3D10_TEX1D_ARRAY_RTV;


    TD3D10_TEX2D_RTV = record
        MipSlice: UINT;
    end;
    PD3D10_TEX2D_RTV = ^TD3D10_TEX2D_RTV;


    TD3D10_TEX2DMS_RTV = record
        UnusedField_NothingToDefine: UINT;
    end;
    PD3D10_TEX2DMS_RTV = ^TD3D10_TEX2DMS_RTV;


    TD3D10_TEX2D_ARRAY_RTV = record
        MipSlice: UINT;
        FirstArraySlice: UINT;
        ArraySize: UINT;
    end;
    PD3D10_TEX2D_ARRAY_RTV = ^TD3D10_TEX2D_ARRAY_RTV;


    TD3D10_TEX2DMS_ARRAY_RTV = record
        FirstArraySlice: UINT;
        ArraySize: UINT;
    end;
    PD3D10_TEX2DMS_ARRAY_RTV = ^TD3D10_TEX2DMS_ARRAY_RTV;


    TD3D10_TEX3D_RTV = record
        MipSlice: UINT;
        FirstWSlice: UINT;
        WSize: UINT;
    end;
    PD3D10_TEX3D_RTV = ^TD3D10_TEX3D_RTV;


    TD3D10_RENDER_TARGET_VIEW_DESC = record
        Format: TDXGI_FORMAT;
        ViewDimension: TD3D10_RTV_DIMENSION;
        case integer of
            0: (
                Buffer: TD3D10_BUFFER_RTV;
            );
            1: (
                Texture1D: TD3D10_TEX1D_RTV;
            );
            2: (
                Texture1DArray: TD3D10_TEX1D_ARRAY_RTV;
            );
            3: (
                Texture2D: TD3D10_TEX2D_RTV;
            );
            4: (
                Texture2DArray: TD3D10_TEX2D_ARRAY_RTV;
            );
            5: (
                Texture2DMS: TD3D10_TEX2DMS_RTV;
            );
            6: (
                Texture2DMSArray: TD3D10_TEX2DMS_ARRAY_RTV;
            );
            7: (
                Texture3D: TD3D10_TEX3D_RTV;
            );
    end;
    PD3D10_RENDER_TARGET_VIEW_DESC = ^TD3D10_RENDER_TARGET_VIEW_DESC;


    ID3D10RenderTargetView = interface(ID3D10View)
        ['{9B7E4C08-342C-4106-A19F-4F2704F689F0}']
        procedure GetDesc(
        {_Out_  } pDesc: PD3D10_RENDER_TARGET_VIEW_DESC); stdcall;

    end;


    TD3D10_TEX1D_DSV = record
        MipSlice: UINT;
    end;
    PD3D10_TEX1D_DSV = ^TD3D10_TEX1D_DSV;


    TD3D10_TEX1D_ARRAY_DSV = record
        MipSlice: UINT;
        FirstArraySlice: UINT;
        ArraySize: UINT;
    end;
    PD3D10_TEX1D_ARRAY_DSV = ^TD3D10_TEX1D_ARRAY_DSV;


    TD3D10_TEX2D_DSV = record
        MipSlice: UINT;
    end;
    PD3D10_TEX2D_DSV = ^TD3D10_TEX2D_DSV;


    TD3D10_TEX2D_ARRAY_DSV = record
        MipSlice: UINT;
        FirstArraySlice: UINT;
        ArraySize: UINT;
    end;
    PD3D10_TEX2D_ARRAY_DSV = ^TD3D10_TEX2D_ARRAY_DSV;


    TD3D10_TEX2DMS_DSV = record
        UnusedField_NothingToDefine: UINT;
    end;
    PD3D10_TEX2DMS_DSV = ^TD3D10_TEX2DMS_DSV;


    TD3D10_TEX2DMS_ARRAY_DSV = record
        FirstArraySlice: UINT;
        ArraySize: UINT;
    end;
    PD3D10_TEX2DMS_ARRAY_DSV = ^TD3D10_TEX2DMS_ARRAY_DSV;


    TD3D10_DEPTH_STENCIL_VIEW_DESC = record
        Format: TDXGI_FORMAT;
        ViewDimension: TD3D10_DSV_DIMENSION;
        case integer of
            0: (
                Texture1D: TD3D10_TEX1D_DSV;
            );
            1: (
                Texture1DArray: TD3D10_TEX1D_ARRAY_DSV;
            );
            2: (
                Texture2D: TD3D10_TEX2D_DSV;
            );
            3: (
                Texture2DArray: TD3D10_TEX2D_ARRAY_DSV;
            );
            4: (
                Texture2DMS: TD3D10_TEX2DMS_DSV;
            );
            5: (
                Texture2DMSArray: TD3D10_TEX2DMS_ARRAY_DSV;
            );
    end;
    PD3D10_DEPTH_STENCIL_VIEW_DESC = ^TD3D10_DEPTH_STENCIL_VIEW_DESC;


    ID3D10DepthStencilView = interface(ID3D10View)
        ['{9B7E4C09-342C-4106-A19F-4F2704F689F0}']
        procedure GetDesc(
        {_Out_  } pDesc: PD3D10_DEPTH_STENCIL_VIEW_DESC); stdcall;

    end;


    ID3D10VertexShader = interface(ID3D10DeviceChild)
        ['{9B7E4C0A-342C-4106-A19F-4F2704F689F0}']
    end;


    ID3D10GeometryShader = interface(ID3D10DeviceChild)
        ['{6316BE88-54CD-4040-AB44-20461BC81F68}']
    end;


    ID3D10PixelShader = interface(ID3D10DeviceChild)
        ['{4968B601-9D00-4cde-8346-8E7F675819B6}']
    end;


    ID3D10InputLayout = interface(ID3D10DeviceChild)
        ['{9B7E4C0B-342C-4106-A19F-4F2704F689F0}']
    end;


    TD3D10_FILTER = (
        D3D10_FILTER_MIN_MAG_MIP_POINT = 0,
        D3D10_FILTER_MIN_MAG_POINT_MIP_LINEAR = $1,
        D3D10_FILTER_MIN_POINT_MAG_LINEAR_MIP_POINT = $4,
        D3D10_FILTER_MIN_POINT_MAG_MIP_LINEAR = $5,
        D3D10_FILTER_MIN_LINEAR_MAG_MIP_POINT = $10,
        D3D10_FILTER_MIN_LINEAR_MAG_POINT_MIP_LINEAR = $11,
        D3D10_FILTER_MIN_MAG_LINEAR_MIP_POINT = $14,
        D3D10_FILTER_MIN_MAG_MIP_LINEAR = $15,
        D3D10_FILTER_ANISOTROPIC = $55,
        D3D10_FILTER_COMPARISON_MIN_MAG_MIP_POINT = $80,
        D3D10_FILTER_COMPARISON_MIN_MAG_POINT_MIP_LINEAR = $81,
        D3D10_FILTER_COMPARISON_MIN_POINT_MAG_LINEAR_MIP_POINT = $84,
        D3D10_FILTER_COMPARISON_MIN_POINT_MAG_MIP_LINEAR = $85,
        D3D10_FILTER_COMPARISON_MIN_LINEAR_MAG_MIP_POINT = $90,
        D3D10_FILTER_COMPARISON_MIN_LINEAR_MAG_POINT_MIP_LINEAR = $91,
        D3D10_FILTER_COMPARISON_MIN_MAG_LINEAR_MIP_POINT = $94,
        D3D10_FILTER_COMPARISON_MIN_MAG_MIP_LINEAR = $95,
        D3D10_FILTER_COMPARISON_ANISOTROPIC = $d5,
        D3D10_FILTER_TEXT_1BIT = longint($80000000));

    PD3D10_FILTER = ^TD3D10_FILTER;


    TD3D10_FILTER_TYPE = (
        D3D10_FILTER_TYPE_POINT = 0,
        D3D10_FILTER_TYPE_LINEAR = 1);

    PD3D10_FILTER_TYPE = ^TD3D10_FILTER_TYPE;


    TD3D10_TEXTURE_ADDRESS_MODE = (
        D3D10_TEXTURE_ADDRESS_WRAP = 1,
        D3D10_TEXTURE_ADDRESS_MIRROR = 2,
        D3D10_TEXTURE_ADDRESS_CLAMP = 3,
        D3D10_TEXTURE_ADDRESS_BORDER = 4,
        D3D10_TEXTURE_ADDRESS_MIRROR_ONCE = 5);

    PD3D10_TEXTURE_ADDRESS_MODE = ^TD3D10_TEXTURE_ADDRESS_MODE;


    TD3D10_SAMPLER_DESC = record
        Filter: TD3D10_FILTER;
        AddressU: TD3D10_TEXTURE_ADDRESS_MODE;
        AddressV: TD3D10_TEXTURE_ADDRESS_MODE;
        AddressW: TD3D10_TEXTURE_ADDRESS_MODE;
        MipLODBias: single;
        MaxAnisotropy: UINT;
        ComparisonFunc: TD3D10_COMPARISON_FUNC;
        BorderColor: array [0..3] of single;
        MinLOD: single;
        MaxLOD: single;
    end;
    PD3D10_SAMPLER_DESC = ^TD3D10_SAMPLER_DESC;


    ID3D10SamplerState = interface(ID3D10DeviceChild)
        ['{9B7E4C0C-342C-4106-A19F-4F2704F689F0}']
        procedure GetDesc(
        {_Out_  } pDesc: PD3D10_SAMPLER_DESC); stdcall;

    end;


    TD3D10_FORMAT_SUPPORT = (
        D3D10_FORMAT_SUPPORT_BUFFER = $1,
        D3D10_FORMAT_SUPPORT_IA_VERTEX_BUFFER = $2,
        D3D10_FORMAT_SUPPORT_IA_INDEX_BUFFER = $4,
        D3D10_FORMAT_SUPPORT_SO_BUFFER = $8,
        D3D10_FORMAT_SUPPORT_TEXTURE1D = $10,
        D3D10_FORMAT_SUPPORT_TEXTURE2D = $20,
        D3D10_FORMAT_SUPPORT_TEXTURE3D = $40,
        D3D10_FORMAT_SUPPORT_TEXTURECUBE = $80,
        D3D10_FORMAT_SUPPORT_SHADER_LOAD = $100,
        D3D10_FORMAT_SUPPORT_SHADER_SAMPLE = $200,
        D3D10_FORMAT_SUPPORT_SHADER_SAMPLE_COMPARISON = $400,
        D3D10_FORMAT_SUPPORT_SHADER_SAMPLE_MONO_TEXT = $800,
        D3D10_FORMAT_SUPPORT_MIP = $1000,
        D3D10_FORMAT_SUPPORT_MIP_AUTOGEN = $2000,
        D3D10_FORMAT_SUPPORT_RENDER_TARGET = $4000,
        D3D10_FORMAT_SUPPORT_BLENDABLE = $8000,
        D3D10_FORMAT_SUPPORT_DEPTH_STENCIL = $10000,
        D3D10_FORMAT_SUPPORT_CPU_LOCKABLE = $20000,
        D3D10_FORMAT_SUPPORT_MULTISAMPLE_RESOLVE = $40000,
        D3D10_FORMAT_SUPPORT_DISPLAY = $80000,
        D3D10_FORMAT_SUPPORT_CAST_WITHIN_BIT_LAYOUT = $100000,
        D3D10_FORMAT_SUPPORT_MULTISAMPLE_RENDERTARGET = $200000,
        D3D10_FORMAT_SUPPORT_MULTISAMPLE_LOAD = $400000,
        D3D10_FORMAT_SUPPORT_SHADER_GATHER = $800000,
        D3D10_FORMAT_SUPPORT_BACK_BUFFER_CAST = $1000000);

    PD3D10_FORMAT_SUPPORT = ^TD3D10_FORMAT_SUPPORT;


    ID3D10Asynchronous = interface(ID3D10DeviceChild)
        ['{9B7E4C0D-342C-4106-A19F-4F2704F689F0}']
        procedure _Begin(); stdcall;

        procedure _End(); stdcall;

        function GetData(
        {_Out_writes_bytes_opt_(DataSize)  } pData: Pvoid;
        {_In_  } DataSize: UINT;
        {_In_  } GetDataFlags: UINT): HRESULT; stdcall;

        function GetDataSize(): UINT; stdcall;

    end;


    TD3D10_ASYNC_GETDATA_FLAG = (
        D3D10_ASYNC_GETDATA_DONOTFLUSH = $1);

    PD3D10_ASYNC_GETDATA_FLAG = ^TD3D10_ASYNC_GETDATA_FLAG;


    TD3D10_QUERY = (
        D3D10_QUERY_EVENT = 0,
        D3D10_QUERY_OCCLUSION = Ord(D3D10_QUERY_EVENT) + 1,
        D3D10_QUERY_TIMESTAMP = Ord(D3D10_QUERY_OCCLUSION) + 1,
        D3D10_QUERY_TIMESTAMP_DISJOINT = Ord(D3D10_QUERY_TIMESTAMP) + 1,
        D3D10_QUERY_PIPELINE_STATISTICS = Ord(D3D10_QUERY_TIMESTAMP_DISJOINT) + 1,
        D3D10_QUERY_OCCLUSION_PREDICATE = Ord(D3D10_QUERY_PIPELINE_STATISTICS) + 1,
        D3D10_QUERY_SO_STATISTICS = Ord(D3D10_QUERY_OCCLUSION_PREDICATE) + 1,
        D3D10_QUERY_SO_OVERFLOW_PREDICATE = Ord(D3D10_QUERY_SO_STATISTICS) + 1);

    PD3D10_QUERY = ^TD3D10_QUERY;


    TD3D10_QUERY_MISC_FLAG = (
        D3D10_QUERY_MISC_PREDICATEHINT = $1);

    PD3D10_QUERY_MISC_FLAG = ^TD3D10_QUERY_MISC_FLAG;


    TD3D10_QUERY_DESC = record
        Query: TD3D10_QUERY;
        MiscFlags: UINT;
    end;
    PD3D10_QUERY_DESC = ^TD3D10_QUERY_DESC;




    ID3D10Query = interface(ID3D10Asynchronous)
        ['{9B7E4C0E-342C-4106-A19F-4F2704F689F0}']
        procedure GetDesc(
        {_Out_  } pDesc: PD3D10_QUERY_DESC); stdcall;

    end;


    ID3D10Predicate = interface(ID3D10Query)
        ['{9B7E4C10-342C-4106-A19F-4F2704F689F0}']
    end;


    TD3D10_QUERY_DATA_TIMESTAMP_DISJOINT = record
        Frequency: uint64;
        Disjoint: boolean;
    end;
    PD3D10_QUERY_DATA_TIMESTAMP_DISJOINT = ^TD3D10_QUERY_DATA_TIMESTAMP_DISJOINT;


    TD3D10_QUERY_DATA_PIPELINE_STATISTICS = record
        IAVertices: uint64;
        IAPrimitives: uint64;
        VSInvocations: uint64;
        GSInvocations: uint64;
        GSPrimitives: uint64;
        CInvocations: uint64;
        CPrimitives: uint64;
        PSInvocations: uint64;
    end;
    PD3D10_QUERY_DATA_PIPELINE_STATISTICS = ^TD3D10_QUERY_DATA_PIPELINE_STATISTICS;


    TD3D10_QUERY_DATA_SO_STATISTICS = record
        NumPrimitivesWritten: uint64;
        PrimitivesStorageNeeded: uint64;
    end;
    PD3D10_QUERY_DATA_SO_STATISTICS = ^TD3D10_QUERY_DATA_SO_STATISTICS;


    TD3D10_COUNTER = (
        D3D10_COUNTER_GPU_IDLE = 0,
        D3D10_COUNTER_VERTEX_PROCESSING = (Ord(D3D10_COUNTER_GPU_IDLE) + 1),
        D3D10_COUNTER_GEOMETRY_PROCESSING = (Ord(D3D10_COUNTER_VERTEX_PROCESSING) + 1),
        D3D10_COUNTER_PIXEL_PROCESSING = (Ord(D3D10_COUNTER_GEOMETRY_PROCESSING) + 1),
        D3D10_COUNTER_OTHER_GPU_PROCESSING = (Ord(D3D10_COUNTER_PIXEL_PROCESSING) + 1),
        D3D10_COUNTER_HOST_ADAPTER_BANDWIDTH_UTILIZATION = (Ord(D3D10_COUNTER_OTHER_GPU_PROCESSING) + 1),
        D3D10_COUNTER_LOCAL_VIDMEM_BANDWIDTH_UTILIZATION = (Ord(D3D10_COUNTER_HOST_ADAPTER_BANDWIDTH_UTILIZATION) + 1),
        D3D10_COUNTER_VERTEX_THROUGHPUT_UTILIZATION = (Ord(D3D10_COUNTER_LOCAL_VIDMEM_BANDWIDTH_UTILIZATION) + 1),
        D3D10_COUNTER_TRIANGLE_SETUP_THROUGHPUT_UTILIZATION = (Ord(D3D10_COUNTER_VERTEX_THROUGHPUT_UTILIZATION) + 1),
        D3D10_COUNTER_FILLRATE_THROUGHPUT_UTILIZATION = (Ord(D3D10_COUNTER_TRIANGLE_SETUP_THROUGHPUT_UTILIZATION) + 1),
        D3D10_COUNTER_VS_MEMORY_LIMITED = (Ord(D3D10_COUNTER_FILLRATE_THROUGHPUT_UTILIZATION) + 1),
        D3D10_COUNTER_VS_COMPUTATION_LIMITED = (Ord(D3D10_COUNTER_VS_MEMORY_LIMITED) + 1),
        D3D10_COUNTER_GS_MEMORY_LIMITED = (Ord(D3D10_COUNTER_VS_COMPUTATION_LIMITED) + 1),
        D3D10_COUNTER_GS_COMPUTATION_LIMITED = (Ord(D3D10_COUNTER_GS_MEMORY_LIMITED) + 1),
        D3D10_COUNTER_PS_MEMORY_LIMITED = (Ord(D3D10_COUNTER_GS_COMPUTATION_LIMITED) + 1),
        D3D10_COUNTER_PS_COMPUTATION_LIMITED = (Ord(D3D10_COUNTER_PS_MEMORY_LIMITED) + 1),
        D3D10_COUNTER_POST_TRANSFORM_CACHE_HIT_RATE = (Ord(D3D10_COUNTER_PS_COMPUTATION_LIMITED) + 1),
        D3D10_COUNTER_TEXTURE_CACHE_HIT_RATE = (Ord(D3D10_COUNTER_POST_TRANSFORM_CACHE_HIT_RATE) + 1),
        D3D10_COUNTER_DEVICE_DEPENDENT_0 = $40000000);

    PD3D10_COUNTER = ^TD3D10_COUNTER;


    TD3D10_COUNTER_TYPE = (
        D3D10_COUNTER_TYPE_FLOAT32 = 0,
        D3D10_COUNTER_TYPE_UINT16 = (Ord(D3D10_COUNTER_TYPE_FLOAT32) + 1),
        D3D10_COUNTER_TYPE_UINT32 = (Ord(D3D10_COUNTER_TYPE_UINT16) + 1),
        D3D10_COUNTER_TYPE_UINT64 = (Ord(D3D10_COUNTER_TYPE_UINT32) + 1));

    PD3D10_COUNTER_TYPE = ^TD3D10_COUNTER_TYPE;


    TD3D10_COUNTER_DESC = record
        Counter: TD3D10_COUNTER;
        MiscFlags: UINT;
    end;
    PD3D10_COUNTER_DESC = ^TD3D10_COUNTER_DESC;


    TD3D10_COUNTER_INFO = record
        LastDeviceDependentCounter: TD3D10_COUNTER;
        NumSimultaneousCounters: UINT;
        NumDetectableParallelUnits: uint8;
    end;
    PD3D10_COUNTER_INFO = ^TD3D10_COUNTER_INFO;


    ID3D10Counter = interface(ID3D10Asynchronous)
        ['{9B7E4C11-342C-4106-A19F-4F2704F689F0}']
        procedure GetDesc(
        {_Out_  } pDesc: PD3D10_COUNTER_DESC); stdcall;

    end;


    ID3D10Device = interface(IUnknown)
        ['{9B7E4C0F-342C-4106-A19F-4F2704F689F0}']
        procedure VSSetConstantBuffers(
        {_In_range_( 0, D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_In_reads_opt_(NumBuffers)  } ppConstantBuffers: PID3D10Buffer); stdcall;

        procedure PSSetShaderResources(
        {_In_range_( 0, D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT - StartSlot )  } NumViews: UINT;
        {_In_reads_opt_(NumViews)  } ppShaderResourceViews: PID3D10ShaderResourceView); stdcall;

        procedure PSSetShader(
        {_In_opt_  } pPixelShader: ID3D10PixelShader); stdcall;

        procedure PSSetSamplers(
        {_In_range_( 0, D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT - StartSlot )  } NumSamplers: UINT;
        {_In_reads_opt_(NumSamplers)  } ppSamplers: PID3D10SamplerState); stdcall;

        procedure VSSetShader(
        {_In_opt_  } pVertexShader: ID3D10VertexShader); stdcall;

        procedure DrawIndexed(
        {_In_  } IndexCount: UINT;
        {_In_  } StartIndexLocation: UINT;
        {_In_  } BaseVertexLocation: int32); stdcall;

        procedure Draw(
        {_In_  } VertexCount: UINT;
        {_In_  } StartVertexLocation: UINT); stdcall;

        procedure PSSetConstantBuffers(
        {_In_range_( 0, D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_In_reads_opt_(NumBuffers)  } ppConstantBuffers: PID3D10Buffer); stdcall;

        procedure IASetInputLayout(
        {_In_opt_  } pInputLayout: ID3D10InputLayout); stdcall;

        procedure IASetVertexBuffers(
        {_In_range_( 0, D3D10_1_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_1_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_In_reads_opt_(NumBuffers)  } ppVertexBuffers: PID3D10Buffer;
        {_In_reads_opt_(NumBuffers)  } pStrides: PUINT;
        {_In_reads_opt_(NumBuffers)  } pOffsets: PUINT); stdcall;

        procedure IASetIndexBuffer(
        {_In_opt_  } pIndexBuffer: ID3D10Buffer;
        {_In_  } Format: TDXGI_FORMAT;
        {_In_  } Offset: UINT); stdcall;

        procedure DrawIndexedInstanced(
        {_In_  } IndexCountPerInstance: UINT;
        {_In_  } InstanceCount: UINT;
        {_In_  } StartIndexLocation: UINT;
        {_In_  } BaseVertexLocation: int32;
        {_In_  } StartInstanceLocation: UINT); stdcall;

        procedure DrawInstanced(
        {_In_  } VertexCountPerInstance: UINT;
        {_In_  } InstanceCount: UINT;
        {_In_  } StartVertexLocation: UINT;
        {_In_  } StartInstanceLocation: UINT); stdcall;

        procedure GSSetConstantBuffers(
        {_In_range_( 0, D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_In_reads_opt_(NumBuffers)  } ppConstantBuffers: PID3D10Buffer); stdcall;

        procedure GSSetShader(
        {_In_opt_  } pShader: ID3D10GeometryShader); stdcall;

        procedure IASetPrimitiveTopology(
        {_In_  } Topology: TD3D10_PRIMITIVE_TOPOLOGY); stdcall;

        procedure VSSetShaderResources(
        {_In_range_( 0, D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT - StartSlot )  } NumViews: UINT;
        {_In_reads_opt_(NumViews)  } ppShaderResourceViews: PID3D10ShaderResourceView); stdcall;

        procedure VSSetSamplers(
        {_In_range_( 0, D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT - StartSlot )  } NumSamplers: UINT;
        {_In_reads_opt_(NumSamplers)  } ppSamplers: PID3D10SamplerState); stdcall;

        procedure SetPredication(
        {_In_opt_  } pPredicate: ID3D10Predicate;
        {_In_  } PredicateValue: boolean); stdcall;

        procedure GSSetShaderResources(
        {_In_range_( 0, D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT - StartSlot )  } NumViews: UINT;
        {_In_reads_opt_(NumViews)  } ppShaderResourceViews: PID3D10ShaderResourceView); stdcall;

        procedure GSSetSamplers(
        {_In_range_( 0, D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT - StartSlot )  } NumSamplers: UINT;
        {_In_reads_opt_(NumSamplers)  } ppSamplers: PID3D10SamplerState); stdcall;

        procedure OMSetRenderTargets(
        {_In_range_( 0, D3D10_SIMULTANEOUS_RENDER_TARGET_COUNT )  } NumViews: UINT;
        {_In_reads_opt_(NumViews)  } ppRenderTargetViews: PID3D10RenderTargetView;
        {_In_opt_  } pDepthStencilView: ID3D10DepthStencilView); stdcall;

        procedure OMSetBlendState(
        {_In_opt_  } pBlendState: ID3D10BlendState;
        {_In_  } BlendFactor: TFloatArray4;
        {_In_  } SampleMask: UINT); stdcall;

        procedure OMSetDepthStencilState(
        {_In_opt_  } pDepthStencilState: ID3D10DepthStencilState;
        {_In_  } StencilRef: UINT); stdcall;

        procedure SOSetTargets(
        {_In_range_( 0, D3D10_SO_BUFFER_SLOT_COUNT)  } NumBuffers: UINT;
        {_In_reads_opt_(NumBuffers)  } ppSOTargets: PID3D10Buffer;
        {_In_reads_opt_(NumBuffers)  } pOffsets: PUINT); stdcall;

        procedure DrawAuto(); stdcall;

        procedure RSSetState(
        {_In_opt_  } pRasterizerState: ID3D10RasterizerState); stdcall;

        procedure RSSetViewports(
        {_In_range_(0, D3D10_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE)  } NumViewports: UINT;
        {_In_reads_opt_(NumViewports)  } pViewports: PD3D10_VIEWPORT); stdcall;

        procedure RSSetScissorRects(
        {_In_range_(0, D3D10_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE)  } NumRects: UINT;
        {_In_reads_opt_(NumRects)  } pRects: PD3D10_RECT); stdcall;

        procedure CopySubresourceRegion(
        {_In_  } pDstResource: ID3D10Resource;
        {_In_  } DstSubresource: UINT;
        {_In_  } DstX: UINT;
        {_In_  } DstY: UINT;
        {_In_  } DstZ: UINT;
        {_In_  } pSrcResource: ID3D10Resource;
        {_In_  } SrcSubresource: UINT;
        {_In_opt_  } pSrcBox: PD3D10_BOX); stdcall;

        procedure CopyResource(
        {_In_  } pDstResource: ID3D10Resource;
        {_In_  } pSrcResource: ID3D10Resource); stdcall;

        procedure UpdateSubresource(
        {_In_  } pDstResource: ID3D10Resource;
        {_In_  } DstSubresource: UINT;
        {_In_opt_  } pDstBox: PD3D10_BOX;
        {_In_  } pSrcData: Pvoid;
        {_In_  } SrcRowPitch: UINT;
        {_In_  } SrcDepthPitch: UINT); stdcall;

        procedure ClearRenderTargetView(
        {_In_  } pRenderTargetView: ID3D10RenderTargetView;
        {_In_  } ColorRGBA: TFloatArray4); stdcall;

        procedure ClearDepthStencilView(
        {_In_  } pDepthStencilView: ID3D10DepthStencilView;
        {_In_  } ClearFlags: UINT;
        {_In_  } Depth: single;
        {_In_  } Stencil: uint8); stdcall;

        procedure GenerateMips(
        {_In_  } pShaderResourceView: ID3D10ShaderResourceView); stdcall;

        procedure ResolveSubresource(
        {_In_  } pDstResource: ID3D10Resource;
        {_In_  } DstSubresource: UINT;
        {_In_  } pSrcResource: ID3D10Resource;
        {_In_  } SrcSubresource: UINT;
        {_In_  } Format: TDXGI_FORMAT); stdcall;

        procedure VSGetConstantBuffers(
        {_In_range_( 0, D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_Out_writes_opt_(NumBuffers)  }  out ppConstantBuffers: ID3D10Buffer); stdcall;

        procedure PSGetShaderResources(
        {_In_range_( 0, D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT - StartSlot )  } NumViews: UINT;
        {_Out_writes_opt_(NumViews)  }  out ppShaderResourceViews: ID3D10ShaderResourceView); stdcall;

        procedure PSGetShader(
        {_Out_  }  out ppPixelShader: ID3D10PixelShader); stdcall;

        procedure PSGetSamplers(
        {_In_range_( 0, D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT - StartSlot )  } NumSamplers: UINT;
        {_Out_writes_opt_(NumSamplers)  }  out ppSamplers: ID3D10SamplerState); stdcall;

        procedure VSGetShader(
        {_Out_  }  out ppVertexShader: ID3D10VertexShader); stdcall;

        procedure PSGetConstantBuffers(
        {_In_range_( 0, D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_Out_writes_opt_(NumBuffers)  }  out ppConstantBuffers: ID3D10Buffer); stdcall;

        procedure IAGetInputLayout(
        {_Out_  }  out ppInputLayout: ID3D10InputLayout); stdcall;

        procedure IAGetVertexBuffers(
        {_In_range_( 0, D3D10_1_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_1_IA_VERTEX_INPUT_RESOURCE_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_Out_writes_opt_(NumBuffers)  }  out ppVertexBuffers: ID3D10Buffer;
        {_Out_writes_opt_(NumBuffers)  } pStrides: PUINT;
        {_Out_writes_opt_(NumBuffers)  } pOffsets: PUINT); stdcall;

        procedure IAGetIndexBuffer(
        {_Out_opt_  }  out pIndexBuffer: ID3D10Buffer;
        {_Out_opt_  } Format: PDXGI_FORMAT;
        {_Out_opt_  } Offset: PUINT); stdcall;

        procedure GSGetConstantBuffers(
        {_In_range_( 0, D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_CONSTANT_BUFFER_API_SLOT_COUNT - StartSlot )  } NumBuffers: UINT;
        {_Out_writes_opt_(NumBuffers)  }  out ppConstantBuffers: ID3D10Buffer); stdcall;

        procedure GSGetShader(
        {_Out_  }  out ppGeometryShader: ID3D10GeometryShader); stdcall;

        procedure IAGetPrimitiveTopology(
        {_Out_  } pTopology: PD3D10_PRIMITIVE_TOPOLOGY); stdcall;

        procedure VSGetShaderResources(
        {_In_range_( 0, D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT - StartSlot )  } NumViews: UINT;
        {_Out_writes_opt_(NumViews)  }  out ppShaderResourceViews: ID3D10ShaderResourceView); stdcall;

        procedure VSGetSamplers(
        {_In_range_( 0, D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT - StartSlot )  } NumSamplers: UINT;
        {_Out_writes_opt_(NumSamplers)  }  out ppSamplers: ID3D10SamplerState); stdcall;

        procedure GetPredication(
        {_Out_opt_  }  out ppPredicate: ID3D10Predicate;
        {_Out_opt_  } pPredicateValue: Pboolean); stdcall;

        procedure GSGetShaderResources(
        {_In_range_( 0, D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_INPUT_RESOURCE_SLOT_COUNT - StartSlot )  } NumViews: UINT;
        {_Out_writes_opt_(NumViews)  }  out ppShaderResourceViews: ID3D10ShaderResourceView); stdcall;

        procedure GSGetSamplers(
        {_In_range_( 0, D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT - 1 )  } StartSlot: UINT;
        {_In_range_( 0, D3D10_COMMONSHADER_SAMPLER_SLOT_COUNT - StartSlot )  } NumSamplers: UINT;
        {_Out_writes_opt_(NumSamplers)  }  out ppSamplers: ID3D10SamplerState); stdcall;

        procedure OMGetRenderTargets(
        {_In_range_( 0, D3D10_SIMULTANEOUS_RENDER_TARGET_COUNT )  } NumViews: UINT;
        {_Out_writes_opt_(NumViews)  }  out ppRenderTargetViews: ID3D10RenderTargetView;
        {_Out_opt_  }  out ppDepthStencilView: ID3D10DepthStencilView); stdcall;

        procedure OMGetBlendState(
        {_Out_opt_  }  out ppBlendState: ID3D10BlendState;
        {_Out_opt_  } BlendFactor: TFloatArray4;
        {_Out_opt_  } pSampleMask: PUINT); stdcall;

        procedure OMGetDepthStencilState(
        {_Out_opt_  }  out ppDepthStencilState: ID3D10DepthStencilState;
        {_Out_opt_  } pStencilRef: PUINT); stdcall;

        procedure SOGetTargets(
        {_In_range_( 0, D3D10_SO_BUFFER_SLOT_COUNT )  } NumBuffers: UINT;
        {_Out_writes_opt_(NumBuffers)  }  out ppSOTargets: ID3D10Buffer;
        {_Out_writes_opt_(NumBuffers)  } pOffsets: PUINT); stdcall;

        procedure RSGetState(
        {_Out_  }  out ppRasterizerState: ID3D10RasterizerState); stdcall;

        procedure RSGetViewports(
        (*_range(0, D3D10_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE )*)
        {_Inout_    } NumViewports: PUINT;
        {_Out_writes_opt_(*NumViewports)  } pViewports: PD3D10_VIEWPORT); stdcall;

        procedure RSGetScissorRects(
        (*_range(0, D3D10_VIEWPORT_AND_SCISSORRECT_OBJECT_COUNT_PER_PIPELINE )*)
        {_Inout_    } NumRects: PUINT;
        {_Out_writes_opt_(*NumRects)  } pRects: PD3D10_RECT); stdcall;

        function GetDeviceRemovedReason(): HRESULT; stdcall;

        function SetExceptionMode(RaiseFlags: UINT): HRESULT; stdcall;

        function GetExceptionMode(): UINT; stdcall;

        function GetPrivateData(
        {_In_  } guid: REFGUID;
        {_Inout_  } pDataSize: PUINT;
        {_Out_writes_bytes_opt_(*pDataSize)  } pData: Pvoid): HRESULT; stdcall;

        function SetPrivateData(
        {_In_  } guid: REFGUID;
        {_In_  } DataSize: UINT;
        {_In_reads_bytes_opt_(DataSize)  } pData: Pvoid): HRESULT; stdcall;

        function SetPrivateDataInterface(
        {_In_  } guid: REFGUID;
        {_In_opt_  } pData: IUnknown): HRESULT; stdcall;

        procedure ClearState(); stdcall;

        procedure Flush(); stdcall;

        function CreateBuffer(
        {_In_  } pDesc: PD3D10_BUFFER_DESC;
        {_In_opt_  } pInitialData: PD3D10_SUBRESOURCE_DATA;
        {_Out_opt_  }  out ppBuffer: ID3D10Buffer): HRESULT; stdcall;

        function CreateTexture1D(
        {_In_  } pDesc: PD3D10_TEXTURE1D_DESC;
        {_In_reads_opt_(_Inexpressible_(pDesc->MipLevels * pDesc->ArraySize))  } pInitialData: PD3D10_SUBRESOURCE_DATA;
        {_Out_  }  out ppTexture1D: ID3D10Texture1D): HRESULT; stdcall;

        function CreateTexture2D(
        {_In_  } pDesc: PD3D10_TEXTURE2D_DESC;
        {_In_reads_opt_(_Inexpressible_(pDesc->MipLevels * pDesc->ArraySize))  } pInitialData: PD3D10_SUBRESOURCE_DATA;
        {_Out_  }  out ppTexture2D: ID3D10Texture2D): HRESULT; stdcall;

        function CreateTexture3D(
        {_In_  } pDesc: PD3D10_TEXTURE3D_DESC;
        {_In_reads_opt_(_Inexpressible_(pDesc->MipLevels))  } pInitialData: PD3D10_SUBRESOURCE_DATA;
        {_Out_  }  out ppTexture3D: ID3D10Texture3D): HRESULT; stdcall;

        function CreateShaderResourceView(
        {_In_  } pResource: ID3D10Resource;
        {_In_opt_  } pDesc: PD3D10_SHADER_RESOURCE_VIEW_DESC;
        {_Out_opt_  }  out ppSRView: ID3D10ShaderResourceView): HRESULT; stdcall;

        function CreateRenderTargetView(
        {_In_  } pResource: ID3D10Resource;
        {_In_opt_  } pDesc: PD3D10_RENDER_TARGET_VIEW_DESC;
        {_Out_opt_  }  out ppRTView: ID3D10RenderTargetView): HRESULT; stdcall;

        function CreateDepthStencilView(
        {_In_  } pResource: ID3D10Resource;
        {_In_opt_  } pDesc: PD3D10_DEPTH_STENCIL_VIEW_DESC;
        {_Out_opt_  }  out ppDepthStencilView: ID3D10DepthStencilView): HRESULT; stdcall;

        function CreateInputLayout(
        {_In_reads_(NumElements)  } pInputElementDescs: PD3D10_INPUT_ELEMENT_DESC;
        {_In_range_( 0, D3D10_1_IA_VERTEX_INPUT_STRUCTURE_ELEMENT_COUNT )  } NumElements: UINT;
        {_In_reads_(BytecodeLength)  } pShaderBytecodeWithInputSignature: Pvoid;
        {_In_  } BytecodeLength: SIZE_T;
        {_Out_opt_  }  out ppInputLayout: ID3D10InputLayout): HRESULT; stdcall;

        function CreateVertexShader(
        {_In_reads_(BytecodeLength)  } pShaderBytecode: Pvoid;
        {_In_  } BytecodeLength: SIZE_T;
        {_Out_opt_  }  out ppVertexShader: ID3D10VertexShader): HRESULT; stdcall;

        function CreateGeometryShader(
        {_In_reads_(BytecodeLength)  } pShaderBytecode: Pvoid;
        {_In_  } BytecodeLength: SIZE_T;
        {_Out_opt_  }  out ppGeometryShader: ID3D10GeometryShader): HRESULT; stdcall;

        function CreateGeometryShaderWithStreamOutput(
        {_In_reads_(BytecodeLength)  } pShaderBytecode: Pvoid;
        {_In_  } BytecodeLength: SIZE_T;
        {_In_reads_opt_(NumEntries)  } pSODeclaration: PD3D10_SO_DECLARATION_ENTRY;
        {_In_range_( 0, D3D10_SO_SINGLE_BUFFER_COMPONENT_LIMIT )  } NumEntries: UINT;
        {_In_  } OutputStreamStride: UINT;
        {_Out_opt_  }  out ppGeometryShader: ID3D10GeometryShader): HRESULT; stdcall;

        function CreatePixelShader(
        {_In_reads_(BytecodeLength)  } pShaderBytecode: Pvoid;
        {_In_  } BytecodeLength: SIZE_T;
        {_Out_opt_  }  out ppPixelShader: ID3D10PixelShader): HRESULT; stdcall;

        function CreateBlendState(
        {_In_  } pBlendStateDesc: PD3D10_BLEND_DESC;
        {_Out_opt_  }  out ppBlendState: ID3D10BlendState): HRESULT; stdcall;

        function CreateDepthStencilState(
        {_In_  } pDepthStencilDesc: PD3D10_DEPTH_STENCIL_DESC;
        {_Out_opt_  }  out ppDepthStencilState: ID3D10DepthStencilState): HRESULT; stdcall;

        function CreateRasterizerState(
        {_In_  } pRasterizerDesc: PD3D10_RASTERIZER_DESC;
        {_Out_opt_  }  out ppRasterizerState: ID3D10RasterizerState): HRESULT; stdcall;

        function CreateSamplerState(
        {_In_  } pSamplerDesc: PD3D10_SAMPLER_DESC;
        {_Out_opt_  }  out ppSamplerState: ID3D10SamplerState): HRESULT; stdcall;

        function CreateQuery(
        {_In_  } pQueryDesc: PD3D10_QUERY_DESC;
        {_Out_opt_  }  out ppQuery: ID3D10Query): HRESULT; stdcall;

        function CreatePredicate(
        {_In_  } pPredicateDesc: PD3D10_QUERY_DESC;
        {_Out_opt_  }  out ppPredicate: ID3D10Predicate): HRESULT; stdcall;

        function CreateCounter(
        {_In_  } pCounterDesc: PD3D10_COUNTER_DESC;
        {_Out_opt_  }  out ppCounter: ID3D10Counter): HRESULT; stdcall;

        function CheckFormatSupport(
        {_In_  } Format: TDXGI_FORMAT;
        {_Out_  } pFormatSupport: PUINT): HRESULT; stdcall;

        function CheckMultisampleQualityLevels(
        {_In_  } Format: TDXGI_FORMAT;
        {_In_  } SampleCount: UINT;
        {_Out_  } pNumQualityLevels: PUINT): HRESULT; stdcall;

        procedure CheckCounterInfo(
        {_Out_  } pCounterInfo: PD3D10_COUNTER_INFO); stdcall;

        function CheckCounter(
        {_In_  } pDesc: PD3D10_COUNTER_DESC;
        {_Out_  } pType: PD3D10_COUNTER_TYPE;
        {_Out_  } pActiveCounters: PUINT;
        {_Out_writes_opt_(*pNameLength)  } szName: LPSTR;
        {_Inout_opt_  } pNameLength: PUINT;
        {_Out_writes_opt_(*pUnitsLength)  } szUnits: LPSTR;
        {_Inout_opt_  } pUnitsLength: PUINT;
        {_Out_writes_opt_(*pDescriptionLength)  } szDescription: LPSTR;
        {_Inout_opt_  } pDescriptionLength: PUINT): HRESULT; stdcall;

        function GetCreationFlags(): UINT; stdcall;

        function OpenSharedResource(
        {_In_  } hResource: HANDLE;
        {_In_  } ReturnedInterface: REFIID;
        {_Out_opt_  }  out ppResource): HRESULT; stdcall;

        procedure SetTextFilterSize(
        {_In_  } Width: UINT;
        {_In_  } Height: UINT); stdcall;

        procedure GetTextFilterSize(
        {_Out_opt_  } pWidth: PUINT;
        {_Out_opt_  } pHeight: PUINT); stdcall;

    end;


    ID3D10Multithread = interface(IUnknown)
        ['{9B7E4E00-342C-4106-A19F-4F2704F689F0}']
        procedure Enter(); stdcall;

        procedure Leave(); stdcall;

        function SetMultithreadProtected(
        {_In_  } bMTProtect: boolean): boolean; stdcall;

        function GetMultithreadProtected(): boolean; stdcall;

    end;

    TD3D10_CREATE_DEVICE_FLAG = (
        D3D10_CREATE_DEVICE_SINGLETHREADED = $1,
        D3D10_CREATE_DEVICE_DEBUG = $2,
        D3D10_CREATE_DEVICE_SWITCH_TO_REF = $4,
        D3D10_CREATE_DEVICE_PREVENT_INTERNAL_THREADING_OPTIMIZATIONS = $8,
        D3D10_CREATE_DEVICE_ALLOW_NULL_FROM_MAP = $10,
        D3D10_CREATE_DEVICE_BGRA_SUPPORT = $20,
        D3D10_CREATE_DEVICE_PREVENT_ALTERING_LAYER_SETTINGS_FROM_REGISTRY = $80,
        D3D10_CREATE_DEVICE_STRICT_VALIDATION = $200,
        D3D10_CREATE_DEVICE_DEBUGGABLE = $400);

    PD3D10_CREATE_DEVICE_FLAG = ^TD3D10_CREATE_DEVICE_FLAG;


function D3D10CalcSubresource(MipSlice: UINT; ArraySlice: UINT; MipLevels: UINT): UINT;
function MAKE_D3D10_HRESULT(code: longword): HRESULT;
function MAKE_D3D10_STATUS(code: longword): HRESULT;

function D3D10_ENCODE_BASIC_FILTER(min, mag, mip: TD3D10_FILTER_TYPE; bComparison: boolean): TD3D10_FILTER;
function D3D10_ENCODE_ANISOTROPIC_FILTER(bComparison: boolean): TD3D10_FILTER;
function D3D10_DECODE_MIN_FILTER(d3d10Filter: UINT): TD3D10_FILTER_TYPE;
function D3D10_DECODE_MAG_FILTER(d3d10Filter: UINT): TD3D10_FILTER_TYPE;
function D3D10_DECODE_MIP_FILTER(d3d10Filter: UINT): TD3D10_FILTER_TYPE;
function D3D10_DECODE_IS_COMPARISON_FILTER(d3d10Filter: UINT): boolean;
function D3D10_DECODE_IS_ANISOTROPIC_FILTER(d3d10Filter: UINT): boolean;
function D3D10_DECODE_IS_TEXT_1BIT_FILTER(d3d10Filter: UINT): boolean;

implementation

uses
    Windows.Macros;



function D3D10CalcSubresource(MipSlice: UINT; ArraySlice: UINT; MipLevels: UINT): UINT; inline;
begin
    Result := MipSlice + ArraySlice * MipLevels;
end;



function MAKE_D3D10_HRESULT(code: longword): HRESULT;
begin
    Result := MAKE_HRESULT(1, _FACD3D10, code);
end;



function MAKE_D3D10_STATUS(code: longword): HRESULT;
begin
    Result := MAKE_HRESULT(0, _FACD3D10, code);
end;



function D3D10_ENCODE_BASIC_FILTER(min, mag, mip: TD3D10_FILTER_TYPE; bComparison: boolean): TD3D10_FILTER;
var
    lFilter: int32 = 0;
begin
    if bComparison then
        lFilter := D3D10_COMPARISON_FILTERING_BIT;

    lFilter := lFilter or ((Ord(min) and D3D10_FILTER_TYPE_MASK) shl D3D10_MIN_FILTER_SHIFT) or ((Ord(mag) and D3D10_FILTER_TYPE_MASK) shl D3D10_MAG_FILTER_SHIFT) or ((Ord(mip) and D3D10_FILTER_TYPE_MASK) shl D3D10_MIP_FILTER_SHIFT);

    Result := TD3D10_FILTER(lFilter);

end;



function D3D10_ENCODE_ANISOTROPIC_FILTER(bComparison: boolean): TD3D10_FILTER;
begin
    Result := TD3D10_FILTER(D3D10_ANISOTROPIC_FILTERING_BIT or Ord(D3D10_ENCODE_BASIC_FILTER(D3D10_FILTER_TYPE_LINEAR, D3D10_FILTER_TYPE_LINEAR, D3D10_FILTER_TYPE_LINEAR, bComparison)));
end;



function D3D10_DECODE_MIN_FILTER(d3d10Filter: UINT): TD3D10_FILTER_TYPE;
begin
    Result := TD3D10_FILTER_TYPE((d3d10Filter shr D3D10_MIN_FILTER_SHIFT) and D3D10_FILTER_TYPE_MASK);
end;



function D3D10_DECODE_MAG_FILTER(d3d10Filter: UINT): TD3D10_FILTER_TYPE;
begin
    Result := TD3D10_FILTER_TYPE((d3d10Filter shr D3D10_MAG_FILTER_SHIFT) and D3D10_FILTER_TYPE_MASK);
end;



function D3D10_DECODE_MIP_FILTER(d3d10Filter: UINT): TD3D10_FILTER_TYPE;
begin
    Result := TD3D10_FILTER_TYPE((d3d10Filter shr D3D10_MIP_FILTER_SHIFT) and D3D10_FILTER_TYPE_MASK);
end;



function D3D10_DECODE_IS_COMPARISON_FILTER(d3d10Filter: UINT): boolean;
begin
    Result := (d3d10Filter and D3D10_COMPARISON_FILTERING_BIT) = D3D10_COMPARISON_FILTERING_BIT;
end;



function D3D10_DECODE_IS_ANISOTROPIC_FILTER(d3d10Filter: UINT): boolean;
begin
    Result := ((d3d10Filter and D3D10_ANISOTROPIC_FILTERING_BIT) = D3D10_ANISOTROPIC_FILTERING_BIT) and (D3D10_FILTER_TYPE_LINEAR = D3D10_DECODE_MIN_FILTER(d3d10Filter)) and
        (D3D10_FILTER_TYPE_LINEAR = D3D10_DECODE_MAG_FILTER(d3d10Filter)) and (D3D10_FILTER_TYPE_LINEAR = D3D10_DECODE_MIP_FILTER(d3d10Filter));
end;



function D3D10_DECODE_IS_TEXT_1BIT_FILTER(d3d10Filter: UINT): boolean;
begin
    result:= ( d3d10Filter = D3D10_TEXT_1BIT_BIT);
end;

{ TD3D10_BUFFER_DESC }

class operator TD3D10_BUFFER_DESC.Initialize(var aRec: TD3D10_BUFFER_DESC);
begin
    arec.ByteWidth := 0;
    arec.bindFlags := 0;
    arec.usage := D3D10_USAGE_DEFAULT;
    arec.cpuaccessFlags := 0;
    arec.miscFlags := 0;
end;



constructor TD3D10_BUFFER_DESC.Create(byteWidth: UINT; bindFlags: UINT; usage: TD3D10_USAGE; cpuaccessFlags: UINT; miscFlags: UINT);
begin
    self.ByteWidth := byteWidth;
    self.Usage := usage;
    self.BindFlags := bindFlags;
    self.CPUAccessFlags := cpuaccessFlags;
    self.MiscFlags := miscFlags;
end;

{ TD3D10_TEXTURE1D_DESC }

class operator TD3D10_TEXTURE1D_DESC.Initialize(var aRec: TD3D10_TEXTURE1D_DESC);
begin
    aRec.format := DXGI_FORMAT_UNKNOWN;
    aRec.Width := 0;
    aRec.arraySize := 1;
    aRec.mipLevels := 0;
    aRec.bindFlags := Ord(D3D10_BIND_SHADER_RESOURCE);
    aRec.usage := D3D10_USAGE_DEFAULT;
    aRec.cpuaccessFlags := 0;
    aRec.miscFlags := 0;
end;



constructor TD3D10_TEXTURE1D_DESC.Create(format: TDXGI_FORMAT; Width: UINT; arraySize: UINT; mipLevels: UINT; bindFlags: UINT; usage: TD3D10_USAGE; cpuaccessFlags: UINT; miscFlags: UINT);
begin
    Self.Width := Width;
    Self.MipLevels := mipLevels;
    Self.ArraySize := arraySize;
    Self.Format := format;
    Self.Usage := usage;
    Self.BindFlags := bindFlags;
    Self.CPUAccessFlags := cpuaccessFlags;
    Self.MiscFlags := miscFlags;
end;

{ TD3D10_TEXTURE2D_DESC }

class operator TD3D10_TEXTURE2D_DESC.Initialize(var aRec: TD3D10_TEXTURE2D_DESC);
begin
    aRec.format := DXGI_FORMAT_UNKNOWN;
    aRec.Width := 0;
    aRec.Height := 0;
    aRec.arraySize := 1;
    aRec.mipLevels := 0;
    aRec.bindFlags := Ord(D3D10_BIND_SHADER_RESOURCE);
    aRec.usage := D3D10_USAGE_DEFAULT;
    aRec.cpuaccessFlags := 0;
    aRec.SampleDesc.Count := 1;
    aRec.SampleDesc.Quality := 0;
    aRec.miscFlags := 0;
end;



constructor TD3D10_TEXTURE2D_DESC.Create(format: TDXGI_FORMAT; Width: UINT; Height: UINT; arraySize: UINT; mipLevels: UINT; bindFlags: UINT; usage: TD3D10_USAGE; cpuaccessFlags: UINT; sampleCount: UINT; sampleQuality: UINT; miscFlags: UINT);
begin
    self.Width := Width;
    self.Height := Height;
    self.MipLevels := mipLevels;
    self.ArraySize := arraySize;
    self.Format := format;
    self.SampleDesc.Count := sampleCount;
    self.SampleDesc.Quality := sampleQuality;
    self.Usage := usage;
    self.BindFlags := bindFlags;
    self.CPUAccessFlags := cpuaccessFlags;
    self.MiscFlags := miscFlags;
end;

{ TD3D10_TEXTURE3D_DESC }

class operator TD3D10_TEXTURE3D_DESC.Initialize(var aRec: TD3D10_TEXTURE3D_DESC);
begin
    aRec.format := DXGI_FORMAT_UNKNOWN;
    aRec.Width := 0;
    aRec.Height := 0;
    aRec.depth := 0;
    aRec.mipLevels := 0;
    aRec.bindFlags := Ord(D3D10_BIND_SHADER_RESOURCE);
    aRec.usage := D3D10_USAGE_DEFAULT;
    aRec.cpuaccessFlags := 0;
    aRec.miscFlags := 0;
end;



constructor TD3D10_TEXTURE3D_DESC.Create(format: TDXGI_FORMAT; Width: UINT; Height: UINT; depth: UINT; mipLevels: UINT; bindFlags: UINT; usage: TD3D10_USAGE; cpuaccessFlags: UINT; miscFlags: UINT);
begin
    self.Width := Width;
    self.Height := Height;
    self.Depth := depth;
    self.MipLevels := mipLevels;
    self.Format := format;
    self.Usage := usage;
    self.BindFlags := bindFlags;
    self.CPUAccessFlags := cpuaccessFlags;
    self.MiscFlags := miscFlags;
end;

end.
