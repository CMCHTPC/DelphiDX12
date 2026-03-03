unit DXSample;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DXSampleHelpers,
    DX12.DXGI,
    DX12.DXGI1_2,
    DX12.DXGI1_4;

type

    { TDXSample }

    TDXSample = class(TObject)
    protected
        // Root assets path.
        m_assetsPath: widestring;

        // Window title.
        m_title: widestring;

        // Viewport dimensions.
        m_width: UINT;
        m_height: UINT;
        m_aspectRatio: single;

        // Adapter info.
        m_useWarpDevice: winbool;

        function GetAssetFullPath(assetName: LPCWSTR): widestring;
        procedure GetHardwareAdapter({_In_ } pFactory: IDXGIFactory1; {_Outptr_result_maybenull_ }  out ppAdapter: IDXGIAdapter1; requestHighPerformanceAdapter: winbool = False);
        procedure SetCustomWindowText(Text: widestring);
    public
        constructor Create(Width: UINT; Height: UINT; Name: widestring);
        destructor Destroy; override;

        procedure OnInit(); virtual;
        procedure OnUpdate(); virtual;
        procedure OnRender(); virtual;
        procedure OnDestroy(); virtual;
        // Samples override the event handlers to handle specific messages.
        procedure OnKeyDown(key: uint8); virtual;
        procedure OnKeyUp(key: uint8); virtual;
        // Accessors.
        function GetWidth(): UINT;
        function GetHeight(): UINT;
        function GetTitle(): widestring;
        procedure ParseCommandLineArgs({_In_reads_(argc) } argv: PWCHAR; argc: int32);
    end;

    PDXSample = ^TDXSample;

implementation

uses
    Win32Application,
    DX12.D3D12,
    DX12.DXGI1_6,
    DX12.D3DCommon;

    { TDXSample }

// Helper function for resolving the full path of assets.
function TDXSample.GetAssetFullPath(assetName: LPCWSTR): widestring;
begin
    Result := m_assetsPath + assetName;
end;


// Helper function for acquiring the first available hardware adapter that supports Direct3D 12.
// If no such adapter can be found, *ppAdapter will be set to nullptr.
procedure TDXSample.GetHardwareAdapter(pFactory: IDXGIFactory1; out ppAdapter: IDXGIAdapter1; requestHighPerformanceAdapter: winbool);
var
    adapter: IDXGIAdapter1;

    factory6: IDXGIFactory6;
    adapterIndex: UINT;
    GpuPreference: TDXGI_GPU_PREFERENCE;
    desc: TDXGI_ADAPTER_DESC1;
begin
    ppAdapter := nil;

    if requestHighPerformanceAdapter then
        GpuPreference := DXGI_GPU_PREFERENCE_HIGH_PERFORMANCE
    else
        GpuPreference := DXGI_GPU_PREFERENCE_UNSPECIFIED;


    if (SUCCEEDED(pFactory.QueryInterface(IID_IDXGIFactory6, factory6))) then
    begin
        adapterIndex := 0;
        while
            SUCCEEDED(factory6.EnumAdapterByGpuPreference(adapterIndex, GpuPreference, @IID_IDXGIAdapter1, adapter)) do

        begin

            adapter.GetDesc1(@desc);

            if ((desc.Flags and Ord(DXGI_ADAPTER_FLAG_SOFTWARE)) = Ord(DXGI_ADAPTER_FLAG_SOFTWARE)) then
            begin
                // Don't select the Basic Render Driver adapter.
                // If you want a software adapter, pass in "/warp" on the command line.
                Inc(adapterIndex);
                continue;
            end;

            // Check to see whether the adapter supports Direct3D 12, but don't create the
            // actual device yet.
            if (SUCCEEDED(D3D12CreateDevice(adapter, D3D_FEATURE_LEVEL_11_0, @IID_ID3D12Device, nil))) then
            begin
                break;
            end;
            Inc(adapterIndex);

        end;
    end;

    if (adapter = nil) then
    begin
        adapterIndex := 0;
        while SUCCEEDED(pFactory.EnumAdapters1(adapterIndex, adapter)) do
        begin
            adapter.GetDesc1(@desc);

            if ((desc.Flags and Ord(DXGI_ADAPTER_FLAG_SOFTWARE)) = Ord(DXGI_ADAPTER_FLAG_SOFTWARE)) then
            begin
                // Don't select the Basic Render Driver adapter.
                // If you want a software adapter, pass in "/warp" on the command line.
                Inc(adapterIndex);
                continue;
            end;

            // Check to see whether the adapter supports Direct3D 12, but don't create the
            // actual device yet.
            if (SUCCEEDED(D3D12CreateDevice(adapter, D3D_FEATURE_LEVEL_11_0, @IID_ID3D12Device, nil))) then
            begin
                break;
            end;
            Inc(adapterIndex);
        end;
    end;

    ppAdapter := adapter;
end;

// Helper function for setting the window's title text.

procedure TDXSample.SetCustomWindowText(Text: widestring);
begin
    SetWindowTextW(gWin32Application.GetHwnd(), pwidechar(Text));
end;



constructor TDXSample.Create(Width: UINT; Height: UINT; Name: widestring);
var
    assetsPath: widestring;
begin
    m_width := Width;
    m_height := Height;
    m_title := Name;
    m_useWarpDevice := False;

    GetAssetsPath(assetsPath);
    m_assetsPath := assetsPath;
    m_aspectRatio := Width / Height;
end;



destructor TDXSample.Destroy;
begin
    inherited Destroy;
end;



procedure TDXSample.OnInit();
begin

end;



procedure TDXSample.OnUpdate();
begin

end;



procedure TDXSample.OnRender();
begin

end;



procedure TDXSample.OnDestroy();
begin

end;



procedure TDXSample.OnKeyDown(key: uint8);
begin

end;



procedure TDXSample.OnKeyUp(key: uint8);
begin

end;



function TDXSample.GetWidth(): UINT;
begin
    Result := m_width;
end;



function TDXSample.GetHeight(): UINT;
begin
    Result := m_height;
end;



function TDXSample.GetTitle(): widestring;
begin
    Result := m_title;
end;


// Helper function for parsing any supplied command line args.
procedure TDXSample.ParseCommandLineArgs(argv: PWCHAR; argc: int32);
begin

end;

end.
