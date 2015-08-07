//////////////////////////////////////////////////////////////////////////////

//  Copyright (c) Microsoft Corporation.  All rights reserved.

//  File:       D3DX11GPGPU.h
//  Content:    D3DX11 General Purpose GPU computing algorithms

//////////////////////////////////////////////////////////////////////////////

unit DX12.D3DCSX;

{$IFDEF FPC}
{$MODE delphi}{$H+}
{$ENDIF}

interface

{$Z4}
uses
    Windows, Classes, SysUtils,
    DX12.D3D11;

const
    D3DCSX_DLL = 'd3dcsx_47.dll';


    D3DX11_FFT_MAX_PRECOMPUTE_BUFFERS = 4;
    D3DX11_FFT_MAX_TEMP_BUFFERS = 4;
    D3DX11_FFT_MAX_DIMENSIONS = 32;


const
    IID_ID3DX11Scan: TGUID = '{5089b68f-e71d-4d38-be8e-f363b95a9405}';
    IID_ID3DX11SegmentedScan: TGUID = '{a915128c-d954-4c79-bfe1-64db923194d6}';
    IID_ID3DX11FFT: TGUID = '{b3f7a938-4c93-4310-a675-b30d6de50553}';



type
    TD3DX11_SCAN_DATA_TYPE = (
        D3DX11_SCAN_DATA_TYPE_FLOAT = 1,
        D3DX11_SCAN_DATA_TYPE_INT,
        D3DX11_SCAN_DATA_TYPE_UINT);

    TD3DX11_SCAN_OPCODE = (
        D3DX11_SCAN_OPCODE_ADD = 1,
        D3DX11_SCAN_OPCODE_MIN,
        D3DX11_SCAN_OPCODE_MAX,
        D3DX11_SCAN_OPCODE_MUL,
        D3DX11_SCAN_OPCODE_AND,
        D3DX11_SCAN_OPCODE_OR,
        D3DX11_SCAN_OPCODE_XOR);

    TD3DX11_SCAN_DIRECTION = (
        D3DX11_SCAN_DIRECTION_FORWARD = 1,
        D3DX11_SCAN_DIRECTION_BACKWARD);




    ID3DX11Scan = interface(IUnknown)
        ['{5089b68f-e71d-4d38-be8e-f363b95a9405}']

        function SetScanDirection(Direction: TD3DX11_SCAN_DIRECTION): HResult; stdcall;

        //=============================================================================
        // Performs an unsegmented scan of a sequence in-place or out-of-place
        //  ElementType         element type
        //  OpCode              binary operation
        //  Direction           scan direction
        //  ElementScanSize     size of scan, in elements
        //  pSrc                input sequence on the device. pSrc==pDst for in-place scans
        //  pDst                output sequence on the device
        //=============================================================================
        function Scan(ElementType: TD3DX11_SCAN_DATA_TYPE; OpCode: TD3DX11_SCAN_OPCODE; ElementScanSize: UINT;
            pSrc: ID3D11UnorderedAccessView; pDst: ID3D11UnorderedAccessView): HResult; stdcall;

        //=============================================================================
        // Performs a multiscan of a sequence in-place or out-of-place
        //  ElementType         element type
        //  OpCode              binary operation
        //  Direction           scan direction
        //  ElementScanSize     size of scan, in elements
        //  ElementScanPitch    pitch of the next scan, in elements
        //  ScanCount           number of scans in a multiscan
        //  pSrc                input sequence on the device. pSrc==pDst for in-place scans
        //  pDst                output sequence on the device
        //=============================================================================
        function Multiscan(ElementType: TD3DX11_SCAN_DATA_TYPE; OpCode: TD3DX11_SCAN_OPCODE; ElementScanSize: UINT;
            ElementScanPitch: UINT; ScanCount: UINT; pSrc: ID3D11UnorderedAccessView; pDst: ID3D11UnorderedAccessView): HResult; stdcall;
    end;




    ID3DX11SegmentedScan = interface(IUnknown)
        ['{a915128c-d954-4c79-bfe1-64db923194d6}']
        function SetScanDirection(Direction: TD3DX11_SCAN_DIRECTION): HResult; stdcall;

        //=============================================================================
        // Performs a segscan of a sequence in-place or out-of-place
        //  ElementType         element type
        //  OpCode              binary operation
        //  Direction           scan direction
        //  pSrcElementFlags    compact array of bits, one per element of pSrc.  A set value
        //                      indicates the start of a new segment.
        //  ElementScanSize     size of scan, in elements
        //  pSrc                input sequence on the device. pSrc==pDst for in-place scans
        //  pDst                output sequence on the device
        //=============================================================================
        function SegScan(ElementType: TD3DX11_SCAN_DATA_TYPE; OpCode: TD3DX11_SCAN_OPCODE; ElementScanSize: UINT;
            pSrc: ID3D11UnorderedAccessView; pSrcElementFlags: ID3D11UnorderedAccessView;
            pDst: ID3D11UnorderedAccessView): HResult; stdcall;
    end;




    ID3DX11FFT = interface(IUnknown)
        ['{b3f7a938-4c93-4310-a675-b30d6de50553}']
        // scale for forward transform (defaults to 1 if set to 0)
        function SetForwardScale(ForwardScale: single): HResult; stdcall;
        function GetForwardScale(): single; stdcall;

        // scale for inverse transform (defaults to 1/N if set to 0, where N is
        // the product of the transformed dimension lengths
        function SetInverseScale(InverseScale: single): HResult; stdcall;
        function GetInverseScale(): single; stdcall;

        //------------------------------------------------------------------------------
        // Attaches buffers to the context and performs any required precomputation.
        // The buffers must be no smaller than the corresponding buffer sizes returned
        // by D3DX11CreateFFT*(). Temp buffers may beshared between multiple contexts,
        // though care should be taken to concurrently execute multiple FFTs which share
        // temp buffers.

        // NumTempBuffers               number of buffers in ppTempBuffers
        // ppTempBuffers                temp buffers to attach
        // NumPrecomputeBuffers         number of buffers in ppPrecomputeBufferSizes
        // ppPrecomputeBufferSizes      buffers to hold precomputed data
        function AttachBuffersAndPrecompute(NumTempBuffers: UINT; ppTempBuffers: PID3D11UnorderedAccessView;
            NumPrecomputeBuffers: UINT; ppPrecomputeBufferSizes: PID3D11UnorderedAccessView): HResult; stdcall;

        //------------------------------------------------------------------------------
        // Call after buffers have been attached to the context, pInput and *ppOuput can
        // be one of the temp buffers.  If *ppOutput == NULL, then the computation will ping-pong
        // between temp buffers and the last buffer written to is stored at *ppOutput.
        // Otherwise, *ppOutput is used as the output buffer (which may incur an extra copy).

        // The format of complex data is interleaved components, e.g. (Real0, Imag0),
        // (Real1, Imag1) ... etc. Data is stored in row major order

        // pInputBuffer         view onto input buffer
        // ppOutpuBuffert       pointer to view of output buffer
        function ForwardTransform(pInputBuffer: ID3D11UnorderedAccessView; var ppOutputBuffer: ID3D11UnorderedAccessView): HResult;
            stdcall;

        function InverseTransform(pInputBuffer: ID3D11UnorderedAccessView; var ppOutputBuffer: ID3D11UnorderedAccessView): HResult;
            stdcall;
    end;


    //////////////////////////////////////////////////////////////////////////////
    // ID3DX11FFT Creation Routines
    //////////////////////////////////////////////////////////////////////////////

    TD3DX11_FFT_DATA_TYPE = (
        D3DX11_FFT_DATA_TYPE_REAL,
        D3DX11_FFT_DATA_TYPE_COMPLEX);

    TD3DX11_FFT_DIM_MASK = (
        D3DX11_FFT_DIM_MASK_1D = $1,
        D3DX11_FFT_DIM_MASK_2D = $3,
        D3DX11_FFT_DIM_MASK_3D = $7);

    TD3DX11_FFT_DESC = record
        NumDimensions: UINT;                             // number of dimensions
        ElementLengths: array[0..D3DX11_FFT_MAX_DIMENSIONS - 1] of UINT; // length of each dimension
        DimensionMask: UINT;                             // a bit set for each dimensions to transform
        //     (see D3DX11_FFT_DIM_MASK for common masks)
        _Type: TD3DX11_FFT_DATA_TYPE;                      // type of the elements in spatial domain
    end;
    PD3DX11_FFT_DESC = ^TD3DX11_FFT_DESC;


    //------------------------------------------------------------------------------
    // NumTempBufferSizes           Number of temporary buffers needed
    // pTempBufferSizes             Minimum sizes (in FLOATs) of temporary buffers
    // NumPrecomputeBufferSizes     Number of precompute buffers needed
    // pPrecomputeBufferSizes       minimum sizes (in FLOATs) for precompute buffers
    //------------------------------------------------------------------------------

    TD3DX11_FFT_BUFFER_INFO = record
        NumTempBufferSizes: UINT;
        TempBufferFloatSizes: array[0..D3DX11_FFT_MAX_TEMP_BUFFERS - 1] of UINT;
        NumPrecomputeBufferSizes: UINT;
        PrecomputeBufferFloatSizes: array[0..D3DX11_FFT_MAX_PRECOMPUTE_BUFFERS - 1] of UINT;
    end;


    TD3DX11_FFT_CREATE_FLAG = (
        D3DX11_FFT_CREATE_FLAG_NO_PRECOMPUTE_BUFFERS = $01   // do not precompute values and store into buffers
        );



//=============================================================================
// Creates a scan context
//  pDevice             the device context
//  MaxElementScanSize  maximum single scan size, in elements (single , UINT, or INT)
//  MaxScanCount        maximum number of scans in multiscan
//  ppScanContext       new scan context
//=============================================================================
function D3DX11CreateScan(pDeviceContext: ID3D11DeviceContext; MaxElementScanSize: UINT; MaxScanCount: UINT;
    out ppScan: ID3DX11Scan): HResult; stdcall; external D3DCSX_DLL;


//=============================================================================
// Creates a segmented scan context
//  pDevice             the device context
//  MaxElementScanSize  maximum single scan size, in elements (single , UINT, or INT)
//  ppScanContext       new scan context
//=============================================================================
function D3DX11CreateSegmentedScan(pDeviceContext: ID3D11DeviceContext; MaxElementScanSize: UINT; out ppScan: ID3DX11SegmentedScan): HResult;
    stdcall; external D3DCSX_DLL;



//------------------------------------------------------------------------------
// Creates an ID3DX11FFT COM interface object and returns a pointer to it at *ppFFT.
// The descriptor describes the shape of the data as well as the scaling factors
// that should be used for forward and inverse transforms.
// The FFT computation may require temporaries that act as ping-pong buffers
// and for other purposes. aTempSizes is a list of the sizes required for
// temporaries. Likewise, some data may need to be precomputed and the sizes
// of those sizes are returned in aPrecomputedBufferSizes.

// To perform a computation, follow these steps:
// 1) Create the FFT context object
// 2) Precompute (and Attach temp working buffers of at least the required size)
// 3) Call Compute() on some input data

// Compute() may be called repeatedly with different inputs and transform
// directions. When finished with the FFT work, release the FFT interface()

// Device                     Direct3DDeviceContext to use                      in
// pDesc                      Descriptor for FFT transform                      in
// Count                      the number of 1D FFTs to perform                  in
// Flags                      See D3DX11_FFT_CREATE_FLAG                        in
// pBufferInfo                Pointer to BUFFER_INFO struct, filled by funciton out
// ppFFT                      Pointer to returned context pointer               out
//------------------------------------------------------------------------------

function D3DX11CreateFFT(pDeviceContext: ID3D11DeviceContext; const pDesc: TD3DX11_FFT_DESC; Flags: UINT;
    out pBufferInfo: TD3DX11_FFT_BUFFER_INFO; out ppFFT: ID3DX11FFT): HResult; stdcall; external D3DCSX_DLL;

function D3DX11CreateFFT1DReal(pDeviceContext: ID3D11DeviceContext; X: UINT; Flags: UINT; out pBufferInfo: TD3DX11_FFT_BUFFER_INFO;
    out ppFFT: ID3DX11FFT): HResult; stdcall; external D3DCSX_DLL;

function D3DX11CreateFFT1DComplex(pDeviceContext: ID3D11DeviceContext; X: UINT; Flags: UINT; out pBufferInfo: TD3DX11_FFT_BUFFER_INFO;
    out ppFFT: ID3DX11FFT): HResult; stdcall; external D3DCSX_DLL;

function D3DX11CreateFFT2DReal(pDeviceContext: ID3D11DeviceContext; X: UINT; Y: UINT; Flags: UINT;
    out pBufferInfo: TD3DX11_FFT_BUFFER_INFO; out ppFFT: ID3DX11FFT): HResult; stdcall; external D3DCSX_DLL;

function D3DX11CreateFFT2DComplex(pDeviceContext: ID3D11DeviceContext; X: UINT; Y: UINT; Flags: UINT;
    out pBufferInfo: TD3DX11_FFT_BUFFER_INFO; out ppFFT: ID3DX11FFT): HResult; stdcall; external D3DCSX_DLL;

function D3DX11CreateFFT3DReal(pDeviceContext: ID3D11DeviceContext; X: UINT; Y: UINT; Z: UINT; Flags: UINT;
    out pBufferInfo: TD3DX11_FFT_BUFFER_INFO; out ppFFT: ID3DX11FFT): HResult; stdcall; external D3DCSX_DLL;

function D3DX11CreateFFT3DComplex(pDeviceContext: ID3D11DeviceContext; X: UINT; Y: UINT; Z: UINT; Flags: UINT;
    out pBufferInfo: TD3DX11_FFT_BUFFER_INFO; out ppFFT: ID3DX11FFT): HResult;
    stdcall; external D3DCSX_DLL;


implementation

end.
