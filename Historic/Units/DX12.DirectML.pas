unit DX12.DirectML;

// Copyright (c) Microsoft Corporation.  All rights reserved.
// Direct Machine Learning

// Header Version 10.0.19041.0

// Translation to Pascal  Copyright (c) 2020 Norbert Sonnleitner
// you can use this for free :)


{$mode delphi}

interface

uses
    Windows, DX12.D3D12;

const

    DLLName = 'DirectML.dll';


    IID_IDMLObject: TGUID = '{c8263aac-9e0c-4a2d-9b8e-007521a3317c}';
    IID_IDMLDevice: TGUID = '{6dbd6437-96fd-423f-a98c-ae5e7c2a573f}';
    IID_IDMLDeviceChild: TGUID = '{27e83142-8165-49e3-974e-2fd66e4cb69d}';
    IID_IDMLPageable: TGUID = '{b1ab0825-4542-4a4b-8617-6dde6e8f6201}';
    IID_IDMLOperator: TGUID = '{26caae7a-3081-4633-9581-226fbe57695d}';
    IID_IDMLDispatchable: TGUID = '{dcb821a8-1039-441e-9f1c-b1759c2f3cec}';
    IID_IDMLCompiledOperator: TGUID = '{6b15e56a-bf5c-4902-92d8-da3a650afea4}';
    IID_IDMLOperatorInitializer: TGUID = '{427c1113-435c-469c-8676-4d5dd072f813}';
    IID_IDMLBindingTable: TGUID = '{29c687dc-de74-4e3b-ab00-1168f2fc3cfc}';
    IID_IDMLCommandRecorder: TGUID = '{e6857a76-2e3e-4fdd-bff4-5d2ba10fb453}';
    IID_IDMLDebugDevice: TGUID = '{7d6f3ac9-394a-4ac3-92a7-390cc57a8217}';


    // ===================================================================================================================
    //   DirectML constants
    // ===================================================================================================================

    DML_TENSOR_DIMENSION_COUNT_MAX: UINT = 5;
    DML_TEMPORARY_BUFFER_ALIGNMENT: UINT = 256;
    DML_PERSISTENT_BUFFER_ALIGNMENT: UINT = 256;
    DML_MINIMUM_BUFFER_TENSOR_ALIGNMENT: UINT = 16;




type

    IDMLDispatchable = interface;
    IDMLOperator = interface;
    IDMLCompiledOperator = interface;
    IDMLPageable = interface;

    PIDMLCompiledOperator = ^IDMLCompiledOperator;
    PIDMLPageable = ^IDMLPageable;

    // ===================================================================================================================
    //   Tensor descriptions
    // ===================================================================================================================

    TDML_TENSOR_DATA_TYPE = (
        DML_TENSOR_DATA_TYPE_UNKNOWN,
        DML_TENSOR_DATA_TYPE_FLOAT32,
        DML_TENSOR_DATA_TYPE_FLOAT16,
        DML_TENSOR_DATA_TYPE_UINT32,
        DML_TENSOR_DATA_TYPE_UINT16,
        DML_TENSOR_DATA_TYPE_UINT8,
        DML_TENSOR_DATA_TYPE_INT32,
        DML_TENSOR_DATA_TYPE_INT16,
        DML_TENSOR_DATA_TYPE_INT8);

    TDML_TENSOR_TYPE = (
        DML_TENSOR_TYPE_INVALID,
        DML_TENSOR_TYPE_BUFFER);

    TDML_TENSOR_FLAGS = (
        DML_TENSOR_FLAG_NONE = $0,
        DML_TENSOR_FLAG_OWNED_BY_DML = $1);

    TDML_BUFFER_TENSOR_DESC = record
        DataType: TDML_TENSOR_DATA_TYPE;
        Flags: TDML_TENSOR_FLAGS;
        DimensionCount: UINT;
        Sizes {DimensionCount}: PUINT;
        Strides {DimensionCount}: PUINT;
        TotalTensorSizeInBytes: UINT64;
        GuaranteedBaseOffsetAlignment: UINT;
    end;

    PDML_BUFFER_TENSOR_DESC = ^TDML_BUFFER_TENSOR_DESC;

    TDML_TENSOR_DESC = record
        _Type: TDML_TENSOR_TYPE;
        Desc: pointer;
    end;

    PDML_TENSOR_DESC = ^TDML_TENSOR_DESC;

    // ===================================================================================================================
    //   Operator types
    // ===================================================================================================================

    TDML_OPERATOR_TYPE = (
        DML_OPERATOR_INVALID,

        DML_OPERATOR_ELEMENT_WISE_IDENTITY,
        DML_OPERATOR_ELEMENT_WISE_ABS,
        DML_OPERATOR_ELEMENT_WISE_ACOS,
        DML_OPERATOR_ELEMENT_WISE_ADD,
        DML_OPERATOR_ELEMENT_WISE_ASIN,
        DML_OPERATOR_ELEMENT_WISE_ATAN,
        DML_OPERATOR_ELEMENT_WISE_CEIL,
        DML_OPERATOR_ELEMENT_WISE_CLIP,
        DML_OPERATOR_ELEMENT_WISE_COS,
        DML_OPERATOR_ELEMENT_WISE_DIVIDE,
        DML_OPERATOR_ELEMENT_WISE_EXP,
        DML_OPERATOR_ELEMENT_WISE_FLOOR,
        DML_OPERATOR_ELEMENT_WISE_LOG,
        DML_OPERATOR_ELEMENT_WISE_LOGICAL_AND,
        DML_OPERATOR_ELEMENT_WISE_LOGICAL_EQUALS,
        DML_OPERATOR_ELEMENT_WISE_LOGICAL_GREATER_THAN,
        DML_OPERATOR_ELEMENT_WISE_LOGICAL_LESS_THAN,
        DML_OPERATOR_ELEMENT_WISE_LOGICAL_NOT,
        DML_OPERATOR_ELEMENT_WISE_LOGICAL_OR,
        DML_OPERATOR_ELEMENT_WISE_LOGICAL_XOR,
        DML_OPERATOR_ELEMENT_WISE_MAX,
        DML_OPERATOR_ELEMENT_WISE_MEAN,
        DML_OPERATOR_ELEMENT_WISE_MIN,
        DML_OPERATOR_ELEMENT_WISE_MULTIPLY,
        DML_OPERATOR_ELEMENT_WISE_POW,
        DML_OPERATOR_ELEMENT_WISE_CONSTANT_POW,
        DML_OPERATOR_ELEMENT_WISE_RECIP,
        DML_OPERATOR_ELEMENT_WISE_SIN,
        DML_OPERATOR_ELEMENT_WISE_SQRT,
        DML_OPERATOR_ELEMENT_WISE_SUBTRACT,
        DML_OPERATOR_ELEMENT_WISE_TAN,
        DML_OPERATOR_ELEMENT_WISE_THRESHOLD,
        DML_OPERATOR_ELEMENT_WISE_QUANTIZE_LINEAR,
        DML_OPERATOR_ELEMENT_WISE_DEQUANTIZE_LINEAR,
        DML_OPERATOR_ACTIVATION_ELU,
        DML_OPERATOR_ACTIVATION_HARDMAX,
        DML_OPERATOR_ACTIVATION_HARD_SIGMOID,
        DML_OPERATOR_ACTIVATION_IDENTITY,
        DML_OPERATOR_ACTIVATION_LEAKY_RELU,
        DML_OPERATOR_ACTIVATION_LINEAR,
        DML_OPERATOR_ACTIVATION_LOG_SOFTMAX,
        DML_OPERATOR_ACTIVATION_PARAMETERIZED_RELU,
        DML_OPERATOR_ACTIVATION_PARAMETRIC_SOFTPLUS,
        DML_OPERATOR_ACTIVATION_RELU,
        DML_OPERATOR_ACTIVATION_SCALED_ELU,
        DML_OPERATOR_ACTIVATION_SCALED_TANH,
        DML_OPERATOR_ACTIVATION_SIGMOID,
        DML_OPERATOR_ACTIVATION_SOFTMAX,
        DML_OPERATOR_ACTIVATION_SOFTPLUS,
        DML_OPERATOR_ACTIVATION_SOFTSIGN,
        DML_OPERATOR_ACTIVATION_TANH,
        DML_OPERATOR_ACTIVATION_THRESHOLDED_RELU,
        DML_OPERATOR_CONVOLUTION,
        DML_OPERATOR_GEMM,
        DML_OPERATOR_REDUCE,
        DML_OPERATOR_AVERAGE_POOLING,
        DML_OPERATOR_LP_POOLING,
        DML_OPERATOR_MAX_POOLING,
        DML_OPERATOR_ROI_POOLING,
        DML_OPERATOR_SLICE,
        DML_OPERATOR_CAST,
        DML_OPERATOR_SPLIT,
        DML_OPERATOR_JOIN,
        DML_OPERATOR_PADDING,
        DML_OPERATOR_VALUE_SCALE_2D,
        DML_OPERATOR_UPSAMPLE_2D,
        DML_OPERATOR_GATHER,
        DML_OPERATOR_SPACE_TO_DEPTH,
        DML_OPERATOR_DEPTH_TO_SPACE,
        DML_OPERATOR_TILE,
        DML_OPERATOR_TOP_K,
        DML_OPERATOR_BATCH_NORMALIZATION,
        DML_OPERATOR_MEAN_VARIANCE_NORMALIZATION,
        DML_OPERATOR_LOCAL_RESPONSE_NORMALIZATION,
        DML_OPERATOR_LP_NORMALIZATION,
        DML_OPERATOR_RNN,
        DML_OPERATOR_LSTM,
        DML_OPERATOR_GRU,

        //{$IFDEF NTDDI_VERSION >= NTDDI_WIN10_VB}
        DML_OPERATOR_ELEMENT_WISE_SIGN,
        DML_OPERATOR_ELEMENT_WISE_IS_NAN,
        DML_OPERATOR_ELEMENT_WISE_ERF,
        DML_OPERATOR_ELEMENT_WISE_SINH,
        DML_OPERATOR_ELEMENT_WISE_COSH,
        DML_OPERATOR_ELEMENT_WISE_TANH,
        DML_OPERATOR_ELEMENT_WISE_ASINH,
        DML_OPERATOR_ELEMENT_WISE_ACOSH,
        DML_OPERATOR_ELEMENT_WISE_ATANH,
        DML_OPERATOR_ELEMENT_WISE_IF,
        DML_OPERATOR_ELEMENT_WISE_ADD1,
        DML_OPERATOR_ACTIVATION_SHRINK,
        DML_OPERATOR_MAX_POOLING1,
        DML_OPERATOR_MAX_UNPOOLING,
        DML_OPERATOR_DIAGONAL_MATRIX,
        DML_OPERATOR_SCATTER,
        DML_OPERATOR_ONE_HOT,
        DML_OPERATOR_RESAMPLE
        //{$endif} // NTDDI_VERSION >= NTDDI_WIN10_VB
        );


    // ===================================================================================================================
    //   Operator enumerations and structures
    // ===================================================================================================================

    TDML_REDUCE_FUNCTION = (
        DML_REDUCE_FUNCTION_ARGMAX,
        DML_REDUCE_FUNCTION_ARGMIN,
        DML_REDUCE_FUNCTION_AVERAGE,
        DML_REDUCE_FUNCTION_L1,
        DML_REDUCE_FUNCTION_L2,
        DML_REDUCE_FUNCTION_LOG_SUM,
        DML_REDUCE_FUNCTION_LOG_SUM_EXP,
        DML_REDUCE_FUNCTION_MAX,
        DML_REDUCE_FUNCTION_MIN,
        DML_REDUCE_FUNCTION_MULTIPLY,
        DML_REDUCE_FUNCTION_SUM,
        DML_REDUCE_FUNCTION_SUM_SQUARE);

    TDML_MATRIX_TRANSFORM = (
        DML_MATRIX_TRANSFORM_NONE,
        DML_MATRIX_TRANSFORM_TRANSPOSE);

    TDML_CONVOLUTION_MODE = (
        DML_CONVOLUTION_MODE_CONVOLUTION,
        DML_CONVOLUTION_MODE_CROSS_CORRELATION);

    TDML_CONVOLUTION_DIRECTION = (
        DML_CONVOLUTION_DIRECTION_FORWARD,
        DML_CONVOLUTION_DIRECTION_BACKWARD);

    TDML_PADDING_MODE = (
        DML_PADDING_MODE_CONSTANT,
        DML_PADDING_MODE_EDGE,
        DML_PADDING_MODE_REFLECTION);

    TDML_INTERPOLATION_MODE = (
        DML_INTERPOLATION_MODE_NEAREST_NEIGHBOR,
        DML_INTERPOLATION_MODE_LINEAR);


    TDML_SCALE_BIAS = record
        Scale: single;
        Bias: single;
    end;

    PDML_SCALE_BIAS = ^TDML_SCALE_BIAS;

    TDML_SIZE_2D = record
        Width: UINT;
        Height: UINT;
    end;

    PDML_SIZE_2D = ^TDML_SIZE_2D;

    TDML_RECURRENT_NETWORK_DIRECTION = (
        DML_RECURRENT_NETWORK_DIRECTION_FORWARD,
        DML_RECURRENT_NETWORK_DIRECTION_BACKWARD,
        DML_RECURRENT_NETWORK_DIRECTION_BIDIRECTIONAL);




    // ===================================================================================================================
    //   Operator descriptions
    // ===================================================================================================================

    TDML_OPERATOR_DESC = record
        _Type: TDML_OPERATOR_TYPE;
        Desc: Pointer;
    end;

    PDML_OPERATOR_DESC = ^TDML_OPERATOR_DESC;

    TDML_ELEMENT_WISE_IDENTITY_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    PDML_ELEMENT_WISE_IDENTITY_OPERATOR_DESC = ^TDML_ELEMENT_WISE_IDENTITY_OPERATOR_DESC;

    TDML_ELEMENT_WISE_ABS_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    PDML_ELEMENT_WISE_ABS_OPERATOR_DESC = ^TDML_ELEMENT_WISE_ABS_OPERATOR_DESC;

    TDML_ELEMENT_WISE_ACOS_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    PDML_ELEMENT_WISE_ACOS_OPERATOR_DESC = ^TDML_ELEMENT_WISE_ACOS_OPERATOR_DESC;

    TDML_ELEMENT_WISE_ADD_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    PDML_ELEMENT_WISE_ADD_OPERATOR_DESC = ^TDML_ELEMENT_WISE_ADD_OPERATOR_DESC;

    TDML_ELEMENT_WISE_ADD1_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        FusedActivation: PDML_OPERATOR_DESC;
    end;

    PDML_ELEMENT_WISE_ADD1_OPERATOR_DESC = ^TDML_ELEMENT_WISE_ADD1_OPERATOR_DESC;

    TDML_ELEMENT_WISE_ASIN_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    PDML_ELEMENT_WISE_ASIN_OPERATOR_DESC = ^TDML_ELEMENT_WISE_ASIN_OPERATOR_DESC;

    TDML_ELEMENT_WISE_ATAN_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    PDML_ELEMENT_WISE_ATAN_OPERATOR_DESC = ^TDML_ELEMENT_WISE_ATAN_OPERATOR_DESC;

    TDML_ELEMENT_WISE_CEIL_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    PDML_ELEMENT_WISE_CEIL_OPERATOR_DESC = ^TDML_ELEMENT_WISE_CEIL_OPERATOR_DESC;




    TDML_ELEMENT_WISE_CLIP_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
        Min: single;
        Max: single;
    end;

    TDML_ELEMENT_WISE_COS_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_DIVIDE_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_EXP_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_FLOOR_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_LOG_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_LOGICAL_AND_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_LOGICAL_EQUALS_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_LOGICAL_GREATER_THAN_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_LOGICAL_LESS_THAN_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_LOGICAL_NOT_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_LOGICAL_OR_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_LOGICAL_XOR_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_MAX_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_MEAN_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_MIN_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_MULTIPLY_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;




    TDML_ELEMENT_WISE_POW_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        ExponentTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_CONSTANT_POW_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
        Exponent: single;
    end;

    TDML_ELEMENT_WISE_RECIP_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_SIN_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_SQRT_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_SUBTRACT_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_TAN_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_THRESHOLD_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
        Min: single;
    end;



    TDML_ELEMENT_WISE_QUANTIZE_LINEAR_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        ScaleTensor: PDML_TENSOR_DESC;
        ZeroPointTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_DEQUANTIZE_LINEAR_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        ScaleTensor: PDML_TENSOR_DESC;
        ZeroPointTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ACTIVATION_ELU_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Alpha: single;
    end;

    TDML_ACTIVATION_HARDMAX_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ACTIVATION_HARD_SIGMOID_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Alpha: single;
        Beta: single;
    end;

    TDML_ACTIVATION_IDENTITY_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ACTIVATION_LEAKY_RELU_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Alpha: single;
    end;

    TDML_ACTIVATION_LINEAR_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Alpha: single;
        Beta: single;
    end;

    TDML_ACTIVATION_LOG_SOFTMAX_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ACTIVATION_PARAMETERIZED_RELU_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        SlopeTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ACTIVATION_PARAMETRIC_SOFTPLUS_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Alpha: single;
        Beta: single;
    end;

    TDML_ACTIVATION_RELU_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ACTIVATION_SCALED_ELU_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Alpha: single;
        Gamma: single;
    end;

    TDML_ACTIVATION_SCALED_TANH_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Alpha: single;
        Beta: single;
    end;

    TDML_ACTIVATION_SIGMOID_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ACTIVATION_SOFTMAX_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ACTIVATION_SOFTPLUS_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Steepness: single;
    end;

    TDML_ACTIVATION_SOFTSIGN_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ACTIVATION_TANH_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ACTIVATION_THRESHOLDED_RELU_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Alpha: single;
    end;

    TDML_CONVOLUTION_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        FilterTensor: PDML_TENSOR_DESC;
        BiasTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Mode: TDML_CONVOLUTION_MODE;
        Direction: TDML_CONVOLUTION_DIRECTION;
        DimensionCount: UINT;
        Strides {DimensionCount}: PUINT;
        Dilations {DimensionCount}: PUINT;
        StartPadding {DimensionCount}: PUINT;
        EndPadding {DimensionCount}: PUINT;
        OutputPadding {DimensionCount}: PUINT;
        GroupCount: UINT;
        FusedActivation: PDML_OPERATOR_DESC;
    end;

    TDML_GEMM_OPERATOR_DESC = record
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        CTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        TransA: TDML_MATRIX_TRANSFORM;
        TransB: TDML_MATRIX_TRANSFORM;
        Alpha: single;
        Beta: single;
        FusedActivation: PDML_OPERATOR_DESC;
    end;

    TDML_REDUCE_OPERATOR_DESC = record
        _Function: TDML_REDUCE_FUNCTION;
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        AxisCount: UINT;
        Axes {AxisCount}: PUINT;
    end;

    TDML_AVERAGE_POOLING_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        DimensionCount: UINT;
        Strides {DimensionCount}: PUINT;
        WindowSize {DimensionCount}: PUINT;
        StartPadding {DimensionCount}: PUINT;
        EndPadding {DimensionCount}: PUINT;
        IncludePadding: boolean;
    end;

    TDML_LP_POOLING_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        DimensionCount: UINT;
        Strides {DimensionCount}: PUINT;
        WindowSize {DimensionCount}: PUINT;
        StartPadding {DimensionCount}: PUINT;
        EndPadding {DimensionCount}: PUINT;
        P: UINT;
    end;

    TDML_MAX_POOLING_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        DimensionCount: UINT;
        Strides {DimensionCount}: PUINT;
        WindowSize {DimensionCount}: PUINT;
        StartPadding {DimensionCount}: PUINT;
        EndPadding {DimensionCount}: PUINT;
    end;

    TDML_MAX_POOLING1_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        OutputIndicesTensor: PDML_TENSOR_DESC;
        DimensionCount: UINT;
        Strides {DimensionCount}: PUINT;
        WindowSize {DimensionCount}: PUINT;
        StartPadding {DimensionCount}: PUINT;
        EndPadding {DimensionCount}: PUINT;
    end;

    TDML_ROI_POOLING_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        ROITensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        SpatialScale: single;
        PooledSize: TDML_SIZE_2D;
    end;



    TDML_SLICE_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        DimensionCount: UINT;
        Offsets {DimensionCount}: PUINT;
        Sizes {DimensionCount}: PUINT;
        Strides {DimensionCount}: PUINT;
    end;

    TDML_CAST_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_SPLIT_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputCount: UINT;
        OutputTensors {OutputCount}: PDML_TENSOR_DESC;
        Axis: UINT;
    end;

    TDML_JOIN_OPERATOR_DESC = record
        InputCount: UINT;
        InputTensors {InputCount}: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Axis: UINT;
    end;

    TDML_PADDING_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        PaddingMode: TDML_PADDING_MODE;
        PaddingValue: single;
        DimensionCount: UINT;
        StartPadding {DimensionCount}: PUINT;
        EndPadding {DimensionCount}: PUINT;
    end;

    TDML_VALUE_SCALE_2D_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Scale: single;
        ChannelCount: UINT;
        Bias {ChannelCount}: PSingle;
    end;

    TDML_UPSAMPLE_2D_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleSize: TDML_SIZE_2D;
        InterpolationMode: TDML_INTERPOLATION_MODE;
    end;




    TDML_GATHER_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        IndicesTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Axis: UINT;
        IndexDimensions: UINT;
    end;

    TDML_SPACE_TO_DEPTH_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        BlockSize: UINT;
    end;

    TDML_DEPTH_TO_SPACE_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        BlockSize: UINT;
    end;

    TDML_TILE_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        RepeatsCount: UINT;
        Repeats {RepeatsCount}: PUINT;
    end;

    TDML_TOP_K_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputValueTensor: PDML_TENSOR_DESC;
        OutputIndexTensor: PDML_TENSOR_DESC;
        Axis: UINT;
        K: UINT;
    end;




    TDML_BATCH_NORMALIZATION_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        MeanTensor: PDML_TENSOR_DESC;
        VarianceTensor: PDML_TENSOR_DESC;
        ScaleTensor: PDML_TENSOR_DESC;
        BiasTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Spatial: boolean;
        Epsilon: single;
        FusedActivation: PDML_OPERATOR_DESC;
    end;

    TDML_MEAN_VARIANCE_NORMALIZATION_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        ScaleTensor: PDML_TENSOR_DESC;
        BiasTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        CrossChannel: boolean;
        NormalizeVariance: boolean;
        Epsilon: single;
        FusedActivation: PDML_OPERATOR_DESC;
    end;

    TDML_LOCAL_RESPONSE_NORMALIZATION_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        CrossChannel: boolean;
        LocalSize: UINT;
        Alpha: single;
        Beta: single;
        Bias: single;
    end;




    TDML_LP_NORMALIZATION_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Axis: UINT;
        Epsilon: single;
        P: UINT;
    end;

    TDML_RNN_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        WeightTensor: PDML_TENSOR_DESC;
        RecurrenceTensor: PDML_TENSOR_DESC;
        BiasTensor: PDML_TENSOR_DESC;
        HiddenInitTensor: PDML_TENSOR_DESC;
        SequenceLengthsTensor: PDML_TENSOR_DESC;
        OutputSequenceTensor: PDML_TENSOR_DESC;
        OutputSingleTensor: PDML_TENSOR_DESC;
        ActivationDescCount: UINT;
        ActivationDescs {ActivationDescCount}: PDML_OPERATOR_DESC;
        Direction: TDML_RECURRENT_NETWORK_DIRECTION;
    end;

    TDML_LSTM_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        WeightTensor: PDML_TENSOR_DESC;
        RecurrenceTensor: PDML_TENSOR_DESC;
        BiasTensor: PDML_TENSOR_DESC;
        HiddenInitTensor: PDML_TENSOR_DESC;
        CellMemInitTensor: PDML_TENSOR_DESC;
        SequenceLengthsTensor: PDML_TENSOR_DESC;
        PeepholeTensor: PDML_TENSOR_DESC;
        OutputSequenceTensor: PDML_TENSOR_DESC;
        OutputSingleTensor: PDML_TENSOR_DESC;
        OutputCellSingleTensor: PDML_TENSOR_DESC;
        ActivationDescCount: UINT;
        ActivationDescs {ActivationDescCount}: PDML_OPERATOR_DESC;
        Direction: TDML_RECURRENT_NETWORK_DIRECTION;
        ClipThreshold: single;
        UseClipThreshold: boolean;
        CoupleInputForget: boolean;
    end;

    TDML_GRU_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        WeightTensor: PDML_TENSOR_DESC;
        RecurrenceTensor: PDML_TENSOR_DESC;
        BiasTensor: PDML_TENSOR_DESC;
        HiddenInitTensor: PDML_TENSOR_DESC;
        SequenceLengthsTensor: PDML_TENSOR_DESC;
        OutputSequenceTensor: PDML_TENSOR_DESC;
        OutputSingleTensor: PDML_TENSOR_DESC;
        ActivationDescCount: UINT;
        ActivationDescs {ActivationDescCount}: PDML_OPERATOR_DESC;
        Direction: TDML_RECURRENT_NETWORK_DIRECTION;
        LinearBeforeReset: boolean;
    end;

    //#if NTDDI_VERSION >= NTDDI_WIN10_VB

    TDML_ELEMENT_WISE_SIGN_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_IS_NAN_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ELEMENT_WISE_ERF_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_SINH_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_COSH_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_TANH_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_ASINH_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_ACOSH_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_ATANH_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        ScaleBias: PDML_SCALE_BIAS;
    end;

    TDML_ELEMENT_WISE_IF_OPERATOR_DESC = record
        ConditionTensor: PDML_TENSOR_DESC;
        ATensor: PDML_TENSOR_DESC;
        BTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_ACTIVATION_SHRINK_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Bias: single;
        Threshold: single;
    end;

    TDML_MAX_UNPOOLING_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        IndicesTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
    end;

    TDML_DIAGONAL_MATRIX_OPERATOR_DESC = record
        OutputTensor: PDML_TENSOR_DESC;
        Offset: INT32;
        Value: single;
    end;




    TDML_SCATTER_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        IndicesTensor: PDML_TENSOR_DESC;
        UpdatesTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Axis: UINT;
    end;

    TDML_ONE_HOT_OPERATOR_DESC = record
        IndicesTensor: PDML_TENSOR_DESC;
        ValuesTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        Axis: UINT;
    end;

    TDML_RESAMPLE_OPERATOR_DESC = record
        InputTensor: PDML_TENSOR_DESC;
        OutputTensor: PDML_TENSOR_DESC;
        InterpolationMode: TDML_INTERPOLATION_MODE;
        ScaleCount: UINT;
        Scales {ScaleCount}: PSingle;
    end;

    //#endif // NTDDI_VERSION >= NTDDI_WIN10_VB

    // ===================================================================================================================
    //   DML feature support queries
    // ===================================================================================================================

    //#if NTDDI_VERSION >= NTDDI_WIN10_VB

    TDML_FEATURE_LEVEL = (
        DML_FEATURE_LEVEL_1_0 = $1000,
        DML_FEATURE_LEVEL_2_0 = $2000);

    PDML_FEATURE_LEVEL = ^TDML_FEATURE_LEVEL;

    //#endif // NTDDI_VERSION >= NTDDI_WIN10_VB

    TDML_FEATURE = (
        DML_FEATURE_TENSOR_DATA_TYPE_SUPPORT,

        //#if NTDDI_VERSION >= NTDDI_WIN10_VB
        DML_FEATURE_FEATURE_LEVELS
        //#endif // NTDDI_VERSION >= NTDDI_WIN10_VB
        );

    TDML_FEATURE_QUERY_TENSOR_DATA_TYPE_SUPPORT = record
        DataType: TDML_TENSOR_DATA_TYPE;
    end;

    TDML_FEATURE_DATA_TENSOR_DATA_TYPE_SUPPORT = record
        IsSupported: boolean;
    end;




    //#if NTDDI_VERSION >= NTDDI_WIN10_VB

    TDML_FEATURE_QUERY_FEATURE_LEVELS = record
        RequestedFeatureLevelCount: UINT;
        RequestedFeatureLevels {RequestedFeatureLevelCount}: PDML_FEATURE_LEVEL;
    end;

    TDML_FEATURE_DATA_FEATURE_LEVELS = record
        MaxSupportedFeatureLevel: TDML_FEATURE_LEVEL;
    end;

    //#endif // NTDDI_VERSION >= NTDDI_WIN10_VB

    // ===================================================================================================================
    //   DML device functions, enumerations, and structures
    // ===================================================================================================================

    TDML_BINDING_TABLE_DESC = record
        Dispatchable: IDMLDispatchable;
        CPUDescriptorHandle: TD3D12_CPU_DESCRIPTOR_HANDLE;
        GPUDescriptorHandle: TD3D12_GPU_DESCRIPTOR_HANDLE;
        SizeInDescriptors: UINT;
    end;

    PDML_BINDING_TABLE_DESC = ^TDML_BINDING_TABLE_DESC;

    TDML_EXECUTION_FLAGS = (
        DML_EXECUTION_FLAG_NONE = 0,
        DML_EXECUTION_FLAG_ALLOW_HALF_PRECISION_COMPUTATION = $1,
        DML_EXECUTION_FLAG_DISABLE_META_COMMANDS = $2,
        DML_EXECUTION_FLAG_DESCRIPTORS_VOLATILE = $4);



    TDML_CREATE_DEVICE_FLAGS = (
        DML_CREATE_DEVICE_FLAG_NONE = 0,
        DML_CREATE_DEVICE_FLAG_DEBUG = $1);



    // ===================================================================================================================
    //   Interface declarations
    // ===================================================================================================================

    // ===================================================================================================================
    //   DML object
    // ===================================================================================================================



    IDMLObject = interface(IUnknown)
        ['{c8263aac-9e0c-4a2d-9b8e-007521a3317c}']
        function GetPrivateData(const guid: TGUID; var dataSize: UINT; out Data {dataSize}: Pointer): HResult; stdcall;

        function SetPrivateData(const guid: TGUID; dataSize: UINT; const Data {dataSize}: Pointer): HResult; stdcall;

        function SetPrivateDataInterface(const guid: TGUID; Data: IUnknown): HResult; stdcall;

        function SetName(Name: PCWSTR): HResult; stdcall;
    end;

    // ===================================================================================================================
    //   DML device
    // ===================================================================================================================


    IDMLDevice = interface(IDMLObject)
        ['{6dbd6437-96fd-423f-a98c-ae5e7c2a573f}']
        function CheckFeatureSupport(feature: TDML_FEATURE; featureQueryDataSize: UINT;
            const featureQueryData {featureQueryDataSize}: PByte; featureSupportDataSize: UINT;
            out featureSupportData {featureSupportDataSize}: PByte): HResult; stdcall;

        function CreateOperator(const desc: TDML_OPERATOR_DESC; const riid: TGUID; // expected: IDMLOperator
            out ppv): HResult; stdcall;

        function CompileOperator(op: IDMLOperator; flags: TDML_EXECUTION_FLAGS; const riid: TGUID;
        // expected: IDMLCompiledOperator
            out ppv): HResult; stdcall;

        function CreateOperatorInitializer(operatorCount: UINT; const operators {operatorCount}: PIDMLCompiledOperator;
            const riid: TGUID; // expected: IDMLOperatorInitializer
            out ppv): HResult; stdcall;

        function CreateCommandRecorder(const riid: TGUID; // expected: IDMLCommandRecorder
            out ppv): HResult; stdcall;

        function CreateBindingTable(const desc: PDML_BINDING_TABLE_DESC; const riid: TGUID; // expected: IDMLBindingTable
            out ppv): HResult; stdcall;

        function Evict(Count: UINT; const ppObjects {count}: PIDMLPageable): HResult; stdcall;

        function MakeResident(Count: UINT; const ppObjects {count}: PIDMLPageable): HResult; stdcall;

        function GetDeviceRemovedReason(): HResult; stdcall;

        function GetParentDevice(const riid: TGUID; out ppv): HResult; stdcall;
    end;


    // ===================================================================================================================
    //   DML device children
    // ===================================================================================================================



    IDMLDeviceChild = interface(IDMLObject)
        ['{27e83142-8165-49e3-974e-2fd66e4cb69d}']
        function GetDevice(const riid: TGUID; // expected: IDMLDevice
            out ppv): HResult; stdcall;
    end;


    IDMLPageable = interface(IDMLDeviceChild)
        ['{b1ab0825-4542-4a4b-8617-6dde6e8f6201}']
    end;


    // ===================================================================================================================
    //   DML operator
    // ===================================================================================================================


    IDMLOperator = interface(IDMLDeviceChild)
        ['{26caae7a-3081-4633-9581-226fbe57695d}']
    end;


    // ===================================================================================================================
    //   DML dispatchable
    // ===================================================================================================================

    TDML_BINDING_PROPERTIES = record
        RequiredDescriptorCount: UINT;
        TemporaryResourceSize: UINT64;
        PersistentResourceSize: UINT64;
    end;


    IDMLDispatchable = interface(IDMLPageable)
        ['{dcb821a8-1039-441e-9f1c-b1759c2f3cec}']
        function GetBindingProperties(): TDML_BINDING_PROPERTIES; stdcall;
    end;


    // ===================================================================================================================
    //   DML compiled operator
    // ===================================================================================================================



    IDMLCompiledOperator = interface(IDMLDispatchable)
        ['{6b15e56a-bf5c-4902-92d8-da3a650afea4}']
    end;


    // ===================================================================================================================
    //   DML operator initializer
    // ===================================================================================================================



    IDMLOperatorInitializer = interface(IDMLDispatchable)
        ['{427c1113-435c-469c-8676-4d5dd072f813}']
        function Reset(operatorCount: UINT; const operators {operatorCount}: PIDMLCompiledOperator): HResult; stdcall;
    end;

    // ===================================================================================================================
    //   DML binding table
    // ===================================================================================================================

    TDML_BINDING_TYPE = (
        DML_BINDING_TYPE_NONE,
        DML_BINDING_TYPE_BUFFER,
        DML_BINDING_TYPE_BUFFER_ARRAY);

    TDML_BINDING_DESC = record
        _Type: TDML_BINDING_TYPE;
        Desc: Pointer;
    end;

    PDML_BINDING_DESC = ^TDML_BINDING_DESC;

    TDML_BUFFER_BINDING = record
        Buffer: ID3D12Resource;
        Offset: UINT64;
        SizeInBytes: UINT64;
    end;

    PDML_BUFFER_BINDING = ^TDML_BUFFER_BINDING;

    TDML_BUFFER_ARRAY_BINDING = record
        BindingCount: UINT;
        Bindings {BindingCount}: PDML_BUFFER_BINDING;
    end;


    IDMLBindingTable = interface(IDMLDeviceChild)
        ['{29c687dc-de74-4e3b-ab00-1168f2fc3cfc}']
        procedure BindInputs(bindingCount: UINT; const bindings {bindingCount}: PDML_BINDING_DESC); stdcall;

        procedure BindOutputs(bindingCount: UINT; const bindings {bindingCount}: PDML_BINDING_DESC); stdcall;

        procedure BindTemporaryResource(const binding: TDML_BINDING_DESC); stdcall;

        procedure BindPersistentResource(const binding: TDML_BINDING_DESC); stdcall;

        function Reset(const desc: TDML_BINDING_TABLE_DESC): HResult; stdcall;
    end;


    // ===================================================================================================================
    //   DML command recorder
    // ===================================================================================================================



    IDMLCommandRecorder = interface(IDMLDeviceChild)
        ['{e6857a76-2e3e-4fdd-bff4-5d2ba10fb453}']
        procedure RecordDispatch(commandList: ID3D12CommandList; dispatchable: IDMLDispatchable; bindings: IDMLBindingTable); stdcall;
    end;


    // ===================================================================================================================
    //   DML debug
    // ===================================================================================================================



    IDMLDebugDevice = interface(IUnknown)
        ['{7d6f3ac9-394a-4ac3-92a7-390cc57a8217}']
        procedure SetMuteDebugOutput(mute: boolean); stdcall;
    end;




function DMLCreateDevice(d3d12Device: ID3D12Device; flags: TDML_CREATE_DEVICE_FLAGS; const riid: TGUID; // Expected: IDMLDevice
    out ppv): HResult; stdcall; external DLLName;

//#if NTDDI_VERSION >= NTDDI_WIN10_VB

function DMLCreateDevice1(d3d12Device: ID3D12Device; flags: TDML_CREATE_DEVICE_FLAGS; minimumFeatureLevel: TDML_FEATURE_LEVEL;
    const riid: TGUID; // Expected: IDMLDevice
    out ppv): HResult; stdcall; external DLLName;

//#endif // NTDDI_VERSION >= NTDDI_WIN10_VB

implementation

end.
