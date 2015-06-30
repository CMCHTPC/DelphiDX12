unit DX12.DXProgrammableCapture;


// Applications use this interface to denote the beginning and ending of a 
// "frame" of captured DXGI/D3D10+ commands for examination within a debugging 
// tool such as Visual Studio 2013. Absent such calls, a frame is defined by 
// Visual Studio as beginning and ending with the IDXGISwapChain*::Present* calls.

//  To retrieve a pointer to this interface, call 

//     ComPtr<IDXGraphicsAnalysis> graphicsAnalysis;
//     DXGIGetDebugInterface1(0, IID_PPV_ARGS(&graphicsAnalysis));

// The function will only succeed when the application is being run under 
// "graphics analysis" in Visual Studio (or other similar tools), so applications
// must be sure to handle failure from DXGIGetDebugInterface1 gracefully.

// Further note that DXGIGetDebugInterface1 is tagged as a development-only capability,
// which implies that linking to this function will cause the application to fail
// Windows store certification. Consequently, it is recommended that usage of that
// function be compiled only for pre-release code.

interface

uses Windows, Classes;

const
    IID_IDXGraphicsAnalysis: TGUID = '{9f251514-9d4d-4902-9d60-18988ab7d4b5}';

type
    IDXGraphicsAnalysis = interface(IUnknown)
        ['{9f251514-9d4d-4902-9d60-18988ab7d4b5}']
        procedure BeginCapture; stdcall;
        procedure EndCapture; stdcall;
    end;

implementation

end.
