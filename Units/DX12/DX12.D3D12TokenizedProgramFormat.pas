unit DX12.D3D12TokenizedProgramFormat;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils;


    //*********************************************************
    // Copyright (c) Microsoft Corporation.
    // Licensed under the MIT License (MIT).
    //*********************************************************
    // High Level Goals
    // - Serve as the runtime/DDI representation for all D3D11 tokenized code,
    //   for all classes of programs, including pixel program, vertex program,
    //   geometry program, etc.
    // - Any information that HLSL needs to give to drivers is encoded in
    //   this token format in some form.
    // - Enable common tools and source code for managing all tokenizable
    //   program formats.
    // - Support extensible token definitions, allowing full customizations for
    //   specific program classes, while maintaining general conventions for all
    //   program models.
    // - Binary backwards compatible with D3D10.  Any token name that was originally
    //   defined with "D3D10" in it is unchanged; D3D11 only adds new tokens.
    // ----------------------------------------------------------------------------
    // Low Level Feature Summary
    // - DWORD based tokens always, for simplicity
    // - Opcode token is generally a single DWORD, though there is a bit indicating
    //   if extended information (extra DWORD(s)) are present
    // - Operand tokens are a completely self contained, extensible format,
    //   with scalar and 4-vector data types as first class citizens, but
    //   allowance for extension to n-component vectors.
    // - Initial operand token identifies register type, register file
    //   structure/dimensionality and mode of indexing for each dimension,
    //   and choice of component selection mechanism (i.e. mask vs. swizzle etc).
    // - Optional additional extended operand tokens can defined things like
    //   modifiers (which are not needed by default).
    // - Operand's immediate index value(s), if needed, appear as subsequent DWORD
    //   values, and if relative addressing is specified, an additional completely
    //   self contained operand definition appears nested in the token sequence.
    // ----------------------------------------------------------------------------

const


    D3D10_SB_TOKENIZED_PROGRAM_TYPE_MASK = $ffff0000;
    D3D10_SB_TOKENIZED_PROGRAM_TYPE_SHIFT = 16;


    D3D10_SB_TOKENIZED_PROGRAM_MAJOR_VERSION_MASK = $000000f0;
    D3D10_SB_TOKENIZED_PROGRAM_MAJOR_VERSION_SHIFT = 4;
    D3D10_SB_TOKENIZED_PROGRAM_MINOR_VERSION_MASK = $0000000f;

    MAX_D3D10_SB_TOKENIZED_PROGRAM_LENGTH = ($ffffffff);

    D3D10_SB_OPCODE_TYPE_MASK = $00007ff;

    D3D10_SB_TOKENIZED_INSTRUCTION_LENGTH_MASK = $7f000000;
    D3D10_SB_TOKENIZED_INSTRUCTION_LENGTH_SHIFT = 24;


    MAX_D3D10_SB_TOKENIZED_INSTRUCTION_LENGTH = 127;

    D3D10_SB_INSTRUCTION_SATURATE_MASK = $00002000;

    D3D10_SB_INSTRUCTION_TEST_BOOLEAN_MASK = $00040000;
    D3D10_SB_INSTRUCTION_TEST_BOOLEAN_SHIFT = 18;

    // Precise value mask (bits 19-22)
    // This is part of the opcode specific control range.
    // It's 1 bit per-channel of the output, for instructions with multiple
    // output operands, it applies to that component in each operand. This
    // uses the components defined in D3D10_SB_COMPONENT_NAME.
    D3D11_SB_INSTRUCTION_PRECISE_VALUES_MASK = $00780000;
    D3D11_SB_INSTRUCTION_PRECISE_VALUES_SHIFT = 19;


    D3D10_SB_RESINFO_INSTRUCTION_RETURN_TYPE_MASK = $00001800;
    D3D10_SB_RESINFO_INSTRUCTION_RETURN_TYPE_SHIFT = 11;

    // sync instruction flags
    D3D11_SB_SYNC_THREADS_IN_GROUP = $00000800;
    D3D11_SB_SYNC_THREAD_GROUP_SHARED_MEMORY = $00001000;
    D3D11_SB_SYNC_UNORDERED_ACCESS_VIEW_MEMORY_GROUP = $00002000;
    D3D11_SB_SYNC_UNORDERED_ACCESS_VIEW_MEMORY_GLOBAL = $00004000;
    D3D11_SB_SYNC_FLAGS_MASK = $00007800;

    D3D10_SB_OPCODE_EXTENDED_MASK = $80000000;
    D3D10_SB_OPCODE_EXTENDED_SHIFT = 31;


    D3D11_SB_MAX_SIMULTANEOUS_EXTENDED_OPCODES = 3;

    D3D10_SB_EXTENDED_OPCODE_TYPE_MASK = $0000003f;

    D3D10_SB_IMMEDIATE_ADDRESS_OFFSET_COORD_MASK = (3);

    D3D11_SB_EXTENDED_RESOURCE_DIMENSION_MASK = $000007C0;
    D3D11_SB_EXTENDED_RESOURCE_DIMENSION_SHIFT = 6;

    D3D11_SB_EXTENDED_RESOURCE_DIMENSION_STRUCTURE_STRIDE_MASK = $007FF800;
    D3D11_SB_EXTENDED_RESOURCE_DIMENSION_STRUCTURE_STRIDE_SHIFT = 11;

    D3D10_SB_RESOURCE_RETURN_TYPE_MASK = $0000000f;
    D3D10_SB_RESOURCE_RETURN_TYPE_NUMBITS = $00000004;
    D3D11_SB_EXTENDED_RESOURCE_RETURN_TYPE_SHIFT = 6;


    D3D10_SB_CUSTOMDATA_CLASS_MASK = $fffff800;
    D3D10_SB_CUSTOMDATA_CLASS_SHIFT = 11;


    D3D10_SB_OPERAND_NUM_COMPONENTS_MASK = $00000003;

    D3D10_SB_OPERAND_4_COMPONENT_SELECTION_MODE_MASK = $0000000c;
    D3D10_SB_OPERAND_4_COMPONENT_SELECTION_MODE_SHIFT = 2;


    D3D10_SB_4_COMPONENT_NAME_MASK = 3;

    // MACROS FOR USE IN D3D10_SB_OPERAND_4_COMPONENT_MASK_MODE:

    D3D10_SB_OPERAND_4_COMPONENT_MASK_MASK = $000000f0;
    D3D10_SB_OPERAND_4_COMPONENT_MASK_SHIFT = 4;
    D3D10_SB_OPERAND_4_COMPONENT_MASK_X = $00000010;
    D3D10_SB_OPERAND_4_COMPONENT_MASK_Y = $00000020;
    D3D10_SB_OPERAND_4_COMPONENT_MASK_Z = $00000040;
    D3D10_SB_OPERAND_4_COMPONENT_MASK_W = $00000080;
    D3D10_SB_OPERAND_4_COMPONENT_MASK_R = D3D10_SB_OPERAND_4_COMPONENT_MASK_X;
    D3D10_SB_OPERAND_4_COMPONENT_MASK_G = D3D10_SB_OPERAND_4_COMPONENT_MASK_Y;
    D3D10_SB_OPERAND_4_COMPONENT_MASK_B = D3D10_SB_OPERAND_4_COMPONENT_MASK_Z;
    D3D10_SB_OPERAND_4_COMPONENT_MASK_A = D3D10_SB_OPERAND_4_COMPONENT_MASK_W;
    D3D10_SB_OPERAND_4_COMPONENT_MASK_ALL = D3D10_SB_OPERAND_4_COMPONENT_MASK_MASK;

    // MACROS FOR USE IN D3D10_SB_OPERAND_4_COMPONENT_SWIZZLE_MODE:
    D3D10_SB_OPERAND_4_COMPONENT_SWIZZLE_MASK = $00000ff0;
    D3D10_SB_OPERAND_4_COMPONENT_SWIZZLE_SHIFT = 4;


    // ToDo    D3D10_SB_OPERAND_4_COMPONENT_REPLICATERED = D3D10_SB_OPERAND_4_COMPONENT_REPLICATEX;
    // ToDo    D3D10_SB_OPERAND_4_COMPONENT_REPLICATEGREEN = D3D10_SB_OPERAND_4_COMPONENT_REPLICATEY;
    // ToDo    D3D10_SB_OPERAND_4_COMPONENT_REPLICATEBLUE = D3D10_SB_OPERAND_4_COMPONENT_REPLICATEZ;
    // ToDo    D3D10_SB_OPERAND_4_COMPONENT_REPLICATEALPHA = D3D10_SB_OPERAND_4_COMPONENT_REPLICATEW;

    // MACROS FOR USE IN D3D10_SB_OPERAND_4_COMPONENT_SELECT_1_MODE:
    D3D10_SB_OPERAND_4_COMPONENT_SELECT_1_MASK = $00000030;
    D3D10_SB_OPERAND_4_COMPONENT_SELECT_1_SHIFT = 4;

    D3D10_SB_OPERAND_TYPE_MASK = $000ff000;
    D3D10_SB_OPERAND_TYPE_SHIFT = 12;


    D3D10_SB_OPERAND_INDEX_DIMENSION_MASK = $00300000;
    D3D10_SB_OPERAND_INDEX_DIMENSION_SHIFT = 20;

    D3D10_SB_OPERAND_EXTENDED_MASK = $80000000;
    D3D10_SB_OPERAND_EXTENDED_SHIFT = 31;

    D3D10_SB_EXTENDED_OPERAND_TYPE_MASK = $0000003f;

    D3D10_SB_OPERAND_MODIFIER_MASK = $00003fc0;
    D3D10_SB_OPERAND_MODIFIER_SHIFT = 6;

    D3D11_SB_OPERAND_MIN_PRECISION_MASK = $0001C000;
    D3D11_SB_OPERAND_MIN_PRECISION_SHIFT = 14;


    // Non-uniform extended operand modifier.
    D3D12_SB_OPERAND_NON_UNIFORM_MASK = $00020000;
    D3D12_SB_OPERAND_NON_UNIFORM_SHIFT = 17;

    D3D10_SB_OPERAND_DOUBLE_EXTENDED_MASK = $80000000;
    D3D10_SB_OPERAND_DOUBLE_EXTENDED_SHIFT = 31;


    D3D10_SB_NAME_MASK = $0000ffff;


    // ----------------------------------------------------------------------------
    // Global Flags Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_GLOBAL_FLAGS
    // [11:11] Refactoring allowed if bit set.
    // [12:12] Enable double precision float ops.
    // [13:13] Force early depth-stencil test.
    // [14:14] Enable RAW and structured buffers in non-CS 4.x shaders.
    // [15:15] Skip optimizations of shader IL when translating to native code
    // [16:16] Enable minimum-precision data types
    // [17:17] Enable 11.1 double-precision floating-point instruction extensions
    // [18:18] Enable 11.1 non-double instruction extensions
    // [23:19] Reserved for future flags.
    // [30:24] Instruction length in DWORDs including the opcode token. == 1
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by no operands.

    // ----------------------------------------------------------------------------
    D3D10_SB_GLOBAL_FLAG_REFACTORING_ALLOWED = (1 shl 11);
    D3D11_SB_GLOBAL_FLAG_ENABLE_DOUBLE_PRECISION_FLOAT_OPS = (1 shl 12);
    D3D11_SB_GLOBAL_FLAG_FORCE_EARLY_DEPTH_STENCIL = (1 shl 13);
    D3D11_SB_GLOBAL_FLAG_ENABLE_RAW_AND_STRUCTURED_BUFFERS = (1 shl 14);
    D3D11_1_SB_GLOBAL_FLAG_SKIP_OPTIMIZATION = (1 shl 15);
    D3D11_1_SB_GLOBAL_FLAG_ENABLE_MINIMUM_PRECISION = (1 shl 16);
    D3D11_1_SB_GLOBAL_FLAG_ENABLE_DOUBLE_EXTENSIONS = (1 shl 17);
    D3D11_1_SB_GLOBAL_FLAG_ENABLE_SHADER_EXTENSIONS = (1 shl 18);
    D3D12_SB_GLOBAL_FLAG_ALL_RESOURCES_BOUND = (1 shl 19);

    D3D10_SB_GLOBAL_FLAGS_MASK = $00fff800;


    // ----------------------------------------------------------------------------
    // Resource Declaration (non multisampled)

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_RESOURCE
    // [15:11] D3D10_SB_RESOURCE_DIMENSION
    // [23:16] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 2 operands on Shader Models 4.0 through 5.0:
    // (1) an operand, starting with OperandToken0, defining which
    //     t# register (D3D10_SB_OPERAND_TYPE_RESOURCE) is being declared.
    // (2) a Resource Return Type token (ResourceReturnTypeToken)

    // OpcodeToken0 is followed by 3 operands on Shader Model 5.1 and later:
    // (1) an operand, starting with OperandToken0, defining which
    //     t# register (D3D10_SB_OPERAND_TYPE_RESOURCE) is being declared.
    //     The indexing dimension for the register must be D3D10_SB_OPERAND_INDEX_DIMENSION_3D,
    //     and the meaning of the index dimensions are as follows: (t<id>[<lbound>:<ubound>])
    //       1 <id>:     variable ID being declared
    //       2 <lbound>: the lower bound of the range of resources in the space
    //       3 <ubound>: the upper bound (inclusive) of this range
    //     As opposed to when the t# is used in shader instructions, where the register
    //     must be D3D10_SB_OPERAND_INDEX_DIMENSION_2D, and the meaning of the index
    //     dimensions are as follows: (t<id>[<idx>]):
    //       1 <id>:  variable ID being used (matches dcl)
    //       2 <idx>: absolute index of resource within space (may be dynamically indexed)
    // (2) a Resource Return Type token (ResourceReturnTypeToken)
    // (3) a DWORD indicating the space index.

    // ----------------------------------------------------------------------------
    D3D10_SB_RESOURCE_DIMENSION_MASK = $0000F800;
    D3D10_SB_RESOURCE_DIMENSION_SHIFT = 11;


    // ----------------------------------------------------------------------------
    // Resource Declaration (multisampled)

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_RESOURCE (same opcode as non-multisampled case)
    // [15:11] D3D10_SB_RESOURCE_DIMENSION (must be TEXTURE2DMS or TEXTURE2DMSARRAY)
    // [22:16] Sample count 1...127.  0 is currently disallowed, though
    //         in future versions 0 could mean "configurable" sample count
    // [23:23] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 2 operands on Shader Models 4.0 through 5.0:
    // (1) an operand, starting with OperandToken0, defining which
    //     t# register (D3D10_SB_OPERAND_TYPE_RESOURCE) is being declared.
    // (2) a Resource Return Type token (ResourceReturnTypeToken)

    // OpcodeToken0 is followed by 3 operands on Shader Model 5.1 and later:
    // (1) an operand, starting with OperandToken0, defining which
    //     t# register (D3D10_SB_OPERAND_TYPE_RESOURCE) is being declared.
    //     The indexing dimension for the register must be D3D10_SB_OPERAND_INDEX_DIMENSION_3D,
    //     and the meaning of the index dimensions are as follows: (t<id>[<lbound>:<ubound>])
    //       1 <id>:     variable ID being declared
    //       2 <lbound>: the lower bound of the range of resources in the space
    //       3 <ubound>: the upper bound (inclusive) of this range
    //     As opposed to when the t# is used in shader instructions, where the register
    //     must be D3D10_SB_OPERAND_INDEX_DIMENSION_2D, and the meaning of the index
    //     dimensions are as follows: (t<id>[<idx>]):
    //       1 <id>:  variable ID being used (matches dcl)
    //       2 <idx>: absolute index of resource within space (may be dynamically indexed)
    // (2) a Resource Return Type token (ResourceReturnTypeToken)
    // (3) a DWORD indicating the space index.

    // ----------------------------------------------------------------------------
    // use same macro for encoding/decoding resource dimension aas the non-msaa declaration


    D3D10_SB_RESOURCE_SAMPLE_COUNT_MASK = $07F0000;
    D3D10_SB_RESOURCE_SAMPLE_COUNT_SHIFT = 16;

    D3D10_SB_SAMPLER_MODE_MASK = $00007800;
    D3D10_SB_SAMPLER_MODE_SHIFT = 11;

    // ----------------------------------------------------------------------------
    // Input Register Declaration (see separate declarations for Pixel Shaders)

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_INPUT
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 1 operand:
    // (1) Operand, starting with OperandToken0, defining which input
    //     v# register (D3D10_SB_OPERAND_TYPE_INPUT) is being declared,
    //     including writemask.

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Input Register Declaration w/System Interpreted Value
    // (see separate declarations for Pixel Shaders)

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_INPUT_SIV
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 2 operands:
    // (1) Operand, starting with OperandToken0, defining which input
    //     v# register (D3D10_SB_OPERAND_TYPE_INPUT) is being declared,
    //     including writemask.  For Geometry Shaders, the input is
    //     v[vertex][attribute], and this declaration is only for which register
    //     on the attribute axis is being declared.  The vertex axis value must
    //     be equal to the # of vertices in the current input primitive for the GS
    //     (i.e. 6 for triangle + adjacency).
    // (2) a System Interpreted Value Name (NameToken)

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Input Register Declaration w/System Generated Value
    // (available for all shaders incl. Pixel Shader, no interpolation mode needed)

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_INPUT_SGV
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 2 operands:
    // (1) Operand, starting with OperandToken0, defining which input
    //     v# register (D3D10_SB_OPERAND_TYPE_INPUT) is being declared,
    //     including writemask.
    // (2) a System Generated Value Name (NameToken)

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Pixel Shader Input Register Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_INPUT_PS
    // [14:11] D3D10_SB_INTERPOLATION_MODE
    // [23:15] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 1 operand:
    // (1) Operand, starting with OperandToken0, defining which input
    //     v# register (D3D10_SB_OPERAND_TYPE_INPUT) is being declared,
    //     including writemask.

    // ----------------------------------------------------------------------------


    D3D10_SB_INPUT_INTERPOLATION_MODE_MASK = $00007800;
    D3D10_SB_INPUT_INTERPOLATION_MODE_SHIFT = 11;

    D3D10_SB_CONSTANT_BUFFER_ACCESS_PATTERN_MASK = $00000800;
    D3D10_SB_CONSTANT_BUFFER_ACCESS_PATTERN_SHIFT = 11;


    // ----------------------------------------------------------------------------
    // Shader Clip Plane Constant Mappings for DX9 hardware

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_CUSTOMDATA
    // [31:11] == D3D11_SB_CUSTOMDATA_SHADER_CLIP_PLANE_CONSTANT_MAPPINGS_FOR_DX9

    // OpcodeToken0 is followed by:
    // (1) DWORD indicating length of declaration, including OpcodeToken0.
    // (2) DWORD indicating number of constant mappings (up to 6 mappings).
    // (3+) Constant mapping tables in following format.

    // struct _Clip_Plane_Constant_Mapping
    // {
    //     WORD ConstantBufferIndex;  // cb[n]
    //     WORD StartConstantElement; // starting index of cb[n][m]
    //     WORD ConstantElemntCount;  // number of elements cb[n][m] ~ cb[n][m+l]
    //     WORD Reserved;             //
    // };
    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Geometry Shader Input Primitive Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_GS_INPUT_PRIMITIVE
    // [16:11] D3D10_SB_PRIMITIVE [not D3D10_SB_PRIMITIVE_TOPOLOGY]
    // [23:17] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token. == 1
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // ----------------------------------------------------------------------------


    D3D10_SB_GS_INPUT_PRIMITIVE_MASK = $0001f800;
    D3D10_SB_GS_INPUT_PRIMITIVE_SHIFT = 11;

    // ----------------------------------------------------------------------------
    // Geometry Shader Output Topology Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_GS_OUTPUT_PRIMITIVE_TOPOLOGY
    // [17:11] D3D10_SB_PRIMITIVE_TOPOLOGY
    // [23:18] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token. == 1
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // ----------------------------------------------------------------------------

    D3D10_SB_GS_OUTPUT_PRIMITIVE_TOPOLOGY_MASK = $0001f800;
    D3D10_SB_GS_OUTPUT_PRIMITIVE_TOPOLOGY_SHIFT = 11;

    // ----------------------------------------------------------------------------
    // Geometry Shader Maximum Output Vertex Count Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_MAX_OUTPUT_VERTEX_COUNT
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by a DWORD representing the
    // maximum number of primitives that could be output
    // by the Geometry Shader.

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Geometry Shader Instance Count Declaration

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_GS_INSTANCE_COUNT
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by a UINT32 representing the
    // number of instances of the geometry shader program to execute.

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Hull Shader Declaration Phase: HS/DS Input Control Point Count

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_INPUT_CONTROL_POINT_COUNT
    // [16:11] Control point count
    // [23:17] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token. == 1
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // ----------------------------------------------------------------------------


    D3D11_SB_INPUT_CONTROL_POINT_COUNT_MASK = $0001f800;
    D3D11_SB_INPUT_CONTROL_POINT_COUNT_SHIFT = 11;

    // ----------------------------------------------------------------------------
    // Hull Shader Declaration Phase: HS Output Control Point Count

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_OUTPUT_CONTROL_POINT_COUNT
    // [16:11] Control point count
    // [23:17] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token. == 1
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // ----------------------------------------------------------------------------
    D3D11_SB_OUTPUT_CONTROL_POINT_COUNT_MASK = $0001f800;
    D3D11_SB_OUTPUT_CONTROL_POINT_COUNT_SHIFT = 11;


    D3D11_SB_TESS_DOMAIN_MASK = $00001800;
    D3D11_SB_TESS_DOMAIN_SHIFT = 11;


    D3D11_SB_TESS_PARTITIONING_MASK = $00003800;
    D3D11_SB_TESS_PARTITIONING_SHIFT = 11;


    D3D11_SB_TESS_OUTPUT_PRIMITIVE_MASK = $00003800;
    D3D11_SB_TESS_OUTPUT_PRIMITIVE_SHIFT = 11;


    D3D10_SB_INSTRUCTION_RETURN_TYPE_MASK = $00001800;
    D3D10_SB_INSTRUCTION_RETURN_TYPE_SHIFT = 11;

    // ----------------------------------------------------------------------------
    // Interface function body Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_FUNCTION_BODY
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  If it is extended, then
    //         it contains the actual instruction length in DWORDs, since
    //         it may not fit into 7 bits if enough operands are defined.

    // OpcodeToken0 is followed by a DWORD that represents the function body
    // identifier.

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Interface function table Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_FUNCTION_TABLE
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  If it is extended, then
    //         it contains the actual instruction length in DWORDs, since
    //         it may not fit into 7 bits if enough functions are defined.

    // OpcodeToken0 is followed by a DWORD that represents the function table
    // identifier and another DWORD (TableLength) that gives the number of
    // functions in the table.

    // This is followed by TableLength DWORDs which are function body indices.

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Interface Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_INTERFACE
    // [11]    1 if the interface is indexed dynamically, 0 otherwise.
    // [23:12] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  If it is extended, then
    //         it contains the actual instruction length in DWORDs, since
    //         it may not fit into 7 bits if enough types are used.

    // OpcodeToken0 is followed by a DWORD that represents the interface
    // identifier. Next is a DWORD that gives the expected function table
    // length. Then another DWORD (OpcodeToken3) with the following layout:

    // [15:00] TableLength, the number of types that implement this interface
    // [31:16] ArrayLength, the number of interfaces that are defined in this array.

    // This is followed by TableLength DWORDs which are function table
    // identifiers, representing possible tables for a given interface.

    // ----------------------------------------------------------------------------


    D3D11_SB_INTERFACE_INDEXED_BIT_MASK = $00000800;
    D3D11_SB_INTERFACE_INDEXED_BIT_SHIFT = 11;

    D3D11_SB_INTERFACE_TABLE_LENGTH_MASK = $0000ffff;
    D3D11_SB_INTERFACE_TABLE_LENGTH_SHIFT = 0;

    D3D11_SB_INTERFACE_ARRAY_LENGTH_MASK = $ffff0000;
    D3D11_SB_INTERFACE_ARRAY_LENGTH_SHIFT = 16;

    // ----------------------------------------------------------------------------
    // Interface call

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_INTERFACE_CALL
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  If it is extended, then
    //         it contains the actual instruction length in DWORDs, since
    //         it may not fit into 7 bits if enough types are used.

    // OpcodeToken0 is followed by a DWORD that gives the function index to
    // call in the function table specified for the given interface.
    // Next is the interface operand.

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Thread Group Declaration (Compute Shader)

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_THREAD_GROUP
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  If it is extended, then
    //         it contains the actual instruction length in DWORDs, since
    //         it may not fit into 7 bits if enough types are used.

    // OpcodeToken0 is followed by 3 DWORDs, the Thread Group dimensions as UINT32:
    // x, y, z

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Typed Unordered Access View Declaration

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_UNORDERED_ACCESS_VIEW_TYPED
    // [15:11] D3D10_SB_RESOURCE_DIMENSION
    // [16:16] D3D11_SB_GLOBALLY_COHERENT_ACCESS or 0 (LOCALLY_COHERENT)
    // [17:17] D3D11_SB_RASTERIZER_ORDERED_ACCESS or 0
    // [23:18] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 2 operands on Shader Models 4.0 through 5.0:
    // (1) an operand, starting with OperandToken0, defining which
    //     u# register (D3D11_SB_OPERAND_TYPE_UNORDERED_ACCESS_VIEW) is being declared.
    // (2) a Resource Return Type token (ResourceReturnTypeToken)

    // OpcodeToken0 is followed by 3 operands on Shader Model 5.1 and later:
    // (1) an operand, starting with OperandToken0, defining which
    //     u# register (D3D11_SB_OPERAND_TYPE_UNORDERED_ACCESS_VIEW) is being declared.
    //     The indexing dimension for the register must be D3D10_SB_OPERAND_INDEX_DIMENSION_3D,
    //     and the meaning of the index dimensions are as follows: (u<id>[<lbound>:<ubound>])
    //       1 <id>:     variable ID being declared
    //       2 <lbound>: the lower bound of the range of UAV's in the space
    //       3 <ubound>: the upper bound (inclusive) of this range
    //     As opposed to when the u# is used in shader instructions, where the register
    //     must be D3D10_SB_OPERAND_INDEX_DIMENSION_2D, and the meaning of the index
    //     dimensions are as follows: (u<id>[<idx>]):
    //       1 <id>:  variable ID being used (matches dcl)
    //       2 <idx>: absolute index of uav within space (may be dynamically indexed)
    // (2) a Resource Return Type token (ResourceReturnTypeToken)
    // (3) a DWORD indicating the space index.

    // ----------------------------------------------------------------------------
    // UAV access scope flags


    D3D11_SB_GLOBALLY_COHERENT_ACCESS = $00010000;
    D3D11_SB_ACCESS_COHERENCY_MASK = $00010000;

    // Additional UAV access flags
    D3D11_SB_RASTERIZER_ORDERED_ACCESS = $00020000;

    // ----------------------------------------------------------------------------
    // Raw Unordered Access View Declaration

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_UNORDERED_ACCESS_VIEW_RAW
    // [15:11] Ignored, 0
    // [16:16] D3D11_SB_GLOBALLY_COHERENT_ACCESS or 0 (LOCALLY_COHERENT)
    // [17:17] D3D11_SB_RASTERIZER_ORDERED_ACCESS or 0
    // [23:18] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 1 operand on Shader Models 4.0 through 5.0:
    // (1) an operand, starting with OperandToken0, defining which
    //     u# register (D3D11_SB_OPERAND_TYPE_UNORDERED_ACCESS_VIEW) is being declared.

    // OpcodeToken0 is followed by 2 operands on Shader Model 5.1 and later:
    // (1) an operand, starting with OperandToken0, defining which
    //     u# register (D3D11_SB_OPERAND_TYPE_UNORDERED_ACCESS_VIEW) is being declared.
    //     The indexing dimension for the register must be D3D10_SB_OPERAND_INDEX_DIMENSION_3D,
    //     and the meaning of the index dimensions are as follows: (u<id>[<lbound>:<ubound>])
    //       1 <id>:     variable ID being declared
    //       2 <lbound>: the lower bound of the range of UAV's in the space
    //       3 <ubound>: the upper bound (inclusive) of this range
    //     As opposed to when the u# is used in shader instructions, where the register
    //     must be D3D10_SB_OPERAND_INDEX_DIMENSION_2D, and the meaning of the index
    //     dimensions are as follows: (u<id>[<idx>]):
    //       1 <id>:  variable ID being used (matches dcl)
    //       2 <idx>: absolute index of uav within space (may be dynamically indexed)
    // (2) a DWORD indicating the space index.

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Structured Unordered Access View Declaration

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_UNORDERED_ACCESS_VIEW_STRUCTURED
    // [15:11] Ignored, 0
    // [16:16] D3D11_SB_GLOBALLY_COHERENT_ACCESS or 0 (LOCALLY_COHERENT)
    // [17:17] D3D11_SB_RASTERIZER_ORDERED_ACCESS or 0
    // [22:18] Ignored, 0
    // [23:23] D3D11_SB_UAV_HAS_ORDER_PRESERVING_COUNTER or 0

    //            The presence of this flag means that if a UAV is bound to the
    //            corresponding slot, it must have been created with
    //            D3D11_BUFFER_UAV_FLAG_COUNTER at the API.  Also, the shader
    //            can contain either imm_atomic_alloc or _consume instructions
    //            operating on the given UAV.

    //            If this flag is not present, the shader can still contain
    //            either imm_atomic_alloc or imm_atomic_consume instructions for
    //            this UAV.  But if such instructions are present in this case,
    //            and a UAV is bound corresponding slot, it must have been created
    //            with the D3D11_BUFFER_UAV_FLAG_APPEND flag at the API.
    //            Append buffers have a counter as well, but values returned
    //            to the shader are only valid for the lifetime of the shader
    //            invocation.

    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 2 operands:
    // (1) an operand, starting with OperandToken0, defining which
    //     u# register (D3D11_SB_OPERAND_TYPE_UNORDERED_ACCESS_VIEW) is
    //     being declared.
    // (2) a DWORD indicating UINT32 byte stride

    // OpcodeToken0 is followed by 3 operands on Shader Model 5.1 and later:
    // (1) an operand, starting with OperandToken0, defining which
    //     u# register (D3D11_SB_OPERAND_TYPE_UNORDERED_ACCESS_VIEW) is being declared.
    //     The indexing dimension for the register must be D3D10_SB_OPERAND_INDEX_DIMENSION_3D,
    //     and the meaning of the index dimensions are as follows: (u<id>[<lbound>:<ubound>])
    //       1 <id>:     variable ID being declared
    //       2 <lbound>: the lower bound of the range of UAV's in the space
    //       3 <ubound>: the upper bound (inclusive) of this range
    //     As opposed to when the u# is used in shader instructions, where the register
    //     must be D3D10_SB_OPERAND_INDEX_DIMENSION_2D, and the meaning of the index
    //     dimensions are as follows: (u<id>[<idx>]):
    //       1 <id>:  variable ID being used (matches dcl)
    //       2 <idx>: absolute index of uav within space (may be dynamically indexed)
    // (2) a DWORD indicating UINT32 byte stride
    // (3) a DWORD indicating the space index.

    // ----------------------------------------------------------------------------
    // UAV flags

    D3D11_SB_UAV_HAS_ORDER_PRESERVING_COUNTER = $00800000;
    D3D11_SB_UAV_FLAGS_MASK = $00800000;


    // ----------------------------------------------------------------------------
    // Raw Thread Group Shared Memory Declaration

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_THREAD_GROUP_SHARED_MEMORY_RAW
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 2 operands:
    // (1) an operand, starting with OperandToken0, defining which
    //     g# register (D3D11_SB_OPERAND_TYPE_THREAD_GROUP_SHARED_MEMORY) is being declared.
    // (2) a DWORD indicating the byte count, which must be a multiple of 4.

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Structured Thread Group Shared Memory Declaration

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_THREAD_GROUP_SHARED_MEMORY_STRUCTURED
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 3 operands:
    // (1) an operand, starting with OperandToken0, defining which
    //     g# register (D3D11_SB_OPERAND_TYPE_THREAD_GROUP_SHARED_MEMORY) is
    //     being declared.
    // (2) a DWORD indicating UINT32 struct byte stride
    // (3) a DWORD indicating UINT32 struct count

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Raw Shader Resource View Declaration

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_RESOURCE_RAW
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 1 operand:
    // (1) an operand, starting with OperandToken0, defining which
    //     t# register (D3D10_SB_OPERAND_TYPE_RESOURCE) is being declared.

    // OpcodeToken0 is followed by 2 operands on Shader Model 5.1 and later:
    // (1) an operand, starting with OperandToken0, defining which
    //     t# register (D3D10_SB_OPERAND_TYPE_RESOURCE) is being declared.
    //     The indexing dimension for the register must be D3D10_SB_OPERAND_INDEX_DIMENSION_3D,
    //     and the meaning of the index dimensions are as follows: (t<id>[<lbound>:<ubound>])
    //       1 <id>:     variable ID being declared
    //       2 <lbound>: the lower bound of the range of resources in the space
    //       3 <ubound>: the upper bound (inclusive) of this range
    //     As opposed to when the t# is used in shader instructions, where the register
    //     must be D3D10_SB_OPERAND_INDEX_DIMENSION_2D, and the meaning of the index
    //     dimensions are as follows: (t<id>[<idx>]):
    //       1 <id>:  variable ID being used (matches dcl)
    //       2 <idx>: absolute index of resource within space (may be dynamically indexed)
    // (2) a DWORD indicating the space index.

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Structured Shader Resource View Declaration

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_RESOURCE_STRUCTURED
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 2 operands:
    // (1) an operand, starting with OperandToken0, defining which
    //     g# register (D3D10_SB_OPERAND_TYPE_RESOURCE) is
    //     being declared.
    // (2) a DWORD indicating UINT32 struct byte stride

    // OpcodeToken0 is followed by 3 operands on Shader Model 5.1 and later:
    // (1) an operand, starting with OperandToken0, defining which
    //     t# register (D3D10_SB_OPERAND_TYPE_RESOURCE) is being declared.
    //     The indexing dimension for the register must be D3D10_SB_OPERAND_INDEX_DIMENSION_3D,
    //     and the meaning of the index dimensions are as follows: (t<id>[<lbound>:<ubound>])
    //       1 <id>:     variable ID being declared
    //       2 <lbound>: the lower bound of the range of resources in the space
    //       3 <ubound>: the upper bound (inclusive) of this range
    //     As opposed to when the t# is used in shader instructions, where the register
    //     must be D3D10_SB_OPERAND_INDEX_DIMENSION_2D, and the meaning of the index
    //     dimensions are as follows: (t<id>[<idx>]):
    //       1 <id>:  variable ID being used (matches dcl)
    //       2 <idx>: absolute index of resource within space (may be dynamically indexed)
    // (2) a DWORD indicating UINT32 struct byte stride
    // (3) a DWORD indicating the space index.

    // ----------------------------------------------------------------------------


type
    // ----------------------------------------------------------------------------
    // Version Token (VerTok)

    // [07:00] minor version number (0-255)
    // [15:08] major version number (0-255)
    // [31:16] D3D10_SB_TOKENIZED_PROGRAM_TYPE

    // ----------------------------------------------------------------------------


    TD3D10_SB_TOKENIZED_PROGRAM_TYPE = (
        D3D10_SB_PIXEL_SHADER = 0,
        D3D10_SB_VERTEX_SHADER = 1,
        D3D10_SB_GEOMETRY_SHADER = 2,
        // D3D11 Shaders
        D3D11_SB_HULL_SHADER = 3,
        D3D11_SB_DOMAIN_SHADER = 4,
        D3D11_SB_COMPUTE_SHADER = 5,
        // Subset of D3D12 Shaders where this field is referenced by runtime
        // Entries from 6-12 are unique to state objects
        // (e.g. library, callable and raytracing shaders)
        D3D12_SB_MESH_SHADER = 13,
        D3D12_SB_AMPLIFICATION_SHADER = 14,
        D3D11_SB_RESERVED0 = $FFF0);

    PD3D10_SB_TOKENIZED_PROGRAM_TYPE = ^TD3D10_SB_TOKENIZED_PROGRAM_TYPE;


    // ----------------------------------------------------------------------------
    // Opcode Format (OpcodeToken0)

    // [10:00] D3D10_SB_OPCODE_TYPE
    // if( [10:00] == D3D10_SB_OPCODE_CUSTOMDATA )
    // {
    //    Token starts a custom-data block.  See "Custom-Data Block Format".
    // }
    // else // standard opcode token
    // {
    //    [23:11] Opcode-Specific Controls
    //    [30:24] Instruction length in DWORDs including the opcode token.
    //    [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //            contains extended opcode token.
    // }

    // ----------------------------------------------------------------------------

    TD3D10_SB_OPCODE_TYPE = (
        D3D10_SB_OPCODE_ADD,
        D3D10_SB_OPCODE_AND,
        D3D10_SB_OPCODE_BREAK,
        D3D10_SB_OPCODE_BREAKC,
        D3D10_SB_OPCODE_CALL,
        D3D10_SB_OPCODE_CALLC,
        D3D10_SB_OPCODE_CASE,
        D3D10_SB_OPCODE_CONTINUE,
        D3D10_SB_OPCODE_CONTINUEC,
        D3D10_SB_OPCODE_CUT,
        D3D10_SB_OPCODE_DEFAULT,
        D3D10_SB_OPCODE_DERIV_RTX,
        D3D10_SB_OPCODE_DERIV_RTY,
        D3D10_SB_OPCODE_DISCARD,
        D3D10_SB_OPCODE_DIV,
        D3D10_SB_OPCODE_DP2,
        D3D10_SB_OPCODE_DP3,
        D3D10_SB_OPCODE_DP4,
        D3D10_SB_OPCODE_ELSE,
        D3D10_SB_OPCODE_EMIT,
        D3D10_SB_OPCODE_EMITTHENCUT,
        D3D10_SB_OPCODE_ENDIF,
        D3D10_SB_OPCODE_ENDLOOP,
        D3D10_SB_OPCODE_ENDSWITCH,
        D3D10_SB_OPCODE_EQ,
        D3D10_SB_OPCODE_EXP,
        D3D10_SB_OPCODE_FRC,
        D3D10_SB_OPCODE_FTOI,
        D3D10_SB_OPCODE_FTOU,
        D3D10_SB_OPCODE_GE,
        D3D10_SB_OPCODE_IADD,
        D3D10_SB_OPCODE_IF,
        D3D10_SB_OPCODE_IEQ,
        D3D10_SB_OPCODE_IGE,
        D3D10_SB_OPCODE_ILT,
        D3D10_SB_OPCODE_IMAD,
        D3D10_SB_OPCODE_IMAX,
        D3D10_SB_OPCODE_IMIN,
        D3D10_SB_OPCODE_IMUL,
        D3D10_SB_OPCODE_INE,
        D3D10_SB_OPCODE_INEG,
        D3D10_SB_OPCODE_ISHL,
        D3D10_SB_OPCODE_ISHR,
        D3D10_SB_OPCODE_ITOF,
        D3D10_SB_OPCODE_LABEL,
        D3D10_SB_OPCODE_LD,
        D3D10_SB_OPCODE_LD_MS,
        D3D10_SB_OPCODE_LOG,
        D3D10_SB_OPCODE_LOOP,
        D3D10_SB_OPCODE_LT,
        D3D10_SB_OPCODE_MAD,
        D3D10_SB_OPCODE_MIN,
        D3D10_SB_OPCODE_MAX,
        D3D10_SB_OPCODE_CUSTOMDATA,
        D3D10_SB_OPCODE_MOV,
        D3D10_SB_OPCODE_MOVC,
        D3D10_SB_OPCODE_MUL,
        D3D10_SB_OPCODE_NE,
        D3D10_SB_OPCODE_NOP,
        D3D10_SB_OPCODE_NOT,
        D3D10_SB_OPCODE_OR,
        D3D10_SB_OPCODE_RESINFO,
        D3D10_SB_OPCODE_RET,
        D3D10_SB_OPCODE_RETC,
        D3D10_SB_OPCODE_ROUND_NE,
        D3D10_SB_OPCODE_ROUND_NI,
        D3D10_SB_OPCODE_ROUND_PI,
        D3D10_SB_OPCODE_ROUND_Z,
        D3D10_SB_OPCODE_RSQ,
        D3D10_SB_OPCODE_SAMPLE,
        D3D10_SB_OPCODE_SAMPLE_C,
        D3D10_SB_OPCODE_SAMPLE_C_LZ,
        D3D10_SB_OPCODE_SAMPLE_L,
        D3D10_SB_OPCODE_SAMPLE_D,
        D3D10_SB_OPCODE_SAMPLE_B,
        D3D10_SB_OPCODE_SQRT,
        D3D10_SB_OPCODE_SWITCH,
        D3D10_SB_OPCODE_SINCOS,
        D3D10_SB_OPCODE_UDIV,
        D3D10_SB_OPCODE_ULT,
        D3D10_SB_OPCODE_UGE,
        D3D10_SB_OPCODE_UMUL,
        D3D10_SB_OPCODE_UMAD,
        D3D10_SB_OPCODE_UMAX,
        D3D10_SB_OPCODE_UMIN,
        D3D10_SB_OPCODE_USHR,
        D3D10_SB_OPCODE_UTOF,
        D3D10_SB_OPCODE_XOR,
        D3D10_SB_OPCODE_DCL_RESOURCE, // DCL* opcodes have
        D3D10_SB_OPCODE_DCL_CONSTANT_BUFFER, // custom operand formats.
        D3D10_SB_OPCODE_DCL_SAMPLER,
        D3D10_SB_OPCODE_DCL_INDEX_RANGE,
        D3D10_SB_OPCODE_DCL_GS_OUTPUT_PRIMITIVE_TOPOLOGY,
        D3D10_SB_OPCODE_DCL_GS_INPUT_PRIMITIVE,
        D3D10_SB_OPCODE_DCL_MAX_OUTPUT_VERTEX_COUNT,
        D3D10_SB_OPCODE_DCL_INPUT,
        D3D10_SB_OPCODE_DCL_INPUT_SGV,
        D3D10_SB_OPCODE_DCL_INPUT_SIV,
        D3D10_SB_OPCODE_DCL_INPUT_PS,
        D3D10_SB_OPCODE_DCL_INPUT_PS_SGV,
        D3D10_SB_OPCODE_DCL_INPUT_PS_SIV,
        D3D10_SB_OPCODE_DCL_OUTPUT,
        D3D10_SB_OPCODE_DCL_OUTPUT_SGV,
        D3D10_SB_OPCODE_DCL_OUTPUT_SIV,
        D3D10_SB_OPCODE_DCL_TEMPS,
        D3D10_SB_OPCODE_DCL_INDEXABLE_TEMP,
        D3D10_SB_OPCODE_DCL_GLOBAL_FLAGS,
        // -----------------------------------------------
        // This marks the end of D3D10.0 opcodes
        D3D10_SB_OPCODE_RESERVED0,
        // ---------- DX 10.1 op codes---------------------
        D3D10_1_SB_OPCODE_LOD,
        D3D10_1_SB_OPCODE_GATHER4,
        D3D10_1_SB_OPCODE_SAMPLE_POS,
        D3D10_1_SB_OPCODE_SAMPLE_INFO,
        // -----------------------------------------------
        // This marks the end of D3D10.1 opcodes
        D3D10_1_SB_OPCODE_RESERVED1,
        // ---------- DX 11 op codes---------------------
        D3D11_SB_OPCODE_HS_DECLS, // token marks beginning of HS sub-shader
        D3D11_SB_OPCODE_HS_CONTROL_POINT_PHASE, // token marks beginning of HS sub-shader
        D3D11_SB_OPCODE_HS_FORK_PHASE, // token marks beginning of HS sub-shader
        D3D11_SB_OPCODE_HS_JOIN_PHASE, // token marks beginning of HS sub-shader
        D3D11_SB_OPCODE_EMIT_STREAM,
        D3D11_SB_OPCODE_CUT_STREAM,
        D3D11_SB_OPCODE_EMITTHENCUT_STREAM,
        D3D11_SB_OPCODE_INTERFACE_CALL,
        D3D11_SB_OPCODE_BUFINFO,
        D3D11_SB_OPCODE_DERIV_RTX_COARSE,
        D3D11_SB_OPCODE_DERIV_RTX_FINE,
        D3D11_SB_OPCODE_DERIV_RTY_COARSE,
        D3D11_SB_OPCODE_DERIV_RTY_FINE,
        D3D11_SB_OPCODE_GATHER4_C,
        D3D11_SB_OPCODE_GATHER4_PO,
        D3D11_SB_OPCODE_GATHER4_PO_C,
        D3D11_SB_OPCODE_RCP,
        D3D11_SB_OPCODE_F32TOF16,
        D3D11_SB_OPCODE_F16TOF32,
        D3D11_SB_OPCODE_UADDC,
        D3D11_SB_OPCODE_USUBB,
        D3D11_SB_OPCODE_COUNTBITS,
        D3D11_SB_OPCODE_FIRSTBIT_HI,
        D3D11_SB_OPCODE_FIRSTBIT_LO,
        D3D11_SB_OPCODE_FIRSTBIT_SHI,
        D3D11_SB_OPCODE_UBFE,
        D3D11_SB_OPCODE_IBFE,
        D3D11_SB_OPCODE_BFI,
        D3D11_SB_OPCODE_BFREV,
        D3D11_SB_OPCODE_SWAPC,
        D3D11_SB_OPCODE_DCL_STREAM,
        D3D11_SB_OPCODE_DCL_FUNCTION_BODY,
        D3D11_SB_OPCODE_DCL_FUNCTION_TABLE,
        D3D11_SB_OPCODE_DCL_INTERFACE,
        D3D11_SB_OPCODE_DCL_INPUT_CONTROL_POINT_COUNT,
        D3D11_SB_OPCODE_DCL_OUTPUT_CONTROL_POINT_COUNT,
        D3D11_SB_OPCODE_DCL_TESS_DOMAIN,
        D3D11_SB_OPCODE_DCL_TESS_PARTITIONING,
        D3D11_SB_OPCODE_DCL_TESS_OUTPUT_PRIMITIVE,
        D3D11_SB_OPCODE_DCL_HS_MAX_TESSFACTOR,
        D3D11_SB_OPCODE_DCL_HS_FORK_PHASE_INSTANCE_COUNT,
        D3D11_SB_OPCODE_DCL_HS_JOIN_PHASE_INSTANCE_COUNT,
        D3D11_SB_OPCODE_DCL_THREAD_GROUP,
        D3D11_SB_OPCODE_DCL_UNORDERED_ACCESS_VIEW_TYPED,
        D3D11_SB_OPCODE_DCL_UNORDERED_ACCESS_VIEW_RAW,
        D3D11_SB_OPCODE_DCL_UNORDERED_ACCESS_VIEW_STRUCTURED,
        D3D11_SB_OPCODE_DCL_THREAD_GROUP_SHARED_MEMORY_RAW,
        D3D11_SB_OPCODE_DCL_THREAD_GROUP_SHARED_MEMORY_STRUCTURED,
        D3D11_SB_OPCODE_DCL_RESOURCE_RAW,
        D3D11_SB_OPCODE_DCL_RESOURCE_STRUCTURED,
        D3D11_SB_OPCODE_LD_UAV_TYPED,
        D3D11_SB_OPCODE_STORE_UAV_TYPED,
        D3D11_SB_OPCODE_LD_RAW,
        D3D11_SB_OPCODE_STORE_RAW,
        D3D11_SB_OPCODE_LD_STRUCTURED,
        D3D11_SB_OPCODE_STORE_STRUCTURED,
        D3D11_SB_OPCODE_ATOMIC_AND,
        D3D11_SB_OPCODE_ATOMIC_OR,
        D3D11_SB_OPCODE_ATOMIC_XOR,
        D3D11_SB_OPCODE_ATOMIC_CMP_STORE,
        D3D11_SB_OPCODE_ATOMIC_IADD,
        D3D11_SB_OPCODE_ATOMIC_IMAX,
        D3D11_SB_OPCODE_ATOMIC_IMIN,
        D3D11_SB_OPCODE_ATOMIC_UMAX,
        D3D11_SB_OPCODE_ATOMIC_UMIN,
        D3D11_SB_OPCODE_IMM_ATOMIC_ALLOC,
        D3D11_SB_OPCODE_IMM_ATOMIC_CONSUME,
        D3D11_SB_OPCODE_IMM_ATOMIC_IADD,
        D3D11_SB_OPCODE_IMM_ATOMIC_AND,
        D3D11_SB_OPCODE_IMM_ATOMIC_OR,
        D3D11_SB_OPCODE_IMM_ATOMIC_XOR,
        D3D11_SB_OPCODE_IMM_ATOMIC_EXCH,
        D3D11_SB_OPCODE_IMM_ATOMIC_CMP_EXCH,
        D3D11_SB_OPCODE_IMM_ATOMIC_IMAX,
        D3D11_SB_OPCODE_IMM_ATOMIC_IMIN,
        D3D11_SB_OPCODE_IMM_ATOMIC_UMAX,
        D3D11_SB_OPCODE_IMM_ATOMIC_UMIN,
        D3D11_SB_OPCODE_SYNC,
        D3D11_SB_OPCODE_DADD,
        D3D11_SB_OPCODE_DMAX,
        D3D11_SB_OPCODE_DMIN,
        D3D11_SB_OPCODE_DMUL,
        D3D11_SB_OPCODE_DEQ,
        D3D11_SB_OPCODE_DGE,
        D3D11_SB_OPCODE_DLT,
        D3D11_SB_OPCODE_DNE,
        D3D11_SB_OPCODE_DMOV,
        D3D11_SB_OPCODE_DMOVC,
        D3D11_SB_OPCODE_DTOF,
        D3D11_SB_OPCODE_FTOD,
        D3D11_SB_OPCODE_EVAL_SNAPPED,
        D3D11_SB_OPCODE_EVAL_SAMPLE_INDEX,
        D3D11_SB_OPCODE_EVAL_CENTROID,
        D3D11_SB_OPCODE_DCL_GS_INSTANCE_COUNT,
        D3D11_SB_OPCODE_ABORT,
        D3D11_SB_OPCODE_DEBUG_BREAK,
        // -----------------------------------------------
        // This marks the end of D3D11.0 opcodes
        D3D11_SB_OPCODE_RESERVED0,
        D3D11_1_SB_OPCODE_DDIV,
        D3D11_1_SB_OPCODE_DFMA,
        D3D11_1_SB_OPCODE_DRCP,
        D3D11_1_SB_OPCODE_MSAD,
        D3D11_1_SB_OPCODE_DTOI,
        D3D11_1_SB_OPCODE_DTOU,
        D3D11_1_SB_OPCODE_ITOD,
        D3D11_1_SB_OPCODE_UTOD,
        // -----------------------------------------------
        // This marks the end of D3D11.1 opcodes
        D3D11_1_SB_OPCODE_RESERVED0,
        D3DWDDM1_3_SB_OPCODE_GATHER4_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_GATHER4_C_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_GATHER4_PO_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_GATHER4_PO_C_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_LD_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_LD_MS_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_LD_UAV_TYPED_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_LD_RAW_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_LD_STRUCTURED_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_SAMPLE_L_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_SAMPLE_C_LZ_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_SAMPLE_CLAMP_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_SAMPLE_B_CLAMP_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_SAMPLE_D_CLAMP_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_SAMPLE_C_CLAMP_FEEDBACK,
        D3DWDDM1_3_SB_OPCODE_CHECK_ACCESS_FULLY_MAPPED,
        // -----------------------------------------------
        // This marks the end of WDDM 1.3 opcodes
        D3DWDDM1_3_SB_OPCODE_RESERVED0,
        D3D10_SB_NUM_OPCODES// Should be the last entry
        );

    PD3D10_SB_OPCODE_TYPE = ^TD3D10_SB_OPCODE_TYPE;


    // Boolean test for conditional instructions such as if (if_z or if_nz)
    // This is part of the opcode specific control range.
    TD3D10_SB_INSTRUCTION_TEST_BOOLEAN = (
        D3D10_SB_INSTRUCTION_TEST_ZERO = 0,
        D3D10_SB_INSTRUCTION_TEST_NONZERO = 1
        );

    PD3D10_SB_INSTRUCTION_TEST_BOOLEAN = ^TD3D10_SB_INSTRUCTION_TEST_BOOLEAN;


    // resinfo instruction return type
    TD3D10_SB_RESINFO_INSTRUCTION_RETURN_TYPE = (
        D3D10_SB_RESINFO_INSTRUCTION_RETURN_FLOAT = 0,
        D3D10_SB_RESINFO_INSTRUCTION_RETURN_RCPFLOAT = 1,
        D3D10_SB_RESINFO_INSTRUCTION_RETURN_UINT = 2
        );

    PD3D10_SB_RESINFO_INSTRUCTION_RETURN_TYPE = ^TD3D10_SB_RESINFO_INSTRUCTION_RETURN_TYPE;


    // ----------------------------------------------------------------------------
    // Extended Opcode Format (OpcodeToken1)

    // If bit31 of an opcode token is set, the
    // opcode has an additional extended opcode token DWORD
    // directly following OpcodeToken0.  Other tokens
    // expected for the opcode, such as the operand
    // token(s) always follow
    // OpcodeToken0 AND OpcodeToken1..n (extended
    // opcode tokens, if present).

    // [05:00] D3D10_SB_EXTENDED_OPCODE_TYPE
    // [30:06] if([05:00] == D3D10_SB_EXTENDED_OPCODE_SAMPLE_CONTROLS)
    //         {
    //              This custom opcode contains controls for SAMPLE.
    //              [08:06] Ignored, 0.
    //              [12:09] U texel immediate offset (4 bit 2's comp) (0 default)
    //              [16:13] V texel immediate offset (4 bit 2's comp) (0 default)
    //              [20:17] W texel immediate offset (4 bit 2's comp) (0 default)
    //              [30:14] Ignored, 0.
    //         }
    //         else if( [05:00] == D3D11_SB_EXTENDED_OPCODE_RESOURCE_DIM )
    //         {
    //              [10:06] D3D10_SB_RESOURCE_DIMENSION
    //              [22:11] When dimension is D3D11_SB_RESOURCE_DIMENSION_STRUCTURED_BUFFER this holds the buffer stride, otherwise 0
    //              [30:23] Ignored, 0.
    //         }
    //         else if( [05:00] == D3D11_SB_EXTENDED_OPCODE_RESOURCE_RETURN_TYPE )
    //         {
    //              [09:06] D3D10_SB_RESOURCE_RETURN_TYPE for component X
    //              [13:10] D3D10_SB_RESOURCE_RETURN_TYPE for component Y
    //              [17:14] D3D10_SB_RESOURCE_RETURN_TYPE for component Z
    //              [21:18] D3D10_SB_RESOURCE_RETURN_TYPE for component W
    //              [30:22] Ignored, 0.
    //         }
    //         else
    //         {
    //              [30:04] Ignored, 0.
    //         }
    // [31]    0 normally. 1 there is another extended opcode.  Any number
    //         of extended opcode tokens can be chained.  It is possible that some extended
    //         opcode tokens could include multiple DWORDS - that is defined
    //         on a case by case basis.

    // ----------------------------------------------------------------------------
    TD3D10_SB_EXTENDED_OPCODE_TYPE = (
        D3D10_SB_EXTENDED_OPCODE_EMPTY = 0,
        D3D10_SB_EXTENDED_OPCODE_SAMPLE_CONTROLS = 1,
        D3D11_SB_EXTENDED_OPCODE_RESOURCE_DIM = 2,
        D3D11_SB_EXTENDED_OPCODE_RESOURCE_RETURN_TYPE = 3
        );

    PD3D10_SB_EXTENDED_OPCODE_TYPE = ^TD3D10_SB_EXTENDED_OPCODE_TYPE;


    TD3D10_SB_IMMEDIATE_ADDRESS_OFFSET_COORD = (
        D3D10_SB_IMMEDIATE_ADDRESS_OFFSET_U = 0,
        D3D10_SB_IMMEDIATE_ADDRESS_OFFSET_V = 1,
        D3D10_SB_IMMEDIATE_ADDRESS_OFFSET_W = 2
        );

    PD3D10_SB_IMMEDIATE_ADDRESS_OFFSET_COORD = ^TD3D10_SB_IMMEDIATE_ADDRESS_OFFSET_COORD;


    // ----------------------------------------------------------------------------
    // Custom-Data Block Format

    // DWORD 0 (CustomDataDescTok):
    // [10:00] == D3D10_SB_OPCODE_CUSTOMDATA
    // [31:11] == D3D10_SB_CUSTOMDATA_CLASS

    // DWORD 1:
    //          32-bit unsigned integer count of number
    //          of DWORDs in custom-data block,
    //          including DWORD 0 and DWORD 1.
    //          So the minimum value is 0x00000002,
    //          meaning empty custom-data.

    // Layout of custom-data contents, for the various meta-data classes,
    // not defined in this file.

    // ----------------------------------------------------------------------------

    TD3D10_SB_CUSTOMDATA_CLASS = (
        D3D10_SB_CUSTOMDATA_COMMENT = 0,
        D3D10_SB_CUSTOMDATA_DEBUGINFO,
        D3D10_SB_CUSTOMDATA_OPAQUE,
        D3D10_SB_CUSTOMDATA_DCL_IMMEDIATE_CONSTANT_BUFFER,
        D3D11_SB_CUSTOMDATA_SHADER_MESSAGE,
        D3D11_SB_CUSTOMDATA_SHADER_CLIP_PLANE_CONSTANT_MAPPINGS_FOR_DX9
        );

    PD3D10_SB_CUSTOMDATA_CLASS = ^TD3D10_SB_CUSTOMDATA_CLASS;


    // ----------------------------------------------------------------------------
    // Instruction Operand Format (OperandToken0)

    // [01:00] D3D10_SB_OPERAND_NUM_COMPONENTS
    // [11:02] Component Selection
    //         if([01:00] == D3D10_SB_OPERAND_0_COMPONENT)
    //              [11:02] = Ignored, 0
    //         else if([01:00] == D3D10_SB_OPERAND_1_COMPONENT
    //              [11:02] = Ignored, 0
    //         else if([01:00] == D3D10_SB_OPERAND_4_COMPONENT
    //         {
    //              [03:02] = D3D10_SB_OPERAND_4_COMPONENT_SELECTION_MODE
    //              if([03:02] == D3D10_SB_OPERAND_4_COMPONENT_MASK_MODE)
    //              {
    //                  [07:04] = D3D10_SB_OPERAND_4_COMPONENT_MASK
    //                  [11:08] = Ignored, 0
    //              }
    //              else if([03:02] == D3D10_SB_OPERAND_4_COMPONENT_SWIZZLE_MODE)
    //              {
    //                  [11:04] = D3D10_SB_4_COMPONENT_SWIZZLE
    //              }
    //              else if([03:02] == D3D10_SB_OPERAND_4_COMPONENT_SELECT_1_MODE)
    //              {
    //                  [05:04] = D3D10_SB_4_COMPONENT_NAME
    //                  [11:06] = Ignored, 0
    //              }
    //         }
    //         else if([01:00] == D3D10_SB_OPERAND_N_COMPONENT)
    //         {
    //              Currently not defined.
    //         }
    // [19:12] D3D10_SB_OPERAND_TYPE
    // [21:20] D3D10_SB_OPERAND_INDEX_DIMENSION:
    //            Number of dimensions in the register
    //            file (NOT the # of dimensions in the
    //            individual register or memory
    //            resource being referenced).
    // [24:22] if( [21:20] >= D3D10_SB_OPERAND_INDEX_1D )
    //             D3D10_SB_OPERAND_INDEX_REPRESENTATION for first operand index
    //         else
    //             Ignored, 0
    // [27:25] if( [21:20] >= D3D10_SB_OPERAND_INDEX_2D )
    //             D3D10_SB_OPERAND_INDEX_REPRESENTATION for second operand index
    //         else
    //             Ignored, 0
    // [30:28] if( [21:20] == D3D10_SB_OPERAND_INDEX_3D )
    //             D3D10_SB_OPERAND_INDEX_REPRESENTATION for third operand index
    //         else
    //             Ignored, 0
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.

    // ----------------------------------------------------------------------------
    // Number of components in data vector referred to by operand.

    TD3D10_SB_OPERAND_NUM_COMPONENTS = (
        D3D10_SB_OPERAND_0_COMPONENT = 0,
        D3D10_SB_OPERAND_1_COMPONENT = 1,
        D3D10_SB_OPERAND_4_COMPONENT = 2,
        D3D10_SB_OPERAND_N_COMPONENT = 3// unused for now
        );

    PD3D10_SB_OPERAND_NUM_COMPONENTS = ^TD3D10_SB_OPERAND_NUM_COMPONENTS;


    TD3D10_SB_OPERAND_4_COMPONENT_SELECTION_MODE = (
        D3D10_SB_OPERAND_4_COMPONENT_MASK_MODE = 0, // mask 4 components
        D3D10_SB_OPERAND_4_COMPONENT_SWIZZLE_MODE = 1, // swizzle 4 components
        D3D10_SB_OPERAND_4_COMPONENT_SELECT_1_MODE = 2// select 1 of 4 components
        );

    PD3D10_SB_OPERAND_4_COMPONENT_SELECTION_MODE = ^TD3D10_SB_OPERAND_4_COMPONENT_SELECTION_MODE;


    TD3D10_SB_4_COMPONENT_NAME = (
        D3D10_SB_4_COMPONENT_X = 0,
        D3D10_SB_4_COMPONENT_Y = 1,
        D3D10_SB_4_COMPONENT_Z = 2,
        D3D10_SB_4_COMPONENT_W = 3,
        D3D10_SB_4_COMPONENT_R = 0,
        D3D10_SB_4_COMPONENT_G = 1,
        D3D10_SB_4_COMPONENT_B = 2,
        D3D10_SB_4_COMPONENT_A = 3
        );

    PD3D10_SB_4_COMPONENT_NAME = ^TD3D10_SB_4_COMPONENT_NAME;


    // MACROS FOR DETERMINING OPERAND TYPE:

    TD3D10_SB_OPERAND_TYPE = (
        D3D10_SB_OPERAND_TYPE_TEMP = 0, // Temporary Register File
        D3D10_SB_OPERAND_TYPE_INPUT = 1, // General Input Register File
        D3D10_SB_OPERAND_TYPE_OUTPUT = 2, // General Output Register File
        D3D10_SB_OPERAND_TYPE_INDEXABLE_TEMP = 3, // Temporary Register File (indexable)
        D3D10_SB_OPERAND_TYPE_IMMEDIATE32 = 4, // 32bit/component immediate value(s)
        // If for example, operand token bits
        // [01:00]==D3D10_SB_OPERAND_4_COMPONENT,
        // this means that the operand type:
        // D3D10_SB_OPERAND_TYPE_IMMEDIATE32
        // results in 4 additional 32bit
        // DWORDS present for the operand.
        D3D10_SB_OPERAND_TYPE_IMMEDIATE64 = 5, // 64bit/comp.imm.val(s)HI:LO
        D3D10_SB_OPERAND_TYPE_SAMPLER = 6, // Reference to sampler state
        D3D10_SB_OPERAND_TYPE_RESOURCE = 7, // Reference to memory resource (e.g. texture)
        D3D10_SB_OPERAND_TYPE_CONSTANT_BUFFER = 8, // Reference to constant buffer
        D3D10_SB_OPERAND_TYPE_IMMEDIATE_CONSTANT_BUFFER = 9, // Reference to immediate constant buffer
        D3D10_SB_OPERAND_TYPE_LABEL = 10, // Label
        D3D10_SB_OPERAND_TYPE_INPUT_PRIMITIVEID = 11, // Input primitive ID
        D3D10_SB_OPERAND_TYPE_OUTPUT_DEPTH = 12, // Output Depth
        D3D10_SB_OPERAND_TYPE_NULL = 13, // Null register, used to discard results of operations
        // Below Are operands new in DX 10.1
        D3D10_SB_OPERAND_TYPE_RASTERIZER = 14, // DX10.1 Rasterizer register, used to denote the depth/stencil and render target resources
        D3D10_SB_OPERAND_TYPE_OUTPUT_COVERAGE_MASK = 15, // DX10.1 PS output MSAA coverage mask (scalar)
        // Below Are operands new in DX 11
        D3D11_SB_OPERAND_TYPE_STREAM = 16, // Reference to GS stream output resource
        D3D11_SB_OPERAND_TYPE_FUNCTION_BODY = 17, // Reference to a function definition
        D3D11_SB_OPERAND_TYPE_FUNCTION_TABLE = 18, // Reference to a set of functions used by a class
        D3D11_SB_OPERAND_TYPE_INTERFACE = 19, // Reference to an interface
        D3D11_SB_OPERAND_TYPE_FUNCTION_INPUT = 20, // Reference to an input parameter to a function
        D3D11_SB_OPERAND_TYPE_FUNCTION_OUTPUT = 21, // Reference to an output parameter to a function
        D3D11_SB_OPERAND_TYPE_OUTPUT_CONTROL_POINT_ID = 22, // HS Control Point phase input saying which output control point ID this is
        D3D11_SB_OPERAND_TYPE_INPUT_FORK_INSTANCE_ID = 23, // HS Fork Phase input instance ID
        D3D11_SB_OPERAND_TYPE_INPUT_JOIN_INSTANCE_ID = 24, // HS Join Phase input instance ID
        D3D11_SB_OPERAND_TYPE_INPUT_CONTROL_POINT = 25, // HS Fork+Join, DS phase input control points (array of them)
        D3D11_SB_OPERAND_TYPE_OUTPUT_CONTROL_POINT = 26, // HS Fork+Join phase output control points (array of them)
        D3D11_SB_OPERAND_TYPE_INPUT_PATCH_CONSTANT = 27, // DS+HSJoin Input Patch Constants (array of them)
        D3D11_SB_OPERAND_TYPE_INPUT_DOMAIN_POINT = 28, // DS Input Domain point
        D3D11_SB_OPERAND_TYPE_THIS_POINTER = 29, // Reference to an interface this pointer
        D3D11_SB_OPERAND_TYPE_UNORDERED_ACCESS_VIEW = 30, // Reference to UAV u#
        D3D11_SB_OPERAND_TYPE_THREAD_GROUP_SHARED_MEMORY = 31, // Reference to Thread Group Shared Memory g#
        D3D11_SB_OPERAND_TYPE_INPUT_THREAD_ID = 32, // Compute Shader Thread ID
        D3D11_SB_OPERAND_TYPE_INPUT_THREAD_GROUP_ID = 33, // Compute Shader Thread Group ID
        D3D11_SB_OPERAND_TYPE_INPUT_THREAD_ID_IN_GROUP = 34, // Compute Shader Thread ID In Thread Group
        D3D11_SB_OPERAND_TYPE_INPUT_COVERAGE_MASK = 35, // Pixel shader coverage mask input
        D3D11_SB_OPERAND_TYPE_INPUT_THREAD_ID_IN_GROUP_FLATTENED = 36, // Compute Shader Thread ID In Group Flattened to a 1D value.
        D3D11_SB_OPERAND_TYPE_INPUT_GS_INSTANCE_ID = 37, // Input GS instance ID
        D3D11_SB_OPERAND_TYPE_OUTPUT_DEPTH_GREATER_EQUAL = 38, // Output Depth, forced to be greater than or equal than current depth
        D3D11_SB_OPERAND_TYPE_OUTPUT_DEPTH_LESS_EQUAL = 39, // Output Depth, forced to be less than or equal to current depth
        D3D11_SB_OPERAND_TYPE_CYCLE_COUNTER = 40, // Cycle counter
        D3D11_SB_OPERAND_TYPE_OUTPUT_STENCIL_REF = 41, // DX11 PS output stencil reference (scalar)
        D3D11_SB_OPERAND_TYPE_INNER_COVERAGE = 42// DX11 PS input inner coverage (scalar)
        );

    PD3D10_SB_OPERAND_TYPE = ^TD3D10_SB_OPERAND_TYPE;


    TD3D10_SB_OPERAND_INDEX_DIMENSION = (
        D3D10_SB_OPERAND_INDEX_0D = 0, // e.g. Position
        D3D10_SB_OPERAND_INDEX_1D = 1, // Most common.  e.g. Temp registers.
        D3D10_SB_OPERAND_INDEX_2D = 2, // e.g. Geometry Program Input registers.
        D3D10_SB_OPERAND_INDEX_3D = 3// 3D rarely if ever used.
        );

    PD3D10_SB_OPERAND_INDEX_DIMENSION = ^TD3D10_SB_OPERAND_INDEX_DIMENSION;


    TD3D10_SB_OPERAND_INDEX_REPRESENTATION = (
        D3D10_SB_OPERAND_INDEX_IMMEDIATE32 = 0, // Extra DWORD
        D3D10_SB_OPERAND_INDEX_IMMEDIATE64 = 1, // 2 Extra DWORDs
        //   (HI32:LO32)
        D3D10_SB_OPERAND_INDEX_RELATIVE = 2, // Extra operand
        D3D10_SB_OPERAND_INDEX_IMMEDIATE32_PLUS_RELATIVE = 3, // Extra DWORD followed by
        //   extra operand
        D3D10_SB_OPERAND_INDEX_IMMEDIATE64_PLUS_RELATIVE = 4// 2 Extra DWORDS
        //   (HI32:LO32) followed
        //   by extra operand
        );

    PD3D10_SB_OPERAND_INDEX_REPRESENTATION = ^TD3D10_SB_OPERAND_INDEX_REPRESENTATION;


    // ----------------------------------------------------------------------------
    // Extended Instruction Operand Format (OperandToken1)

    // If bit31 of an operand token is set, the
    // operand has additional data in a second DWORD
    // directly following OperandToken0.  Other tokens
    // expected for the operand, such as immmediate
    // values or relative address operands (full
    // operands in themselves) always follow
    // OperandToken0 AND OperandToken1..n (extended
    // operand tokens, if present).

    // [05:00] D3D10_SB_EXTENDED_OPERAND_TYPE
    // [16:06] if([05:00] == D3D10_SB_EXTENDED_OPERAND_MODIFIER)
    //         {
    //              [13:06] D3D10_SB_OPERAND_MODIFIER
    //              [16:14] Min Precision: D3D11_SB_OPERAND_MIN_PRECISION
    //              [17:17] Non-uniform: D3D12_SB_OPERAND_NON_UNIFORM
    //         }
    //         else
    //         {
    //              [17:06] Ignored, 0.
    //         }
    // [30:18] Ignored, 0.
    // [31]    0 normally. 1 if second order extended operand definition,
    //         meaning next DWORD contains yet ANOTHER extended operand
    //         description. Currently no second order extensions defined.
    //         This would be useful if a particular extended operand does
    //         not have enough space to store the required information in
    //         a single token and so is extended further.

    // ----------------------------------------------------------------------------

    TD3D10_SB_EXTENDED_OPERAND_TYPE = (
        D3D10_SB_EXTENDED_OPERAND_EMPTY = 0, // Might be used if this
        // enum is full and
        // further extended opcode
        // is needed.
        D3D10_SB_EXTENDED_OPERAND_MODIFIER = 1
        );

    PD3D10_SB_EXTENDED_OPERAND_TYPE = ^TD3D10_SB_EXTENDED_OPERAND_TYPE;


    TD3D10_SB_OPERAND_MODIFIER = (
        D3D10_SB_OPERAND_MODIFIER_NONE = 0, // Nop.  This is the implied
        // default if the extended
        // operand is not present for
        // an operand for which source
        // modifiers are meaningful
        D3D10_SB_OPERAND_MODIFIER_NEG = 1, // Negate
        D3D10_SB_OPERAND_MODIFIER_ABS = 2, // Absolute value, abs()
        D3D10_SB_OPERAND_MODIFIER_ABSNEG = 3// -abs()
        );

    PD3D10_SB_OPERAND_MODIFIER = ^TD3D10_SB_OPERAND_MODIFIER;


    // Min precision specifier for source/dest operands.  This
    // fits in the extended operand token field. Implementations are free to
    // execute at higher precision than the min - details spec'ed elsewhere.
    // This is part of the opcode specific control range.
    TD3D11_SB_OPERAND_MIN_PRECISION = (
        D3D11_SB_OPERAND_MIN_PRECISION_DEFAULT = 0, // Default precision
        // for the shader model
        D3D11_SB_OPERAND_MIN_PRECISION_FLOAT_16 = 1, // Min 16 bit/component float
        D3D11_SB_OPERAND_MIN_PRECISION_FLOAT_2_8 = 2, // Min 10(2.8)bit/comp. float
        D3D11_SB_OPERAND_MIN_PRECISION_SINT_16 = 4, // Min 16 bit/comp. signed integer
        D3D11_SB_OPERAND_MIN_PRECISION_UINT_16 = 5// Min 16 bit/comp. unsigned integer
        );

    PD3D11_SB_OPERAND_MIN_PRECISION = ^TD3D11_SB_OPERAND_MIN_PRECISION;


    // ----------------------------------------------------------------------------
    // Sampler Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_SAMPLER
    // [14:11] D3D10_SB_SAMPLER_MODE
    // [23:15] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 1 operand on Shader Models 4.0 through 5.0:
    // (1) Operand starting with OperandToken0, defining which sampler
    //     (D3D10_SB_OPERAND_TYPE_SAMPLER) register # is being declared.

    // OpcodeToken0 is followed by 2 operands on Shader Model 5.1 and later:
    // (1) an operand, starting with OperandToken0, defining which
    //     s# register (D3D10_SB_OPERAND_TYPE_SAMPLER) is being declared.
    //     The indexing dimension for the register must be D3D10_SB_OPERAND_INDEX_DIMENSION_3D,
    //     and the meaning of the index dimensions are as follows: (s<id>[<lbound>:<ubound>])
    //       1 <id>:     variable ID being declared
    //       2 <lbound>: the lower bound of the range of samplers in the space
    //       3 <ubound>: the upper bound (inclusive) of this range
    //     As opposed to when the s# is used in shader instructions, where the register
    //     must be D3D10_SB_OPERAND_INDEX_DIMENSION_2D, and the meaning of the index
    //     dimensions are as follows: (s<id>[<idx>]):
    //       1 <id>:  variable ID being used (matches dcl)
    //       2 <idx>: absolute index of sampler within space (may be dynamically indexed)
    // (2) a DWORD indicating the space index.

    // ----------------------------------------------------------------------------
    TD3D10_SB_SAMPLER_MODE = (
        D3D10_SB_SAMPLER_MODE_DEFAULT = 0,
        D3D10_SB_SAMPLER_MODE_COMPARISON = 1,
        D3D10_SB_SAMPLER_MODE_MONO = 2);

    PD3D10_SB_SAMPLER_MODE = ^TD3D10_SB_SAMPLER_MODE;


    // ----------------------------------------------------------------------------
    // Pixel Shader Input Register Declaration w/System Interpreted Value

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_INPUT_PS_SIV
    // [14:11] D3D10_SB_INTERPOLATION_MODE
    // [23:15] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 2 operands:
    // (1) Operand, starting with OperandToken0, defining which input
    //     v# register (D3D10_SB_OPERAND_TYPE_INPUT) is being declared.
    // (2) a System Interpreted Value Name (NameToken)

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Pixel Shader Input Register Declaration w/System Generated Value

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_INPUT_PS_SGV
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 2 operands:
    // (1) Operand, starting with OperandToken0, defining which input
    //     v# register (D3D10_SB_OPERAND_TYPE_INPUT) is being declared.
    // (2) a System Generated Value Name (NameToken)

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Output Register Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_OUTPUT
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 1 operand:
    // (1) Operand, starting with OperandToken0, defining which
    //     o# register (D3D10_SB_OPERAND_TYPE_OUTPUT) is being declared,
    //     including writemask.
    //     (in Pixel Shader, output can also be one of
    //     D3D10_SB_OPERAND_TYPE_OUTPUT_DEPTH,
    //     D3D11_SB_OPERAND_TYPE_OUTPUT_DEPTH_GREATER_EQUAL, or
    //     D3D11_SB_OPERAND_TYPE_OUTPUT_DEPTH_LESS_EQUAL )

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Output Register Declaration w/System Interpreted Value

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_OUTPUT_SIV
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 2 operands:
    // (1) an operand, starting with OperandToken0, defining which
    //     o# register (D3D10_SB_OPERAND_TYPE_OUTPUT) is being declared,
    //     including writemask.
    // (2) a System Interpreted Name token (NameToken)

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Output Register Declaration w/System Generated Value

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_OUTPUT_SGV
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 2 operands:
    // (1) an operand, starting with OperandToken0, defining which
    //     o# register (D3D10_SB_OPERAND_TYPE_OUTPUT) is being declared,
    //     including writemask.
    // (2) a System Generated Name token (NameToken)

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Input or Output Register Indexing Range Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_INDEX_RANGE
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 2 operands:
    // (1) an operand, starting with OperandToken0, defining which
    //     input (v#) or output (o#) register is having its array indexing range
    //     declared, including writemask.  For Geometry Shader inputs,
    //     it is assumed that the vertex axis is always fully indexable,
    //     and 0 must be specified as the vertex# in this declaration, so that
    //     only the a range of attributes are having their index range defined.

    // (2) a DWORD representing the count of registers starting from the one
    //     indicated in (1).

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Temp Register Declaration r0...r(n-1)

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_TEMPS
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 1 operand:
    // (1) DWORD (unsigned int) indicating how many temps are being declared.
    //     i.e. 5 means r0...r4 are declared.

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Indexable Temp Register (x#[size]) Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_INDEXABLE_TEMP
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 3 DWORDs:
    // (1) Register index (defines which x# register is declared)
    // (2) Number of registers in this register bank
    // (3) Number of components in the array (1-4). 1 means .x, 2 means .xy etc.

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Constant Buffer Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_DCL_CONSTANT_BUFFER
    // [11]    D3D10_SB_CONSTANT_BUFFER_ACCESS_PATTERN
    // [23:12] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by 1 operand on Shader Model 4.0 through 5.0:
    // (1) Operand, starting with OperandToken0, defining which CB slot (cb#[size])
    //     is being declared. (operand type: D3D10_SB_OPERAND_TYPE_CONSTANT_BUFFER)
    //     The indexing dimension for the register must be
    //     D3D10_SB_OPERAND_INDEX_DIMENSION_2D, where the first index specifies
    //     which cb#[] is being declared, and the second (array) index specifies the size
    //     of the buffer, as a count of 32-bit*4 elements.  (As opposed to when the
    //     cb#[] is used in shader instructions, and the array index represents which
    //     location in the constant buffer is being referenced.)
    //     If the size is specified as 0, the CB size is not known (any size CB
    //     can be bound to the slot).

    // The order of constant buffer declarations in a shader indicates their
    // relative priority from highest to lowest (hint to driver).

    // OpcodeToken0 is followed by 3 operands on Shader Model 5.1 and later:
    // (1) Operand, starting with OperandToken0, defining which CB range (ID and bounds)
    //     is being declared. (operand type: D3D10_SB_OPERAND_TYPE_CONSTANT_BUFFER)
    //     The indexing dimension for the register must be D3D10_SB_OPERAND_INDEX_DIMENSION_3D,
    //     and the meaning of the index dimensions are as follows: (cb<id>[<lbound>:<ubound>])
    //       1 <id>:     variable ID being declared
    //       2 <lbound>: the lower bound of the range of constant buffers in the space
    //       3 <ubound>: the upper bound (inclusive) of this range
    //     As opposed to when the cb#[] is used in shader instructions: (cb<id>[<idx>][<loc>])
    //       1 <id>:  variable ID being used (matches dcl)
    //       2 <idx>: absolute index of constant buffer within space (may be dynamically indexed)
    //       3 <loc>: location of vector within constant buffer being referenced,
    //          which may also be dynamically indexed, with no access pattern flag required.
    // (2) a DWORD indicating the size of the constant buffer as a count of 16-byte vectors.
    //     Each vector is 32-bit*4 elements == 128-bits == 16 bytes.
    //     If the size is specified as 0, the CB size is not known (any size CB
    //     can be bound to the slot).
    // (3) a DWORD indicating the space index.

    // ----------------------------------------------------------------------------


    TD3D10_SB_CONSTANT_BUFFER_ACCESS_PATTERN = (
        D3D10_SB_CONSTANT_BUFFER_IMMEDIATE_INDEXED = 0,
        D3D10_SB_CONSTANT_BUFFER_DYNAMIC_INDEXED = 1);

    PD3D10_SB_CONSTANT_BUFFER_ACCESS_PATTERN = ^TD3D10_SB_CONSTANT_BUFFER_ACCESS_PATTERN;


    // ----------------------------------------------------------------------------
    // Immediate Constant Buffer Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_CUSTOMDATA
    // [31:11] == D3D10_SB_CUSTOMDATA_DCL_IMMEDIATE_CONSTANT_BUFFER

    // OpcodeToken0 is followed by:
    // (1) DWORD indicating length of declaration, including OpcodeToken0.
    //     This length must = 2(for OpcodeToken0 and 1) + a multiple of 4
    //                                                    (# of immediate constants)
    // (2) Sequence of 4-tuples of DWORDs defining the Immediate Constant Buffer.
    //     The number of 4-tuples is (length above - 1) / 4
    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Shader Message Declaration

    // OpcodeToken0:

    // [10:00] D3D10_SB_OPCODE_CUSTOMDATA
    // [31:11] == D3D11_SB_CUSTOMDATA_SHADER_MESSAGE

    // OpcodeToken0 is followed by:
    // (1) DWORD indicating length of declaration, including OpcodeToken0.
    // (2) DWORD (D3D11_SB_SHADER_MESSAGE_ID) indicating shader message or error.
    // (3) D3D11_SB_SHADER_MESSAGE_FORMAT indicating the convention for formatting the message.
    // (4) DWORD indicating the number of characters in the string without the terminator.
    // (5) DWORD indicating the number of operands.
    // (6) DWORD indicating length of operands.
    // (7) Encoded operands.
    // (8) String with trailing zero, padded to a multiple of DWORDs.
    //     The string is in the given format and the operands given should
    //     be used for argument substitutions when formatting.
    // ----------------------------------------------------------------------------


    TD3D11_SB_SHADER_MESSAGE_ID = (
        D3D11_SB_SHADER_MESSAGE_ID_MESSAGE = $00200102,
        D3D11_SB_SHADER_MESSAGE_ID_ERROR = $00200103);

    PD3D11_SB_SHADER_MESSAGE_ID = ^TD3D11_SB_SHADER_MESSAGE_ID;


    TD3D11_SB_SHADER_MESSAGE_FORMAT = (
        // No formatting, just a text string.  Operands are ignored.
        D3D11_SB_SHADER_MESSAGE_FORMAT_ANSI_TEXT,
        // Format string follows C/C++ printf conventions.
        D3D11_SB_SHADER_MESSAGE_FORMAT_ANSI_PRINTF);

    PD3D11_SB_SHADER_MESSAGE_FORMAT = ^TD3D11_SB_SHADER_MESSAGE_FORMAT;


    // ----------------------------------------------------------------------------
    // Hull Shader Declaration Phase: Tessellator Domain

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_TESS_DOMAIN
    // [12:11] Domain
    // [23:13] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token. == 1
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // ----------------------------------------------------------------------------
    TD3D11_SB_TESSELLATOR_DOMAIN = (
        D3D11_SB_TESSELLATOR_DOMAIN_UNDEFINED = 0,
        D3D11_SB_TESSELLATOR_DOMAIN_ISOLINE = 1,
        D3D11_SB_TESSELLATOR_DOMAIN_TRI = 2,
        D3D11_SB_TESSELLATOR_DOMAIN_QUAD = 3);

    PD3D11_SB_TESSELLATOR_DOMAIN = ^TD3D11_SB_TESSELLATOR_DOMAIN;


    // ----------------------------------------------------------------------------
    // Hull Shader Declaration Phase: Tessellator Partitioning

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_TESS_PARTITIONING
    // [13:11] Partitioning
    // [23:14] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token. == 1
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // ----------------------------------------------------------------------------
    TD3D11_SB_TESSELLATOR_PARTITIONING = (
        D3D11_SB_TESSELLATOR_PARTITIONING_UNDEFINED = 0,
        D3D11_SB_TESSELLATOR_PARTITIONING_INTEGER = 1,
        D3D11_SB_TESSELLATOR_PARTITIONING_POW2 = 2,
        D3D11_SB_TESSELLATOR_PARTITIONING_FRACTIONAL_ODD = 3,
        D3D11_SB_TESSELLATOR_PARTITIONING_FRACTIONAL_EVEN = 4);

    PD3D11_SB_TESSELLATOR_PARTITIONING = ^TD3D11_SB_TESSELLATOR_PARTITIONING;


    // ----------------------------------------------------------------------------
    // Hull Shader Declaration Phase: Tessellator Output Primitive

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_TESS_OUTPUT_PRIMITIVE
    // [13:11] Output Primitive
    // [23:14] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token. == 1
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // ----------------------------------------------------------------------------
    TD3D11_SB_TESSELLATOR_OUTPUT_PRIMITIVE = (
        D3D11_SB_TESSELLATOR_OUTPUT_UNDEFINED = 0,
        D3D11_SB_TESSELLATOR_OUTPUT_POINT = 1,
        D3D11_SB_TESSELLATOR_OUTPUT_LINE = 2,
        D3D11_SB_TESSELLATOR_OUTPUT_TRIANGLE_CW = 3,
        D3D11_SB_TESSELLATOR_OUTPUT_TRIANGLE_CCW = 4);

    PD3D11_SB_TESSELLATOR_OUTPUT_PRIMITIVE = ^TD3D11_SB_TESSELLATOR_OUTPUT_PRIMITIVE;


    // ----------------------------------------------------------------------------
    // Hull Shader Declaration Phase: Hull Shader Max Tessfactor

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_HS_MAX_TESSFACTOR
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by a float32 representing the
    // maximum TessFactor.

    // ----------------------------------------------------------------------------
    // ----------------------------------------------------------------------------
    // Hull Shader Declaration Phase: Hull Shader Fork Phase Instance Count

    // OpcodeToken0:

    // [10:00] D3D11_SB_OPCODE_DCL_HS_FORK_PHASE_INSTANCE_COUNT
    // [23:11] Ignored, 0
    // [30:24] Instruction length in DWORDs including the opcode token.
    // [31]    0 normally. 1 if extended operand definition, meaning next DWORD
    //         contains extended operand description.  This dcl is currently not
    //         extended.

    // OpcodeToken0 is followed by a UINT32 representing the
    // number of instances of the current fork phase program to execute.

    // ----------------------------------------------------------------------------


    TD3D10_SB_INTERPOLATION_MODE = (
        D3D10_SB_INTERPOLATION_UNDEFINED = 0,
        D3D10_SB_INTERPOLATION_CONSTANT = 1,
        D3D10_SB_INTERPOLATION_LINEAR = 2,
        D3D10_SB_INTERPOLATION_LINEAR_CENTROID = 3,
        D3D10_SB_INTERPOLATION_LINEAR_NOPERSPECTIVE = 4,
        D3D10_SB_INTERPOLATION_LINEAR_NOPERSPECTIVE_CENTROID = 5,
        D3D10_SB_INTERPOLATION_LINEAR_SAMPLE = 6, // DX10.1
        D3D10_SB_INTERPOLATION_LINEAR_NOPERSPECTIVE_SAMPLE = 7// DX10.1
        );

    PD3D10_SB_INTERPOLATION_MODE = ^TD3D10_SB_INTERPOLATION_MODE;


    // Keep PRIMITIVE_TOPOLOGY values in sync with earlier DX versions (HW consumes values directly).
    TD3D10_SB_PRIMITIVE_TOPOLOGY = (
        D3D10_SB_PRIMITIVE_TOPOLOGY_UNDEFINED = 0,
        D3D10_SB_PRIMITIVE_TOPOLOGY_POINTLIST = 1,
        D3D10_SB_PRIMITIVE_TOPOLOGY_LINELIST = 2,
        D3D10_SB_PRIMITIVE_TOPOLOGY_LINESTRIP = 3,
        D3D10_SB_PRIMITIVE_TOPOLOGY_TRIANGLELIST = 4,
        D3D10_SB_PRIMITIVE_TOPOLOGY_TRIANGLESTRIP = 5,
        // 6 is reserved for legacy triangle fans
        // Adjacency values should be equal to (0x8 & non-adjacency):
        D3D10_SB_PRIMITIVE_TOPOLOGY_LINELIST_ADJ = 10,
        D3D10_SB_PRIMITIVE_TOPOLOGY_LINESTRIP_ADJ = 11,
        D3D10_SB_PRIMITIVE_TOPOLOGY_TRIANGLELIST_ADJ = 12,
        D3D10_SB_PRIMITIVE_TOPOLOGY_TRIANGLESTRIP_ADJ = 13);

    PD3D10_SB_PRIMITIVE_TOPOLOGY = ^TD3D10_SB_PRIMITIVE_TOPOLOGY;


    TD3D10_SB_PRIMITIVE = (
        D3D10_SB_PRIMITIVE_UNDEFINED = 0,
        D3D10_SB_PRIMITIVE_POINT = 1,
        D3D10_SB_PRIMITIVE_LINE = 2,
        D3D10_SB_PRIMITIVE_TRIANGLE = 3,
        // Adjacency values should be equal to (0x4 & non-adjacency):
        D3D10_SB_PRIMITIVE_LINE_ADJ = 6,
        D3D10_SB_PRIMITIVE_TRIANGLE_ADJ = 7,
        D3D11_SB_PRIMITIVE_1_CONTROL_POINT_PATCH = 8,
        D3D11_SB_PRIMITIVE_2_CONTROL_POINT_PATCH = 9,
        D3D11_SB_PRIMITIVE_3_CONTROL_POINT_PATCH = 10,
        D3D11_SB_PRIMITIVE_4_CONTROL_POINT_PATCH = 11,
        D3D11_SB_PRIMITIVE_5_CONTROL_POINT_PATCH = 12,
        D3D11_SB_PRIMITIVE_6_CONTROL_POINT_PATCH = 13,
        D3D11_SB_PRIMITIVE_7_CONTROL_POINT_PATCH = 14,
        D3D11_SB_PRIMITIVE_8_CONTROL_POINT_PATCH = 15,
        D3D11_SB_PRIMITIVE_9_CONTROL_POINT_PATCH = 16,
        D3D11_SB_PRIMITIVE_10_CONTROL_POINT_PATCH = 17,
        D3D11_SB_PRIMITIVE_11_CONTROL_POINT_PATCH = 18,
        D3D11_SB_PRIMITIVE_12_CONTROL_POINT_PATCH = 19,
        D3D11_SB_PRIMITIVE_13_CONTROL_POINT_PATCH = 20,
        D3D11_SB_PRIMITIVE_14_CONTROL_POINT_PATCH = 21,
        D3D11_SB_PRIMITIVE_15_CONTROL_POINT_PATCH = 22,
        D3D11_SB_PRIMITIVE_16_CONTROL_POINT_PATCH = 23,
        D3D11_SB_PRIMITIVE_17_CONTROL_POINT_PATCH = 24,
        D3D11_SB_PRIMITIVE_18_CONTROL_POINT_PATCH = 25,
        D3D11_SB_PRIMITIVE_19_CONTROL_POINT_PATCH = 26,
        D3D11_SB_PRIMITIVE_20_CONTROL_POINT_PATCH = 27,
        D3D11_SB_PRIMITIVE_21_CONTROL_POINT_PATCH = 28,
        D3D11_SB_PRIMITIVE_22_CONTROL_POINT_PATCH = 29,
        D3D11_SB_PRIMITIVE_23_CONTROL_POINT_PATCH = 30,
        D3D11_SB_PRIMITIVE_24_CONTROL_POINT_PATCH = 31,
        D3D11_SB_PRIMITIVE_25_CONTROL_POINT_PATCH = 32,
        D3D11_SB_PRIMITIVE_26_CONTROL_POINT_PATCH = 33,
        D3D11_SB_PRIMITIVE_27_CONTROL_POINT_PATCH = 34,
        D3D11_SB_PRIMITIVE_28_CONTROL_POINT_PATCH = 35,
        D3D11_SB_PRIMITIVE_29_CONTROL_POINT_PATCH = 36,
        D3D11_SB_PRIMITIVE_30_CONTROL_POINT_PATCH = 37,
        D3D11_SB_PRIMITIVE_31_CONTROL_POINT_PATCH = 38,
        D3D11_SB_PRIMITIVE_32_CONTROL_POINT_PATCH = 39);

    PD3D10_SB_PRIMITIVE = ^TD3D10_SB_PRIMITIVE;


    TD3D10_SB_COMPONENT_MASK = (
        D3D10_SB_COMPONENT_MASK_X = 1,
        D3D10_SB_COMPONENT_MASK_Y = 2,
        D3D10_SB_COMPONENT_MASK_Z = 4,
        D3D10_SB_COMPONENT_MASK_W = 8,
        D3D10_SB_COMPONENT_MASK_R = 1,
        D3D10_SB_COMPONENT_MASK_G = 2,
        D3D10_SB_COMPONENT_MASK_B = 4,
        D3D10_SB_COMPONENT_MASK_A = 8,
        D3D10_SB_COMPONENT_MASK_ALL = 15);

    PD3D10_SB_COMPONENT_MASK = ^TD3D10_SB_COMPONENT_MASK;


    TD3D10_SB_NAME = (
        D3D10_SB_NAME_UNDEFINED = 0,
        D3D10_SB_NAME_POSITION = 1,
        D3D10_SB_NAME_CLIP_DISTANCE = 2,
        D3D10_SB_NAME_CULL_DISTANCE = 3,
        D3D10_SB_NAME_RENDER_TARGET_ARRAY_INDEX = 4,
        D3D10_SB_NAME_VIEWPORT_ARRAY_INDEX = 5,
        D3D10_SB_NAME_VERTEX_ID = 6,
        D3D10_SB_NAME_PRIMITIVE_ID = 7,
        D3D10_SB_NAME_INSTANCE_ID = 8,
        D3D10_SB_NAME_IS_FRONT_FACE = 9,
        D3D10_SB_NAME_SAMPLE_INDEX = 10,
        // The following are added for D3D11
        D3D11_SB_NAME_FINAL_QUAD_U_EQ_0_EDGE_TESSFACTOR = 11,
        D3D11_SB_NAME_FINAL_QUAD_V_EQ_0_EDGE_TESSFACTOR = 12,
        D3D11_SB_NAME_FINAL_QUAD_U_EQ_1_EDGE_TESSFACTOR = 13,
        D3D11_SB_NAME_FINAL_QUAD_V_EQ_1_EDGE_TESSFACTOR = 14,
        D3D11_SB_NAME_FINAL_QUAD_U_INSIDE_TESSFACTOR = 15,
        D3D11_SB_NAME_FINAL_QUAD_V_INSIDE_TESSFACTOR = 16,
        D3D11_SB_NAME_FINAL_TRI_U_EQ_0_EDGE_TESSFACTOR = 17,
        D3D11_SB_NAME_FINAL_TRI_V_EQ_0_EDGE_TESSFACTOR = 18,
        D3D11_SB_NAME_FINAL_TRI_W_EQ_0_EDGE_TESSFACTOR = 19,
        D3D11_SB_NAME_FINAL_TRI_INSIDE_TESSFACTOR = 20,
        D3D11_SB_NAME_FINAL_LINE_DETAIL_TESSFACTOR = 21,
        D3D11_SB_NAME_FINAL_LINE_DENSITY_TESSFACTOR = 22,
        // The following are added for D3D12
        D3D12_SB_NAME_BARYCENTRICS = 23,
        D3D12_SB_NAME_SHADINGRATE = 24,
        D3D12_SB_NAME_CULLPRIMITIVE = 25);

    PD3D10_SB_NAME = ^TD3D10_SB_NAME;


    TD3D10_SB_RESOURCE_DIMENSION = (
        D3D10_SB_RESOURCE_DIMENSION_UNKNOWN = 0,
        D3D10_SB_RESOURCE_DIMENSION_BUFFER = 1,
        D3D10_SB_RESOURCE_DIMENSION_TEXTURE1D = 2,
        D3D10_SB_RESOURCE_DIMENSION_TEXTURE2D = 3,
        D3D10_SB_RESOURCE_DIMENSION_TEXTURE2DMS = 4,
        D3D10_SB_RESOURCE_DIMENSION_TEXTURE3D = 5,
        D3D10_SB_RESOURCE_DIMENSION_TEXTURECUBE = 6,
        D3D10_SB_RESOURCE_DIMENSION_TEXTURE1DARRAY = 7,
        D3D10_SB_RESOURCE_DIMENSION_TEXTURE2DARRAY = 8,
        D3D10_SB_RESOURCE_DIMENSION_TEXTURE2DMSARRAY = 9,
        D3D10_SB_RESOURCE_DIMENSION_TEXTURECUBEARRAY = 10,
        D3D11_SB_RESOURCE_DIMENSION_RAW_BUFFER = 11,
        D3D11_SB_RESOURCE_DIMENSION_STRUCTURED_BUFFER = 12);

    PD3D10_SB_RESOURCE_DIMENSION = ^TD3D10_SB_RESOURCE_DIMENSION;


    TD3D10_SB_RESOURCE_RETURN_TYPE = (
        D3D10_SB_RETURN_TYPE_UNORM = 1,
        D3D10_SB_RETURN_TYPE_SNORM = 2,
        D3D10_SB_RETURN_TYPE_SINT = 3,
        D3D10_SB_RETURN_TYPE_UINT = 4,
        D3D10_SB_RETURN_TYPE_FLOAT = 5,
        D3D10_SB_RETURN_TYPE_MIXED = 6,
        D3D11_SB_RETURN_TYPE_DOUBLE = 7,
        D3D11_SB_RETURN_TYPE_CONTINUED = 8,
        D3D11_SB_RETURN_TYPE_UNUSED = 9);

    PD3D10_SB_RESOURCE_RETURN_TYPE = ^TD3D10_SB_RESOURCE_RETURN_TYPE;


    TD3D10_SB_REGISTER_COMPONENT_TYPE = (
        D3D10_SB_REGISTER_COMPONENT_UNKNOWN = 0,
        D3D10_SB_REGISTER_COMPONENT_UINT32 = 1,
        D3D10_SB_REGISTER_COMPONENT_SINT32 = 2,
        D3D10_SB_REGISTER_COMPONENT_FLOAT32 = 3,
        // Below types aren't used in DXBC, only signatures from DXIL shaders
        D3D10_SB_REGISTER_COMPONENT_UINT16 = 4,
        D3D10_SB_REGISTER_COMPONENT_SINT16 = 5,
        D3D10_SB_REGISTER_COMPONENT_FLOAT16 = 6,
        D3D10_SB_REGISTER_COMPONENT_UINT64 = 7,
        D3D10_SB_REGISTER_COMPONENT_SINT64 = 8,
        D3D10_SB_REGISTER_COMPONENT_FLOAT64 = 9);

    PD3D10_SB_REGISTER_COMPONENT_TYPE = ^TD3D10_SB_REGISTER_COMPONENT_TYPE;


    TD3D10_SB_INSTRUCTION_RETURN_TYPE = (
        D3D10_SB_INSTRUCTION_RETURN_FLOAT = 0,
        D3D10_SB_INSTRUCTION_RETURN_UINT = 1);

    PD3D10_SB_INSTRUCTION_RETURN_TYPE = ^TD3D10_SB_INSTRUCTION_RETURN_TYPE;


// DECODER MACRO: Retrieve program type from version token
function DECODE_D3D10_SB_TOKENIZED_PROGRAM_TYPE(VerTok: longword): TD3D10_SB_TOKENIZED_PROGRAM_TYPE;

// DECODER MACRO: Retrieve major version # from version token
function DECODE_D3D10_SB_TOKENIZED_PROGRAM_MAJOR_VERSION(VerTok: longword): longword;

// DECODER MACRO: Retrieve minor version # from version token
function DECODE_D3D10_SB_TOKENIZED_PROGRAM_MINOR_VERSION(VerTok: longword): longword;

// ENCODER MACRO: Create complete VerTok
function ENCODE_D3D10_SB_TOKENIZED_PROGRAM_VERSION_TOKEN(ProgType, MajorVer, MinorVer: longword): longword;


// ----------------------------------------------------------------------------
// Length Token (LenTok)

// Always follows VerTok

// [31:00] Unsigned integer count of number of
//              DWORDs in program code, including version
//              and length tokens.  So the minimum value
//              is 0x00000002 (if an empty program is ever
//              valid).

// ----------------------------------------------------------------------------

// DECODER MACRO: Retrieve program length
function DECODE_D3D10_SB_TOKENIZED_PROGRAM_LENGTH(LenTok: longword): longword;
// ENCODER MACRO: Create complete LenTok
function ENCODE_D3D10_SB_TOKENIZED_PROGRAM_LENGTH(Length: longword): longword;

implementation

// DECODER MACRO: Retrieve program type from version token

function DECODE_D3D10_SB_TOKENIZED_PROGRAM_TYPE(VerTok: longword): TD3D10_SB_TOKENIZED_PROGRAM_TYPE;
begin
    Result := TD3D10_SB_TOKENIZED_PROGRAM_TYPE((VerTok and D3D10_SB_TOKENIZED_PROGRAM_TYPE_MASK) shr D3D10_SB_TOKENIZED_PROGRAM_TYPE_SHIFT);
end;

// DECODER MACRO: Retrieve major version # from version token

function DECODE_D3D10_SB_TOKENIZED_PROGRAM_MAJOR_VERSION(VerTok: longword): longword;
begin
    Result := ((VerTok and D3D10_SB_TOKENIZED_PROGRAM_MAJOR_VERSION_MASK) shr D3D10_SB_TOKENIZED_PROGRAM_MAJOR_VERSION_SHIFT);

end;

// DECODER MACRO: Retrieve minor version # from version token

function DECODE_D3D10_SB_TOKENIZED_PROGRAM_MINOR_VERSION(VerTok: longword): longword;
begin
    Result := (VerTok and D3D10_SB_TOKENIZED_PROGRAM_MINOR_VERSION_MASK);
end;


// ENCODER MACRO: Create complete VerTok
function ENCODE_D3D10_SB_TOKENIZED_PROGRAM_VERSION_TOKEN(ProgType, MajorVer, MinorVer: longword): longword;
begin
    Result := (((ProgType shl D3D10_SB_TOKENIZED_PROGRAM_TYPE_SHIFT) and D3D10_SB_TOKENIZED_PROGRAM_TYPE_MASK) or (((MajorVer shl D3D10_SB_TOKENIZED_PROGRAM_MAJOR_VERSION_SHIFT) and D3D10_SB_TOKENIZED_PROGRAM_MAJOR_VERSION_MASK)) or
        (MinorVer and D3D10_SB_TOKENIZED_PROGRAM_MINOR_VERSION_MASK));

end;



function DECODE_D3D10_SB_TOKENIZED_PROGRAM_LENGTH(LenTok: longword): longword;
begin
    Result := LenTok;
end;



function ENCODE_D3D10_SB_TOKENIZED_PROGRAM_LENGTH(Length: longword): longword;
begin
    Result := Length;
end;


// DECODER MACRO: Retrieve program opcode
function DECODE_D3D10_SB_OPCODE_TYPE(OpcodeToken0: longword): TD3D10_SB_OPCODE_TYPE;
begin
    Result := TD3D10_SB_OPCODE_TYPE((OpcodeToken0 and D3D10_SB_OPCODE_TYPE_MASK));
end;

// ENCODER MACRO: Create the opcode-type portion of OpcodeToken0

function ENCODE_D3D10_SB_OPCODE_TYPE(OpcodeName: longword): longword;
begin
    Result := (OpcodeName and D3D10_SB_OPCODE_TYPE_MASK);
end;

// DECODER MACRO: Retrieve instruction length
// in # of DWORDs including the opcode token(s).
// The range is 1-127.
function DECODE_D3D10_SB_TOKENIZED_INSTRUCTION_LENGTH(OpcodeToken0: longword): longword;
begin
    Result := (OpcodeToken0 and D3D10_SB_TOKENIZED_INSTRUCTION_LENGTH_MASK shr D3D10_SB_TOKENIZED_INSTRUCTION_LENGTH_SHIFT);
end;

// ENCODER MACRO: Store instruction length
// portion of OpcodeToken0, in # of DWORDs
// including the opcode token(s).
// Valid range is 1-127.
function ENCODE_D3D10_SB_TOKENIZED_INSTRUCTION_LENGTH(Length: longword): longword;
begin
    Result := ((Length shl D3D10_SB_TOKENIZED_INSTRUCTION_LENGTH_SHIFT) and D3D10_SB_TOKENIZED_INSTRUCTION_LENGTH_MASK);
end;
// DECODER MACRO: Check OpcodeToken0 to see if an instruction
// is to saturate the result [0..1]
// This flag is indicated by one of the bits in the
// opcode specific control range.
function DECODE_IS_D3D10_SB_INSTRUCTION_SATURATE_ENABLED(OpcodeToken0: longword): longword;
begin
    Result := (OpcodeToken0 and D3D10_SB_INSTRUCTION_SATURATE_MASK);
end;
// ENCODER MACRO: Encode in OpcodeToken0 if instruction is to saturate the result.


function ENCODE_D3D10_SB_INSTRUCTION_SATURATE(bSat: longword): longword;
begin
    if (bSat <> 0) then
        Result := D3D10_SB_INSTRUCTION_SATURATE_MASK
    else
        Result := 0;
end;


end.
