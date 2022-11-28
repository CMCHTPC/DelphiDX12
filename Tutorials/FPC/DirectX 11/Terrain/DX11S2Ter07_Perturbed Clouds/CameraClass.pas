unit CameraClass;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

{$DEFINE xxx}

interface

uses
    Classes, SysUtils,
    DirectX.Math;

type

    { TCameraClass }

    TCameraClass = class(TObject)
    private
        m_positionX, m_positionY, m_positionZ: single;
        m_rotationX, m_rotationY, m_rotationZ: single;
        m_viewMatrix: TXMMATRIX;
        m_baseViewMatrix: TXMMATRIX;
    public
        constructor Create;
        destructor Destroy; override;

        procedure SetPosition(x, y, z: single);
        procedure SetRotation(x, y, z: single);

        function GetPosition(): TXMFLOAT3;
        function GetRotation(): TXMFLOAT3;

        procedure Render();
        procedure RenderBaseViewMatrix();
        procedure GetViewMatrix( out viewMatrix: TXMMATRIX);
        procedure GetBaseViewMatrix (out viewMatrix: TXMMATRIX);
    end;


implementation


uses
    DX12.D3DX10;

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
{$IFDEF xxx}
    up, position, lookAt: TXMFLOAT3;
    upVector, positionVector, lookAtVector: TXMVECTOR;
    yaw, pitch, roll: single;
    rotationMatrix: TXMMATRIX;

    rotationMatrix2: TD3DXMATRIX;
{$else}
  up, position, lookAt, lookAt3: TD3DXVECTOR3;
    lookAt2: PD3DXVECTOR3;
    pos4D: TD3DXVector4;
    yaw, pitch, roll: single;
    rotationMatrix: TD3DXMATRIX;
    tempmatrix: TD3DXMATRIX;
{$ENDIF}
begin

{$IFDEF xxx}
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

    // Create the rotation matrix from the yaw, pitch, and roll values.
    D3DXMatrixRotationYawPitchRoll(rotationMatrix2, yaw, pitch, roll);




    // Transform the lookAt and up vector by the rotation matrix so the view is correctly rotated at the origin.
    lookAtVector := XMVector3TransformCoord(lookAtVector, rotationMatrix);
    upVector :=     XMVector3TransformCoord(upVector, rotationMatrix);

    // Translate the rotated camera position to the location of the viewer.
    lookAtVector := XMVectorAdd(positionVector, lookAtVector);

    // Finally create the view matrix from the three updated vectors.
    m_viewMatrix := XMMatrixLookAtLH(positionVector, lookAtVector, upVector);
    {$else}
      // Setup the vector that points upwards.
    up.x := 0.0;
    up.y := 1.0;
    up.z := 0.0;

    // Setup the position of the camera in the world.
    position.x := m_positionX;
    position.y := m_positionY;
    position.z := m_positionZ;

    // Setup where the camera is looking by default.
    lookAt.x := 0.0;
    lookAt.y := 0.0;
    lookAt.z := 1.0;

    // Set the yaw (Y axis), pitch (X axis), and roll (Z axis) rotations in radians.
    pitch := m_rotationX * 0.0174532925;
    yaw := m_rotationY * 0.0174532925;
    roll := m_rotationZ * 0.0174532925;

    // Create the rotation matrix from the yaw, pitch, and roll values.
    D3DXMatrixRotationYawPitchRoll(rotationMatrix, yaw, pitch, roll);

    // Transform the lookAt and up vector by the rotation matrix so the view is correctly rotated at the origin.
    {$IFDEF FPC}
    pos4D := TD3DXVector4.Create(lookAt.x, lookAt.y, lookAt.z, 1);
    d3dxvec4transform(pos4D, pos4D, rotationMatrix);
    lookAt.x := pos4D.x;
    lookAt.y := pos4D.y;
    lookAt.z := pos4D.z;

    pos4D := TD3DXVector4.Create(up.x, up.y, up.z, 1);
    d3dxvec4transform(pos4D, pos4D, rotationMatrix);
    up.x := pos4D.x;
    up.y := pos4D.y;
    up.z := pos4D.z;
    {$ELSE}
    D3DXVec3TransformCoord(lookAt, lookAt, rotationMatrix);
    D3DXVec3TransformCoord(up, up, rotationMatrix);
    {$ENDIF}


    // Translate the rotated camera position to the location of the viewer.
    lookAt := position + lookAt;

    // Finally create the view matrix from the three updated vectors.
    D3DXMatrixLookAtLH(tempmatrix, position, lookAt, up);


    m_viewMatrix._11:= tempmatrix._11;
    m_viewMatrix._12:= tempmatrix._12;
    m_viewMatrix._13:= tempmatrix._13;
    m_viewMatrix._14:= tempmatrix._14;

    m_viewMatrix._21:= tempmatrix._21;
    m_viewMatrix._22:= tempmatrix._22;
    m_viewMatrix._23:= tempmatrix._23;
    m_viewMatrix._24:= tempmatrix._24;

    m_viewMatrix._31:= tempmatrix._31;
    m_viewMatrix._32:= tempmatrix._32;
    m_viewMatrix._33:= tempmatrix._33;
    m_viewMatrix._34:= tempmatrix._34;

    m_viewMatrix._41:= tempmatrix._41;
    m_viewMatrix._42:= tempmatrix._42;
    m_viewMatrix._43:= tempmatrix._43;
    m_viewMatrix._44:= tempmatrix._44;
    {$endif}
end;



procedure TCameraClass.GetViewMatrix(out viewMatrix: TXMMATRIX);
begin
    viewMatrix := m_viewMatrix;
end;



procedure TCameraClass.RenderBaseViewMatrix();
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
    m_baseViewMatrix := XMMatrixLookAtLH(positionVector, lookAtVector, upVector);

end;



procedure TCameraClass.GetBaseViewMatrix(out viewMatrix: TXMMATRIX);
begin
    viewMatrix := m_baseViewMatrix;
end;

end.
