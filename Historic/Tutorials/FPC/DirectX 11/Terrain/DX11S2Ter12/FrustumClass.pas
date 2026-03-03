unit FrustumClass;

{$mode Delphi}

interface

uses
    Classes, SysUtils,
    DirectX.Math;

type

    { TFrustumClass }

    TFrustumClass = class(TObject)
    public
        constructor Create;
        destructor Destroy; override;

        procedure Initialize(screenDepth: single);

        procedure ConstructFrustum(projectionMatrix, viewMatrix: TXMMATRIX);

        function CheckPoint(x, y, z: single): boolean;
        function CheckCube(xCenter, yCenter, zCenter, radius: single): boolean;
        function CheckSphere(xCenter, yCenter, zCenter, radius: single): boolean;
        function CheckRectangle(xCenter, yCenter, zCenter, xSize, ySize, zSize: single): boolean;
        function CheckRectangle2(maxWidth, maxHeight, maxDepth, minWidth, minHeight, minDepth: single): boolean;

    private
        m_screenDepth: single;
        m_planes: array[0..5, 0..3] of single;
    end;

implementation

{ TFrustumClass }

constructor TFrustumClass.Create;
begin

end;



destructor TFrustumClass.Destroy;
begin
    inherited Destroy;
end;



procedure TFrustumClass.Initialize(screenDepth: single);
begin
    m_screenDepth := screenDepth;
end;



procedure TFrustumClass.ConstructFrustum(projectionMatrix, viewMatrix: TXMMATRIX);
var
    pMatrix, matrix: TXMFLOAT4X4;
    zMinimum, r, length: single;
    finalMatrix: TXMMATRIX;
begin
    // Convert the projection matrix into a 4x4 float type.
    XMStoreFloat4x4(pMatrix, projectionMatrix);

    // Calculate the minimum Z distance in the frustum.
    zMinimum := -pMatrix._43 / pMatrix._33;
    r := m_screenDepth / (m_screenDepth - zMinimum);

    // Load the updated values back into the projection matrix.
    pMatrix._33 := r;
    pMatrix._43 := -r * zMinimum;
    projectionMatrix := XMLoadFloat4x4(@pMatrix);

    // Create the frustum matrix from the view matrix and updated projection matrix.
    finalMatrix := XMMatrixMultiply(viewMatrix, projectionMatrix);

    // Convert the final matrix into a 4x4 float type.
    XMStoreFloat4x4(&matrix, finalMatrix);

    // Calculate near plane of frustum.
    m_planes[0][0] := matrix._14 + matrix._13;
    m_planes[0][1] := matrix._24 + matrix._23;
    m_planes[0][2] := matrix._34 + matrix._33;
    m_planes[0][3] := matrix._44 + matrix._43;

    // Normalize the near plane.
    length := sqrt((m_planes[0][0] * m_planes[0][0]) + (m_planes[0][1] * m_planes[0][1]) + (m_planes[0][2] * m_planes[0][2]));
    m_planes[0][0] := m_planes[0][0] / length;
    m_planes[0][1] := m_planes[0][1] / length;
    m_planes[0][2] := m_planes[0][2] / length;
    m_planes[0][3] := m_planes[0][3] / length;

    // Calculate far plane of frustum.
    m_planes[1][0] := matrix._14 - matrix._13;
    m_planes[1][1] := matrix._24 - matrix._23;
    m_planes[1][2] := matrix._34 - matrix._33;
    m_planes[1][3] := matrix._44 - matrix._43;

    // Normalize the far plane.
    length := sqrt((m_planes[1][0] * m_planes[1][0]) + (m_planes[1][1] * m_planes[1][1]) + (m_planes[1][2] * m_planes[1][2]));
    m_planes[1][0] /= length;
    m_planes[1][1] /= length;
    m_planes[1][2] /= length;
    m_planes[1][3] /= length;

    // Calculate left plane of frustum.
    m_planes[2][0] := matrix._14 + matrix._11;
    m_planes[2][1] := matrix._24 + matrix._21;
    m_planes[2][2] := matrix._34 + matrix._31;
    m_planes[2][3] := matrix._44 + matrix._41;

    // Normalize the left plane.
    length := sqrt((m_planes[2][0] * m_planes[2][0]) + (m_planes[2][1] * m_planes[2][1]) + (m_planes[2][2] * m_planes[2][2]));
    m_planes[2][0] /= length;
    m_planes[2][1] /= length;
    m_planes[2][2] /= length;
    m_planes[2][3] /= length;

    // Calculate right plane of frustum.
    m_planes[3][0] := matrix._14 - matrix._11;
    m_planes[3][1] := matrix._24 - matrix._21;
    m_planes[3][2] := matrix._34 - matrix._31;
    m_planes[3][3] := matrix._44 - matrix._41;

    // Normalize the right plane.
    length := sqrt((m_planes[3][0] * m_planes[3][0]) + (m_planes[3][1] * m_planes[3][1]) + (m_planes[3][2] * m_planes[3][2]));
    m_planes[3][0] /= length;
    m_planes[3][1] /= length;
    m_planes[3][2] /= length;
    m_planes[3][3] /= length;

    // Calculate top plane of frustum.
    m_planes[4][0] := matrix._14 - matrix._12;
    m_planes[4][1] := matrix._24 - matrix._22;
    m_planes[4][2] := matrix._34 - matrix._32;
    m_planes[4][3] := matrix._44 - matrix._42;

    // Normalize the top plane.
    length := sqrt((m_planes[4][0] * m_planes[4][0]) + (m_planes[4][1] * m_planes[4][1]) + (m_planes[4][2] * m_planes[4][2]));
    m_planes[4][0] /= length;
    m_planes[4][1] /= length;
    m_planes[4][2] /= length;
    m_planes[4][3] /= length;

    // Calculate bottom plane of frustum.
    m_planes[5][0] := matrix._14 + matrix._12;
    m_planes[5][1] := matrix._24 + matrix._22;
    m_planes[5][2] := matrix._34 + matrix._32;
    m_planes[5][3] := matrix._44 + matrix._42;

    // Normalize the bottom plane.
    length := sqrt((m_planes[5][0] * m_planes[5][0]) + (m_planes[5][1] * m_planes[5][1]) + (m_planes[5][2] * m_planes[5][2]));
    m_planes[5][0] /= length;
    m_planes[5][1] /= length;
    m_planes[5][2] /= length;
    m_planes[5][3] /= length;

end;



function TFrustumClass.CheckPoint(x, y, z: single): boolean;
var
    i: integer;
    dotProduct: single;
begin
    // Check each of the six planes to make sure the point is inside all of them and hence inside the frustum.
    for i := 0 to 5 do
    begin
        // Calculate the dot product of the plane and the 3D point.
        dotProduct := (m_planes[i][0] * x) + (m_planes[i][1] * y) + (m_planes[i][2] * z) + (m_planes[i][3] * 1.0);

        // Determine if the point is on the correct side of the current plane, exit out if it is not.
        if (dotProduct <= 0.0) then
        begin
            Result := False;
            Exit;
        end;
    end;

    Result := True;
end;



function TFrustumClass.CheckCube(xCenter, yCenter, zCenter, radius: single): boolean;
var
    i: integer;
    dotProduct: single;
begin
    // Check each of the six planes to see if the cube is inside the frustum.
    for i := 0 to 5 do
    begin
        // Check all eight points of the cube to see if they all reside within the frustum.
        dotProduct := (m_planes[i][0] * (xCenter - radius)) + (m_planes[i][1] * (yCenter - radius)) +
            (m_planes[i][2] * (zCenter - radius)) + (m_planes[i][3] * 1.0);
        if (dotProduct > 0.0) then
            continue;

        dotProduct := (m_planes[i][0] * (xCenter + radius)) + (m_planes[i][1] * (yCenter - radius)) +
            (m_planes[i][2] * (zCenter - radius)) + (m_planes[i][3] * 1.0);
        if (dotProduct > 0.0) then
            continue;

        dotProduct := (m_planes[i][0] * (xCenter - radius)) + (m_planes[i][1] * (yCenter + radius)) +
            (m_planes[i][2] * (zCenter - radius)) + (m_planes[i][3] * 1.0);
        if (dotProduct > 0.0) then
            continue;

        dotProduct := (m_planes[i][0] * (xCenter + radius)) + (m_planes[i][1] * (yCenter + radius)) +
            (m_planes[i][2] * (zCenter - radius)) + (m_planes[i][3] * 1.0);
        if (dotProduct > 0.0) then
            continue;

        dotProduct := (m_planes[i][0] * (xCenter - radius)) + (m_planes[i][1] * (yCenter - radius)) +
            (m_planes[i][2] * (zCenter + radius)) + (m_planes[i][3] * 1.0);
        if (dotProduct > 0.0) then
            continue;

        dotProduct := (m_planes[i][0] * (xCenter + radius)) + (m_planes[i][1] * (yCenter - radius)) +
            (m_planes[i][2] * (zCenter + radius)) + (m_planes[i][3] * 1.0);
        if (dotProduct > 0.0) then
            continue;

        dotProduct := (m_planes[i][0] * (xCenter - radius)) + (m_planes[i][1] * (yCenter + radius)) +
            (m_planes[i][2] * (zCenter + radius)) + (m_planes[i][3] * 1.0);
        if (dotProduct > 0.0) then
            continue;

        dotProduct := (m_planes[i][0] * (xCenter + radius)) + (m_planes[i][1] * (yCenter + radius)) +
            (m_planes[i][2] * (zCenter + radius)) + (m_planes[i][3] * 1.0);
        if (dotProduct > 0.0) then
            continue;


        Result := False;
        Exit;
    end;

    Result := True;
end;



function TFrustumClass.CheckSphere(xCenter, yCenter, zCenter, radius: single): boolean;
var
    i: integer;
    dotProduct: single;
begin
    // Check the six planes to see if the sphere is inside them or not.
    for i := 0 to 5 do
    begin
        dotProduct := ((m_planes[i][0] * xCenter) + (m_planes[i][1] * yCenter) + (m_planes[i][2] * zCenter) + (m_planes[i][3] * 1.0));
        if (dotProduct <= -radius) then
        begin
            Result := False;
            Exit;
        end;
    end;

    Result := True;
end;



function TFrustumClass.CheckRectangle(xCenter, yCenter, zCenter, xSize, ySize, zSize: single): boolean;
var
    i: integer;
    dotProduct: single;
begin
    // Check each of the six planes to see if the rectangle is in the frustum or not.
    for i := 0 to 5 do
    begin
        dotProduct := (m_planes[i][0] * (xCenter - xSize)) + (m_planes[i][1] * (yCenter - ySize)) + (m_planes[i][2] * (zCenter - zSize)) +
            (m_planes[i][3] * 1.0);
        if (dotProduct >= 0.0) then
            continue;

        dotProduct := (m_planes[i][0] * (xCenter + xSize)) + (m_planes[i][1] * (yCenter - ySize)) + (m_planes[i][2] * (zCenter - zSize)) +
            (m_planes[i][3] * 1.0);
        if (dotProduct >= 0.0) then
            continue;

        dotProduct := (m_planes[i][0] * (xCenter - xSize)) + (m_planes[i][1] * (yCenter + ySize)) + (m_planes[i][2] * (zCenter - zSize)) +
            (m_planes[i][3] * 1.0);
        if (dotProduct >= 0.0) then
            continue;
        dotProduct := (m_planes[i][0] * (xCenter + xSize)) + (m_planes[i][1] * (yCenter + ySize)) + (m_planes[i][2] * (zCenter - zSize)) +
            (m_planes[i][3] * 1.0);
        if (dotProduct >= 0.0) then
            continue;

        dotProduct := (m_planes[i][0] * (xCenter - xSize)) + (m_planes[i][1] * (yCenter - ySize)) + (m_planes[i][2] * (zCenter + zSize)) +
            (m_planes[i][3] * 1.0);
        if (dotProduct >= 0.0) then
            continue;

        dotProduct := (m_planes[i][0] * (xCenter + xSize)) + (m_planes[i][1] * (yCenter - ySize)) + (m_planes[i][2] * (zCenter + zSize)) +
            (m_planes[i][3] * 1.0);
        if (dotProduct >= 0.0) then
            continue;

        dotProduct := (m_planes[i][0] * (xCenter - xSize)) + (m_planes[i][1] * (yCenter + ySize)) + (m_planes[i][2] * (zCenter + zSize)) +
            (m_planes[i][3] * 1.0);
        if (dotProduct >= 0.0) then
            continue;

        dotProduct := (m_planes[i][0] * (xCenter + xSize)) + (m_planes[i][1] * (yCenter + ySize)) + (m_planes[i][2] * (zCenter + zSize)) +
            (m_planes[i][3] * 1.0);
        if (dotProduct >= 0.0) then
            continue;

        Result := False;
        Exit;
    end;

    Result := True;
end;



function TFrustumClass.CheckRectangle2(maxWidth, maxHeight, maxDepth, minWidth, minHeight, minDepth: single): boolean;
var
    i: integer;
    dotProduct: single;
begin
    // Check if any of the 6 planes of the rectangle are inside the view frustum.
    for i := 0 to 5 do
    begin
        dotProduct := ((m_planes[i][0] * minWidth) + (m_planes[i][1] * minHeight) + (m_planes[i][2] * minDepth) + (m_planes[i][3] * 1.0));
        if (dotProduct >= 0.0) then
            continue;

        dotProduct := ((m_planes[i][0] * maxWidth) + (m_planes[i][1] * minHeight) + (m_planes[i][2] * minDepth) + (m_planes[i][3] * 1.0));
        if (dotProduct >= 0.0) then
            continue;

        dotProduct := ((m_planes[i][0] * minWidth) + (m_planes[i][1] * maxHeight) + (m_planes[i][2] * minDepth) + (m_planes[i][3] * 1.0));
        if (dotProduct >= 0.0) then
            continue;

        dotProduct := ((m_planes[i][0] * maxWidth) + (m_planes[i][1] * maxHeight) + (m_planes[i][2] * minDepth) + (m_planes[i][3] * 1.0));
        if (dotProduct >= 0.0) then
            continue;

        dotProduct := ((m_planes[i][0] * minWidth) + (m_planes[i][1] * minHeight) + (m_planes[i][2] * maxDepth) + (m_planes[i][3] * 1.0));
        if (dotProduct >= 0.0) then
            continue;

        dotProduct := ((m_planes[i][0] * maxWidth) + (m_planes[i][1] * minHeight) + (m_planes[i][2] * maxDepth) + (m_planes[i][3] * 1.0));
        if (dotProduct >= 0.0) then
            continue;

        dotProduct := ((m_planes[i][0] * minWidth) + (m_planes[i][1] * maxHeight) + (m_planes[i][2] * maxDepth) + (m_planes[i][3] * 1.0));
        if (dotProduct >= 0.0) then
            continue;

        dotProduct := ((m_planes[i][0] * maxWidth) + (m_planes[i][1] * maxHeight) + (m_planes[i][2] * maxDepth) + (m_planes[i][3] * 1.0));
        if (dotProduct >= 0.0) then
            continue;

        Result := False;
        Exit;
    end;

    Result := True;
end;

end.
