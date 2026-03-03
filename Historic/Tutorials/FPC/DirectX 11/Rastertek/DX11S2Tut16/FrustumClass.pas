unit FrustumClass;

{$mode DelphiUnicode}{$H+}

interface

uses
    Classes, SysUtils, Windows,
    DirectX.Math,
    DX12.D3DX11,
    DX12.D3DX10;

type

    { TFrustumClass }

    TFrustumClass = class(TObject)
    private
        m_planes: array [0..5] of TXMVECTOR;
    public
        constructor Create;
        destructor Destroy; override;

        procedure ConstructFrustum(screenDepth: single; projectionMatrix, viewMatrix: TXMMATRIX);
        function CheckPoint(x, y, z: single): boolean;
        function CheckCube(xCenter, yCenter, zCenter, radius: single): boolean;
        function CheckSphere(xCenter, yCenter, zCenter, radius: single): boolean;
        function CheckRectangle(xCenter, yCenter, zCenter, xSize, ySize, zSize: single): boolean;

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



procedure TFrustumClass.ConstructFrustum(screenDepth: single; projectionMatrix, viewMatrix: TXMMATRIX);
var
    zMinimum, r: single;
    matrix: TXMMATRIX;
begin

    // Calculate the minimum Z distance in the frustum.
    zMinimum := -projectionMatrix._43 / projectionMatrix._33;
    r := screenDepth / (screenDepth - zMinimum);
    projectionMatrix._33 := r;
    projectionMatrix._43 := -r * zMinimum;

    // Create the frustum matrix from the view matrix and updated projection matrix.
    matrix := XMMatrixMultiply(viewMatrix, projectionMatrix);

    // Calculate near plane of frustum.
    m_planes[0].a := matrix._14 + matrix._13;
    m_planes[0].b := matrix._24 + matrix._23;
    m_planes[0].c := matrix._34 + matrix._33;
    m_planes[0].d := matrix._44 + matrix._43;
    m_planes[0] := XMPlaneNormalize(m_planes[0]);

    // Calculate far plane of frustum.
    m_planes[1].a := matrix._14 - matrix._13;
    m_planes[1].b := matrix._24 - matrix._23;
    m_planes[1].c := matrix._34 - matrix._33;
    m_planes[1].d := matrix._44 - matrix._43;
    m_planes[1] := XMPlaneNormalize(m_planes[1]);


    // Calculate left plane of frustum.
    m_planes[2].a := matrix._14 + matrix._11;
    m_planes[2].b := matrix._24 + matrix._21;
    m_planes[2].c := matrix._34 + matrix._31;
    m_planes[2].d := matrix._44 + matrix._41;
    m_planes[2] := XMPlaneNormalize(m_planes[2]);

    // Calculate right plane of frustum.
    m_planes[3].a := matrix._14 - matrix._11;
    m_planes[3].b := matrix._24 - matrix._21;
    m_planes[3].c := matrix._34 - matrix._31;
    m_planes[3].d := matrix._44 - matrix._41;
    m_planes[3] := XMPlaneNormalize(m_planes[3]);


    // Calculate top plane of frustum.
    m_planes[4].a := matrix._14 - matrix._12;
    m_planes[4].b := matrix._24 - matrix._22;
    m_planes[4].c := matrix._34 - matrix._32;
    m_planes[4].d := matrix._44 - matrix._42;
    m_planes[4] := XMPlaneNormalize(m_planes[4]);


    // Calculate bottom plane of frustum.
    m_planes[5].a := matrix._14 + matrix._12;
    m_planes[5].b := matrix._24 + matrix._22;
    m_planes[5].c := matrix._34 + matrix._32;
    m_planes[5].d := matrix._44 + matrix._42;
    m_planes[5] := XMPlaneNormalize(m_planes[5]);
end;



function TFrustumClass.CheckPoint(x, y, z: single): boolean;
var
     i:integer;
begin



	// Check if the point is inside all six planes of the view frustum.
	for i:=0 to 5 do
	begin
                XMPlaneDotCoord();
		if(D3DXPlaneDotCoord(&m_planes[i], &D3DXVECTOR3(x, y, z)) < 0.0f)
		begin
			return false;
		end;
	end;

	return true;
end;



function TFrustumClass.CheckCube(xCenter, yCenter, zCenter, radius: single): boolean;
begin

end;



function TFrustumClass.CheckSphere(xCenter, yCenter, zCenter, radius: single): boolean;
begin

end;



function TFrustumClass.CheckRectangle(xCenter, yCenter, zCenter, xSize, ySize, zSize: single): boolean;
begin

end;

end.
