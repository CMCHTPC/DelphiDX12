unit CameraClass;

interface

uses
    Classes, SysUtils, Windows,
    DX12.D3DX10;

type

    TCameraClass = class(TObject)
    private
        m_positionX, m_positionY, m_positionZ: single;
        m_rotationX, m_rotationY, m_rotationZ: single;
        m_viewMatrix: TD3DXMATRIX;
    public
        constructor Create;
        destructor Destroy; override;
        procedure SetPosition(x, y, z: single);
        procedure SetRotation(x, y, z: single);
        function GetPosition(): TD3DXVECTOR3;
        function GetRotation(): TD3DXVECTOR3;
        procedure Render();
        procedure GetViewMatrix(out viewMatrix: TD3DXMATRIX);
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



function TCameraClass.GetPosition(): TD3DXVECTOR3;
begin
    Result := TD3DXVECTOR3.Create(m_positionX, m_positionY, m_positionZ);
end;



function TCameraClass.GetRotation(): TD3DXVECTOR3;
begin
    Result := TD3DXVECTOR3.Create(m_rotationX, m_rotationY, m_rotationZ);
end;



procedure TCameraClass.Render();
var
    up, position, lookAt, lookAt3: TD3DXVECTOR3;
    lookAt2: PD3DXVECTOR3;
    pos4D: TD3DXVector4;
    yaw, pitch, roll: single;
    rotationMatrix: TD3DXMATRIX;
begin

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
    D3DXMatrixLookAtLH(m_viewMatrix, position, lookAt, up);

end;



procedure TCameraClass.GetViewMatrix(out viewMatrix: TD3DXMATRIX);
begin
    viewMatrix := m_viewMatrix;
end;

end.
