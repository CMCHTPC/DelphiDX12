unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
    Windows, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
    ExtCtrls;

type

    { TForm1 }

    TForm1 = class(TForm)
        Button1: TButton;
        edMaxFeatureLevel: TLabeledEdit;
        procedure Button1Click(Sender: TObject);
    private

    public

    end;

var
    Form1: TForm1;

implementation

uses
    DX12.D3DCommon,
    DX12.DXGI,
    DX12.DXGI1_2,
    DX12.DXGI1_3,
    DX12.DXGI1_4,
    DX12.DXGI1_6,
    DX12.D3D12,
    DX12.D3DX12_Check_Feature_Support;

    {$R *.frm}

    { TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
    FDXGIFactoryFlags: UINT = 0;
    FDevice: ID3D12Device;
    FCheckFeature: TD3DX12FeatureSupport;
    FFactory: IDXGIFactory4;
    FHardwareAdapter: IDXGIAdapter1;
    hr: HResult;



    procedure GetHardwareAdapter(pFactory: IDXGIFactory1; out ppAdapter: IDXGIAdapter1; requestHighPerformanceAdapter: boolean = False);
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
                    hr := factory6.EnumAdapterByGpuPreference(adapterIndex, DXGI_GPU_PREFERENCE_HIGH_PERFORMANCE, @IID_IDXGIAdapter1, adapter)
                else
                    hr := factory6.EnumAdapterByGpuPreference(adapterIndex, DXGI_GPU_PREFERENCE_UNSPECIFIED, @IID_IDXGIAdapter1, adapter);
                if hr = S_OK then
                begin
                    adapter.GetDesc1(@desc);

                    if (desc.Flags and Ord(DXGI_ADAPTER_FLAG_SOFTWARE)) = Ord(DXGI_ADAPTER_FLAG_SOFTWARE) then
                    begin
                        // Don't select the Basic Render Driver adapter.
                        // If you want a software adapter, pass in "/warp" on the command line.
                        Inc(adapterIndex);
                        continue;
                    end;
                    // Check to see whether the adapter supports Direct3D 12, but don't create the
                    // actual device yet.
                    if D3D12CreateDevice(adapter, D3D_FEATURE_LEVEL_11_0, @IID_ID3D12Device, nil) = S_OK then
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
                    adapter.GetDesc1(@desc);
                    if (desc.Flags and Ord(DXGI_ADAPTER_FLAG_SOFTWARE)) = Ord(DXGI_ADAPTER_FLAG_SOFTWARE) then
                    begin
                        // Don't select the Basic Render Driver adapter.
                        // If you want a software adapter, pass in "/warp" on the command line.
                        Inc(adapterIndex);
                        continue;
                    end;
                    // Check to see whether the adapter supports Direct3D 12, but don't create the
                    // actual device yet.
                    if D3D12CreateDevice(adapter, D3D_FEATURE_LEVEL_11_0, @IID_ID3D12Device, nil) = S_OK then
                        Break;
                    Inc(adapterIndex);
                end;
            end;
        end;
        ppAdapter := adapter;
    end;

begin

    hr := CreateDXGIFactory2(FDXGIFactoryFlags, @IID_IDXGIFactory4, FFactory);
    if hr = S_OK then
        GetHardwareAdapter(FFactory, FHardwareAdapter);
    if hr = S_OK then
        hr := D3D12CreateDevice(FHardwareAdapter, D3D_FEATURE_LEVEL_11_0, @IID_ID3D12Device, @FDevice);
    if hr = S_OK then
    begin
        FCheckFeature := TD3DX12FeatureSupport.Create;
        FCheckFeature.Init(FDevice);

       edMaxFeatureLevel.Text:=IntToStr(ord(FCheckFeature.MaxSupportedFeatureLevel));

        FCheckFeature.Free;

    end;
    if FDevice <> nil then
        FDevice := nil;
end;

end.
