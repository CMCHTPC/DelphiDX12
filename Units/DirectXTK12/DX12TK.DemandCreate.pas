//--------------------------------------------------------------------------------------
// File: DemandCreate.h

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkId=248929
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.DemandCreate;

{$mode ObjFPC}{$H+}
{$modeswitch nestedprocvars}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12,
    syncobjs;

type
    generic TCreateFunc<T> = function (var comPtr: T): HResult is nested;

    // Helper for lazily creating a D3D resource.
generic function DemandCreate<T>(comPtr: T; mutex: TCriticalSection;  createFunc: specialize TCreateFunc<T>): T;


function TEffectDeviceResources_DemandCreateRootSig(mDevice: ID3D12Device; mMutex: TCriticalSection; var rootSig: ID3D12RootSignature; const desc: PD3D12_ROOT_SIGNATURE_DESC): ID3D12RootSignature;inline;

implementation

uses
    DX12TK.PlatformHelpers,
    DX12TK.DirectXHelpers;



generic function DemandCreate<T>(var comPtr: T; mutex: TCriticalSection; createFunc: specialize TCreateFunc<T>): T;
begin
    Result := ComPtr;
    // Double-checked lock pattern.
    ReadWriteBarrier;

    if (Result = nil) then
    begin
        mutex.Acquire;

        Result := comPtr;

        if (Result = nil) then
        begin
            // Create the new object.
            ThrowIfFailed(
                createFunc(Result)
                );
            ReadWriteBarrier;
        end;
        mutex.Release;
    end;
end;


function TEffectDeviceResources_DemandCreateRootSig(mDevice: ID3D12Device; mMutex: TCriticalSection; var rootSig: ID3D12RootSignature; const desc: PD3D12_ROOT_SIGNATURE_DESC): ID3D12RootSignature; inline;
var
    pResult: ID3D12RootSignature;

    function ACreateFunc(var comPtr: ID3D12RootSignature): HResult;
    var
        hr: HResult;
    begin
        hr := CreateRootSignature(mDevice, @desc, ID3D12RootSignature(comPtr));

        if (SUCCEEDED(hr)) then
            SetDebugObjectName(comPtr, 'DirectXTK:Effect');

        Result := hr;
    end;
begin
    pResult := specialize DemandCreate<ID3D12RootSignature>(rootSig, mMutex, @aCreateFunc);
    Result := pResult;
end;

end.
