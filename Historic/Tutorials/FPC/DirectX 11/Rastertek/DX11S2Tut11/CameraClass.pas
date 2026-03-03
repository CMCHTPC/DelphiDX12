unit CameraClass;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils,
    DirectX.Math;

type
    TCameraClass = class(TObject)
    private
        m_positionX, m_positionY, m_positionZ: single;
        m_rotationX, m_rotationY, m_rotationZ: single;
        m_viewMatrix: TXMMATRIX;
    public
        constructor Create;
        destructor Destroy; override;

        procedure SetPosition(x, y, z: single);
        procedure SetRotation(x, y, z: single);

        function GetPosition(): TXMFLOAT3;
        function GetRotation(): TXMFLOAT3;

        procedure Render();
        function GetViewMatrix:TXMMATRIX;


    end;


implementation



constructor TCameraClass.Create;
begin
    m_positionX := 0.0;
    m_positionY := 0.0;
    m_positionZ := 0.0;

    m_rotationX := 0.0;
    m_rotationY := 0.0;
    m_rotationZ := 0.0;
end;



destructor TCameraClass.Destroy;
begin
    inherited;
end;



procedure TCameraClass.SetPosition(x, y, z: single);
begin
    m_positionX := x;
    m_positionY := y;
    m_positionZ := z;
end;



procedure TCameraClass.SetRotation(x, y, z: single);
begin
    m_rotationX := x;
    m_rotationY := y;
    m_rotationZ := z;
end;



function TCameraClass.GetPosition(): TXMFLOAT3;
begin
    Result := TXMFLOAT3.Create(m_positionX, m_positionY, m_positionZ);
end;



function TCameraClass.GetRotation(): TXMFLOAT3;
begin
    Result := TXMFLOAT3.Create(m_rotationX, m_rotationY, m_rotationZ);
end;



procedure TCameraClass.Render();
var
    up, position, lookAt: TXMFLOAT3;
    upVector, positionVector, lookAtVector: TXMVECTOR;
    yaw, pitch, roll: single;
    rotationMatrix: TXMMATRIX;
begin

    // Setup the vector that points upwards.
    up.x := 0.0;
    up.y := 1.0;
    up.z := 0.0;

    // Load it into a XMVECTOR structure.
    upVector := XMLoadFloat3(up);

    // Setup the position of the camera in the world.
    position.x := m_positionX;
    position.y := m_positionY;
    position.z := m_positionZ;

    // Load it into a XMVECTOR structure.
    positionVector := XMLoadFloat3(position);

    // Setup where the camera is looking by default.
    lookAt.x := 0.0;
    lookAt.y := 0.0;
    lookAt.z := 1.0;

    // Load it into a XMVECTOR structure.
    lookAtVector := XMLoadFloat3(lookAt);

    // Set the yaw (Y axis), pitch (X axis), and roll (Z axis) rotations in radians.
    pitch := m_rotationX * 0.0174532925;
    yaw := m_rotationY * 0.0174532925;
    roll := m_rotationZ * 0.0174532925;

    // Create the rotation matrix from the yaw, pitch, and roll values.
    rotationMatrix := XMMatrixRotationRollPitchYaw(pitch, yaw, roll);

    // Transform the lookAt and up vector by the rotation matrix so the view is correctly rotated at the origin.
    lookAtVector := XMVector3TransformCoord(lookAtVector, rotationMatrix);
    upVector := XMVector3TransformCoord(upVector, rotationMatrix);

    // Translate the rotated camera position to the location of the viewer.
    lookAtVector := XMVectorAdd(positionVector, lookAtVector);

    // Finally create the view matrix from the three updated vectors.
    m_viewMatrix := XMMatrixLookAtLH(positionVector, lookAtVector, upVector);

end;



function TCameraClass.GetViewMatrix: TXMMATRIX;
begin
    result := m_viewMatrix;
end;

end.
