unit CMC.COMBaseAPI;

{$mode delphi}

interface

uses
    Windows, Classes, SysUtils, ActiveX;

{$Z8}
{$A8}
//include <pshpack8.h>

const
    OLE32_DLL = 'ole32.dll';


function PropVariantClear(var pvar: PROPVARIANT): HResult; stdcall; external OLE32_DLL;


implementation

end.




