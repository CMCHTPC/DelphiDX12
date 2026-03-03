unit DXSample;

{$mode Delphi}

interface

uses
    Classes, SysUtils, Windows,
    DX12.DXGI,
    DX12.D3DCommon,
    DX12.D3D12,
    DX12.DXGI1_4,
    DX12.DXGI1_6;

type

    { TDXSample }

    TDXSample = class(TObject)
    private
        // Root assets path.
        m_assetsPath: WideString;
        // Window title.
        m_title: WideString;
    protected
        // Viewport dimensions.
        m_width: UINT;
        m_height: UINT;
        m_aspectRatio: single;

        // Adapter info.
        m_useWarpDevice: boolean;
    protected
        function GetAssetFullPath(assetName: WideString): WideString;
        procedure GetHardwareAdapter(pFactory: IDXGIFactory1; out ppAdapter: IDXGIAdapter1;
            requestHighPerformanceAdapter: boolean = False);
        procedure SetCustomWindowText(Text: WideString);
    public
        constructor Create(Width, Height: UINT; Name: WideString);
        destructor Destroy; override;
        procedure OnInit(); virtual; abstract;
        procedure OnUpdate(); virtual; abstract;
        procedure OnRender(); virtual; abstract;
        procedure OnDestroy(); virtual; abstract;
        // Samples override the event handlers to handle specific messages.
        procedure OnKeyDown(key: uint8); virtual; abstract;
        procedure OnKeyUp(key: uint8); virtual; abstract;

        // Accessors.
        function GetWidth: uint;
        function GetHeight: uint;
        function GetTitle: WideString;

    end;


implementation

uses
    DXSampleHelper, Win32Application;

{ TDXSample }

// Helper function for resolving the full path of assets.
function TDXSample.GetAssetFullPath(assetName: WideString): WideString;
begin
    Result := m_assetsPath + assetName;
end;


// Helper function for acquiring the first available hardware adapter that supports Direct3D 12.
// If no such adapter can be found, *ppAdapter will be set to nullptr.
procedure TDXSample.GetHardwareAdapter(pFactory: IDXGIFactory1; out ppAdapter: IDXGIAdapter1; requestHighPerformanceAdapter: boolean);
var
    adapter: IDXGIAdapter1;
    factory6: IDXGIFactory6;
    hr: HResult;
    adapterIndex: uint;
    desc: TDXGI_ADAPTER_DESC1;
begin
    ppAdapter := nil;
    adapterIndex := 0;
    hr := pFactory.QueryInterface(IID_IDXGIFactory6, factory6);
    if hr = S_OK then
    begin
        while hr = S_OK do
        begin
            if requestHighPerformanceAdapter then
                hr := factory6.EnumAdapterByGpuPreference(adapterIndex, DXGI_GPU_PREFERENCE_HIGH_PERFORMANCE, IID_IDXGIAdapter1, adapter)
            else
                hr := factory6.EnumAdapterByGpuPreference(adapterIndex, DXGI_GPU_PREFERENCE_UNSPECIFIED, IID_IDXGIAdapter1, adapter);
            if hr = S_OK then
            begin
                adapter.GetDesc1(desc);

                if (desc.Flags and Ord(DXGI_ADAPTER_FLAG_SOFTWARE)) = Ord(DXGI_ADAPTER_FLAG_SOFTWARE) then
                begin
                    // Don't select the Basic Render Driver adapter.
                    // If you want a software adapter, pass in "/warp" on the command line.
                    continue;
                end;
                // Check to see whether the adapter supports Direct3D 12, but don't create the
                // actual device yet.
                if D3D12CreateDevice(adapter, D3D_FEATURE_LEVEL_11_0, IID_ID3D12Device, nil) = S_OK then
                    Break;

                Inc(adapterIndex);
            end;

        end;
    end;
    if adapter = nil then
    begin
        hr := S_OK;
        adapterIndex := 0;
        while hr = S_OK do
        begin
            hr := pFactory.EnumAdapters1(adapterIndex, adapter);
            if hr = S_OK then
            begin
                adapter.GetDesc1(desc);
                if (desc.Flags and Ord(DXGI_ADAPTER_FLAG_SOFTWARE)) = Ord(DXGI_ADAPTER_FLAG_SOFTWARE) then
                begin
                    // Don't select the Basic Render Driver adapter.
                    // If you want a software adapter, pass in "/warp" on the command line.
                    continue;
                end;
                // Check to see whether the adapter supports Direct3D 12, but don't create the
                // actual device yet.
                if D3D12CreateDevice(adapter, D3D_FEATURE_LEVEL_11_0, IID_ID3D12Device, nil) = S_OK then
                    Break;
                Inc(adapterIndex);
            end;
        end;
    end;
    ppAdapter := adapter;
end;


// Helper function for setting the window's title text.
procedure TDXSample.SetCustomWindowText(Text: WideString);
var
    windowText: WideString;
begin
    windowText := m_title + ': ' + Text;
    SetWindowTextW(Win32App.GetHwnd(), PWideChar(windowText));
end;



constructor TDXSample.Create(Width, Height: UINT; Name: WideString);
begin
    m_width := Width;
    m_height := Height;
    m_title := Name;
    m_useWarpDevice := True; // False;
    GetAssetsPath(m_assetsPath);
    m_aspectRatio := Width / Height;
end;



destructor TDXSample.Destroy;
begin
    inherited Destroy;
end;



function TDXSample.GetWidth: uint;
begin
    Result := m_width;
end;



function TDXSample.GetHeight: uint;
begin
    Result := m_height;
end;



function TDXSample.GetTitle: WideString;
begin
    Result := m_title;
end;

end.
