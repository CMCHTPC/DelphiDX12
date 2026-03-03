    {$DEFINE USESDK43}

    ///////////////////////////////////////////////////////////////////////////
    // D3DX_SDK_VERSION:
    // -----------------
    // This identifier is passed to D3DXCheckVersion in order to ensure that an
    // application was built against the correct header files and lib files.
    // This number is incremented whenever a header (or other) change would
    // require applications to be rebuilt. If the version doesn't match,
    // D3DXCreateVersion will return FALSE. (The number itself has no meaning.)
    ///////////////////////////////////////////////////////////////////////////
const
    {$IFNDEF USESDK43}
    D3DX_VERSION = $0900;
    D3DX_SDK_VERSION = 9;
    D3DX9_DLL = 'D3DX9.dll';
    {$ELSE}
    D3DX_VERSION = $0902;
    D3DX_SDK_VERSION = 43;
    D3DX9_DLL = 'D3DX9_43.dll';
    {$ENDIF}
