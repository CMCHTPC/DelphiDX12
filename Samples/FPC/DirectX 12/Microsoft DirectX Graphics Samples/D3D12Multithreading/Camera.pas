//*********************************************************

// Copyright (c) Microsoft. All rights reserved.
// This code is licensed under the MIT License (MIT).
// THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
// IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.

//*********************************************************
unit Camera;

{$mode ObjFPC}{$H+}
{$modeswitch ADVANCEDRECORDS}
{$modeswitch TypeHelpers}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D12, DirectX.Math;

type

    { TCamera }

    TCamera = record
    private
        mEye: TXMVECTOR; // Where the camera is in world space. Z increases into of the screen when using LH coord system (which we are and DX uses)
        mAt: TXMVECTOR; // What the camera is looking at (world origin)
        mUp: TXMVECTOR; // Which way is up
    public
        class operator Initialize(var A: TCamera);
        procedure Get3DViewProjMatrices(view: PXMFLOAT4X4; proj: PXMFLOAT4X4; fovInDegrees: single; screenWidth: single; screenHeight: single);
        procedure Reset();
        procedure SetCamera(eye: TXMVECTOR; at: TXMVECTOR; up: TXMVECTOR);
        function GetCamera(): TCamera;
        procedure RotateYaw(deg: single);
        procedure RotatePitch(deg: single);
        procedure GetOrthoProjMatrices(view: PXMFLOAT4X4; proj: PXMFLOAT4X4; Width: single; Height: single);
    end;

implementation

{ TCamera }

class operator TCamera.Initialize(var A: TCamera);
begin
  a.Reset();
end;

procedure TCamera.Get3DViewProjMatrices(view: PXMFLOAT4X4; proj: PXMFLOAT4X4; fovInDegrees: single; screenWidth: single; screenHeight: single);
var
    aspectRatio, fovAngleY: single;
begin
    aspectRatio := screenWidth / screenHeight;
    fovAngleY := fovInDegrees * XM_PI / 180.0;

    if (aspectRatio < 1.0) then
        fovAngleY := fovAngleY / aspectRatio;


    XMStoreFloat4x4(view^, XMMatrixTranspose(XMMatrixLookAtRH(mEye, mAt, mUp)));
    XMStoreFloat4x4(proj^, XMMatrixTranspose(XMMatrixPerspectiveFovRH(fovAngleY, aspectRatio, 0.01, 125.0)));
end;



procedure TCamera.Reset();
begin
    mEye := XMVectorSet(0.0, 15.0, -30.0, 0.0);
    mAt := XMVectorSet(0.0, 8.0, 0.0, 0.0);
    mUp := XMVectorSet(0.0, 1.0, 0.0, 0.0);
end;



procedure TCamera.SetCamera(eye: TXMVECTOR; at: TXMVECTOR; up: TXMVECTOR);
begin
    mEye := eye;
    mAt := at;
    mUp := up;
end;



function TCamera.GetCamera(): TCamera;
begin
    Result := self;
end;



procedure TCamera.RotateYaw(deg: single);
var
    rotation: TXMMATRIX;
begin
    rotation := XMMatrixRotationAxis(mUp, deg);

    mEye := XMVector3TransformCoord(mEye, rotation);
end;



procedure TCamera.RotatePitch(deg: single);
var
    right: TXMVECTOR;
    rotation: TXMMATRIX;
begin
    right := XMVector3Normalize(XMVector3Cross(mEye, mUp));
    rotation := XMMatrixRotationAxis(right, deg);

    mEye := XMVector3TransformCoord(mEye, rotation);
end;



procedure TCamera.GetOrthoProjMatrices(view: PXMFLOAT4X4; proj: PXMFLOAT4X4; Width: single; Height: single);
begin
    XMStoreFloat4x4(view^, XMMatrixTranspose(XMMatrixLookAtRH(mEye, mAt, mUp)));
    XMStoreFloat4x4(proj^, XMMatrixTranspose(XMMatrixOrthographicRH(Width, Height, 0.01, 125.0)));
end;

end.
