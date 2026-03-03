unit PositionClass;

interface

uses
    Classes, SysUtils, Windows;

type

    TPositionClass = class(TObject)
    private
        m_positionX, m_positionY, m_positionZ: single;
        m_rotationX, m_rotationY, m_rotationZ: single;

        m_frameTime: single;

        m_forwardSpeed, m_backwardSpeed: single;
        m_upwardSpeed, m_downwardSpeed: single;
        m_leftTurnSpeed, m_rightTurnSpeed: single;
        m_lookUpSpeed, m_lookDownSpeed: single;
    public
        constructor Create;
        destructor Destroy; override;

        procedure SetPosition(x, y, z: single);
        procedure SetRotation(x, y, z: single);

        procedure GetPosition(out x, y, z: single);
        procedure GetRotation(out x, y, z: single);

        procedure SetFrameTime(time: single);

        procedure MoveForward(keydown: boolean);
        procedure MoveBackward(keydown: boolean);
        procedure MoveUpward(keydown: boolean);
        procedure MoveDownward(keydown: boolean);
        procedure TurnLeft(keydown: boolean);
        procedure TurnRight(keydown: boolean);
        procedure LookUpward(keydown: boolean);
        procedure LookDownward(keydown: boolean);

    end;

implementation

constructor TPositionClass.Create;
begin
    m_positionX := 0.0;
    m_positionY := 0.0;
    m_positionZ := 0.0;

    m_rotationX := 0.0;
    m_rotationY := 0.0;
    m_rotationZ := 0.0;

    m_frameTime := 0.0;

    m_forwardSpeed := 0.0;
    m_backwardSpeed := 0.0;
    m_upwardSpeed := 0.0;
    m_downwardSpeed := 0.0;
    m_leftTurnSpeed := 0.0;
    m_rightTurnSpeed := 0.0;
    m_lookUpSpeed := 0.0;
    m_lookDownSpeed := 0.0;
end;

destructor TPositionClass.Destroy;
begin
    inherited;
end;

procedure TPositionClass.SetPosition(x, y, z: single);
begin
    m_positionX := x;
    m_positionY := y;
    m_positionZ := z;
end;

procedure TPositionClass.SetRotation(x, y, z: single);
begin
    m_rotationX := x;
    m_rotationY := y;
    m_rotationZ := z;
end;

procedure TPositionClass.GetPosition(out x, y, z: single);
begin
    x := m_positionX;
    y := m_positionY;
    z := m_positionZ;
end;

procedure TPositionClass.GetRotation(out x, y, z: single);
begin
    x := m_rotationX;
    y := m_rotationY;
    z := m_rotationZ;

end;

procedure TPositionClass.SetFrameTime(time: single);
begin
    m_frameTime := time;

end;

procedure TPositionClass.MoveForward(keydown: boolean);
var
    radians: single;
begin

    // Update the forward speed movement based on the frame time and whether the user is holding the key down or not.
    if (keydown) then
    begin
        m_forwardSpeed := m_forwardSpeed + m_frameTime * 0.001;

        if (m_forwardSpeed > (m_frameTime * 0.03)) then
        begin
            m_forwardSpeed := m_frameTime * 0.03;
        end;
    end
    else
    begin
        m_forwardSpeed := m_forwardSpeed - m_frameTime * 0.0007;

        if (m_forwardSpeed < 0.0) then
        begin
            m_forwardSpeed := 0.0;
        end;
    end;

    // Convert degrees to radians.
    radians := m_rotationY * 0.0174532925;

    // Update the position.
    m_positionX := m_positionX + sin(radians) * m_forwardSpeed;
    m_positionZ := m_positionZ + cos(radians) * m_forwardSpeed;

end;

procedure TPositionClass.MoveBackward(keydown: boolean);
var
    radians: single;
begin

    // Update the backward speed movement based on the frame time and whether the user is holding the key down or not.
    if (keydown) then
    begin
        m_backwardSpeed := m_backwardSpeed + m_frameTime * 0.001;

        if (m_backwardSpeed > (m_frameTime * 0.03)) then
        begin
            m_backwardSpeed := m_frameTime * 0.03;
        end;
    end
    else
    begin
        m_backwardSpeed := m_backwardSpeed - m_frameTime * 0.0007;

        if (m_backwardSpeed < 0.0) then
        begin
            m_backwardSpeed := 0.0;
        end;
    end;

    // Convert degrees to radians.
    radians := m_rotationY * 0.0174532925;

    // Update the position.
    m_positionX := m_positionX - sin(radians) * m_backwardSpeed;
    m_positionZ := m_positionZ - cos(radians) * m_backwardSpeed;

end;

procedure TPositionClass.MoveUpward(keydown: boolean);
begin
    // Update the upward speed movement based on the frame time and whether the user is holding the key down or not.
    if (keydown) then
    begin
        m_upwardSpeed := m_upwardSpeed + m_frameTime * 0.003;

        if (m_upwardSpeed > (m_frameTime * 0.03)) then
        begin
            m_upwardSpeed := m_frameTime * 0.03;
        end;
    end
    else
    begin
        m_upwardSpeed := m_upwardSpeed - m_frameTime * 0.002;

        if (m_upwardSpeed < 0.0) then
        begin
            m_upwardSpeed := 0.0;
        end;
    end;

    // Update the height position.
    m_positionY := m_positionY + m_upwardSpeed;
end;

procedure TPositionClass.MoveDownward(keydown: boolean);
begin
    // Update the downward speed movement based on the frame time and whether the user is holding the key down or not.
    if (keydown) then
    begin
        m_downwardSpeed := m_downwardSpeed + m_frameTime * 0.003;

        if (m_downwardSpeed > (m_frameTime * 0.03)) then
        begin
            m_downwardSpeed := m_frameTime * 0.03;
        end;
    end
    else
    begin
        m_downwardSpeed := m_downwardSpeed - m_frameTime * 0.002;

        if (m_downwardSpeed < 0.0) then
        begin
            m_downwardSpeed := 0.0;
        end;
    end;

    // Update the height position.
    m_positionY := m_positionY - m_downwardSpeed;
end;

procedure TPositionClass.TurnLeft(keydown: boolean);
begin
    // Update the left turn speed movement based on the frame time and whether the user is holding the key down or not.
    if (keydown) then
    begin
        m_leftTurnSpeed := m_leftTurnSpeed + m_frameTime * 0.01;

        if (m_leftTurnSpeed > (m_frameTime * 0.15)) then
        begin
            m_leftTurnSpeed := m_frameTime * 0.15;
        end;
    end
    else
    begin
        m_leftTurnSpeed := m_leftTurnSpeed - m_frameTime * 0.005;

        if (m_leftTurnSpeed < 0.0) then
        begin
            m_leftTurnSpeed := 0.0;
        end;
    end;

    // Update the rotation.
    m_rotationY := m_rotationY - m_leftTurnSpeed;

    // Keep the rotation in the 0 to 360 range.
    if (m_rotationY < 0.0) then
    begin
        m_rotationY := m_rotationY + 360.0;
    end;

end;

procedure TPositionClass.TurnRight(keydown: boolean);
begin
    // Update the right turn speed movement based on the frame time and whether the user is holding the key down or not.
    if (keydown) then
    begin
        m_rightTurnSpeed := m_rightTurnSpeed + m_frameTime * 0.01;

        if (m_rightTurnSpeed > (m_frameTime * 0.15)) then
        begin
            m_rightTurnSpeed := m_frameTime * 0.15;
        end;
    end
    else
    begin
        m_rightTurnSpeed := m_rightTurnSpeed - m_frameTime * 0.005;

        if (m_rightTurnSpeed < 0.0) then
        begin
            m_rightTurnSpeed := 0.0;
        end;
    end;

    // Update the rotation.
    m_rotationY := m_rotationY + m_rightTurnSpeed;

    // Keep the rotation in the 0 to 360 range.
    if (m_rotationY > 360.0) then
    begin
        m_rotationY := m_rotationY - 360.0;
    end;

end;

procedure TPositionClass.LookUpward(keydown: boolean);
begin
    // Update the upward rotation speed movement based on the frame time and whether the user is holding the key down or not.
    if (keydown) then
    begin
        m_lookUpSpeed := m_lookUpSpeed + m_frameTime * 0.01;

        if (m_lookUpSpeed > (m_frameTime * 0.15)) then
        begin
            m_lookUpSpeed := m_frameTime * 0.15;
        end;
    end
    else
    begin
        m_lookUpSpeed := m_lookUpSpeed - m_frameTime * 0.005;

        if (m_lookUpSpeed < 0.0) then
        begin
            m_lookUpSpeed := 0.0;
        end;
    end;

    // Update the rotation.
    m_rotationX := m_rotationX - m_lookUpSpeed;

    // Keep the rotation maximum 90 degrees.
    if (m_rotationX > 90.0) then
    begin
        m_rotationX := 90.0;
    end;

end;

procedure TPositionClass.LookDownward(keydown: boolean);
begin
    // Update the downward rotation speed movement based on the frame time and whether the user is holding the key down or not.
    if (keydown) then
    begin
        m_lookDownSpeed := m_lookDownSpeed + m_frameTime * 0.01;

        if (m_lookDownSpeed > (m_frameTime * 0.15)) then
        begin
            m_lookDownSpeed := m_frameTime * 0.15;
        end;
    end
    else
    begin
        m_lookDownSpeed := m_lookDownSpeed - m_frameTime * 0.005;

        if (m_lookDownSpeed < 0.0) then
        begin
            m_lookDownSpeed := 0.0;
        end;
    end;

    // Update the rotation.
    m_rotationX := m_rotationX + m_lookDownSpeed;

    // Keep the rotation maximum 90 degrees.
    if (m_rotationX < -90.0) then
    begin
        m_rotationX := -90.0;
    end;

end;

end.
