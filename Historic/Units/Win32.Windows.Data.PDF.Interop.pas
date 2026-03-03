unit Win32.Windows.Data.PDF.Interop;


interface

uses
    Windows, Classes, SysUtils, ActiveX,
    DX12.DXGI, DX12.D2D1,
    DX12.D2D1_1,
    DX12.D2DBaseTypes,
    DX12.DCommon;

const
    IID_IPdfRendererNative: TGUID = '{7d9dcd91-d277-4947-8527-07a0daeda94a}';

type

    (* Forward Declarations *)

    IPdfRendererNative = interface;

    TPDF_RENDER_PARAMS = record

        SourceRect: TD2D_RECT_F;
        DestinationWidth: uint32;
        DestinationHeight: uint32;
        BackgroundColor: TD2D_COLOR_F;
        IgnoreHighContrast: boolean;
    end;
    PPDF_RENDER_PARAMS = ^TPDF_RENDER_PARAMS;


    PFN_PDF_CREATE_RENDERER = function(pDevice: IDXGIDevice; out ppRenderer: IPdfRendererNative): HRESULT; stdcall;




const
    sc_PdfRenderParamsDefaultSrcRect: TD2D_RECT_F = (left: 0.0; top: 0.0; right: 0.0; bottom: 0.0);
    sc_PdfRenderParamsDefaultBkColor: TD2D_COLOR_F = (r:1.0; g: 1.0; b: 1.0; a: 1.0);




type
    IPdfRendererNative = interface(IUnknown)
        ['{7d9dcd91-d277-4947-8527-07a0daeda94a}']
        function RenderPageToSurface(pdfPage: IUnknown; pSurface: IDXGISurface; offset: TPOINT; pRenderParams: PPDF_RENDER_PARAMS): HRESULT; stdcall;
        function RenderPageToDeviceContext(pdfPage: IUnknown; pD2DDeviceContext: ID2D1DeviceContext; pRenderParams: PPDF_RENDER_PARAMS): HRESULT; stdcall;
    end;

{function PdfRenderParams(srcRect: PD2D1_RECT_F = @sc_PdfRenderParamsDefaultSrcRect; destinationWidth: uint32 = 0; destinationHeight: uint32 = 0; const bkColor: PD2D_COLOR_F = @sc_PdfRenderParamsDefaultBkColor;
    ignoreHighContrast: boolean = True): TPDF_RENDER_PARAMS; inline;   }

function PdfCreateRenderer(pDevice: IDXGIDevice; out ppRenderer: IPdfRendererNative): HRESULT; stdcall; external 'Windows.Data.Pdf.dll';

implementation


(*
function PdfRenderParams(const srcRect: TD2D_RECT_F = sc_PdfRenderParamsDefaultSrcRect; destinationWidth: uint32 = 0; destinationHeight: uint32 = 0; const bkColor: TD2D_COLOR_F = sc_PdfRenderParamsDefaultBkColor;
    ignoreHighContrast: boolean = True): TPDF_RENDER_PARAMS; inline;
begin
    Result.SourceRect := srcRect;
    Result.DestinationWidth := destinationWidth;
    Result.DestinationHeight := destinationHeight;
    Result.BackgroundColor := bkColor;
    Result.IgnoreHighContrast :=
    begin
    ;
end;    *)

end.
