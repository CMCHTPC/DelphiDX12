unit DX12.DCompAnimation;

interface

uses
    Windows, SysUtils, Classes;

const
    IID_IDCompositionAnimation: TGUID = '{CBFD91D9-51B2-45e4-B3DE-D19CCFB863C5}';

type

    { Forward Declarations }

    IDCompositionAnimation = interface(IUnknown)
        ['{CBFD91D9-51B2-45e4-B3DE-D19CCFB863C5}']
        function Reset(): HRESULT; stdcall;
        function SetAbsoluteBeginTime(beginTime: LARGE_INTEGER): HRESULT; stdcall;
        function AddCubic(beginOffset: double; constantCoefficient: single; linearCoefficient: single; quadraticCoefficient: single;
            cubicCoefficient: single): HRESULT; stdcall;
        function AddSinusoidal(beginOffset: double; bias: single; amplitude: single; frequency: single; phase: single): HRESULT; stdcall;
        function AddRepeat(beginOffset: double; durationToRepeat: double): HRESULT; stdcall;
        function _End(endOffset: double; endValue: single): HRESULT; stdcall;
    end;


implementation

end.

