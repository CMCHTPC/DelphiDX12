unit DirectX.Collision;
//-------------------------------------------------------------------------------------
// DirectXCollision.h -- C++ Collision Math library

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID:=615560
//-------------------------------------------------------------------------------------

{$IFDEF FPC}
{$mode delphi}{$H+}
{$modeswitch advancedrecords}
{$ENDIF}

interface

uses
    Classes, SysUtils,
    DirectX.Math;

const
    BoundingBox_CORNER_COUNT = 8;
    BoundingOrientedBox_CORNER_COUNT = 8;
    BoundingFrustum_CORNER_COUNT = 8;

type

    TContainmentType = (
        ctDISJOINT = 0,
        ctINTERSECTS = 1,
        ctCONTAINS = 2
        );

    TPlaneIntersectionType = (
        piFRONT = 0,
        piINTERSECTING = 1,
        piBACK = 2
        );

    PBoundingSphere = ^TBoundingSphere;
    PBoundingBox = ^TBoundingBox;
    PBoundingOrientedBox = ^TBoundingOrientedBox;
    PBoundingFrustum = ^TBoundingFrustum;


    //-------------------------------------------------------------------------------------
    // Bounding sphere
    //-------------------------------------------------------------------------------------

    { TBoundingSphere }
    TBoundingSphere = record
        Center: TXMFLOAT3;            // Center of the sphere.
        Radius: single;               // Radius of the sphere.
        // Creators
        class operator Initialize(var t: TBoundingSphere);
        constructor Create(ACenter: TXMFLOAT3; ARadius: single);

        // Methods
        procedure Transform( _out: PBoundingSphere; M: TFXMMATRIX); overload;
        procedure Transform(_Out: PBoundingSphere; Scale: single; Rotation: TFXMVECTOR; Translation: TFXMVECTOR); overload;
        // Transform the sphere
        function Contains(Point: TFXMVECTOR): TContainmentType; overload;
        function Contains(V0: TFXMVECTOR; V1: TFXMVECTOR; V2: TFXMVECTOR): TContainmentType; overload;
        function Contains(sh: PBoundingSphere): TContainmentType; overload;
        function Contains(box: PBoundingBox): TContainmentType; overload;
        function Contains(box: PBoundingOrientedBox): TContainmentType; overload;
        function Contains(fr: PBoundingFrustum): TContainmentType; overload;
        function Intersects(sh: PBoundingSphere): boolean; overload;
        function Intersects(box: PBoundingBox): boolean; overload;
        function Intersects(box: PBoundingOrientedBox): boolean; overload;
        function Intersects(fr: PBoundingFrustum): boolean; overload;
        // Triangle-sphere test
        function Intersects(V0, V1, V2: TFXMVECTOR): boolean; overload;
        // Plane-sphere test
        function Intersects(Plane: TFXMVECTOR): TPlaneIntersectionType; overload;
        // Ray-sphere test
        function Intersects(Origin, Direction: TFXMVECTOR; var Dist: single): boolean; overload;

        // Test sphere against six planes (see TBoundingFrustum.GetPlanes)
        function ContainedBy(Plane0, Plane1, Plane2: TFXMVECTOR; Plane3: TGXMVECTOR; Plane4: THXMVECTOR; Plane5: THXMVECTOR): TContainmentType;
        // Static methods
        procedure CreateMerged(_Out: PBoundingSphere; S1, S2: PBoundingSphere);
        procedure CreateFromBoundingBox(_Out: PBoundingSphere; box: PBoundingBox); overload;
        procedure CreateFromBoundingBox(_Out: PBoundingSphere; box: PBoundingOrientedBox); overload;
        procedure CreateFromPoints(_Out: PBoundingSphere; Count: size_t;
        {sizeof(TXMFLOAT3) + Stride * (Count - 1))}const pPoints: PXMFLOAT3; Stride: size_t);
        procedure CreateFromFrustum(_Out: PBoundingSphere; fr: PBoundingFrustum);
    end;

    //-------------------------------------------------------------------------------------
    // Axis-aligned bounding box
    //-------------------------------------------------------------------------------------

    { TBoundingBox }

    TBoundingBox = record
        Center: TXMFLOAT3;            // Center of the box.
        Extents: TXMFLOAT3;           // Distance from the center to each side.
        // Creators
        class operator Initialize(var t: TBoundingBox);
        constructor Create(const ACenter: TXMFLOAT3; const AExtents: TXMFLOAT3);

        // Methods
        procedure Transform(_Out: PBoundingBox; M: TFXMMATRIX); overload;
        procedure Transform(_Out: PBoundingBox; Scale: single; Rotation, Translation: TFXMVECTOR); overload;
        // Gets the 8 corners of the box
        procedure GetCorners(var Corners: array of TXMFLOAT3);

        function Contains(Point: TFXMVECTOR): TContainmentType; overload;
        function Contains(V0, V1, V2: TFXMVECTOR): TContainmentType; overload;
        function Contains(sh: PBoundingSphere): TContainmentType; overload;
        function Contains(box: PBoundingBox): TContainmentType; overload;
        function Contains(box: PBoundingOrientedBox): TContainmentType; overload;
        function Contains(fr: PBoundingFrustum): TContainmentType; overload;

        function Intersects(sh: PBoundingSphere): boolean; overload;
        function Intersects(box: PBoundingBox): boolean; overload;
        function Intersects(box: PBoundingOrientedBox): boolean; overload;
        function Intersects(fr: PBoundingFrustum): boolean; overload;

        // Triangle-Box test
        function Intersects(V0, V1, V2: TFXMVECTOR): boolean; overload;

        // Plane-box test
        function Intersects(Plane: TFXMVECTOR): TPlaneIntersectionType; overload;

        // Ray-Box test
        function Intersects(Origin, Direction: TFXMVECTOR; var Dist: single): boolean; overload;

        // Test box against six planes (see TBoundingFrustum.GetPlanes)
        function ContainedBy(Plane0, Plane1, Plane2: TFXMVECTOR; Plane3: TGXMVECTOR; Plane4, Plane5: THXMVECTOR): TContainmentType;

        // Static methods
        procedure CreateMerged(_Out: PBoundingBox; b1, b2: PBoundingBox);
        procedure CreateFromSphere(_Out: PBoundingBox; sh: PBoundingSphere);
        procedure CreateFromPoints(_Out: PBoundingBox; pt1, pt2: TFXMVECTOR); overload;
        procedure CreateFromPoints(_Out: PBoundingBox; Count: size_t; constref pPoints: PXMFLOAT3; Stride: size_t); overload;
    end;

    //-------------------------------------------------------------------------------------
    // Oriented bounding box
    //-------------------------------------------------------------------------------------

    { TBoundingOrientedBox }

    TBoundingOrientedBox = record
        Center: TXMFLOAT3;            // Center of the box.
        Extents: TXMFLOAT3;           // Distance from the center to each side.
        Orientation: TXMFLOAT4;       // Unit quaternion representing rotation (box -> world).
        // Creators
        class operator Initialize(var t: TBoundingOrientedBox);
        constructor Create(constref ACenter: TXMFLOAT3; constref AExtents: TXMFLOAT3; constref AOrientation: TXMFLOAT4);

        // Methods
        procedure Transform(var _Out: TBoundingOrientedBox; M: TFXMMATRIX); overload;
        procedure Transform(var _Out: TBoundingOrientedBox; Scale: single; Rotation, Translation: TFXMVECTOR); overload;
        // Gets the 8 corners of the box
        procedure GetCorners(var Corners: array of TXMFLOAT3);

        function Contains(Point: TFXMVECTOR): TContainmentType; overload;
        function Contains(V0, V1, V2: TFXMVECTOR): TContainmentType; overload;
        function Contains(sh: PBoundingSphere): TContainmentType; overload;
        function Contains(box: PBoundingBox): TContainmentType; overload;
        function Contains(box: PBoundingOrientedBox): TContainmentType; overload;
        function Contains(fr: PBoundingFrustum): TContainmentType; overload;

        function Intersects(sh: PBoundingSphere): boolean; overload;
        function Intersects(box: PBoundingBox): boolean; overload;
        function Intersects(box: PBoundingOrientedBox): boolean; overload;
        function Intersects(fr: PBoundingFrustum): boolean; overload;
        // Triangle-OrientedBox test
        function Intersects(V0, V1, V2: TFXMVECTOR): boolean; overload;
        // Plane-OrientedBox test
        function Intersects(Plane: TFXMVECTOR): TPlaneIntersectionType; overload;
        // Ray-OrientedBox test
        function Intersects(Origin, Direction: TFXMVECTOR; var Dist: single): boolean; overload;
        // Test OrientedBox against six planes (see TBoundingFrustum.GetPlanes)
        function ContainedBy(Plane0, Plane1, Plane2: TFXMVECTOR; Plane3: TGXMVECTOR; Plane4, Plane5: THXMVECTOR): TContainmentType;
        // Static methods
        procedure CreateFromBoundingBox(_Out: PBoundingOrientedBox; box: PBoundingBox);
        procedure CreateFromPoints(_Out: PBoundingOrientedBox; Count: size_t; constref pPoints: PXMFLOAT3; Stride: size_t);
    end;

    //-------------------------------------------------------------------------------------
    // Bounding frustum
    //-------------------------------------------------------------------------------------

    { TBoundingFrustum }

    TBoundingFrustum = record
        Origin: TXMFLOAT3;            // Origin of the frustum (and projection).
        Orientation: TXMFLOAT4;       // Quaternion representing rotation.

        RightSlope: single;           // Positive X (X/Z)
        LeftSlope: single;            // Negative X
        TopSlope: single;             // Positive Y (Y/Z)
        BottomSlope: single;          // Negative Y
        _Near, _Far: single;            // Z of the near plane and far plane.
        // Creators
        class operator Initialize(var t: TBoundingFrustum);
        constructor Create(constref _Origin: TXMFLOAT3; constref _Orientation: TXMFLOAT4; _RightSlope, _LeftSlope, _TopSlope, _BottomSlope, NearPlane, FarPlane: single); overload;
        constructor Create(Projection: TCXMMATRIX; rhcoords: boolean = False); overload;
        // Static methods
        procedure CreateFromMatrix(_Out: PBoundingFrustum; Projection: TFXMMATRIX; rhcoords: boolean = False);

        // Methods
        procedure Transform(_Out: PBoundingFrustum; M: TFXMMATRIX); overload;
        procedure Transform(_Out: PBoundingFrustum; Scale: single; Rotation, Translation: TFXMVECTOR); overload;
        // Gets the 8 corners of the frustum
        procedure GetCorners(var Corners: array of TXMFLOAT3);

        function Contains(Point: TFXMVECTOR): TContainmentType; overload;
        function Contains(V0, V1, V2: TFXMVECTOR): TContainmentType; overload;
        function Contains(sh: PBoundingSphere): TContainmentType; overload;
        function Contains(box: PBoundingBox): TContainmentType; overload;
        function Contains(box: PBoundingOrientedBox): TContainmentType; overload;
        // Frustum-Frustum test
        function Contains(fr: PBoundingFrustum): TContainmentType; overload;

        function Intersects(sh: PBoundingSphere): boolean; overload;
        function Intersects(box: PBoundingBox): boolean; overload;
        function Intersects(box: PBoundingOrientedBox): boolean; overload;
        function Intersects(fr: PBoundingFrustum): boolean; overload;
        // Triangle-Frustum test
        function Intersects(V0, V1, V2: TFXMVECTOR): boolean; overload;
        // Plane-Frustum test
        function Intersects(Plane: TFXMVECTOR): TPlaneIntersectionType; overload;
        // Ray-Frustum test
        function Intersects(rayOrigin, Direction: TFXMVECTOR; var Dist: single): boolean; overload;
        // Test frustum against six planes (see TBoundingFrustum.GetPlanes)
        function ContainedBy(Plane0, Plane1, Plane2: TFXMVECTOR; Plane3: TGXMVECTOR; Plane4, Plane5: THXMVECTOR): TContainmentType;
        // Create 6 Planes representation of Frustum
        procedure GetPlanes(var NearPlane, FarPlane, RightPlane, LeftPlane, TopPlane, BottomPlane: TXMVECTOR);
    end;


//-----------------------------------------------------------------------------
// Triangle intersection testing routines.
//-----------------------------------------------------------------------------

// Ray-Triangle
function TriangleTests_Intersects(Origin, Direction, V0: TFXMVECTOR; V1: TGXMVECTOR; V2: THXMVECTOR; var Dist: single): boolean; overload;
// Triangle-Triangle
function TriangleTests_Intersects(A0, A1, A2: TFXMVECTOR; B0: TGXMVECTOR; B1, B2: THXMVECTOR): boolean; overload;
// Plane-Triangle
function TriangleTests_Intersects(V0, V1, V2: TFXMVECTOR; Plane: TGXMVECTOR): TPlaneIntersectionType; overload;
// Test a triangle against six planes at once (see TBoundingFrustum.GetPlanes)
function TriangleTests_ContainedBy(V0, V1, V2: TFXMVECTOR; Plane0: TGXMVECTOR; Plane1, Plane2: THXMVECTOR; Plane3, Plane4, Plane5: TCXMVECTOR): TContainmentType;

implementation

uses
    Math;

const
    FLT_MAX = 3.402823466e+38;


    g_BoxOffset: array[0..7] of TXMVECTOR =
        ((f: (-1.0, -1.0, 1.0, 0.0)),
        (f: (1.0, -1.0, 1.0, 0.0)),
        (f: (1.0, 1.0, 1.0, 0.0)),
        (f: (-1.0, 1.0, 1.0, 0.0)),
        (f: (-1.0, -1.0, -1.0, 0.0)),
        (f: (1.0, -1.0, -1.0, 0.0)),
        (f: (1.0, 1.0, -1.0, 0.0)),
        (f: (-1.0, 1.0, -1.0, 0.0)));


    g_RayEpsilon: TXMVECTOR = (f: (1e-20, 1e-20, 1e-20, 1e-20));
    g_RayNegEpsilon: TXMVECTOR = (f: (-1e-20, -1e-20, -1e-20, -1e-20));
    g_FltMin: TXMVECTOR = (f: (-FLT_MAX, -FLT_MAX, -FLT_MAX, -FLT_MAX));
    g_FltMax: TXMVECTOR = (f: (FLT_MAX, FLT_MAX, FLT_MAX, FLT_MAX));


    g_UnitVectorEpsilon: TXMVECTOR = (f: (1.0e-4, 1.0e-4, 1.0e-4, 1.0e-4));
    g_UnitQuaternionEpsilon: TXMVECTOR = (f: (1.0e-4, 1.0e-4, 1.0e-4, 1.0e-4));
    g_UnitPlaneEpsilon: TXMVECTOR = (f: (1.0e-4, 1.0e-4, 1.0e-4, 1.0e-4));

//-----------------------------------------------------------------------------
// Return true if any of the elements of a 3 vector are equal to 0xffffffff.
// Slightly more efficient than using XMVector3EqualInt.
//-----------------------------------------------------------------------------
function XMVector3AnyTrue(V: TFXMVECTOR): boolean;
var
    c: TXMVECTOR;
begin
    // Duplicate the fourth element from the first element.
    C := XMVectorSwizzle(XM_SWIZZLE_X, XM_SWIZZLE_Y, XM_SWIZZLE_Z, XM_SWIZZLE_X, V);
    Result := XMComparisonAnyTrue(XMVector4EqualIntR(C, XMVectorTrueInt()));
end;

//-----------------------------------------------------------------------------
// Return true if all of the elements of a 3 vector are equal to 0xffffffff.
// Slightly more efficient than using XMVector3EqualInt.
//-----------------------------------------------------------------------------
function XMVector3AllTrue(V: TFXMVECTOR): boolean;
var
    C: TXMVECTOR;
begin
    // Duplicate the fourth element from the first element.
    C := XMVectorSwizzle(XM_SWIZZLE_X, XM_SWIZZLE_Y, XM_SWIZZLE_Z, XM_SWIZZLE_X, V);
    Result := XMComparisonAllTrue(XMVector4EqualIntR(C, XMVectorTrueInt()));
end;

//-----------------------------------------------------------------------------
// Return true if the vector is a unit vector (length == 1).
//-----------------------------------------------------------------------------
function XMVector3IsUnit(V: TFXMVECTOR): boolean;
var
    Difference: TXMVECTOR;
begin
    Difference := XMVectorSubtract(XMVector3Length(V), XMVectorSplatOne());
    Result := XMVector4Less(XMVectorAbs(Difference), g_UnitVectorEpsilon);
end;

//-----------------------------------------------------------------------------
// Return true if the quaterion is a unit quaternion.
//-----------------------------------------------------------------------------
function XMQuaternionIsUnit(Q: TFXMVECTOR): boolean;
var
    Difference: TXMVECTOR;
begin
    Difference := XMVectorSubtract(XMVector4Length(Q), XMVectorSplatOne());
    Result := XMVector4Less(XMVectorAbs(Difference), g_UnitQuaternionEpsilon);
end;

//-----------------------------------------------------------------------------
// Return true if the plane is a unit plane.
//-----------------------------------------------------------------------------
function XMPlaneIsUnit(Plane: TFXMVECTOR): boolean;
var
    Difference: TXMVECTOR;
begin
    Difference := XMVectorSubtract(XMVector3Length(Plane), XMVectorSplatOne());
    Result := XMVector4Less(XMVectorAbs(Difference), g_UnitPlaneEpsilon);
end;



//-----------------------------------------------------------------------------
function XMPlaneTransform(Plane, Rotation, Translation: TFXMVECTOR): TXMVECTOR;
var
    vNormal, vD: TXMVECTOR;
begin
    vNormal := XMVector3Rotate(Plane, Rotation);
    vD := XMVectorSubtract(XMVectorSplatW(Plane), XMVector3Dot(vNormal, Translation));

    Result := XMVectorInsert(0, 0, 0, 0, 1, vNormal, vD);
end;

//-----------------------------------------------------------------------------
// Return the point on the line segement (S1, S2) nearest the point P.
//-----------------------------------------------------------------------------
function PointOnLineSegmentNearestPoint(S1, S2, P: TFXMVECTOR): TXMVECTOR;
var
    Dir, Projection, LengthSq, t, Point: TXMVECTOR;
    SelectS1, SelectS2: TXMVECTOR;
begin
    Dir := XMVectorSubtract(S2, S1);
    Projection := XMVectorSubtract(XMVector3Dot(P, Dir), XMVector3Dot(S1, Dir));
    LengthSq := XMVector3Dot(Dir, Dir);

    t := XMVectorMultiply(Projection, XMVectorReciprocal(LengthSq));
    Point := XMVectorMultiplyAdd(t, Dir, S1);

    // t < 0
    SelectS1 := XMVectorLess(Projection, XMVectorZero());
    Point := XMVectorSelect(Point, S1, SelectS1);

    // t > 1
    SelectS2 := XMVectorGreater(Projection, LengthSq);
    Point := XMVectorSelect(Point, S2, SelectS2);

    Result := Point;
end;

//-----------------------------------------------------------------------------
// Test if the point (P) on the plane of the triangle is inside the triangle
// (V0, V1, V2).
//-----------------------------------------------------------------------------
function PointOnPlaneInsideTriangle(P, V0, V1: TFXMVECTOR; V2: TGXMVECTOR): TXMVECTOR;
var
    N, C0, C1, C2: TXMVECTOR;
    Zero, Inside0, Inside1, Inside2: TXMVECTOR;
begin
    // Compute the triangle normal.
    N := XMVector3Cross(XMVectorSubtract(V2, V0), XMVectorSubtract(V1, V0));

    // Compute the cross products of the vector from the base of each edge to
    // the point with each edge vector.
    C0 := XMVector3Cross(XMVectorSubtract(P, V0), XMVectorSubtract(V1, V0));
    C1 := XMVector3Cross(XMVectorSubtract(P, V1), XMVectorSubtract(V2, V1));
    C2 := XMVector3Cross(XMVectorSubtract(P, V2), XMVectorSubtract(V0, V2));

    // If the cross product points in the same direction as the normal the the
    // point is inside the edge (it is zero if is on the edge).
    Zero := XMVectorZero();
    Inside0 := XMVectorGreaterOrEqual(XMVector3Dot(C0, N), Zero);
    Inside1 := XMVectorGreaterOrEqual(XMVector3Dot(C1, N), Zero);
    Inside2 := XMVectorGreaterOrEqual(XMVector3Dot(C2, N), Zero);

    // If the point inside all of the edges it is inside.
    Result := XMVectorAndInt(XMVectorAndInt(Inside0, Inside1), Inside2);
end;




//-----------------------------------------------------------------------------
function SolveCubic(e, f, g: single; out t, u, v: single): boolean;
var
    p, q, h, rc, d, theta, costh3, sinth3: single;
begin
    p := f - e * e / 3.0;
    q := g - e * f / 3.0 + e * e * e * 2.0 / 27.0;
    h := q * q / 4.0 + p * p * p / 27.0;

    if (h > 0) then
    begin
        t := 0.0;
        u := 0.0;
        v := 0.0;
        Result := False; // only one real root
        Exit;
    end;

    if ((h = 0) and (q = 0)) then // all the same root
    begin
        t := -e / 3;
        u := -e / 3;
        v := -e / 3;

        Result := True;
        Exit;
    end;

    d := sqrt(q * q / 4.0 - h);
    if (d < 0) then
        rc := -power(-d, 1.0 / 3.0)
    else
        rc := power(d, 1.0 / 3.0);

    theta := XMScalarACos(-q / (2.0 * d));
    costh3 := XMScalarCos(theta / 3.0);
    sinth3 := sqrt(3.0) * XMScalarSin(theta / 3.0);
    t := 2.0 * rc * costh3 - e / 3.0;
    u := -rc * (costh3 + sinth3) - e / 3.0;
    v := -rc * (costh3 - sinth3) - e / 3.0;

    Result := True;
end;

//-----------------------------------------------------------------------------

function CalculateEigenVector(m11, m12, m13, m22, m23, m33, e: single): TXMVECTOR;
var
    fTmp: array[0..2] of single;
    vTmp: TXMVECTOR;
var
    f1, f2, f3: single;
begin

    fTmp[0] := m12 * m23 - m13 * (m22 - e);
    fTmp[1] := m13 * m12 - m23 * (m11 - e);
    fTmp[2] := (m11 - e) * (m22 - e) - m12 * m12;

    vTmp := XMLoadFloat3(TXMFLOAT3(fTmp));

    if (XMVector3Equal(vTmp, XMVectorZero())) then // planar or linear

    begin

        // we only have one equation - find a valid one
        if ((m11 - e <> 0) or (m12 <> 0) or (m13 <> 0)) then
        begin
            f1 := m11 - e;
            f2 := m12;
            f3 := m13;
        end
        else if ((m12 <> 0) or (m22 - e <> 0) or (m23 <> 0)) then
        begin
            f1 := m12;
            f2 := m22 - e;
            f3 := m23;
        end
        else if ((m13 <> 0) or (m23 <> 0) or (m33 - e <> 0)) then
        begin
            f1 := m13;
            f2 := m23;
            f3 := m33 - e;
        end
        else
        begin
            // error, we'll just make something up - we have NO context
            f1 := 1.0;
            f2 := 0.0;
            f3 := 0.0;
        end;

        if (f1 = 0) then
            vTmp := XMVectorSetX(vTmp, 0.0)
        else
            vTmp := XMVectorSetX(vTmp, 1.0);

        if (f2 = 0) then
            vTmp := XMVectorSetY(vTmp, 0.0)
        else
            vTmp := XMVectorSetY(vTmp, 1.0);

        if (f3 = 0) then
        begin
            vTmp := XMVectorSetZ(vTmp, 0.0);
            // recalculate y to make equation work
            if (m12 <> 0) then
                vTmp := XMVectorSetY(vTmp, -f1 / f2);
        end
        else
        begin
            vTmp := XMVectorSetZ(vTmp, (f2 - f1) / f3);
        end;
    end;

    if (XMVectorGetX(XMVector3LengthSq(vTmp)) > 1e-5) then
    begin
        Result := XMVector3Normalize(vTmp);
    end
    else
    begin
        // Multiply by a value large enough to make the vector non-zero.
        vTmp := XMVectorScale(vTmp, 1e5);
        Result := XMVector3Normalize(vTmp);
    end;
end;

//-----------------------------------------------------------------------------

function CalculateEigenVectors(m11, m12, m13, m22, m23, m33, e1, e2, e3: single; var pV1, pV2, pV3: TXMVECTOR): boolean;
var
    v1z, v2z, v3z: boolean;
    Zero: TXMVECTOR;
    e12, e13, e23: boolean;
    vTmp: TXMVECTOR;
begin
    pV1 := CalculateEigenVector(m11, m12, m13, m22, m23, m33, e1);
    pV2 := CalculateEigenVector(m11, m12, m13, m22, m23, m33, e2);
    pV3 := CalculateEigenVector(m11, m12, m13, m22, m23, m33, e3);

    v1z := False;
    v2z := False;
    v3z := False;

    Zero := XMVectorZero();

    if (XMVector3Equal(pV1, Zero)) then
        v1z := True;

    if (XMVector3Equal(pV2, Zero)) then
        v2z := True;

    if (XMVector3Equal(pV3, Zero)) then
        v3z := True;

    e12 := (abs(XMVectorGetX(XMVector3Dot(pV1, pV2))) > 0.1); // check for non-orthogonal vectors
    e13 := (abs(XMVectorGetX(XMVector3Dot(pV1, pV3))) > 0.1);
    e23 := (abs(XMVectorGetX(XMVector3Dot(pV2, pV3))) > 0.1);

    if ((v1z and v2z and v3z) or (e12 and e13 and e23) or (e12 and v3z) or (e13 and v2z) or (e23 and v1z)) then
        // all eigenvectors are 0- any basis set
    begin
        pV1 := g_XMIdentityR0;
        pV2 := g_XMIdentityR1;
        pV3 := g_XMIdentityR2;
        Result := True;
        Exit;
    end;

    if (v1z and v2z) then
    begin

        vTmp := XMVector3Cross(g_XMIdentityR1, pV3);
        if (XMVectorGetX(XMVector3LengthSq(vTmp)) < 1e-5) then
        begin
            vTmp := XMVector3Cross(g_XMIdentityR0, pV3);
        end;
        pV1 := XMVector3Normalize(vTmp);
        pV2 := XMVector3Cross(pV3, pV1);
        Result := True;
        Exit;
    end;

    if (v3z and v1z) then
    begin
        vTmp := XMVector3Cross(g_XMIdentityR1, pV2);
        if (XMVectorGetX(XMVector3LengthSq(vTmp)) < 1e-5) then
        begin
            vTmp := XMVector3Cross(g_XMIdentityR0, pV2);
        end;
        pV3 := XMVector3Normalize(vTmp);
        pV1 := XMVector3Cross(pV2, pV3);
        Result := True;
        Exit;
    end;

    if (v2z and v3z) then
    begin
        vTmp := XMVector3Cross(g_XMIdentityR1, pV1);
        if (XMVectorGetX(XMVector3LengthSq(vTmp)) < 1e-5) then
        begin
            vTmp := XMVector3Cross(g_XMIdentityR0, pV1);
        end;
        pV2 := XMVector3Normalize(vTmp);
        pV3 := XMVector3Cross(pV1, pV2);
        Result := True;
        Exit;
    end;

    if ((v1z) or e12) then
    begin
        pV1 := XMVector3Cross(pV2, pV3);
        Result := True;
        Exit;
    end;

    if ((v2z) or e23) then
    begin
        pV2 := XMVector3Cross(pV3, pV1);
        Result := True;
        Exit;
    end;

    if ((v3z) or e13) then
    begin
        pV3 := XMVector3Cross(pV1, pV2);
        Result := True;
        Exit;
    end;

    Result := True;
end;

//-----------------------------------------------------------------------------

function CalculateEigenVectorsFromCovarianceMatrix(Cxx, Cyy, Czz, Cxy, Cxz, Cyz: single; var pV1, pV2, pV3: TXMVECTOR): boolean;
var
    e, f, g: single;
    ev1, ev2, ev3: single;
begin
    // Calculate the eigenvalues by solving a cubic equation.
    e := -(Cxx + Cyy + Czz);
    f := Cxx * Cyy + Cyy * Czz + Czz * Cxx - Cxy * Cxy - Cxz * Cxz - Cyz * Cyz;
    g := Cxy * Cxy * Czz + Cxz * Cxz * Cyy + Cyz * Cyz * Cxx - Cxy * Cyz * Cxz * 2.0 - Cxx * Cyy * Czz;


    if (not SolveCubic(e, f, g, ev1, ev2, ev3)) then
    begin
        // set them to arbitrary orthonormal basis set
        pV1 := g_XMIdentityR0;
        pV2 := g_XMIdentityR1;
        pV3 := g_XMIdentityR2;
        Result := False;
        Exit;
    end;

    Result := CalculateEigenVectors(Cxx, Cxy, Cxz, Cyy, Cyz, Czz, ev1, ev2, ev3, pV1, pV2, pV3);
end;


//-----------------------------------------------------------------------------
procedure FastIntersectTrianglePlane(V0, V1, V2: TFXMVECTOR; Plane: TGXMVECTOR; var Outside, Inside: TXMVECTOR);
var
    Dist0, Dist1, Dist2: TXMVECTOR;
    MinDist, MaxDist: TXMVECTOR;
    Zero: TXMVECTOR;
begin
    // Plane0
    Dist0 := XMVector4Dot(V0, Plane);
    Dist1 := XMVector4Dot(V1, Plane);
    Dist2 := XMVector4Dot(V2, Plane);

    MinDist := XMVectorMin(Dist0, Dist1);
    MinDist := XMVectorMin(MinDist, Dist2);

    MaxDist := XMVectorMax(Dist0, Dist1);
    MaxDist := XMVectorMax(MaxDist, Dist2);

    Zero := XMVectorZero();

    // Outside the plane?
    Outside := XMVectorGreater(MinDist, Zero);

    // Fully inside the plane?
    Inside := XMVectorLess(MaxDist, Zero);
end;

//-----------------------------------------------------------------------------

procedure FastIntersectSpherePlane(Center, Radius, Plane: TFXMVECTOR; var Outside, Inside: TXMVECTOR);
var
    Dist: TXMVECTOR;
begin
    Dist := XMVector4Dot(Center, Plane);

    // Outside the plane?
    Outside := XMVectorGreater(Dist, Radius);

    // Fully inside the plane?
    Inside := XMVectorLess(Dist, XMVectorNegate(Radius));
end;

//-----------------------------------------------------------------------------

procedure FastIntersectAxisAlignedBoxPlane(Center, Extents, Plane: TFXMVECTOR; var Outside, Inside: TXMVECTOR);
var
    Dist: TXMVECTOR;
    Radius: TXMVECTOR;
begin
    // Compute the distance to the center of the box.
    Dist := XMVector4Dot(Center, Plane);

    // Project the axes of the box onto the normal of the plane.  Half the
    // length of the projection (sometime called the "radius") is equal to
    // h(u) * abs(n dot b(u))) + h(v) * abs(n dot b(v)) + h(w) * abs(n dot b(w))
    // where h(i) are extents of the box, n is the plane normal, and b(i) are the
    // axes of the box. In this case b(i) := [(1,0,0), (0,1,0), (0,0,1)].
    Radius := XMVector3Dot(Extents, XMVectorAbs(Plane));

    // Outside the plane?
    Outside := XMVectorGreater(Dist, Radius);

    // Fully inside the plane?
    Inside := XMVectorLess(Dist, XMVectorNegate(Radius));
end;

//-----------------------------------------------------------------------------

procedure FastIntersectOrientedBoxPlane(Center, Extents, Axis0: TFXMVECTOR; Axis1: TGXMVECTOR; Axis2, Plane: THXMVECTOR; var Outside, Inside: TXMVECTOR);
var
    Dist: TXMVECTOR;
    Radius: TXMVECTOR;
begin
    // Compute the distance to the center of the box.
    Dist := XMVector4Dot(Center, Plane);

    // Project the axes of the box onto the normal of the plane.  Half the
    // length of the projection (sometime called the "radius") is equal to
    // h(u) * abs(n dot b(u))) + h(v) * abs(n dot b(v)) + h(w) * abs(n dot b(w))
    // where h(i) are extents of the box, n is the plane normal, and b(i) are the
    // axes of the box.
    Radius := XMVector3Dot(Plane, Axis0);
    Radius := XMVectorInsert(0, 0, 1, 0, 0, Radius, XMVector3Dot(Plane, Axis1));
    Radius := XMVectorInsert(0, 0, 0, 1, 0, Radius, XMVector3Dot(Plane, Axis2));
    Radius := XMVector3Dot(Extents, XMVectorAbs(Radius));

    // Outside the plane?
    Outside := XMVectorGreater(Dist, Radius);

    // Fully inside the plane?
    Inside := XMVectorLess(Dist, XMVectorNegate(Radius));
end;

//-----------------------------------------------------------------------------

procedure FastIntersectFrustumPlane(Point0, Point1, Point2: TFXMVECTOR; Point3: TGXMVECTOR; Point4, Point5: THXMVECTOR; Point6, Point7, Plane: TCXMVECTOR; var Outside, Inside: TXMVECTOR);
var
    Min, Max, Dist: TXMVECTOR;
    PlaneDist: TXMVECTOR;
begin
    // Find the min/max projection of the frustum onto the plane normal.
    Min := XMVector3Dot(Plane, Point0);
    Max := Min;

    Dist := XMVector3Dot(Plane, Point1);
    Min := XMVectorMin(Min, Dist);
    Max := XMVectorMax(Max, Dist);

    Dist := XMVector3Dot(Plane, Point2);
    Min := XMVectorMin(Min, Dist);
    Max := XMVectorMax(Max, Dist);

    Dist := XMVector3Dot(Plane, Point3);
    Min := XMVectorMin(Min, Dist);
    Max := XMVectorMax(Max, Dist);

    Dist := XMVector3Dot(Plane, Point4);
    Min := XMVectorMin(Min, Dist);
    Max := XMVectorMax(Max, Dist);

    Dist := XMVector3Dot(Plane, Point5);
    Min := XMVectorMin(Min, Dist);
    Max := XMVectorMax(Max, Dist);

    Dist := XMVector3Dot(Plane, Point6);
    Min := XMVectorMin(Min, Dist);
    Max := XMVectorMax(Max, Dist);

    Dist := XMVector3Dot(Plane, Point7);
    Min := XMVectorMin(Min, Dist);
    Max := XMVectorMax(Max, Dist);

    PlaneDist := XMVectorNegate(XMVectorSplatW(Plane));

    // Outside the plane?
    Outside := XMVectorGreater(Min, PlaneDist);

    // Fully inside the plane?
    Inside := XMVectorLess(Max, PlaneDist);
end;

(****************************************************************************
 *
 * TriangleTests
 *
 ****************************************************************************)

{$region TriangleTests}

//-----------------------------------------------------------------------------
// Compute the intersection of a ray (Origin, Direction) with a triangle
// (V0, V1, V2).  Return true if there is an intersection and also set *pDist
// to the distance along the ray to the intersection.

// The algorithm is based on Moller, Tomas and Trumbore, "Fast, Minimum Storage
// Ray-Triangle Intersection", Journal of Graphics Tools, vol. 2, no. 1,
// pp 21-28, 1997.
//-----------------------------------------------------------------------------
function TriangleTests_Intersects(Origin, Direction, V0: TFXMVECTOR; V1: TGXMVECTOR; V2: THXMVECTOR; var Dist: single): boolean;
var
    Zero, e1, e2, p, det: TXMVECTOR;
    u, v, t, s, NoIntersection: TXMVECTOR;
    q: TXMVECTOR;
begin
    {$IFDEF UseAssert}
    assert(XMVector3IsUnit(Direction));
    {$ENDIF}

    Zero := XMVectorZero();

    e1 := XMVectorSubtract(V1, V0);
    e2 := XMVectorSubtract(V2, V0);

    // p := Direction ^ e2;
    p := XMVector3Cross(Direction, e2);

    // det := e1 * p;
    det := XMVector3Dot(e1, p);

    if (XMVector3GreaterOrEqual(det, g_RayEpsilon)) then
    begin
        // Determinate is positive (front side of the triangle).
        s := XMVectorSubtract(Origin, V0);

        // u := s * p;
        u := XMVector3Dot(s, p);

        NoIntersection := XMVectorLess(u, Zero);
        NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(u, det));

        // q := s ^ e1;
        q := XMVector3Cross(s, e1);

        // v := Direction * q;
        v := XMVector3Dot(Direction, q);

        NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(v, Zero));
        NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAdd(u, v), det));

        // t := e2 * q;
        t := XMVector3Dot(e2, q);

        NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(t, Zero));

        if (XMVector4EqualInt(NoIntersection, XMVectorTrueInt())) then
        begin
            Dist := 0.0;
            Result := False;
            Exit;
        end;
    end
    else if (XMVector3LessOrEqual(det, g_RayNegEpsilon)) then
    begin
        // Determinate is negative (back side of the triangle).
        s := XMVectorSubtract(Origin, V0);

        // u := s * p;
        u := XMVector3Dot(s, p);

        NoIntersection := XMVectorGreater(u, Zero);
        NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(u, det));

        // q := s ^ e1;
        q := XMVector3Cross(s, e1);

        // v := Direction * q;
        v := XMVector3Dot(Direction, q);

        NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(v, Zero));
        NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(XMVectorAdd(u, v), det));

        // t := e2 * q;
        t := XMVector3Dot(e2, q);

        NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(t, Zero));

        if (XMVector4EqualInt(NoIntersection, XMVectorTrueInt())) then
        begin
            Dist := 0.0;
            Result := False;
            Exit;
        end;
    end
    else
    begin
        // Parallel ray.
        Dist := 0.0;
        Result := False;
        Exit;
    end;

    t := XMVectorDivide(t, det);

    // (u / det) and (v / dev) are the barycentric cooridinates of the intersection.

    // Store the x-component to *pDist
    XMStoreFloat(Dist, t);

    Result := True;
end;


//-----------------------------------------------------------------------------
// Test if two triangles intersect.

// The final test of algorithm is based on Shen, Heng, and Tang, "A Fast
// Triangle-Triangle Overlap Test Using Signed Distances", Journal of Graphics
// Tools, vol. 8, no. 1, pp 17-23, 2003 and Guigue and Devillers, "Fast and
// Robust Triangle-Triangle Overlap Test Using Orientation Predicates", Journal
// of Graphics Tools, vol. 8, no. 1, pp 25-32, 2003.

// The final test could be considered an edge-edge separating plane test with
// the 9 possible cases narrowed down to the only two pairs of edges that can
// actaully result in a seperation.
//-----------------------------------------------------------------------------
function TriangleTests_Intersects(A0, A1, A2: TFXMVECTOR; B0: TGXMVECTOR; B1, B2: THXMVECTOR): boolean;
const
    SelectY: TXMVECTOR = (u: (XM_SELECT_0, XM_SELECT_1, XM_SELECT_0, XM_SELECT_0));
    SelectZ: TXMVECTOR = (u: (XM_SELECT_0, XM_SELECT_0, XM_SELECT_1, XM_SELECT_0));
    Select0111: TXMVECTOR = (u: (XM_SELECT_0, XM_SELECT_1, XM_SELECT_1, XM_SELECT_1));
    Select1011: TXMVECTOR = (u: (XM_SELECT_1, XM_SELECT_0, XM_SELECT_1, XM_SELECT_1));
    Select1101: TXMVECTOR = (u: (XM_SELECT_1, XM_SELECT_1, XM_SELECT_0, XM_SELECT_1));
var
    Zero, N1, BDist, N2, ADist: TXMVECTOR;
    BDistIsZeroCR: uint32;
    BDistIsLessCR: uint32;
    BDistIsGreaterCR: uint32;
    BDistIsZero, BDistIsLess, BDistIsGreater: TXMVECTOR;
    ADistIsZeroCR: uint32;
    ADistIsLessCR: uint32;
    ADistIsGreaterCR: uint32;
    ADistIsZero, ADistIsLess, ADistIsGreater: TXMVECTOR;
    Axis, Dist, MinDist: TXMVECTOR;

    ADistIsLessEqual, ADistIsGreaterEqual: TXMVECTOR;
    AA0, AA1, AA2: TXMVECTOR;
    bPositiveA: boolean;
    BB0, BB1, BB2, BDistIsLessEqual, BDistIsGreaterEqual: TXMVECTOR;
    bPositiveB: boolean;
    Delta0, Delta1: TXMVECTOR;
    Dist0, Dist1: TXMVECTOR;
begin
    Zero := XMVectorZero();

    // Compute the normal of triangle A.
    N1 := XMVector3Cross(XMVectorSubtract(A1, A0), XMVectorSubtract(A2, A0));

    // Assert that the triangle is not degenerate.
        {$IFDEF UseAssert}
        assert(!XMVector3Equal(N1, Zero));
		{$ENDIF}

    // Test points of B against the plane of A.
    BDist := XMVector3Dot(N1, XMVectorSubtract(B0, A0));
    BDist := XMVectorSelect(BDist, XMVector3Dot(N1, XMVectorSubtract(B1, A0)), SelectY);
    BDist := XMVectorSelect(BDist, XMVector3Dot(N1, XMVectorSubtract(B2, A0)), SelectZ);

    // Ensure robustness with co-planar triangles by zeroing small distances.

    BDistIsZero := XMVectorGreaterR(BDistIsZeroCR, g_RayEpsilon, XMVectorAbs(BDist));
    BDist := XMVectorSelect(BDist, Zero, BDistIsZero);


    BDistIsLess := XMVectorGreaterR(BDistIsLessCR, Zero, BDist);


    BDistIsGreater := XMVectorGreaterR(BDistIsGreaterCR, BDist, Zero);

    // If all the points are on the same side we don't intersect.
    if (XMComparisonAllTrue(BDistIsLessCR) or XMComparisonAllTrue(BDistIsGreaterCR)) then
    begin
        Result := False;
        Exit;
    end;

    // Compute the normal of triangle B.
    N2 := XMVector3Cross(XMVectorSubtract(B1, B0), XMVectorSubtract(B2, B0));

    // Assert that the triangle is not degenerate.
        {$IFDEF UseAssert}
        assert(!XMVector3Equal(N2, Zero));
		{$ENDIF}

    // Test points of A against the plane of B.
    ADist := XMVector3Dot(N2, XMVectorSubtract(A0, B0));
    ADist := XMVectorSelect(ADist, XMVector3Dot(N2, XMVectorSubtract(A1, B0)), SelectY);
    ADist := XMVectorSelect(ADist, XMVector3Dot(N2, XMVectorSubtract(A2, B0)), SelectZ);

    // Ensure robustness with co-planar triangles by zeroing small distances.

    ADistIsZero := XMVectorGreaterR(ADistIsZeroCR, g_RayEpsilon, XMVectorAbs(BDist));
    ADist := XMVectorSelect(ADist, Zero, ADistIsZero);


    ADistIsLess := XMVectorGreaterR(ADistIsLessCR, Zero, ADist);


    ADistIsGreater := XMVectorGreaterR(ADistIsGreaterCR, ADist, Zero);

    // If all the points are on the same side we don't intersect.
    if (XMComparisonAllTrue(ADistIsLessCR) or XMComparisonAllTrue(ADistIsGreaterCR)) then
    begin
        Result := False;
        Exit;
    end;

    // Special case for co-planar triangles.
    if (XMComparisonAllTrue(ADistIsZeroCR) or XMComparisonAllTrue(BDistIsZeroCR)) then
    begin
        // Compute an axis perpindicular to the edge (points out).
        Axis := XMVector3Cross(N1, XMVectorSubtract(A1, A0));
        Dist := XMVector3Dot(Axis, A0);

        // Test points of B against the axis.
        MinDist := XMVector3Dot(B0, Axis);
        MinDist := XMVectorMin(MinDist, XMVector3Dot(B1, Axis));
        MinDist := XMVectorMin(MinDist, XMVector3Dot(B2, Axis));
        if (XMVector4GreaterOrEqual(MinDist, Dist)) then
        begin
            Result := False;
            Exit;
        end;

        // Edge (A1, A2)
        Axis := XMVector3Cross(N1, XMVectorSubtract(A2, A1));
        Dist := XMVector3Dot(Axis, A1);

        MinDist := XMVector3Dot(B0, Axis);
        MinDist := XMVectorMin(MinDist, XMVector3Dot(B1, Axis));
        MinDist := XMVectorMin(MinDist, XMVector3Dot(B2, Axis));
        if (XMVector4GreaterOrEqual(MinDist, Dist)) then
        begin
            Result := False;
            Exit;
        end;

        // Edge (A2, A0)
        Axis := XMVector3Cross(N1, XMVectorSubtract(A0, A2));
        Dist := XMVector3Dot(Axis, A2);

        MinDist := XMVector3Dot(B0, Axis);
        MinDist := XMVectorMin(MinDist, XMVector3Dot(B1, Axis));
        MinDist := XMVectorMin(MinDist, XMVector3Dot(B2, Axis));
        if (XMVector4GreaterOrEqual(MinDist, Dist)) then
        begin
            Result := False;
            Exit;
        end;

        // Edge (B0, B1)
        Axis := XMVector3Cross(N2, XMVectorSubtract(B1, B0));
        Dist := XMVector3Dot(Axis, B0);

        MinDist := XMVector3Dot(A0, Axis);
        MinDist := XMVectorMin(MinDist, XMVector3Dot(A1, Axis));
        MinDist := XMVectorMin(MinDist, XMVector3Dot(A2, Axis));
        if (XMVector4GreaterOrEqual(MinDist, Dist)) then
        begin
            Result := False;
            Exit;
        end;

        // Edge (B1, B2)
        Axis := XMVector3Cross(N2, XMVectorSubtract(B2, B1));
        Dist := XMVector3Dot(Axis, B1);

        MinDist := XMVector3Dot(A0, Axis);
        MinDist := XMVectorMin(MinDist, XMVector3Dot(A1, Axis));
        MinDist := XMVectorMin(MinDist, XMVector3Dot(A2, Axis));
        if (XMVector4GreaterOrEqual(MinDist, Dist)) then
        begin
            Result := False;
            Exit;
        end;

        // Edge (B2,B0)
        Axis := XMVector3Cross(N2, XMVectorSubtract(B0, B2));
        Dist := XMVector3Dot(Axis, B2);

        MinDist := XMVector3Dot(A0, Axis);
        MinDist := XMVectorMin(MinDist, XMVector3Dot(A1, Axis));
        MinDist := XMVectorMin(MinDist, XMVector3Dot(A2, Axis));
        if (XMVector4GreaterOrEqual(MinDist, Dist)) then
            Result := False
        else
            Result := True;
        Exit;
    end;


    // Find the single vertex of A and B (ie the vertex on the opposite side
    // of the plane from the other two) and reorder the edges so we can compute
    // the signed edge/edge distances.

    // if ( (V0 >= 0 AND V1 <  0 AND V2 <  0) OR
    //      (V0 >  0 AND V1 <= 0 AND V2 <= 0) OR
    //      (V0 <= 0 AND V1 >  0 AND V2 >  0) OR
    //      (V0 <  0 AND V1 >= 0 AND V2 >= 0) ) then V0 is singular;

    // If our singular vertex is not on the positive side of the plane we reverse
    // the triangle winding so that the overlap comparisons will compare the
    // correct edges with the correct signs.

    ADistIsLessEqual := XMVectorOrInt(ADistIsLess, ADistIsZero);
    ADistIsGreaterEqual := XMVectorOrInt(ADistIsGreater, ADistIsZero);



    if (XMVector3AllTrue(XMVectorSelect(ADistIsGreaterEqual, ADistIsLess, Select0111)) or XMVector3AllTrue(XMVectorSelect(ADistIsGreater, ADistIsLessEqual, Select0111))) then
    begin
        // A0 is singular, crossing from positive to negative.
        AA0 := A0;
        AA1 := A1;
        AA2 := A2;
        bPositiveA := True;
    end
    else if (XMVector3AllTrue(XMVectorSelect(ADistIsLessEqual, ADistIsGreater, Select0111)) or XMVector3AllTrue(XMVectorSelect(ADistIsLess, ADistIsGreaterEqual, Select0111))) then
    begin
        // A0 is singular, crossing from negative to positive.
        AA0 := A0;
        AA1 := A2;
        AA2 := A1;
        bPositiveA := False;
    end
    else if (XMVector3AllTrue(XMVectorSelect(ADistIsGreaterEqual, ADistIsLess, Select1011)) or XMVector3AllTrue(XMVectorSelect(ADistIsGreater, ADistIsLessEqual, Select1011))) then
    begin
        // A1 is singular, crossing from positive to negative.
        AA0 := A1;
        AA1 := A2;
        AA2 := A0;
        bPositiveA := True;
    end
    else if (XMVector3AllTrue(XMVectorSelect(ADistIsLessEqual, ADistIsGreater, Select1011)) or XMVector3AllTrue(XMVectorSelect(ADistIsLess, ADistIsGreaterEqual, Select1011))) then
    begin
        // A1 is singular, crossing from negative to positive.
        AA0 := A1;
        AA1 := A0;
        AA2 := A2;
        bPositiveA := False;
    end
    else if (XMVector3AllTrue(XMVectorSelect(ADistIsGreaterEqual, ADistIsLess, Select1101)) or XMVector3AllTrue(XMVectorSelect(ADistIsGreater, ADistIsLessEqual, Select1101))) then
    begin
        // A2 is singular, crossing from positive to negative.
        AA0 := A2;
        AA1 := A0;
        AA2 := A1;
        bPositiveA := True;
    end
    else if (XMVector3AllTrue(XMVectorSelect(ADistIsLessEqual, ADistIsGreater, Select1101)) or XMVector3AllTrue(XMVectorSelect(ADistIsLess, ADistIsGreaterEqual, Select1101))) then
    begin
        // A2 is singular, crossing from negative to positive.
        AA0 := A2;
        AA1 := A1;
        AA2 := A0;
        bPositiveA := False;
    end
    else
    begin
        {$IFDEF UseAssert}
	assert(false);
	{$ENDIF}

        Result := False;
        Exit;
    end;

    BDistIsLessEqual := XMVectorOrInt(BDistIsLess, BDistIsZero);
    BDistIsGreaterEqual := XMVectorOrInt(BDistIsGreater, BDistIsZero);



    if (XMVector3AllTrue(XMVectorSelect(BDistIsGreaterEqual, BDistIsLess, Select0111)) or XMVector3AllTrue(XMVectorSelect(BDistIsGreater, BDistIsLessEqual, Select0111))) then
    begin
        // B0 is singular, crossing from positive to negative.
        BB0 := B0;
        BB1 := B1;
        BB2 := B2;
        bPositiveB := True;
    end
    else if (XMVector3AllTrue(XMVectorSelect(BDistIsLessEqual, BDistIsGreater, Select0111)) or XMVector3AllTrue(XMVectorSelect(BDistIsLess, BDistIsGreaterEqual, Select0111))) then
    begin
        // B0 is singular, crossing from negative to positive.
        BB0 := B0;
        BB1 := B2;
        BB2 := B1;
        bPositiveB := False;
    end
    else if (XMVector3AllTrue(XMVectorSelect(BDistIsGreaterEqual, BDistIsLess, Select1011)) or XMVector3AllTrue(XMVectorSelect(BDistIsGreater, BDistIsLessEqual, Select1011))) then
    begin
        // B1 is singular, crossing from positive to negative.
        BB0 := B1;
        BB1 := B2;
        BB2 := B0;
        bPositiveB := True;
    end
    else if (XMVector3AllTrue(XMVectorSelect(BDistIsLessEqual, BDistIsGreater, Select1011)) or XMVector3AllTrue(XMVectorSelect(BDistIsLess, BDistIsGreaterEqual, Select1011))) then
    begin
        // B1 is singular, crossing from negative to positive.
        BB0 := B1;
        BB1 := B0;
        BB2 := B2;
        bPositiveB := False;
    end
    else if (XMVector3AllTrue(XMVectorSelect(BDistIsGreaterEqual, BDistIsLess, Select1101)) or XMVector3AllTrue(XMVectorSelect(BDistIsGreater, BDistIsLessEqual, Select1101))) then
    begin
        // B2 is singular, crossing from positive to negative.
        BB0 := B2;
        BB1 := B0;
        BB2 := B1;
        bPositiveB := True;
    end
    else if (XMVector3AllTrue(XMVectorSelect(BDistIsLessEqual, BDistIsGreater, Select1101)) or XMVector3AllTrue(XMVectorSelect(BDistIsLess, BDistIsGreaterEqual, Select1101))) then
    begin
        // B2 is singular, crossing from negative to positive.
        BB0 := B2;
        BB1 := B1;
        BB2 := B0;
        bPositiveB := False;
    end
    else
    begin
        {$IFDEF UseAssert}
	assert(false);
	{$ENDIF}
        Result := False;
        Exit;
    end;


    // Reverse the direction of the test depending on whether the singular vertices are
    // the same sign or different signs.
    if (bPositiveA xor bPositiveB) then
    begin
        Delta0 := XMVectorSubtract(BB0, AA0);
        Delta1 := XMVectorSubtract(AA0, BB0);
    end
    else
    begin
        Delta0 := XMVectorSubtract(AA0, BB0);
        Delta1 := XMVectorSubtract(BB0, AA0);
    end;

    // Check if the triangles overlap on the line of intersection between the
    // planes of the two triangles by finding the signed line distances.
    Dist0 := XMVector3Dot(Delta0, XMVector3Cross(XMVectorSubtract(BB2, BB0), XMVectorSubtract(AA2, AA0)));
    if (XMVector4Greater(Dist0, Zero)) then
    begin
        Result := False;
        Exit;
    end;

    Dist1 := XMVector3Dot(Delta1, XMVector3Cross(XMVectorSubtract(BB1, BB0), XMVectorSubtract(AA1, AA0)));
    if (XMVector4Greater(Dist1, Zero)) then
        Result := False
    else
        Result := True;
end;


//-----------------------------------------------------------------------------
// Ray-triangle test
//-----------------------------------------------------------------------------
function TriangleTests_Intersects(V0, V1, V2: TFXMVECTOR; Plane: TGXMVECTOR): TPlaneIntersectionType;
var
    One: TXMVECTOR;
    TV0, TV1, TV2: TXMVECTOR;
    Outside, Inside: TXMVECTOR;
begin
    One := XMVectorSplatOne();

    {$IFDEF UseAssert}
    assert(XMPlaneIsUnit(Plane));
    {$ENDIF}

    // Set w of the points to one so we can dot4 with a plane.
    TV0 := XMVectorInsert(0, 0, 0, 0, 1, V0, One);
    TV1 := XMVectorInsert(0, 0, 0, 0, 1, V1, One);
    TV2 := XMVectorInsert(0, 0, 0, 0, 1, V2, One);

    FastIntersectTrianglePlane(TV0, TV1, TV2, Plane, Outside, Inside);

    // If the triangle is outside any plane it is outside.
    if (XMVector4EqualInt(Outside, XMVectorTrueInt())) then
        Result := piFRONT
    // If the triangle is inside all planes it is inside.
    else if (XMVector4EqualInt(Inside, XMVectorTrueInt())) then
        Result := piBACK
    // The triangle is not inside all planes or outside a plane it intersects.
    else
        Result := piINTERSECTING;
end;


//-----------------------------------------------------------------------------
// Test a triangle vs 6 planes (typically forming a frustum).
//-----------------------------------------------------------------------------
function TriangleTests_ContainedBy(V0, V1, V2: TFXMVECTOR; Plane0: TGXMVECTOR; Plane1, Plane2: THXMVECTOR; Plane3, Plane4, Plane5: TCXMVECTOR): TContainmentType;
var
    One: TXMVECTOR;
    TV0, TV1, TV2: TXMVECTOR;
    Outside, Inside: TXMVECTOR;
    AnyOutside: TXMVECTOR;
    AllInside: TXMVECTOR;
begin
    One := XMVectorSplatOne();

    // Set w of the points to one so we can dot4 with a plane.
    TV0 := XMVectorInsert(0, 0, 0, 0, 1, V0, One);
    TV1 := XMVectorInsert(0, 0, 0, 0, 1, V1, One);
    TV2 := XMVectorInsert(0, 0, 0, 0, 1, V2, One);



    // Test against each plane.
    FastIntersectTrianglePlane(TV0, TV1, TV2, Plane0, Outside, Inside);

    AnyOutside := Outside;
    AllInside := Inside;

    FastIntersectTrianglePlane(TV0, TV1, TV2, Plane1, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectTrianglePlane(TV0, TV1, TV2, Plane2, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectTrianglePlane(TV0, TV1, TV2, Plane3, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectTrianglePlane(TV0, TV1, TV2, Plane4, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectTrianglePlane(TV0, TV1, TV2, Plane5, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    // If the triangle is outside any plane it is outside.
    if (XMVector4EqualInt(AnyOutside, XMVectorTrueInt())) then
        Result := ctDISJOINT
    // If the triangle is inside all planes it is inside.
    else if (XMVector4EqualInt(AllInside, XMVectorTrueInt())) then
        Result := ctCONTAINS
    // The triangle is not inside all planes or outside a plane, it may intersect.
    else
        Result := ctINTERSECTS;
end;

{$endregion}


(****************************************************************************
 *
 * BoundingSphere
 *
 ****************************************************************************)

{$REGION BoundingSphere}
{ TBoundingSphere }

constructor TBoundingSphere.Create(ACenter: TXMFLOAT3; ARadius: single);
begin
    Center := ACenter;
    Radius := ARadius;
end;



class operator TBoundingSphere.Initialize(var t: TBoundingSphere);
begin
    t.Center := TXMFLOAT3.Create(0, 0, 0);
    t.Radius := 0;
end;



//-----------------------------------------------------------------------------
// Transform a sphere by an angle preserving transform.
//-----------------------------------------------------------------------------

procedure TBoundingSphere.Transform( _out: PBoundingSphere; M: TFXMMATRIX);
var
    vCenter: TXMVECTOR;
    C, dX, dY, dZ, d: TXMVECTOR;
    Scale: single;
begin
    // Load the center of the sphere.
    vCenter := XMLoadFloat3(Self.Center);

    // Transform the center of the sphere.
    C := XMVector3Transform(vCenter, M);

    dX := XMVector3Dot(M.r[0], M.r[0]);
    dY := XMVector3Dot(M.r[1], M.r[1]);
    dZ := XMVector3Dot(M.r[2], M.r[2]);

    d := XMVectorMax(dX, XMVectorMax(dY, dZ));

    // Store the center sphere.
    XMStoreFloat3(_Out.Center, C);

    // Scale the radius of the pshere.
    Scale := sqrt(XMVectorGetX(d));
    _Out.Radius := Self.Radius * Scale;
end;



procedure TBoundingSphere.Transform( _Out: PBoundingSphere; Scale: single; Rotation: TFXMVECTOR; Translation: TFXMVECTOR);
var
    vCenter: TXMVECTOR;
begin
    // Load the center of the sphere.
    vCenter := XMLoadFloat3(Self.Center);

    // Transform the center of the sphere.
    vCenter := XMVectorAdd(XMVector3Rotate(XMVectorScale(vCenter, Scale), Rotation), Translation);

    // Store the center sphere.
    XMStoreFloat3(_Out.Center, vCenter);

    // Scale the radius of the pshere.
    _Out.Radius := Self.Radius * Scale;
end;



//-----------------------------------------------------------------------------
// Point in sphere test.
//-----------------------------------------------------------------------------


function TBoundingSphere.Contains(Point: TFXMVECTOR): TContainmentType;
var
    vCenter: TXMVECTOR;
    vRadius: TXMVECTOR;
    DistanceSquared, RadiusSquared: TXMVECTOR;
begin
    vCenter := XMLoadFloat3(Self.Center);
    vRadius := XMVectorReplicatePtr(@Self.Radius);

    DistanceSquared := XMVector3LengthSq(XMVectorSubtract(Point, vCenter));
    RadiusSquared := XMVectorMultiply(vRadius, vRadius);

    if XMVector3LessOrEqual(DistanceSquared, RadiusSquared) then
        Result := ctCONTAINS
    else
        Result := ctDISJOINT;
end;



//-----------------------------------------------------------------------------
// Triangle in sphere test
//-----------------------------------------------------------------------------

function TBoundingSphere.Contains(V0: TFXMVECTOR; V1: TFXMVECTOR; V2: TFXMVECTOR): TContainmentType;
var
    vCenter, vRadius, RadiusSquared: TXMVECTOR;
    DistanceSquared, Inside: TXMVECTOR;
begin
    if (not Self.Intersects(V0, V1, V2)) then
    begin
        Result := ctDISJOINT;
        Exit;
    end;

    vCenter := XMLoadFloat3(Self.Center);
    vRadius := XMVectorReplicatePtr(@Self.Radius);
    RadiusSquared := XMVectorMultiply(vRadius, vRadius);

    DistanceSquared := XMVector3LengthSq(XMVectorSubtract(V0, vCenter));
    Inside := XMVectorLessOrEqual(DistanceSquared, RadiusSquared);

    DistanceSquared := XMVector3LengthSq(XMVectorSubtract(V1, vCenter));
    Inside := XMVectorAndInt(Inside, XMVectorLessOrEqual(DistanceSquared, RadiusSquared));

    DistanceSquared := XMVector3LengthSq(XMVectorSubtract(V2, vCenter));
    Inside := XMVectorAndInt(Inside, XMVectorLessOrEqual(DistanceSquared, RadiusSquared));

    if (XMVector3EqualInt(Inside, XMVectorTrueInt())) then Result := ctCONTAINS
    else
        Result := ctINTERSECTS;
end;



//-----------------------------------------------------------------------------
// Sphere in sphere test.
//-----------------------------------------------------------------------------
function TBoundingSphere.Contains(sh: PBoundingSphere): TContainmentType;
var
    Center1, Center2, V, Dist: TXMVECTOR;
    r1, r2, d: single;
begin
    Center1 := XMLoadFloat3(Self.Center);
    r1 := Radius;

    Center2 := XMLoadFloat3(sh.Center);
    r2 := sh.Radius;

    V := XMVectorSubtract(Center2, Center1);

    Dist := XMVector3Length(V);

    d := XMVectorGetX(Dist);

    if (r1 + r2 >= d) then
    begin
        if (r1 - r2 >= d) then Result := ctCONTAINS
        else
            Result := ctINTERSECTS;
    end
    else
        Result := ctDISJOINT;
end;


//-----------------------------------------------------------------------------
// Axis-aligned box in sphere test
//-----------------------------------------------------------------------------
function TBoundingSphere.Contains(box: PBoundingBox): TContainmentType;
var
    vCenter, vRadius, RadiusSq: TXMVECTOR;
    boxCenter, boxExtents, InsideAll, offset: TXMVECTOR;
    i: integer;
    c, d: TXMVECTOR;
begin
    if (not box.Intersects(PBoundingSphere(@self))) then
    begin
        Result := ctDISJOINT;
        Exit;
    end;

    vCenter := XMLoadFloat3(Center);
    vRadius := XMVectorReplicatePtr(@Radius);
    RadiusSq := XMVectorMultiply(vRadius, vRadius);

    boxCenter := XMLoadFloat3(box.Center);
    boxExtents := XMLoadFloat3(box.Extents);

    InsideAll := XMVectorTrueInt();

    offset := XMVectorSubtract(boxCenter, vCenter);

    for  i := 0 to BoundingBox_CORNER_COUNT - 1 do
    begin
        C := XMVectorMultiplyAdd(boxExtents, g_BoxOffset[i], offset);
        d := XMVector3LengthSq(C);
        InsideAll := XMVectorAndInt(InsideAll, XMVectorLessOrEqual(d, RadiusSq));
    end;

    if (XMVector3EqualInt(InsideAll, XMVectorTrueInt())) then Result := ctCONTAINS
    else
        Result := ctINTERSECTS;

end;


//-----------------------------------------------------------------------------
// Oriented box in sphere test
//-----------------------------------------------------------------------------
function TBoundingSphere.Contains(box: PBoundingOrientedBox): TContainmentType;
var
    vCenter, vRadius, RadiusSq: TXMVECTOR;
    boxCenter, boxExtents, boxOrientation: TXMVECTOR;
    InsideAll: TXMVECTOR;
    i: integer;
    C, d: TXMVECTOR;
begin
    if (not box.Intersects(PBoundingSphere(@self))) then
    begin
        Result := ctDISJOINT;
        exit;
    end;

    vCenter := XMLoadFloat3(Center);
    vRadius := XMVectorReplicatePtr(@Radius);
    RadiusSq := XMVectorMultiply(vRadius, vRadius);

    boxCenter := XMLoadFloat3(box.Center);
    boxExtents := XMLoadFloat3(box.Extents);
    boxOrientation := XMLoadFloat4(box.Orientation);
     {$IFDEF UseAssert}
     assert(XMQuaternionIsUnit(boxOrientation));
     {$ENDIF}
    InsideAll := XMVectorTrueInt();

    for  i := 0 to BoundingOrientedBox_CORNER_COUNT - 1 do
    begin
        C := XMVectorAdd(XMVector3Rotate(XMVectorMultiply(boxExtents, g_BoxOffset[i]), boxOrientation), boxCenter);
        d := XMVector3LengthSq(XMVectorSubtract(vCenter, C));
        InsideAll := XMVectorAndInt(InsideAll, XMVectorLessOrEqual(d, RadiusSq));
    end;

    if (XMVector3EqualInt(InsideAll, XMVectorTrueInt())) then Result := ctCONTAINS
    else
        Result := ctINTERSECTS;

end;


//-----------------------------------------------------------------------------
// Frustum in sphere test
//-----------------------------------------------------------------------------
function TBoundingSphere.Contains(fr: PBoundingFrustum): TContainmentType;
var
    vCenter, vRadius, RadiusSq: TXMVECTOR;
    vOrigin, vOrientation: TXMVECTOR;
    vRightTop, vRightBottom, vLeftTop, vLeftBottom, vNear, vFar: TXMVECTOR;
    Corners: array [0..BoundingFrustum_CORNER_COUNT - 1] of TXMVECTOR;
    InsideAll, C, d: TXMVECTOR;
    i: integer;
begin
    if (not fr.Intersects(PBoundingSphere(@self))) then
    begin
        Result := ctDISJOINT;
        exit;
    end;

    vCenter := XMLoadFloat3(Center);
    vRadius := XMVectorReplicatePtr(@Radius);
    RadiusSq := XMVectorMultiply(vRadius, vRadius);

    vOrigin := XMLoadFloat3(fr.Origin);
    vOrientation := XMLoadFloat4(fr.Orientation);
    {$IFDEF UseAssert}
    assert(DirectX.Internal.XMQuaternionIsUnit(vOrientation));
    {$ENDIF}

    // Build the corners of the frustum.
    vRightTop := XMVectorSet(fr.RightSlope, fr.TopSlope, 1.0, 0.0);
    vRightBottom := XMVectorSet(fr.RightSlope, fr.BottomSlope, 1.0, 0.0);
    vLeftTop := XMVectorSet(fr.LeftSlope, fr.TopSlope, 1.0, 0.0);
    vLeftBottom := XMVectorSet(fr.LeftSlope, fr.BottomSlope, 1.0, 0.0);
    vNear := XMVectorReplicatePtr(@fr._Near);
    vFar := XMVectorReplicatePtr(@fr._Far);


    Corners[0] := XMVectorMultiply(vRightTop, vNear);
    Corners[1] := XMVectorMultiply(vRightBottom, vNear);
    Corners[2] := XMVectorMultiply(vLeftTop, vNear);
    Corners[3] := XMVectorMultiply(vLeftBottom, vNear);
    Corners[4] := XMVectorMultiply(vRightTop, vFar);
    Corners[5] := XMVectorMultiply(vRightBottom, vFar);
    Corners[6] := XMVectorMultiply(vLeftTop, vFar);
    Corners[7] := XMVectorMultiply(vLeftBottom, vFar);

    InsideAll := XMVectorTrueInt();
    for  i := 0 to BoundingFrustum_CORNER_COUNT - 1 do
    begin
        C := XMVectorAdd(XMVector3Rotate(Corners[i], vOrientation), vOrigin);
        d := XMVector3LengthSq(XMVectorSubtract(vCenter, C));
        InsideAll := XMVectorAndInt(InsideAll, XMVectorLessOrEqual(d, RadiusSq));
    end;

    if (XMVector3EqualInt(InsideAll, XMVectorTrueInt())) then
        Result := ctCONTAINS
    else
        Result := ctINTERSECTS;

end;


//-----------------------------------------------------------------------------
// Test a sphere vs 6 planes (typically forming a frustum).
//-----------------------------------------------------------------------------
function TBoundingSphere.ContainedBy(Plane0, Plane1, Plane2: TFXMVECTOR; Plane3: TGXMVECTOR; Plane4: THXMVECTOR; Plane5: THXMVECTOR): TContainmentType;
var
    vCenter, vRadius: TXMVECTOR;
    Outside, Inside: TXMVECTOR;
    AnyOutside, AllInside: TXMVECTOR;
begin
    // Load the sphere.
    vCenter := XMLoadFloat3(Center);
    vRadius := XMVectorReplicatePtr(@Radius);

    // Set w of the center to one so we can dot4 with a plane.
    vCenter := XMVectorInsert(0, 0, 0, 0, 1, vCenter, XMVectorSplatOne());



    // Test against each plane.
    FastIntersectSpherePlane(vCenter, vRadius, Plane0, Outside, Inside);

    AnyOutside := Outside;
    AllInside := Inside;

    FastIntersectSpherePlane(vCenter, vRadius, Plane1, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectSpherePlane(vCenter, vRadius, Plane2, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectSpherePlane(vCenter, vRadius, Plane3, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectSpherePlane(vCenter, vRadius, Plane4, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectSpherePlane(vCenter, vRadius, Plane5, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    // If the sphere is outside any plane it is outside.
    if (XMVector4EqualInt(AnyOutside, XMVectorTrueInt())) then
        Result := ctDISJOINT

    // If the sphere is inside all planes it is inside.
    else if (XMVector4EqualInt(AllInside, XMVectorTrueInt())) then
        Result := ctCONTAINS

    else// The sphere is not inside all planes or outside a plane, it may intersect.
        Result := ctINTERSECTS;
end;


//-----------------------------------------------------------------------------
// Triangle vs sphere test
//-----------------------------------------------------------------------------
function TBoundingSphere.Intersects(V0, V1, V2: TFXMVECTOR): boolean;
var
    vCenter, vRadius: TXMVECTOR;
    N: TXMVECTOR;
    Dist: TXMVECTOR;
    NoIntersection: TXMVECTOR;
    Point: TXMVECTOR;
    Intersection: TXMVECTOR;
    RadiusSq: TXMVECTOR;
begin
    // Load the sphere.
    vCenter := XMLoadFloat3(Center);
    vRadius := XMVectorReplicatePtr(@Radius);

    // Compute the plane of the triangle (has to be normalized).
    N := XMVector3Normalize(XMVector3Cross(XMVectorSubtract(V1, V0), XMVectorSubtract(V2, V0)));

    // Assert that the triangle is not degenerate.
    assert(not XMVector3Equal(N, XMVectorZero()));

    // Find the nearest feature on the triangle to the sphere.
    Dist := XMVector3Dot(XMVectorSubtract(vCenter, V0), N);

    // If the center of the sphere is farther from the plane of the triangle than
    // the radius of the sphere, then there cannot be an intersection.
    NoIntersection := XMVectorLess(Dist, XMVectorNegate(vRadius));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(Dist, vRadius));

    // Project the center of the sphere onto the plane of the triangle.
    Point := XMVectorNegativeMultiplySubtract(N, Dist, vCenter);

    // Is it inside all the edges? If so we intersect because the distance
    // to the plane is less than the radius.
    Intersection := PointOnPlaneInsideTriangle(Point, V0, V1, V2);

    // Find the nearest point on each edge.
    RadiusSq := XMVectorMultiply(vRadius, vRadius);

    // Edge 0,1
    Point := PointOnLineSegmentNearestPoint(V0, V1, vCenter);

    // If the distance to the center of the sphere to the point is less than
    // the radius of the sphere then it must intersect.
    Intersection := XMVectorOrInt(Intersection, XMVectorLessOrEqual(XMVector3LengthSq(XMVectorSubtract(vCenter, Point)), RadiusSq));

    // Edge 1,2
    Point := PointOnLineSegmentNearestPoint(V1, V2, vCenter);

    // If the distance to the center of the sphere to the point is less than
    // the radius of the sphere then it must intersect.
    Intersection := XMVectorOrInt(Intersection, XMVectorLessOrEqual(XMVector3LengthSq(XMVectorSubtract(vCenter, Point)), RadiusSq));

    // Edge 2,0
    Point := PointOnLineSegmentNearestPoint(V2, V0, vCenter);

    // If the distance to the center of the sphere to the point is less than
    // the radius of the sphere then it must intersect.
    Intersection := XMVectorOrInt(Intersection, XMVectorLessOrEqual(XMVector3LengthSq(XMVectorSubtract(vCenter, Point)), RadiusSq));

    Result := XMVector4EqualInt(XMVectorAndCInt(Intersection, NoIntersection), XMVectorTrueInt());
end;


//-----------------------------------------------------------------------------
// Sphere vs. sphere test.
//-----------------------------------------------------------------------------
function TBoundingSphere.Intersects(sh: PBoundingSphere): boolean;
var
    vCenterA, vRadiusA: TXMVECTOR;
    vCenterB, vRadiusB: TXMVECTOR;
    Delta, DistanceSquared, RadiusSquared: TXMVECTOR;
begin
    // Load A.
    vCenterA := XMLoadFloat3(Center);
    vRadiusA := XMVectorReplicatePtr(@Radius);

    // Load B.
    vCenterB := XMLoadFloat3(sh.Center);
    vRadiusB := XMVectorReplicatePtr(@sh.Radius);

    // Distance squared between centers.
    Delta := XMVectorSubtract(vCenterB, vCenterA);
    DistanceSquared := XMVector3LengthSq(Delta);

    // Sum of the radii squared.
    RadiusSquared := XMVectorAdd(vRadiusA, vRadiusB);
    RadiusSquared := XMVectorMultiply(RadiusSquared, RadiusSquared);

    Result := XMVector3LessOrEqual(DistanceSquared, RadiusSquared);
end;


//-----------------------------------------------------------------------------
// Box vs. sphere test.
//-----------------------------------------------------------------------------
function TBoundingSphere.Intersects(box: PBoundingBox): boolean;
begin
    Result := box.Intersects(PBoundingSphere(@self));
end;



function TBoundingSphere.Intersects(box: PBoundingOrientedBox): boolean;
begin
    Result := box.Intersects(PBoundingSphere(@self));
end;


//-----------------------------------------------------------------------------
// Frustum vs. sphere test.
//-----------------------------------------------------------------------------
function TBoundingSphere.Intersects(fr: PBoundingFrustum): boolean;
begin
    Result := fr.Intersects(PBoundingSphere(@self));
end;


//-----------------------------------------------------------------------------
// Sphere-plane intersection
//-----------------------------------------------------------------------------
function TBoundingSphere.Intersects(Plane: TFXMVECTOR): TPlaneIntersectionType;
var
    vCenter, vRadius: TXMVECTOR;
    Outside, Inside: TXMVECTOR;
begin
    assert(XMPlaneIsUnit(Plane));

    // Load the sphere.
    vCenter := XMLoadFloat3(Center);
    vRadius := XMVectorReplicatePtr(@Radius);

    // Set w of the center to one so we can dot4 with a plane.
    vCenter := XMVectorInsert(0, 0, 0, 0, 1, vCenter, XMVectorSplatOne());


    FastIntersectSpherePlane(vCenter, vRadius, Plane, Outside, Inside);

    // If the sphere is outside any plane it is outside.
    if (XMVector4EqualInt(Outside, XMVectorTrueInt())) then
        Result := TPlaneIntersectionType.piFRONT

    // If the sphere is inside all planes it is inside.
    else if (XMVector4EqualInt(Inside, XMVectorTrueInt())) then
        Result := TPlaneIntersectionType.piBACK
    else
        // The sphere is not inside all planes or outside a plane it intersects.
        Result := piINTERSECTING;
end;


//-----------------------------------------------------------------------------
// Compute the intersection of a ray (Origin, Direction) with a sphere.
//-----------------------------------------------------------------------------
function TBoundingSphere.Intersects(Origin, Direction: TFXMVECTOR; var Dist: single): boolean;
var
    vCenter, vRadius, l, s, l2, r2, m2: TXMVECTOR;
    NoIntersection: TXMVECTOR;
    q, t1, t2, t, OriginInside: TXMVECTOR;
begin
    assert(XMVector3IsUnit(Direction));

    vCenter := XMLoadFloat3(Center);
    vRadius := XMVectorReplicatePtr(@Radius);

    // l is the vector from the ray origin to the center of the sphere.
    l := XMVectorSubtract(vCenter, Origin);

    // s is the projection of the l onto the ray direction.
    s := XMVector3Dot(l, Direction);

    l2 := XMVector3Dot(l, l);

    r2 := XMVectorMultiply(vRadius, vRadius);

    // m2 is squared distance from the center of the sphere to the projection.
    m2 := XMVectorNegativeMultiplySubtract(s, s, l2);



    // If the ray origin is outside the sphere and the center of the sphere is
    // behind the ray origin there is no intersection.
    NoIntersection := XMVectorAndInt(XMVectorLess(s, XMVectorZero()), XMVectorGreater(l2, r2));

    // If the squared distance from the center of the sphere to the projection
    // is greater than the radius squared the ray will miss the sphere.
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(m2, r2));

    // The ray hits the sphere, compute the nearest intersection point.
    q := XMVectorSqrt(XMVectorSubtract(r2, m2));
    t1 := XMVectorSubtract(s, q);
    t2 := XMVectorAdd(s, q);

    OriginInside := XMVectorLessOrEqual(l2, r2);
    t := XMVectorSelect(t1, t2, OriginInside);

    if (XMVector4NotEqualInt(NoIntersection, XMVectorTrueInt())) then
    begin
        // Store the x-component to *pDist.
        XMStoreFloat(Dist, t);
        Result := True;
        Exit;
    end;

    Dist := 0.0;
    Result := False;
end;


//-----------------------------------------------------------------------------
// Creates a bounding sphere that contains two other bounding spheres
//-----------------------------------------------------------------------------
procedure TBoundingSphere.CreateMerged(_Out: PBoundingSphere; S1, S2: PBoundingSphere);
var
    Center1, Center2, V, Dist: TXMVECTOR;
    r1, r2, d: single;
    N, NCenter: TXMVECTOR;
    t1, t2, t_5: single;
begin
    Center1 := XMLoadFloat3(S1.Center);
    r1 := S1.Radius;

    Center2 := XMLoadFloat3(S2.Center);
    r2 := S2.Radius;

    V := XMVectorSubtract(Center2, Center1);

    Dist := XMVector3Length(V);

    d := XMVectorGetX(Dist);

    if (r1 + r2 >= d) then
    begin
        if (r1 - r2 >= d) then
        begin
            _Out := S1;
            Exit;
        end
        else if (r2 - r1 >= d) then
        begin
            _Out := S2;
            Exit;
        end;
    end;

    N := XMVectorDivide(V, Dist);

    t1 := XMMin<single>(-r1, d - r2);
    t2 := XMMax<single>(r1, d + r2);
    t_5 := (t2 - t1) * 0.5;

    NCenter := XMVectorAdd(Center1, XMVectorMultiply(N, XMVectorReplicate(t_5 + t1)));

    XMStoreFloat3(_Out.Center, NCenter);
    _Out.Radius := t_5;
end;


//-----------------------------------------------------------------------------
// Create sphere enscribing bounding box
//-----------------------------------------------------------------------------
procedure TBoundingSphere.CreateFromBoundingBox(_Out: PBoundingSphere; box: PBoundingBox);
var
    vExtents: TXMVECTOR;
begin
    _Out.Center := box.Center;
    vExtents := XMLoadFloat3(box.Extents);
    _Out.Radius := XMVectorGetX(XMVector3Length(vExtents));
end;



procedure TBoundingSphere.CreateFromBoundingBox(_Out: PBoundingSphere; box: PBoundingOrientedBox);
var
    vExtents: TXMVECTOR;
begin
    // Bounding box orientation is irrelevant because a sphere is rotationally invariant
    _Out.Center := box.Center;
    vExtents := XMLoadFloat3(box.Extents);
    _Out.Radius := XMVectorGetX(XMVector3Length(vExtents));
end;


//-----------------------------------------------------------------------------
// Find the approximate smallest enclosing bounding sphere for a set of
// points. Exact computation of the smallest enclosing bounding sphere is
// possible but is slower and requires a more complex algorithm.
// The algorithm is based on  Jack Ritter, "An Efficient Bounding Sphere",
// Graphics Gems.
//-----------------------------------------------------------------------------
procedure TBoundingSphere.CreateFromPoints(_Out: PBoundingSphere; Count: size_t; const pPoints: PXMFLOAT3; Stride: size_t);
var
    MinX, MaxX, MinY, MaxY, MinZ, MaxZ: TXMVECTOR;
    i: integer;
    px, py, pz: single;
    DeltaX, DistX, DeltaY, DistY, DeltaZ, DistZ: TXMVECTOR;
    vCenter, vRadius: TXMVECTOR;
    Point, Delta, Dist: TXMVECTOR;
begin
    assert(Count > 0);
    assert(pPoints <> nil);

    // Find the points with minimum and maximum x, y, and z


    MinX := XMLoadFloat3(pPoints^);
    MaxX := MinX;
    MinY := MinX;
    MaxY := MinX;
    MinZ := MinX;
    MaxZ := MinX;

    for i := 1 to Count - 1 do
    begin
        Point := XMLoadFloat3(PXMFLOAT3(pbyte(pPoints) + i * Stride)^);

        px := XMVectorGetX(Point);
        py := XMVectorGetY(Point);
        pz := XMVectorGetZ(Point);

        if (px < XMVectorGetX(MinX)) then
            MinX := Point;

        if (px > XMVectorGetX(MaxX)) then
            MaxX := Point;

        if (py < XMVectorGetY(MinY)) then
            MinY := Point;

        if (py > XMVectorGetY(MaxY)) then
            MaxY := Point;

        if (pz < XMVectorGetZ(MinZ)) then
            MinZ := Point;

        if (pz > XMVectorGetZ(MaxZ)) then
            MaxZ := Point;
    end;

    // Use the min/max pair that are farthest apart to form the initial sphere.
    DeltaX := XMVectorSubtract(MaxX, MinX);
    DistX := XMVector3Length(DeltaX);

    DeltaY := XMVectorSubtract(MaxY, MinY);
    DistY := XMVector3Length(DeltaY);

    DeltaZ := XMVectorSubtract(MaxZ, MinZ);
    DistZ := XMVector3Length(DeltaZ);



    if (XMVector3Greater(DistX, DistY)) then
    begin
        if (XMVector3Greater(DistX, DistZ)) then
        begin
            // Use min/max x.
            vCenter := XMVectorLerp(MaxX, MinX, 0.5);
            vRadius := XMVectorScale(DistX, 0.5);
        end
        else
        begin
            // Use min/max z.
            vCenter := XMVectorLerp(MaxZ, MinZ, 0.5);
            vRadius := XMVectorScale(DistZ, 0.5);
        end;
    end
    else // Y >= X
    begin
        if (XMVector3Greater(DistY, DistZ)) then
        begin
            // Use min/max y.
            vCenter := XMVectorLerp(MaxY, MinY, 0.5);
            vRadius := XMVectorScale(DistY, 0.5);
        end
        else
        begin
            // Use min/max z.
            vCenter := XMVectorLerp(MaxZ, MinZ, 0.5);
            vRadius := XMVectorScale(DistZ, 0.5);
        end;
    end;

    // Add any points not inside the sphere.
    for  i := 0 to Count - 1 do
    begin
        Point := XMLoadFloat3(PXMFLOAT3(pbyte(pPoints) + i * Stride)^);

        Delta := XMVectorSubtract(Point, vCenter);

        Dist := XMVector3Length(Delta);

        if (XMVector3Greater(Dist, vRadius)) then
        begin
            // Adjust sphere to include the new point.
            vRadius := XMVectorScale(XMVectorAdd(vRadius, Dist), 0.5);
            vCenter := XMVectorAdd(vCenter, XMVectorMultiply(XMVectorSubtract(XMVectorReplicate(1.0), XMVectorDivide(vRadius, Dist)), Delta));
        end;
    end;

    XMStoreFloat3(_Out.Center, vCenter);
    XMStoreFloat(_Out.Radius, vRadius);
end;


//-----------------------------------------------------------------------------
// Create sphere containing frustum
//-----------------------------------------------------------------------------
procedure TBoundingSphere.CreateFromFrustum(_Out: PBoundingSphere; fr: PBoundingFrustum);
var
    Corners: array[0..BoundingFrustum_CORNER_COUNT - 1] of TXMFLOAT3;
begin
    fr.GetCorners(Corners);
    CreateFromPoints(_Out, BoundingFrustum_CORNER_COUNT, Corners, sizeof(TXMFLOAT3));
end;

{$ENDREGION}

(****************************************************************************
 *
 * TBoundingBox
 *
 ****************************************************************************)

{$REGION BoundingBox}

{ TBoundingBox }

class operator TBoundingBox.Initialize(var t: TBoundingBox);
begin
    t.Center := TXMFLOAT3.Create(0, 0, 0);
    t.Extents := TXMFLOAT3.Create(1.0, 1.0, 1.0);
end;



constructor TBoundingBox.Create(const ACenter: TXMFLOAT3; const AExtents: TXMFLOAT3);
begin
    Center := ACenter;
    Extents := AExtents;
end;

{ TBoundingBoxHelper }

//-----------------------------------------------------------------------------
// Transform an axis aligned box by an angle preserving transform.
//-----------------------------------------------------------------------------
procedure TBoundingBox.Transform(_Out: PBoundingBox; M: TFXMMATRIX);
var
    vCenter, vExtents, Corner: TXMVECTOR;
    Min, Max: TXMVECTOR;
    i: integer;
begin
    // Load center and extents.
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);

    // Compute and transform the corners and find new min/max bounds.
    Corner := XMVectorMultiplyAdd(vExtents, g_BoxOffset[0], vCenter);
    Corner := XMVector3Transform(Corner, M);


    Min := Corner;
    Max := Corner;

    for  i := 1 to BoundingBox_CORNER_COUNT - 1 do
    begin
        Corner := XMVectorMultiplyAdd(vExtents, g_BoxOffset[i], vCenter);
        Corner := XMVector3Transform(Corner, M);

        Min := XMVectorMin(Min, Corner);
        Max := XMVectorMax(Max, Corner);
    end;

    // Store center and extents.
    XMStoreFloat3(_Out.Center, XMVectorScale(XMVectorAdd(Min, Max), 0.5));
    XMStoreFloat3(_Out.Extents, XMVectorScale(XMVectorSubtract(Max, Min), 0.5));
end;



procedure TBoundingBox.Transform(_Out: PBoundingBox; Scale: single; Rotation, Translation: TFXMVECTOR);
var
    vCenter, vExtents, VectorScale, Corner: TXMVECTOR;
    Min, Max: TXMVECTOR;
    i: integer;
begin
    assert(XMQuaternionIsUnit(Rotation));

    // Load center and extents.
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);

    VectorScale := XMVectorReplicate(Scale);

    // Compute and transform the corners and find new min/max bounds.
    Corner := XMVectorMultiplyAdd(vExtents, g_BoxOffset[0], vCenter);
    Corner := XMVectorAdd(XMVector3Rotate(XMVectorMultiply(Corner, VectorScale), Rotation), Translation);


    Min := Corner;
    Max := Corner;

    for i := 1 to BoundingBox_CORNER_COUNT - 1 do
    begin
        Corner := XMVectorMultiplyAdd(vExtents, g_BoxOffset[i], vCenter);
        Corner := XMVectorAdd(XMVector3Rotate(XMVectorMultiply(Corner, VectorScale), Rotation), Translation);

        Min := XMVectorMin(Min, Corner);
        Max := XMVectorMax(Max, Corner);
    end;

    // Store center and extents.
    XMStoreFloat3(_Out.Center, XMVectorScale(XMVectorAdd(Min, Max), 0.5));
    XMStoreFloat3(_Out.Extents, XMVectorScale(XMVectorSubtract(Max, Min), 0.5));
end;


//-----------------------------------------------------------------------------
// Get the corner points of the box
//-----------------------------------------------------------------------------
procedure TBoundingBox.GetCorners(var Corners: array of TXMFLOAT3);
var
    vCenter, vExtents, C: TXMVECTOR;
    i: integer;
begin
    assert(@Corners[0] <> nil);

    // Load the box
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);

    for  i := 0 to BoundingBox_CORNER_COUNT - 1 do
    begin
        C := XMVectorMultiplyAdd(vExtents, g_BoxOffset[i], vCenter);
        XMStoreFloat3(Corners[i], C);
    end;
end;


//-----------------------------------------------------------------------------
// Point in axis-aligned box test
//-----------------------------------------------------------------------------
function TBoundingBox.Contains(Point: TFXMVECTOR): TContainmentType;
var
    vCenter, vExtents: TXMVECTOR;
begin
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);

    if XMVector3InBounds(XMVectorSubtract(Point, vCenter), vExtents) then Result := ctCONTAINS
    else
        Result := ctDISJOINT;
end;


//-----------------------------------------------------------------------------
// Triangle in axis-aligned box test
//-----------------------------------------------------------------------------
function TBoundingBox.Contains(V0, V1, V2: TFXMVECTOR): TContainmentType;
var
    vCenter, vExtents: TXMVECTOR;
    d, Inside: TXMVECTOR;
begin
    if (not Intersects(V0, V1, V2)) then
    begin
        Result := ctDISJOINT;
        Exit;
    end;

    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);

    d := XMVectorAbs(XMVectorSubtract(V0, vCenter));
    Inside := XMVectorLessOrEqual(d, vExtents);

    d := XMVectorAbs(XMVectorSubtract(V1, vCenter));
    Inside := XMVectorAndInt(Inside, XMVectorLessOrEqual(d, vExtents));

    d := XMVectorAbs(XMVectorSubtract(V2, vCenter));
    Inside := XMVectorAndInt(Inside, XMVectorLessOrEqual(d, vExtents));

    if (XMVector3EqualInt(Inside, XMVectorTrueInt())) then
        Result := ctCONTAINS
    else
        Result := ctINTERSECTS;
end;


//-----------------------------------------------------------------------------
// Sphere in axis-aligned box test
//-----------------------------------------------------------------------------
function TBoundingBox.Contains(sh: PBoundingSphere): TContainmentType;
var
    SphereCenter, SphereRadius, BoxCenter, BoxExtents, BoxMin, BoxMax, d, d2: TXMVECTOR;
    LessThanMin, GreaterThanMax, MinDelta, MaxDelta: TXMVECTOR;
    InsideAll: TXMVECTOR;
begin
    SphereCenter := XMLoadFloat3(sh.Center);
    SphereRadius := XMVectorReplicatePtr(@sh.Radius);

    BoxCenter := XMLoadFloat3(Center);
    BoxExtents := XMLoadFloat3(Extents);

    BoxMin := XMVectorSubtract(BoxCenter, BoxExtents);
    BoxMax := XMVectorAdd(BoxCenter, BoxExtents);

    // Find the distance to the nearest point on the box.
    // for each i in (x, y, z)
    // if (SphereCenter(i) < BoxMin(i)) d2 += (SphereCenter(i) - BoxMin(i)) ^ 2
    // else if (SphereCenter(i) > BoxMax(i)) d2 += (SphereCenter(i) - BoxMax(i)) ^ 2

    d := XMVectorZero();

    // Compute d for each dimension.
    LessThanMin := XMVectorLess(SphereCenter, BoxMin);
    GreaterThanMax := XMVectorGreater(SphereCenter, BoxMax);

    MinDelta := XMVectorSubtract(SphereCenter, BoxMin);
    MaxDelta := XMVectorSubtract(SphereCenter, BoxMax);

    // Choose value for each dimension based on the comparison.
    d := XMVectorSelect(d, MinDelta, LessThanMin);
    d := XMVectorSelect(d, MaxDelta, GreaterThanMax);

    // Use a dot-product to square them and sum them together.
    d2 := XMVector3Dot(d, d);

    if (XMVector3Greater(d2, XMVectorMultiply(SphereRadius, SphereRadius))) then
    begin
        Result := ctDISJOINT;
        exit;
    end;

    InsideAll := XMVectorLessOrEqual(XMVectorAdd(BoxMin, SphereRadius), SphereCenter);
    InsideAll := XMVectorAndInt(InsideAll, XMVectorLessOrEqual(SphereCenter, XMVectorSubtract(BoxMax, SphereRadius)));
    InsideAll := XMVectorAndInt(InsideAll, XMVectorGreater(XMVectorSubtract(BoxMax, BoxMin), SphereRadius));

    if (XMVector3EqualInt(InsideAll, XMVectorTrueInt())) then Result := ctCONTAINS
    else
        Result := ctINTERSECTS;
end;


//-----------------------------------------------------------------------------
// Axis-aligned box in axis-aligned box test
//-----------------------------------------------------------------------------
function TBoundingBox.Contains(box: PBoundingBox): TContainmentType;
var
    CenterA, ExtentsA, CenterB, ExtentsB: TXMVECTOR;
    MinA, MaxA, MinB, MaxB: TXMVECTOR;
    Disjoint, Inside: TXMVECTOR;
begin
    CenterA := XMLoadFloat3(Center);
    ExtentsA := XMLoadFloat3(Extents);

    CenterB := XMLoadFloat3(box.Center);
    ExtentsB := XMLoadFloat3(box.Extents);

    MinA := XMVectorSubtract(CenterA, ExtentsA);
    MaxA := XMVectorAdd(CenterA, ExtentsA);

    MinB := XMVectorSubtract(CenterB, ExtentsB);
    MaxB := XMVectorAdd(CenterB, ExtentsB);

    // for each i in (x, y, z) if a_min(i) > b_max(i) or b_min(i) > a_max(i) then return false
    Disjoint := XMVectorOrInt(XMVectorGreater(MinA, MaxB), XMVectorGreater(MinB, MaxA));

    if (XMVector3AnyTrue(Disjoint)) then
    begin
        Result := ctDISJOINT;
        Exit;
    end;

    // for each i in (x, y, z) if a_min(i) <= b_min(i) and b_max(i) <= a_max(i) then A contains B
    Inside := XMVectorAndInt(XMVectorLessOrEqual(MinA, MinB), XMVectorLessOrEqual(MaxB, MaxA));

    if XMVector3AllTrue(Inside) then Result := ctCONTAINS
    else
        Result := ctINTERSECTS;
end;


//-----------------------------------------------------------------------------
// Oriented box in axis-aligned box test
//-----------------------------------------------------------------------------
function TBoundingBox.Contains(box: PBoundingOrientedBox): TContainmentType;
var
    vCenter, vExtents: TXMVECTOR;
    oCenter, oExtents, oOrientation: TXMVECTOR;
    Inside: TXMVECTOR;
    i: integer;
    C, d: TXMVECTOR;
begin
    if (not box.Intersects(PBoundingBox(@self))) then
    begin
        Result := ctDISJOINT;
        Exit;
    end;

    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);

    // Subtract off the AABB center to remove a subtract below
    oCenter := XMVectorSubtract(XMLoadFloat3(box.Center), vCenter);

    oExtents := XMLoadFloat3(box.Extents);
    oOrientation := XMLoadFloat4(box.Orientation);

    assert(XMQuaternionIsUnit(oOrientation));

    Inside := XMVectorTrueInt();

    for  i := 0 to BoundingOrientedBox_CORNER_COUNT - 1 do
    begin
        C := XMVectorAdd(XMVector3Rotate(XMVectorMultiply(oExtents, g_BoxOffset[i]), oOrientation), oCenter);
        d := XMVectorAbs(C);
        Inside := XMVectorAndInt(Inside, XMVectorLessOrEqual(d, vExtents));
    end;

    if (XMVector3EqualInt(Inside, XMVectorTrueInt())) then
        Result := ctCONTAINS
    else
        Result := ctINTERSECTS;
end;


//-----------------------------------------------------------------------------
// Frustum in axis-aligned box test
//-----------------------------------------------------------------------------
function TBoundingBox.Contains(fr: PBoundingFrustum): TContainmentType;
var
    Corners: array [0..BoundingFrustum_CORNER_COUNT - 1] of TXMFLOAT3;
    vCenter, vExtents, Inside: TXMVECTOR;
    i: integer;
    Point, d: TXMVECTOR;
begin
    if (not fr.Intersects(PBoundingBox(@self))) then
    begin
        Result := ctDISJOINT;
        Exit;
    end;


    fr.GetCorners(Corners);

    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);

    Inside := XMVectorTrueInt();

    for  i := 0 to BoundingFrustum_CORNER_COUNT - 1 do
    begin
        Point := XMLoadFloat3(Corners[i]);
        d := XMVectorAbs(XMVectorSubtract(Point, vCenter));
        Inside := XMVectorAndInt(Inside, XMVectorLessOrEqual(d, vExtents));
    end;

    if (XMVector3EqualInt(Inside, XMVectorTrueInt())) then
        Result := ctCONTAINS
    else
        Result := ctINTERSECTS;
end;


//-----------------------------------------------------------------------------
// Sphere vs axis-aligned box test
//-----------------------------------------------------------------------------
function TBoundingBox.Intersects(sh: PBoundingSphere): boolean;
var
    SphereCenter, SphereRadius: TXMVECTOR;
    BoxCenter, BoxExtents: TXMVECTOR;
    BoxMin, BoxMax: TXMVECTOR;
    d, d2: TXMVECTOR;
    LessThanMin, GreaterThanMax: TXMVECTOR;
    MinDelta, MaxDelta: TXMVECTOR;
begin
    SphereCenter := XMLoadFloat3(sh.Center);
    SphereRadius := XMVectorReplicatePtr(@sh.Radius);

    BoxCenter := XMLoadFloat3(Center);
    BoxExtents := XMLoadFloat3(Extents);

    BoxMin := XMVectorSubtract(BoxCenter, BoxExtents);
    BoxMax := XMVectorAdd(BoxCenter, BoxExtents);

    // Find the distance to the nearest point on the box.
    // for each i in (x, y, z)
    // if (SphereCenter(i) < BoxMin(i)) d2 += (SphereCenter(i) - BoxMin(i)) ^ 2
    // else if (SphereCenter(i) > BoxMax(i)) d2 += (SphereCenter(i) - BoxMax(i)) ^ 2

    d := XMVectorZero();

    // Compute d for each dimension.
    LessThanMin := XMVectorLess(SphereCenter, BoxMin);
    GreaterThanMax := XMVectorGreater(SphereCenter, BoxMax);

    MinDelta := XMVectorSubtract(SphereCenter, BoxMin);
    MaxDelta := XMVectorSubtract(SphereCenter, BoxMax);

    // Choose value for each dimension based on the comparison.
    d := XMVectorSelect(d, MinDelta, LessThanMin);
    d := XMVectorSelect(d, MaxDelta, GreaterThanMax);

    // Use a dot-product to square them and sum them together.
    d2 := XMVector3Dot(d, d);

    Result := XMVector3LessOrEqual(d2, XMVectorMultiply(SphereRadius, SphereRadius));
end;


//-----------------------------------------------------------------------------
// Axis-aligned box vs. axis-aligned box test
//-----------------------------------------------------------------------------
function TBoundingBox.Intersects(box: PBoundingBox): boolean;
var
    CenterA, ExtentsA, CenterB, ExtentsB: TXMVECTOR;
    MinA, MinB, MaxA, MaxB: TXMVECTOR;
    Disjoint: TXMVECTOR;
begin
    CenterA := XMLoadFloat3(Center);
    ExtentsA := XMLoadFloat3(Extents);

    CenterB := XMLoadFloat3(box.Center);
    ExtentsB := XMLoadFloat3(box.Extents);

    MinA := XMVectorSubtract(CenterA, ExtentsA);
    MaxA := XMVectorAdd(CenterA, ExtentsA);

    MinB := XMVectorSubtract(CenterB, ExtentsB);
    MaxB := XMVectorAdd(CenterB, ExtentsB);

    // for each i in (x, y, z) if a_min(i) > b_max(i) or b_min(i) > a_max(i) then return false
    Disjoint := XMVectorOrInt(XMVectorGreater(MinA, MaxB), XMVectorGreater(MinB, MaxA));

    Result := not XMVector3AnyTrue(Disjoint);
end;


//-----------------------------------------------------------------------------
// Oriented box vs. axis-aligned box test
//-----------------------------------------------------------------------------
function TBoundingBox.Intersects(box: PBoundingOrientedBox): boolean;
begin
    Result := box.Intersects(PBoundingBox(@self));
end;


//-----------------------------------------------------------------------------
// Frustum vs. axis-aligned box test
//-----------------------------------------------------------------------------
function TBoundingBox.Intersects(fr: PBoundingFrustum): boolean;
begin
    Result := fr.Intersects(PBoundingBox(@self));
end;


//-----------------------------------------------------------------------------
// Triangle vs. axis aligned box test
//-----------------------------------------------------------------------------
function TBoundingBox.Intersects(V0, V1, V2: TFXMVECTOR): boolean;
var
    Zero: TXMVECTOR;
    vCenter, vExtents, BoxMin, BoxMax: TXMVECTOR;
    TriMin, TriMax, Disjoint: TXMVECTOR;

    Normal, Dist: TXMVECTOR;
    NormalSelect, V_Min, V_Max: TXMVECTOR;
    MinDist, MaxDist: TXMVECTOR;
    NoIntersection: TXMVECTOR;
    TV0, TV1, TV2: TXMVECTOR;

    Axis, e0, e1, e2: TXMVECTOR;
    p0, p1, p2: TXMVECTOR;
    Min, Max: TXMVECTOR;
    Radius: TXMVECTOR;
begin
    Zero := XMVectorZero();

    // Load the box.
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);

    BoxMin := XMVectorSubtract(vCenter, vExtents);
    BoxMax := XMVectorAdd(vCenter, vExtents);

    // Test the axes of the box (in effect test the AAB against the minimal AAB
    // around the triangle).
    TriMin := XMVectorMin(XMVectorMin(V0, V1), V2);
    TriMax := XMVectorMax(XMVectorMax(V0, V1), V2);

    // for each i in (x, y, z) if a_min(i) > b_max(i) or b_min(i) > a_max(i) then disjoint
    Disjoint := XMVectorOrInt(XMVectorGreater(TriMin, BoxMax), XMVectorGreater(BoxMin, TriMax));
    if (XMVector3AnyTrue(Disjoint)) then
    begin
        Result := False;
        Exit;
    end;


    // Test the plane of the triangle.
    Normal := XMVector3Cross(XMVectorSubtract(V1, V0), XMVectorSubtract(V2, V0));
    Dist := XMVector3Dot(Normal, V0);

    // Assert that the triangle is not degenerate.
    assert(not XMVector3Equal(Normal, Zero));

    // for each i in (x, y, z) if n(i) >= 0 then v_min(i)=b_min(i), v_max(i)=b_max(i)
    // else v_min(i)=b_max(i), v_max(i)=b_min(i)
    NormalSelect := XMVectorGreater(Normal, Zero);
    V_Min := XMVectorSelect(BoxMax, BoxMin, NormalSelect);
    V_Max := XMVectorSelect(BoxMin, BoxMax, NormalSelect);

    // if n dot v_min + d > 0 OR n dot v_max + d < 0 then disjoint
    MinDist := XMVector3Dot(V_Min, Normal);
    MaxDist := XMVector3Dot(V_Max, Normal);

    NoIntersection := XMVectorGreater(MinDist, Dist);
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(MaxDist, Dist));

    // Move the box center to zero to simplify the following tests.
    TV0 := XMVectorSubtract(V0, vCenter);
    TV1 := XMVectorSubtract(V1, vCenter);
    TV2 := XMVectorSubtract(V2, vCenter);

    // Test the edge/edge axes (3*3).
    e0 := XMVectorSubtract(TV1, TV0);
    e1 := XMVectorSubtract(TV2, TV1);
    e2 := XMVectorSubtract(TV0, TV2);

    // Make w zero.
    e0 := XMVectorInsert(0, 0, 0, 0, 1, e0, Zero);
    e1 := XMVectorInsert(0, 0, 0, 0, 1, e1, Zero);
    e2 := XMVectorInsert(0, 0, 0, 0, 1, e2, Zero);



    // Axis == (1,0,0) x e0 := (0, -e0.z, e0.y)
    Axis := XMVectorPermute(XM_PERMUTE_0W, XM_PERMUTE_1Z, XM_PERMUTE_0Y, XM_PERMUTE_0X, e0, XMVectorNegate(e0));
    p0 := XMVector3Dot(TV0, Axis);
    // p1 := XMVector3Dot( V1, Axis ); // p1 := p0;
    p2 := XMVector3Dot(TV2, Axis);
    Min := XMVectorMin(p0, p2);
    Max := XMVectorMax(p0, p2);
    Radius := XMVector3Dot(vExtents, XMVectorAbs(Axis));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(Min, Radius));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(Max, XMVectorNegate(Radius)));

    // Axis == (1,0,0) x e1 := (0, -e1.z, e1.y)
    Axis := XMVectorPermute(XM_PERMUTE_0W, XM_PERMUTE_1Z, XM_PERMUTE_0Y, XM_PERMUTE_0X, e1, XMVectorNegate(e1));
    p0 := XMVector3Dot(TV0, Axis);
    p1 := XMVector3Dot(TV1, Axis);
    // p2 := XMVector3Dot( V2, Axis ); // p2 := p1;
    Min := XMVectorMin(p0, p1);
    Max := XMVectorMax(p0, p1);
    Radius := XMVector3Dot(vExtents, XMVectorAbs(Axis));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(Min, Radius));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(Max, XMVectorNegate(Radius)));

    // Axis == (1,0,0) x e2 := (0, -e2.z, e2.y)
    Axis := XMVectorPermute(XM_PERMUTE_0W, XM_PERMUTE_1Z, XM_PERMUTE_0Y, XM_PERMUTE_0X, e2, XMVectorNegate(e2));
    p0 := XMVector3Dot(TV0, Axis);
    p1 := XMVector3Dot(TV1, Axis);
    // p2 := XMVector3Dot( V2, Axis ); // p2 := p0;
    Min := XMVectorMin(p0, p1);
    Max := XMVectorMax(p0, p1);
    Radius := XMVector3Dot(vExtents, XMVectorAbs(Axis));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(Min, Radius));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(Max, XMVectorNegate(Radius)));

    // Axis == (0,1,0) x e0 := (e0.z, 0, -e0.x)
    Axis := XMVectorPermute(XM_PERMUTE_0Z, XM_PERMUTE_0W, XM_PERMUTE_1X, XM_PERMUTE_0Y, e0, XMVectorNegate(e0));
    p0 := XMVector3Dot(TV0, Axis);
    // p1 := XMVector3Dot( V1, Axis ); // p1 := p0;
    p2 := XMVector3Dot(TV2, Axis);
    Min := XMVectorMin(p0, p2);
    Max := XMVectorMax(p0, p2);
    Radius := XMVector3Dot(vExtents, XMVectorAbs(Axis));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(Min, Radius));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(Max, XMVectorNegate(Radius)));

    // Axis == (0,1,0) x e1 := (e1.z, 0, -e1.x)
    Axis := XMVectorPermute(XM_PERMUTE_0Z, XM_PERMUTE_0W, XM_PERMUTE_1X, XM_PERMUTE_0Y, e1, XMVectorNegate(e1));
    p0 := XMVector3Dot(TV0, Axis);
    p1 := XMVector3Dot(TV1, Axis);
    // p2 := XMVector3Dot( V2, Axis ); // p2 := p1;
    Min := XMVectorMin(p0, p1);
    Max := XMVectorMax(p0, p1);
    Radius := XMVector3Dot(vExtents, XMVectorAbs(Axis));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(Min, Radius));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(Max, XMVectorNegate(Radius)));

    // Axis == (0,0,1) x e2 := (e2.z, 0, -e2.x)
    Axis := XMVectorPermute(XM_PERMUTE_0Z, XM_PERMUTE_0W, XM_PERMUTE_1X, XM_PERMUTE_0Y, e2, XMVectorNegate(e2));
    p0 := XMVector3Dot(TV0, Axis);
    p1 := XMVector3Dot(TV1, Axis);
    // p2 := XMVector3Dot( V2, Axis ); // p2 := p0;
    Min := XMVectorMin(p0, p1);
    Max := XMVectorMax(p0, p1);
    Radius := XMVector3Dot(vExtents, XMVectorAbs(Axis));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(Min, Radius));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(Max, XMVectorNegate(Radius)));

    // Axis == (0,0,1) x e0 := (-e0.y, e0.x, 0)
    Axis := XMVectorPermute(XM_PERMUTE_1Y, XM_PERMUTE_0X, XM_PERMUTE_0W, XM_PERMUTE_0Z, e0, XMVectorNegate(e0));
    p0 := XMVector3Dot(TV0, Axis);
    // p1 := XMVector3Dot( V1, Axis ); // p1 := p0;
    p2 := XMVector3Dot(TV2, Axis);
    Min := XMVectorMin(p0, p2);
    Max := XMVectorMax(p0, p2);
    Radius := XMVector3Dot(vExtents, XMVectorAbs(Axis));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(Min, Radius));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(Max, XMVectorNegate(Radius)));

    // Axis == (0,0,1) x e1 := (-e1.y, e1.x, 0)
    Axis := XMVectorPermute(XM_PERMUTE_1Y, XM_PERMUTE_0X, XM_PERMUTE_0W, XM_PERMUTE_0Z, e1, XMVectorNegate(e1));
    p0 := XMVector3Dot(TV0, Axis);
    p1 := XMVector3Dot(TV1, Axis);
    // p2 := XMVector3Dot( V2, Axis ); // p2 := p1;
    Min := XMVectorMin(p0, p1);
    Max := XMVectorMax(p0, p1);
    Radius := XMVector3Dot(vExtents, XMVectorAbs(Axis));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(Min, Radius));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(Max, XMVectorNegate(Radius)));

    // Axis == (0,0,1) x e2 := (-e2.y, e2.x, 0)
    Axis := XMVectorPermute(XM_PERMUTE_1Y, XM_PERMUTE_0X, XM_PERMUTE_0W, XM_PERMUTE_0Z, e2, XMVectorNegate(e2));
    p0 := XMVector3Dot(TV0, Axis);
    p1 := XMVector3Dot(TV1, Axis);
    // p2 := XMVector3Dot( V2, Axis ); // p2 := p0;
    Min := XMVectorMin(p0, p1);
    Max := XMVectorMax(p0, p1);
    Radius := XMVector3Dot(vExtents, XMVectorAbs(Axis));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(Min, Radius));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(Max, XMVectorNegate(Radius)));

    Result := XMVector4NotEqualInt(NoIntersection, XMVectorTrueInt());
end;



function TBoundingBox.Intersects(Plane: TFXMVECTOR): TPlaneIntersectionType;
var
    vCenter, vExtents: TXMVECTOR;
    Outside, Inside: TXMVECTOR;
begin
    assert(XMPlaneIsUnit(Plane));

    // Load the box.
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);

    // Set w of the center to one so we can dot4 with a plane.
    vCenter := XMVectorInsert(0, 0, 0, 0, 1, vCenter, XMVectorSplatOne());


    FastIntersectAxisAlignedBoxPlane(vCenter, vExtents, Plane, Outside, Inside);

    // If the box is outside any plane it is outside.
    if (XMVector4EqualInt(Outside, XMVectorTrueInt())) then
        Result := piFRONT

    // If the box is inside all planes it is inside.
    else if (XMVector4EqualInt(Inside, XMVectorTrueInt())) then
        Result := piBACK

    else
        // The box is not inside all planes or outside a plane it intersects.
        Result := piINTERSECTING;
end;


//-----------------------------------------------------------------------------
// Compute the intersection of a ray (Origin, Direction) with an axis aligned
// box using the slabs method.
//-----------------------------------------------------------------------------
function TBoundingBox.Intersects(Origin, Direction: TFXMVECTOR; var Dist: single): boolean;
var
    vCenter, vExtents, TOrigin: TXMVECTOR;
    AxisDotOrigin, AxisDotDirection, IsParallel: TXMVECTOR;
    InverseAxisDotDirection, t1, t2: TXMVECTOR;

    t_min, t_max, NoIntersection, ParallelOverlap: TXMVECTOR;
begin
    assert(XMVector3IsUnit(Direction));

    // Load the box.
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);

    // Adjust ray origin to be relative to center of the box.
    TOrigin := XMVectorSubtract(vCenter, Origin);

    // Compute the dot product againt each axis of the box.
    // Since the axii are (1,0,0), (0,1,0), (0,0,1) no computation is necessary.
    AxisDotOrigin := TOrigin;
    AxisDotDirection := Direction;

    // if (fabs(AxisDotDirection) <= Epsilon) the ray is nearly parallel to the slab.
    IsParallel := XMVectorLessOrEqual(XMVectorAbs(AxisDotDirection), g_RayEpsilon);

    // Test against all three axii simultaneously.
    InverseAxisDotDirection := XMVectorReciprocal(AxisDotDirection);
    t1 := XMVectorMultiply(XMVectorSubtract(AxisDotOrigin, vExtents), InverseAxisDotDirection);
    t2 := XMVectorMultiply(XMVectorAdd(AxisDotOrigin, vExtents), InverseAxisDotDirection);

    // Compute the max of min(t1,t2) and the min of max(t1,t2) ensuring we don't
    // use the results from any directions parallel to the slab.
    t_min := XMVectorSelect(XMVectorMin(t1, t2), g_FltMin, IsParallel);
    t_max := XMVectorSelect(XMVectorMax(t1, t2), g_FltMax, IsParallel);

    // t_min.x := maximum( t_min.x, t_min.y, t_min.z );
    // t_max.x := minimum( t_max.x, t_max.y, t_max.z );
    t_min := XMVectorMax(t_min, XMVectorSplatY(t_min));  // x := max(x,y)
    t_min := XMVectorMax(t_min, XMVectorSplatZ(t_min));  // x := max(max(x,y),z)
    t_max := XMVectorMin(t_max, XMVectorSplatY(t_max));  // x := min(x,y)
    t_max := XMVectorMin(t_max, XMVectorSplatZ(t_max));  // x := min(min(x,y),z)

    // if ( t_min > t_max ) return false;
    NoIntersection := XMVectorGreater(XMVectorSplatX(t_min), XMVectorSplatX(t_max));

    // if ( t_max < 0.0 ) return false;
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(XMVectorSplatX(t_max), XMVectorZero()));

    // if (IsParallel AND (-Extents > AxisDotOrigin OR Extents < AxisDotOrigin)) return false;
    ParallelOverlap := XMVectorInBounds(AxisDotOrigin, vExtents);
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorAndCInt(IsParallel, ParallelOverlap));

    if (not XMVector3AnyTrue(NoIntersection)) then
    begin
        // Store the x-component to *pDist
        XMStoreFloat(Dist, t_min);
        Result := True;
    end
    else
    begin
        Dist := 0.0;
        Result := False;

    end;
end;


//-----------------------------------------------------------------------------
// Test an axis alinged box vs 6 planes (typically forming a frustum).
//-----------------------------------------------------------------------------
function TBoundingBox.ContainedBy(Plane0, Plane1, Plane2: TFXMVECTOR; Plane3: TGXMVECTOR; Plane4, Plane5: THXMVECTOR): TContainmentType;
var
    vCenter, vExtents: TXMVECTOR;
    Outside, Inside: TXMVECTOR;
    AnyOutside, AllInside: TXMVECTOR;
begin
    // Load the box.
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);

    // Set w of the center to one so we can dot4 with a plane.
    vCenter := XMVectorInsert(0, 0, 0, 0, 1, vCenter, XMVectorSplatOne());



    // Test against each plane.
    FastIntersectAxisAlignedBoxPlane(vCenter, vExtents, Plane0, Outside, Inside);

    AnyOutside := Outside;
    AllInside := Inside;

    FastIntersectAxisAlignedBoxPlane(vCenter, vExtents, Plane1, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectAxisAlignedBoxPlane(vCenter, vExtents, Plane2, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectAxisAlignedBoxPlane(vCenter, vExtents, Plane3, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectAxisAlignedBoxPlane(vCenter, vExtents, Plane4, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectAxisAlignedBoxPlane(vCenter, vExtents, Plane5, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    // If the box is outside any plane it is outside.
    if (XMVector4EqualInt(AnyOutside, XMVectorTrueInt())) then
        Result := ctDISJOINT

    // If the box is inside all planes it is inside.
    else if (XMVector4EqualInt(AllInside, XMVectorTrueInt())) then
        Result := ctCONTAINS
    else
        // The box is not inside all planes or outside a plane, it may intersect.
        Result := ctINTERSECTS;
end;


//-----------------------------------------------------------------------------
// Create axis-aligned box that contains two other bounding boxes
//-----------------------------------------------------------------------------
procedure TBoundingBox.CreateMerged(_Out: PBoundingBox; b1, b2: PBoundingBox);
var
    b1Center, b1Extents, b2Center, b2Extents, Min, Max: TXMVECTOR;

begin
    b1Center := XMLoadFloat3(b1.Center);
    b1Extents := XMLoadFloat3(b1.Extents);

    b2Center := XMLoadFloat3(b2.Center);
    b2Extents := XMLoadFloat3(b2.Extents);

    Min := XMVectorSubtract(b1Center, b1Extents);
    Min := XMVectorMin(Min, XMVectorSubtract(b2Center, b2Extents));

    Max := XMVectorAdd(b1Center, b1Extents);
    Max := XMVectorMax(Max, XMVectorAdd(b2Center, b2Extents));

    assert(XMVector3LessOrEqual(Min, Max));

    XMStoreFloat3(_Out.Center, XMVectorScale(XMVectorAdd(Min, Max), 0.5));
    XMStoreFloat3(_Out.Extents, XMVectorScale(XMVectorSubtract(Max, Min), 0.5));
end;


//-----------------------------------------------------------------------------
// Create axis-aligned box that contains a bounding sphere
//-----------------------------------------------------------------------------
procedure TBoundingBox.CreateFromSphere(_Out: PBoundingBox; sh: PBoundingSphere);
var
    spCenter, shRadius, Min, Max: TXMVECTOR;
begin
    spCenter := XMLoadFloat3(sh.Center);
    shRadius := XMVectorReplicatePtr(@sh.Radius);

    Min := XMVectorSubtract(spCenter, shRadius);
    Max := XMVectorAdd(spCenter, shRadius);

    assert(XMVector3LessOrEqual(Min, Max));

    XMStoreFloat3(_Out.Center, XMVectorScale(XMVectorAdd(Min, Max), 0.5));
    XMStoreFloat3(_Out.Extents, XMVectorScale(XMVectorSubtract(Max, Min), 0.5));
end;


//-----------------------------------------------------------------------------
// Create axis-aligned box from min/max points
//-----------------------------------------------------------------------------
procedure TBoundingBox.CreateFromPoints(_Out: PBoundingBox; pt1, pt2: TFXMVECTOR);
var
    Min, Max: TXMVECTOR;
begin
    Min := XMVectorMin(pt1, pt2);
    Max := XMVectorMax(pt1, pt2);

    // Store center and extents.
    XMStoreFloat3(_Out.Center, XMVectorScale(XMVectorAdd(Min, Max), 0.5));
    XMStoreFloat3(_Out.Extents, XMVectorScale(XMVectorSubtract(Max, Min), 0.5));
end;


//-----------------------------------------------------------------------------
// Find the minimum axis aligned bounding box containing a set of points.
//-----------------------------------------------------------------------------
procedure TBoundingBox.CreateFromPoints(_Out: PBoundingBox; Count: size_t; constref pPoints: PXMFLOAT3; Stride: size_t);
var
    vMin, vMax, Point: TXMVECTOR;
    i: integer;
begin
    assert(Count > 0);
    assert(pPoints <> nil);

    // Find the minimum and maximum x, y, and z


    vMin := XMLoadFloat3(pPoints^);
    vMax := vMin;

    for  i := 1 to Count - 1 do
    begin
        Point := XMLoadFloat3(PXMFLOAT3(pbyte(pPoints) + i * Stride)^);

        vMin := XMVectorMin(vMin, Point);
        vMax := XMVectorMax(vMax, Point);
    end;

    // Store center and extents.
    XMStoreFloat3(_Out.Center, XMVectorScale(XMVectorAdd(vMin, vMax), 0.5));
    XMStoreFloat3(_Out.Extents, XMVectorScale(XMVectorSubtract(vMax, vMin), 0.5));
end;

{$ENDREGION}




(****************************************************************************
 *
 * TBoundingOrientedBox
 *
 ****************************************************************************)

{$REGION BoundingOrientedBox}

{ TBoundingOrientedBox }

constructor TBoundingOrientedBox.Create(constref ACenter: TXMFLOAT3; constref AExtents: TXMFLOAT3; constref AOrientation: TXMFLOAT4);
begin
    Center := ACenter;
    Extents := AExtents;
    Orientation := AOrientation;
end;



class operator TBoundingOrientedBox.Initialize(var t: TBoundingOrientedBox);
begin
    t.Center := TXMFLOAT3.Create(0, 0, 0);
    t.Extents := TXMFLOAT3.Create(1.0, 1.0, 1.0);
    t.Orientation := TXMFLOAT4.Create(0, 0, 0, 1.0);
end;


{ TBoundingOrientedBoxHelper }

//-----------------------------------------------------------------------------
// Transform an oriented box by an angle preserving transform.
//-----------------------------------------------------------------------------
procedure TBoundingOrientedBox.Transform(var _Out: TBoundingOrientedBox; M: TFXMMATRIX);
var
    vCenter, vExtents, vOrientation: TXMVECTOR;
    nM: TXMMATRIX;
    Rotation: TXMVECTOR;
    dX, dY, dZ: TXMVECTOR;
    VectorScale: TXMVECTOR;
begin
    // Load the box.
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);
    vOrientation := XMLoadFloat4(Orientation);

    assert(XMQuaternionIsUnit(vOrientation));

    // Composite the box rotation and the transform rotation.

    nM.r[0] := XMVector3Normalize(M.r[0]);
    nM.r[1] := XMVector3Normalize(M.r[1]);
    nM.r[2] := XMVector3Normalize(M.r[2]);
    nM.r[3] := g_XMIdentityR3;
    Rotation := XMQuaternionRotationMatrix(nM);
    vOrientation := XMQuaternionMultiply(vOrientation, Rotation);

    // Transform the center.
    vCenter := XMVector3Transform(vCenter, M);

    // Scale the box extents.
    dX := XMVector3Length(M.r[0]);
    dY := XMVector3Length(M.r[1]);
    dZ := XMVector3Length(M.r[2]);

    VectorScale := XMVectorSelect(dY, dX, g_XMSelect1000);
    VectorScale := XMVectorSelect(dZ, VectorScale, g_XMSelect1100);
    vExtents := XMVectorMultiply(vExtents, VectorScale);

    // Store the box.
    XMStoreFloat3(_Out.Center, vCenter);
    XMStoreFloat3(_Out.Extents, vExtents);
    XMStoreFloat4(_Out.Orientation, vOrientation);
end;



procedure TBoundingOrientedBox.Transform(var _Out: TBoundingOrientedBox; Scale: single; Rotation, Translation: TFXMVECTOR);
var
    vCenter, vExtents, vOrientation: TXMVECTOR;
    VectorScale: TXMVECTOR;
begin
    assert(XMQuaternionIsUnit(Rotation));

    // Load the box.
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);
    vOrientation := XMLoadFloat4(Orientation);

    assert(XMQuaternionIsUnit(vOrientation));

    // Composite the box rotation and the transform rotation.
    vOrientation := XMQuaternionMultiply(vOrientation, Rotation);

    // Transform the center.
    VectorScale := XMVectorReplicate(Scale);
    vCenter := XMVectorAdd(XMVector3Rotate(XMVectorMultiply(vCenter, VectorScale), Rotation), Translation);

    // Scale the box extents.
    vExtents := XMVectorMultiply(vExtents, VectorScale);

    // Store the box.
    XMStoreFloat3(_Out.Center, vCenter);
    XMStoreFloat3(_Out.Extents, vExtents);
    XMStoreFloat4(_Out.Orientation, vOrientation);
end;


//-----------------------------------------------------------------------------
// Get the corner points of the box
//-----------------------------------------------------------------------------
procedure TBoundingOrientedBox.GetCorners(var Corners: array of TXMFLOAT3);
var
    vCenter, vExtents, vOrientation: TXMVECTOR;
    C: TXMVECTOR;
    i: integer;
begin
    assert(@Corners[0] <> nil);

    // Load the box
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);
    vOrientation := XMLoadFloat4(Orientation);

    assert(XMQuaternionIsUnit(vOrientation));

    for  i := 0 to BoundingOrientedBox_CORNER_COUNT - 1 do
    begin
        C := XMVectorAdd(XMVector3Rotate(XMVectorMultiply(vExtents, g_BoxOffset[i]), vOrientation), vCenter);
        XMStoreFloat3(Corners[i], C);
    end;
end;


//-----------------------------------------------------------------------------
// Point in oriented box test.
//-----------------------------------------------------------------------------
function TBoundingOrientedBox.Contains(Point: TFXMVECTOR): TContainmentType;
var
    vCenter, vExtents, vOrientation: TXMVECTOR;
    TPoint: TXMVECTOR;
begin
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);
    vOrientation := XMLoadFloat4(Orientation);

    // Transform the point to be local to the box.
    TPoint := XMVector3InverseRotate(XMVectorSubtract(Point, vCenter), vOrientation);

    if XMVector3InBounds(TPoint, vExtents) then Result := ctCONTAINS
    else
        Result := ctDISJOINT;
end;


//-----------------------------------------------------------------------------
// Triangle in oriented bounding box
//-----------------------------------------------------------------------------
function TBoundingOrientedBox.Contains(V0, V1, V2: TFXMVECTOR): TContainmentType;
var
    vCenter, vOrientation: TXMVECTOR;
    TV0, TV1, TV2: TXMVECTOR;
    box: TBoundingBox;
begin
    // Load the box center & orientation.
    vCenter := XMLoadFloat3(Center);
    vOrientation := XMLoadFloat4(Orientation);

    // Transform the triangle vertices into the space of the box.
    TV0 := XMVector3InverseRotate(XMVectorSubtract(V0, vCenter), vOrientation);
    TV1 := XMVector3InverseRotate(XMVectorSubtract(V1, vCenter), vOrientation);
    TV2 := XMVector3InverseRotate(XMVectorSubtract(V2, vCenter), vOrientation);


    box.Center := TXMFLOAT3.Create(0.0, 0.0, 0.0);
    box.Extents := Extents;

    // Use the triangle vs axis aligned box intersection routine.
    Result := box.Contains(TV0, TV1, TV2);
end;


//-----------------------------------------------------------------------------
// Sphere in oriented bounding box
//-----------------------------------------------------------------------------
function TBoundingOrientedBox.Contains(sh: PBoundingSphere): TContainmentType;
var
    SphereCenter, SphereRadius: TXMVECTOR;
    BoxCenter, BoxExtents, BoxOrientation: TXMVECTOR;
    d, d2, LessThanMin, GreaterThanMax: TXMVECTOR;
    MinDelta, MaxDelta: TXMVECTOR;
    SphereRadiusSq: TXMVECTOR;
    SMin, SMax: TXMVECTOR;
begin
    SphereCenter := XMLoadFloat3(sh.Center);
    SphereRadius := XMVectorReplicatePtr(@sh.Radius);

    BoxCenter := XMLoadFloat3(Center);
    BoxExtents := XMLoadFloat3(Extents);
    BoxOrientation := XMLoadFloat4(Orientation);

    assert(XMQuaternionIsUnit(BoxOrientation));

    // Transform the center of the sphere to be local to the box.
    // BoxMin := -BoxExtents
    // BoxMax := +BoxExtents
    SphereCenter := XMVector3InverseRotate(XMVectorSubtract(SphereCenter, BoxCenter), BoxOrientation);

    // Find the distance to the nearest point on the box.
    // for each i in (x, y, z)
    // if (SphereCenter(i) < BoxMin(i)) d2 += (SphereCenter(i) - BoxMin(i)) ^ 2
    // else if (SphereCenter(i) > BoxMax(i)) d2 += (SphereCenter(i) - BoxMax(i)) ^ 2

    d := XMVectorZero();

    // Compute d for each dimension.
    LessThanMin := XMVectorLess(SphereCenter, XMVectorNegate(BoxExtents));
    GreaterThanMax := XMVectorGreater(SphereCenter, BoxExtents);

    MinDelta := XMVectorAdd(SphereCenter, BoxExtents);
    MaxDelta := XMVectorSubtract(SphereCenter, BoxExtents);

    // Choose value for each dimension based on the comparison.
    d := XMVectorSelect(d, MinDelta, LessThanMin);
    d := XMVectorSelect(d, MaxDelta, GreaterThanMax);

    // Use a dot-product to square them and sum them together.
    d2 := XMVector3Dot(d, d);
    SphereRadiusSq := XMVectorMultiply(SphereRadius, SphereRadius);

    if (XMVector4Greater(d2, SphereRadiusSq)) then
    begin
        Result := ctDISJOINT;
        Exit;
    end;

    // See if we are completely inside the box
    SMin := XMVectorSubtract(SphereCenter, SphereRadius);
    SMax := XMVectorAdd(SphereCenter, SphereRadius);

    if (XMVector3InBounds(SMin, BoxExtents) and XMVector3InBounds(SMax, BoxExtents)) then
        Result := ctCONTAINS
    else
        Result := ctINTERSECTS;
end;


//-----------------------------------------------------------------------------
// Axis aligned box vs. oriented box. Constructs an oriented box and uses
// the oriented box vs. oriented box test.
//-----------------------------------------------------------------------------
function TBoundingOrientedBox.Contains(box: PBoundingBox): TContainmentType;
var
    obox: TBoundingOrientedBox;
begin
    // Make the axis aligned box oriented and do an OBB vs OBB test.
    obox := TBoundingOrientedBox.Create(box.Center, box.Extents, TXMFLOAT4.Create(0.0, 0.0, 0.0, 1.0));
    Result := Contains(PBoundingOrientedBox(@obox));
end;


//-----------------------------------------------------------------------------
// Oriented bounding box in oriented bounding box
//-----------------------------------------------------------------------------
function TBoundingOrientedBox.Contains(box: PBoundingOrientedBox): TContainmentType;
var
    aCenter, aExtents, aOrientation: TXMVECTOR;
    bCenter, bExtents, bOrientation: TXMVECTOR;
    offset, C: TXMVECTOR;
    i: integer;
begin
    if (not Intersects(box)) then
    begin
        Result := ctDISJOINT;
        Exit;
    end;

    // Load the boxes
    aCenter := XMLoadFloat3(Center);
    aExtents := XMLoadFloat3(Extents);
    aOrientation := XMLoadFloat4(Orientation);

    assert(XMQuaternionIsUnit(aOrientation));

    bCenter := XMLoadFloat3(box.Center);
    bExtents := XMLoadFloat3(box.Extents);
    bOrientation := XMLoadFloat4(box.Orientation);

    assert(XMQuaternionIsUnit(bOrientation));

    offset := XMVectorSubtract(bCenter, aCenter);

    for  i := 0 to BoundingOrientedBox_CORNER_COUNT - 1 do
    begin
        // Cb := rotate( bExtents * corneroffset[i], bOrientation ) + bcenter
        // Ca := invrotate( Cb - aCenter, aOrientation )

        C := XMVectorAdd(XMVector3Rotate(XMVectorMultiply(bExtents, g_BoxOffset[i]), bOrientation), offset);
        C := XMVector3InverseRotate(C, aOrientation);

        if (not XMVector3InBounds(C, aExtents)) then
        begin
            Result := ctINTERSECTS;
            Exit;
        end;
    end;

    Result := ctCONTAINS;
end;


//-----------------------------------------------------------------------------
// Frustum in oriented bounding box
//-----------------------------------------------------------------------------
function TBoundingOrientedBox.Contains(fr: PBoundingFrustum): TContainmentType;
var
    Corners: array [0..BoundingFrustum_CORNER_COUNT - 1] of TXMFLOAT3;
    vCenter, vExtents, vOrientation, C: TXMVECTOR;
    i: integer;
begin
    if (not fr.Intersects(PBoundingOrientedBox(@self))) then
    begin
        Result := ctDISJOINT;
        Exit;
    end;


    fr.GetCorners(Corners);

    // Load the box
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);
    vOrientation := XMLoadFloat4(Orientation);

    assert(XMQuaternionIsUnit(vOrientation));

    for  i := 0 to BoundingFrustum_CORNER_COUNT - 1 do
    begin
        C := XMVector3InverseRotate(XMVectorSubtract(XMLoadFloat3(Corners[i]), vCenter), vOrientation);

        if (not XMVector3InBounds(C, vExtents)) then
        begin
            Result := ctINTERSECTS;
            Exit;
        end;
    end;

    Result := ctCONTAINS;
end;



//-----------------------------------------------------------------------------
// Sphere vs. oriented box test
//-----------------------------------------------------------------------------
function TBoundingOrientedBox.Intersects(sh: PBoundingSphere): boolean;
var
    SphereCenter, SphereRadius, BoxCenter, BoxExtents, BoxOrientation: TXMVECTOR;
    d, LessThanMin, GreaterThanMax, MinDelta, MaxDelta, d2: TXMVECTOR;
begin
    SphereCenter := XMLoadFloat3(sh.Center);
    SphereRadius := XMVectorReplicatePtr(@sh.Radius);

    BoxCenter := XMLoadFloat3(Center);
    BoxExtents := XMLoadFloat3(Extents);
    BoxOrientation := XMLoadFloat4(Orientation);
    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(BoxOrientation));
    {$ENDIF}


    // Transform the center of the sphere to be local to the box.
    // BoxMin := -BoxExtents
    // BoxMax := +BoxExtents
    SphereCenter := XMVector3InverseRotate(XMVectorSubtract(SphereCenter, BoxCenter), BoxOrientation);

    // Find the distance to the nearest point on the box.
    // for each i in (x, y, z)
    // if (SphereCenter(i) < BoxMin(i)) d2 += (SphereCenter(i) - BoxMin(i)) ^ 2
    // else if (SphereCenter(i) > BoxMax(i)) d2 += (SphereCenter(i) - BoxMax(i)) ^ 2

    d := XMVectorZero();

    // Compute d for each dimension.
    LessThanMin := XMVectorLess(SphereCenter, XMVectorNegate(BoxExtents));
    GreaterThanMax := XMVectorGreater(SphereCenter, BoxExtents);

    MinDelta := XMVectorAdd(SphereCenter, BoxExtents);
    MaxDelta := XMVectorSubtract(SphereCenter, BoxExtents);

    // Choose value for each dimension based on the comparison.
    d := XMVectorSelect(d, MinDelta, LessThanMin);
    d := XMVectorSelect(d, MaxDelta, GreaterThanMax);

    // Use a dot-product to square them and sum them together.
    d2 := XMVector3Dot(d, d);

    Result := XMVector4LessOrEqual(d2, XMVectorMultiply(SphereRadius, SphereRadius));
end;


//-----------------------------------------------------------------------------
// Axis aligned box vs. oriented box. Constructs an oriented box and uses
// the oriented box vs. oriented box test.
//-----------------------------------------------------------------------------
function TBoundingOrientedBox.Intersects(box: PBoundingBox): boolean;
var
    obox: TBoundingOrientedBox;
begin
    // Make the axis aligned box oriented and do an OBB vs OBB test.
    obox := TBoundingOrientedBox.Create(box.Center, box.Extents, TXMFLOAT4.Create(0.0, 0.0, 0.0, 1.0));
    Result := Intersects(PBoundingOrientedBox(@obox));
end;


//-----------------------------------------------------------------------------
// Fast oriented box / oriented box intersection test using the separating axis
// theorem.
//-----------------------------------------------------------------------------
function TBoundingOrientedBox.Intersects(box: PBoundingOrientedBox): boolean;
var
    A_quat, B_quat, Q, A_cent, B_cent, t: TXMVECTOR;
    R: TXMMATRIX;
    h_A, h_B, R0X, R1X, R2X: TXMVECTOR;
    RX0, RX1, RX2, AR0X, AR1X, AR2X: TXMVECTOR;
    ARX0, ARX1, ARX2: TXMVECTOR;
    d, d_A, d_B: TXMVECTOR;
    NoIntersection: TXMVECTOR;
begin
    // Build the 3x3 rotation matrix that defines the orientation of B relative to A.
    A_quat := XMLoadFloat4(Orientation);
    B_quat := XMLoadFloat4(box.Orientation);

{$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(A_quat));
    assert(XMQuaternionIsUnit(B_quat));
	{$ENDIF}

    Q := XMQuaternionMultiply(A_quat, XMQuaternionConjugate(B_quat));
    R := XMMatrixRotationQuaternion(Q);

    // Compute the translation of B relative to A.
    A_cent := XMLoadFloat3(Center);
    B_cent := XMLoadFloat3(box.Center);
    t := XMVector3InverseRotate(XMVectorSubtract(B_cent, A_cent), A_quat);


    // h(A) := extents of A.
    // h(B) := extents of B.

    // a(u) := axes of A := (1,0,0), (0,1,0), (0,0,1)
    // b(u) := axes of B relative to A := (r00,r10,r20), (r01,r11,r21), (r02,r12,r22)

    // For each possible separating axis l:
    //   d(A) := sum (for i := u,v,w) h(A)(i) * abs( a(i) dot l )
    //   d(B) := sum (for i := u,v,w) h(B)(i) * abs( b(i) dot l )
    //   if abs( t dot l ) > d(A) + d(B) then disjoint



    // Load extents of A and B.
    h_A := XMLoadFloat3(Extents);
    h_B := XMLoadFloat3(box.Extents);

    // Rows. Note R[0,1,2]X.w := 0.
    R0X := R.r[0];
    R1X := R.r[1];
    R2X := R.r[2];

    R := XMMatrixTranspose(R);


    // Columns. Note RX[0,1,2].w := 0.
    RX0 := R.r[0];
    RX1 := R.r[1];
    RX2 := R.r[2];

    // Absolute value of rows.
    AR0X := XMVectorAbs(R0X);
    AR1X := XMVectorAbs(R1X);
    AR2X := XMVectorAbs(R2X);

    // Absolute value of columns.
    ARX0 := XMVectorAbs(RX0);
    ARX1 := XMVectorAbs(RX1);
    ARX2 := XMVectorAbs(RX2);

    // Test each of the 15 possible seperating axii.


    // l := a(u) := (1, 0, 0)
    // t dot l := t.x
    // d(A) := h(A).x
    // d(B) := h(B) dot abs(r00, r01, r02)
    d := XMVectorSplatX(t);
    d_A := XMVectorSplatX(h_A);
    d_B := XMVector3Dot(h_B, AR0X);
    NoIntersection := XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B));

    // l := a(v) := (0, 1, 0)
    // t dot l := t.y
    // d(A) := h(A).y
    // d(B) := h(B) dot abs(r10, r11, r12)
    d := XMVectorSplatY(t);
    d_A := XMVectorSplatY(h_A);
    d_B := XMVector3Dot(h_B, AR1X);
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B)));

    // l := a(w) := (0, 0, 1)
    // t dot l := t.z
    // d(A) := h(A).z
    // d(B) := h(B) dot abs(r20, r21, r22)
    d := XMVectorSplatZ(t);
    d_A := XMVectorSplatZ(h_A);
    d_B := XMVector3Dot(h_B, AR2X);
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B)));

    // l := b(u) := (r00, r10, r20)
    // d(A) := h(A) dot abs(r00, r10, r20)
    // d(B) := h(B).x
    d := XMVector3Dot(t, RX0);
    d_A := XMVector3Dot(h_A, ARX0);
    d_B := XMVectorSplatX(h_B);
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B)));

    // l := b(v) := (r01, r11, r21)
    // d(A) := h(A) dot abs(r01, r11, r21)
    // d(B) := h(B).y
    d := XMVector3Dot(t, RX1);
    d_A := XMVector3Dot(h_A, ARX1);
    d_B := XMVectorSplatY(h_B);
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B)));

    // l := b(w) := (r02, r12, r22)
    // d(A) := h(A) dot abs(r02, r12, r22)
    // d(B) := h(B).z
    d := XMVector3Dot(t, RX2);
    d_A := XMVector3Dot(h_A, ARX2);
    d_B := XMVectorSplatZ(h_B);
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B)));

    // l := a(u) x b(u) := (0, -r20, r10)
    // d(A) := h(A) dot abs(0, r20, r10)
    // d(B) := h(B) dot abs(0, r02, r01)
    d := XMVector3Dot(t, XMVectorPermute(XM_PERMUTE_0W, XM_PERMUTE_1Z, XM_PERMUTE_0Y, XM_PERMUTE_0X, RX0, XMVectorNegate(RX0)));
    d_A := XMVector3Dot(h_A, XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_Z, XM_SWIZZLE_Y, XM_SWIZZLE_X, ARX0));
    d_B := XMVector3Dot(h_B, XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_Z, XM_SWIZZLE_Y, XM_SWIZZLE_X, AR0X));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B)));

    // l := a(u) x b(v) := (0, -r21, r11)
    // d(A) := h(A) dot abs(0, r21, r11)
    // d(B) := h(B) dot abs(r02, 0, r00)
    d := XMVector3Dot(t, XMVectorPermute(XM_PERMUTE_0W, XM_PERMUTE_1Z, XM_PERMUTE_0Y, XM_PERMUTE_0X, RX1, XMVectorNegate(RX1)));
    d_A := XMVector3Dot(h_A, XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_Z, XM_SWIZZLE_Y, XM_SWIZZLE_X, ARX1));
    d_B := XMVector3Dot(h_B, XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_W, XM_SWIZZLE_X, XM_SWIZZLE_Y, AR0X));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B)));

    // l := a(u) x b(w) := (0, -r22, r12)
    // d(A) := h(A) dot abs(0, r22, r12)
    // d(B) := h(B) dot abs(r01, r00, 0)
    d := XMVector3Dot(t, XMVectorPermute(XM_PERMUTE_0W, XM_PERMUTE_1Z, XM_PERMUTE_0Y, XM_PERMUTE_0X, RX2, XMVectorNegate(RX2)));
    d_A := XMVector3Dot(h_A, XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_Z, XM_SWIZZLE_Y, XM_SWIZZLE_X, ARX2));
    d_B := XMVector3Dot(h_B, XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_X, XM_SWIZZLE_W, XM_SWIZZLE_Z, AR0X));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B)));

    // l := a(v) x b(u) := (r20, 0, -r00)
    // d(A) := h(A) dot abs(r20, 0, r00)
    // d(B) := h(B) dot abs(0, r12, r11)
    d := XMVector3Dot(t, XMVectorPermute(XM_PERMUTE_0Z, XM_PERMUTE_0W, XM_PERMUTE_1X, XM_PERMUTE_0Y, RX0, XMVectorNegate(RX0)));
    d_A := XMVector3Dot(h_A, XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_W, XM_SWIZZLE_X, XM_SWIZZLE_Y, ARX0));
    d_B := XMVector3Dot(h_B, XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_Z, XM_SWIZZLE_Y, XM_SWIZZLE_X, AR1X));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B)));

    // l := a(v) x b(v) := (r21, 0, -r01)
    // d(A) := h(A) dot abs(r21, 0, r01)
    // d(B) := h(B) dot abs(r12, 0, r10)
    d := XMVector3Dot(t, XMVectorPermute(XM_PERMUTE_0Z, XM_PERMUTE_0W, XM_PERMUTE_1X, XM_PERMUTE_0Y, RX1, XMVectorNegate(RX1)));
    d_A := XMVector3Dot(h_A, XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_W, XM_SWIZZLE_X, XM_SWIZZLE_Y, ARX1));
    d_B := XMVector3Dot(h_B, XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_W, XM_SWIZZLE_X, XM_SWIZZLE_Y, AR1X));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B)));

    // l := a(v) x b(w) := (r22, 0, -r02)
    // d(A) := h(A) dot abs(r22, 0, r02)
    // d(B) := h(B) dot abs(r11, r10, 0)
    d := XMVector3Dot(t, XMVectorPermute(XM_PERMUTE_0Z, XM_PERMUTE_0W, XM_PERMUTE_1X, XM_PERMUTE_0Y, RX2, XMVectorNegate(RX2)));
    d_A := XMVector3Dot(h_A, XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_W, XM_SWIZZLE_X, XM_SWIZZLE_Y, ARX2));
    d_B := XMVector3Dot(h_B, XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_X, XM_SWIZZLE_W, XM_SWIZZLE_Z, AR1X));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B)));

    // l := a(w) x b(u) := (-r10, r00, 0)
    // d(A) := h(A) dot abs(r10, r00, 0)
    // d(B) := h(B) dot abs(0, r22, r21)
    d := XMVector3Dot(t, XMVectorPermute(XM_PERMUTE_1Y, XM_PERMUTE_0X, XM_PERMUTE_0W, XM_PERMUTE_0Z, RX0, XMVectorNegate(RX0)));
    d_A := XMVector3Dot(h_A, XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_X, XM_SWIZZLE_W, XM_SWIZZLE_Z, ARX0));
    d_B := XMVector3Dot(h_B, XMVectorSwizzle(XM_SWIZZLE_W, XM_SWIZZLE_Z, XM_SWIZZLE_Y, XM_SWIZZLE_X, AR2X));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B)));

    // l := a(w) x b(v) := (-r11, r01, 0)
    // d(A) := h(A) dot abs(r11, r01, 0)
    // d(B) := h(B) dot abs(r22, 0, r20)
    d := XMVector3Dot(t, XMVectorPermute(XM_PERMUTE_1Y, XM_PERMUTE_0X, XM_PERMUTE_0W, XM_PERMUTE_0Z, RX1, XMVectorNegate(RX1)));
    d_A := XMVector3Dot(h_A, XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_X, XM_SWIZZLE_W, XM_SWIZZLE_Z, ARX1));
    d_B := XMVector3Dot(h_B, XMVectorSwizzle(XM_SWIZZLE_Z, XM_SWIZZLE_W, XM_SWIZZLE_X, XM_SWIZZLE_Y, AR2X));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B)));

    // l := a(w) x b(w) := (-r12, r02, 0)
    // d(A) := h(A) dot abs(r12, r02, 0)
    // d(B) := h(B) dot abs(r21, r20, 0)
    d := XMVector3Dot(t, XMVectorPermute(XM_PERMUTE_1Y, XM_PERMUTE_0X, XM_PERMUTE_0W, XM_PERMUTE_0Z, RX2, XMVectorNegate(RX2)));
    d_A := XMVector3Dot(h_A, XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_X, XM_SWIZZLE_W, XM_SWIZZLE_Z, ARX2));
    d_B := XMVector3Dot(h_B, XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_X, XM_SWIZZLE_W, XM_SWIZZLE_Z, AR2X));
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorGreater(XMVectorAbs(d), XMVectorAdd(d_A, d_B)));

    // No seperating axis found, boxes must intersect.
    Result := XMVector4NotEqualInt(NoIntersection, XMVectorTrueInt());
end;


//-----------------------------------------------------------------------------
// Frustum vs. oriented box test
//-----------------------------------------------------------------------------
function TBoundingOrientedBox.Intersects(fr: PBoundingFrustum): boolean;
begin
    Result := fr.Intersects(PBoundingOrientedBox(@self));
end;


//-----------------------------------------------------------------------------
// Triangle vs. oriented box test.
//-----------------------------------------------------------------------------
function TBoundingOrientedBox.Intersects(V0, V1, V2: TFXMVECTOR): boolean;
var
    vCenter, vOrientation, TV0, TV1, TV2: TXMVECTOR;
    box: TBoundingBox;
begin
    // Load the box center & orientation.
    vCenter := XMLoadFloat3(Center);
    vOrientation := XMLoadFloat4(Orientation);

    // Transform the triangle vertices into the space of the box.
    TV0 := XMVector3InverseRotate(XMVectorSubtract(V0, vCenter), vOrientation);
    TV1 := XMVector3InverseRotate(XMVectorSubtract(V1, vCenter), vOrientation);
    TV2 := XMVector3InverseRotate(XMVectorSubtract(V2, vCenter), vOrientation);


    box.Center := TXMFLOAT3.Create(0.0, 0.0, 0.0);
    box.Extents := Extents;

    // Use the triangle vs axis aligned box intersection routine.
    Result := box.Intersects(TV0, TV1, TV2);
end;



function TBoundingOrientedBox.Intersects(Plane: TFXMVECTOR): TPlaneIntersectionType;
var
    vCenter, vExtents, BoxOrientation: TXMVECTOR;
    R: TXMMATRIX;
    Outside, Inside: TXMVECTOR;
begin
    {$IFDEF UseAssert}
    assert(XMPlaneIsUnit(Plane));
    {$ENDIF}

    // Load the box.
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);
    BoxOrientation := XMLoadFloat4(Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(BoxOrientation));
    {$ENDIF}

    // Set w of the center to one so we can dot4 with a plane.
    vCenter := XMVectorInsert(0, 0, 0, 0, 1, vCenter, XMVectorSplatOne());

    // Build the 3x3 rotation matrix that defines the box axes.
    R := XMMatrixRotationQuaternion(BoxOrientation);

    FastIntersectOrientedBoxPlane(vCenter, vExtents, R.r[0], R.r[1], R.r[2], Plane, Outside, Inside);

    // If the box is outside any plane it is outside.
    if (XMVector4EqualInt(Outside, XMVectorTrueInt())) then
        Result := piFRONT
    // If the box is inside all planes it is inside.
    else if (XMVector4EqualInt(Inside, XMVectorTrueInt())) then
        Result := piBACK
    // The box is not inside all planes or outside a plane it intersects.
    else
        Result := piINTERSECTING;
end;


//-----------------------------------------------------------------------------
// Compute the intersection of a ray (Origin, Direction) with an oriented box
// using the slabs method.
//-----------------------------------------------------------------------------
function TBoundingOrientedBox.Intersects(Origin, Direction: TFXMVECTOR; var Dist: single): boolean;
const
    SelectY: TXMVECTOR = (U: (XM_SELECT_0, XM_SELECT_1, XM_SELECT_0, XM_SELECT_0));
    SelectZ: TXMVECTOR = (U: (XM_SELECT_0, XM_SELECT_0, XM_SELECT_1, XM_SELECT_0));
var
    vCenter, vExtents, vOrientation: TXMVECTOR;
    R: TXMMATRIX;
    TOrigin, AxisDotOrigin, AxisDotDirection, IsParallel, InverseAxisDotDirection: TXMVECTOR;
    t1, t2, t_min, t_max, NoIntersection, ParallelOverlap: TXMVECTOR;
begin
    {$IFDEF UseAssert}
    assert(XMVector3IsUnit(Direction));
    {$ENDIF}

    // Load the box.
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);
    vOrientation := XMLoadFloat4(Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(vOrientation));
	{$ENDIF}

    // Get the boxes normalized side directions.
    R := XMMatrixRotationQuaternion(vOrientation);

    // Adjust ray origin to be relative to center of the box.
    TOrigin := XMVectorSubtract(vCenter, Origin);

    // Compute the dot product againt each axis of the box.
    AxisDotOrigin := XMVector3Dot(R.r[0], TOrigin);
    AxisDotOrigin := XMVectorSelect(AxisDotOrigin, XMVector3Dot(R.r[1], TOrigin), SelectY);
    AxisDotOrigin := XMVectorSelect(AxisDotOrigin, XMVector3Dot(R.r[2], TOrigin), SelectZ);

    AxisDotDirection := XMVector3Dot(R.r[0], Direction);
    AxisDotDirection := XMVectorSelect(AxisDotDirection, XMVector3Dot(R.r[1], Direction), SelectY);
    AxisDotDirection := XMVectorSelect(AxisDotDirection, XMVector3Dot(R.r[2], Direction), SelectZ);

    // if (fabs(AxisDotDirection) <= Epsilon) the ray is nearly parallel to the slab.
    IsParallel := XMVectorLessOrEqual(XMVectorAbs(AxisDotDirection), g_RayEpsilon);


    // Test against all three axes simultaneously.
    InverseAxisDotDirection := XMVectorReciprocal(AxisDotDirection);
    t1 := XMVectorMultiply(XMVectorSubtract(AxisDotOrigin, vExtents), InverseAxisDotDirection);
    t2 := XMVectorMultiply(XMVectorAdd(AxisDotOrigin, vExtents), InverseAxisDotDirection);

    // Compute the max of min(t1,t2) and the min of max(t1,t2) ensuring we don't
    // use the results from any directions parallel to the slab.
    t_min := XMVectorSelect(XMVectorMin(t1, t2), g_FltMin, IsParallel);
    t_max := XMVectorSelect(XMVectorMax(t1, t2), g_FltMax, IsParallel);

    // t_min.x := maximum( t_min.x, t_min.y, t_min.z );
    // t_max.x := minimum( t_max.x, t_max.y, t_max.z );
    t_min := XMVectorMax(t_min, XMVectorSplatY(t_min));  // x := max(x,y)
    t_min := XMVectorMax(t_min, XMVectorSplatZ(t_min));  // x := max(max(x,y),z)
    t_max := XMVectorMin(t_max, XMVectorSplatY(t_max));  // x := min(x,y)
    t_max := XMVectorMin(t_max, XMVectorSplatZ(t_max));  // x := min(min(x,y),z)

    // if ( t_min > t_max ) return false;
    NoIntersection := XMVectorGreater(XMVectorSplatX(t_min), XMVectorSplatX(t_max));

    // if ( t_max < 0.0 ) return false;
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorLess(XMVectorSplatX(t_max), XMVectorZero()));

    // if (IsParallel AND (-Extents > AxisDotOrigin OR Extents < AxisDotOrigin)) return false;
    ParallelOverlap := XMVectorInBounds(AxisDotOrigin, vExtents);
    NoIntersection := XMVectorOrInt(NoIntersection, XMVectorAndCInt(IsParallel, ParallelOverlap));

    if (not XMVector3AnyTrue(NoIntersection)) then
    begin
        // Store the x-component to *pDist
        XMStoreFloat(Dist, t_min);
        Result := True;
    end
    else
    begin
        Dist := 0.0;
        Result := False;
    end;
end;


//-----------------------------------------------------------------------------
// Test an oriented box vs 6 planes (typically forming a frustum).
//-----------------------------------------------------------------------------
function TBoundingOrientedBox.ContainedBy(Plane0, Plane1, Plane2: TFXMVECTOR; Plane3: TGXMVECTOR; Plane4, Plane5: THXMVECTOR): TContainmentType;
var
    vCenter, vExtents, BoxOrientation: TXMVECTOR;
    R: TXMMATRIX;
    Outside, Inside: TXMVECTOR;
    AnyOutside, AllInside: TXMVECTOR;
begin
    // Load the box.
    vCenter := XMLoadFloat3(Center);
    vExtents := XMLoadFloat3(Extents);
    BoxOrientation := XMLoadFloat4(Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(BoxOrientation));
	{$ENDIF}

    // Set w of the center to one so we can dot4 with a plane.
    vCenter := XMVectorInsert(0, 0, 0, 0, 1, vCenter, XMVectorSplatOne());

    // Build the 3x3 rotation matrix that defines the box axes.
    R := XMMatrixRotationQuaternion(BoxOrientation);



    // Test against each plane.
    FastIntersectOrientedBoxPlane(vCenter, vExtents, R.r[0], R.r[1], R.r[2], Plane0, Outside, Inside);

    AnyOutside := Outside;
    AllInside := Inside;

    FastIntersectOrientedBoxPlane(vCenter, vExtents, R.r[0], R.r[1], R.r[2], Plane1, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectOrientedBoxPlane(vCenter, vExtents, R.r[0], R.r[1], R.r[2], Plane2, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectOrientedBoxPlane(vCenter, vExtents, R.r[0], R.r[1], R.r[2], Plane3, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectOrientedBoxPlane(vCenter, vExtents, R.r[0], R.r[1], R.r[2], Plane4, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectOrientedBoxPlane(vCenter, vExtents, R.r[0], R.r[1], R.r[2], Plane5, Outside, Inside);
    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    // If the box is outside any plane it is outside.
    if (XMVector4EqualInt(AnyOutside, XMVectorTrueInt())) then
        Result := ctDISJOINT
    // If the box is inside all planes it is inside.
    else if (XMVector4EqualInt(AllInside, XMVectorTrueInt())) then
        Result := ctCONTAINS
    // The box is not inside all planes or outside a plane, it may intersect.
    else
        Result := ctINTERSECTS;
end;


//-----------------------------------------------------------------------------
// Create oriented bounding box from axis-aligned bounding box
//-----------------------------------------------------------------------------
procedure TBoundingOrientedBox.CreateFromBoundingBox(_Out: PBoundingOrientedBox; box: PBoundingBox);
begin
    _Out.Center := box.Center;
    _Out.Extents := box.Extents;
    _Out.Orientation := TXMFLOAT4.Create(0.0, 0.0, 0.0, 1.0);
end;


//-----------------------------------------------------------------------------
// Find the approximate minimum oriented bounding box containing a set of
// points.  Exact computation of minimum oriented bounding box is possible but
// is slower and requires a more complex algorithm.
// The algorithm works by computing the inertia tensor of the points and then
// using the eigenvectors of the intertia tensor as the axes of the box.
// Computing the intertia tensor of the convex hull of the points will usually
// result in better bounding box but the computation is more complex.
// Exact computation of the minimum oriented bounding box is possible but the
// best know algorithm is O(N^3) and is significanly more complex to implement.
//-----------------------------------------------------------------------------
procedure TBoundingOrientedBox.CreateFromPoints(_Out: PBoundingOrientedBox; Count: size_t; constref pPoints: PXMFLOAT3; Stride: size_t);
var
    CenterOfMass: TXMVECTOR;
    i: integer;
    Point: TXMVECTOR;
    XX_YY_ZZ, XY_XZ_YZ: TXMVECTOR;
    v1, v2, v3, XXY, YZZ: TXMVECTOR;
    R, InverseR: TXMMATRIX;
    Det, vOrientation: TXMVECTOR;
    vMin, vMax, vCenter: TXMVECTOR;
begin
    {$IFDEF UseAssert}
    assert(Count > 0);
    assert(pPoints <> nullptr);
	{$ENDIF}

    CenterOfMass := XMVectorZero();

    // Compute the center of mass and inertia tensor of the points.
    for  i := 0 to Count - 1 do
    begin
        Point := XMLoadFloat3(PXMFLOAT3(pbyte(pPoints) + i * Stride)^);

        CenterOfMass := XMVectorAdd(CenterOfMass, Point);
    end;

    CenterOfMass := XMVectorMultiply(CenterOfMass, XMVectorReciprocal(XMVectorReplicate(single(Count))));

    // Compute the inertia tensor of the points around the center of mass.
    // Using the center of mass is not strictly necessary, but will hopefully
    // improve the stability of finding the eigenvectors.
    XX_YY_ZZ := XMVectorZero();
    XY_XZ_YZ := XMVectorZero();

    for i := 0 to Count - 1 do
    begin
        Point := XMVectorSubtract(XMLoadFloat3(PXMFLOAT3(pbyte(pPoints) + i * Stride)^), CenterOfMass);

        XX_YY_ZZ := XMVectorAdd(XX_YY_ZZ, XMVectorMultiply(Point, Point));

        XXY := XMVectorSwizzle(XM_SWIZZLE_X, XM_SWIZZLE_X, XM_SWIZZLE_Y, XM_SWIZZLE_W, Point);
        YZZ := XMVectorSwizzle(XM_SWIZZLE_Y, XM_SWIZZLE_Z, XM_SWIZZLE_Z, XM_SWIZZLE_W, Point);

        XY_XZ_YZ := XMVectorAdd(XY_XZ_YZ, XMVectorMultiply(XXY, YZZ));
    end;



    // Compute the eigenvectors of the inertia tensor.
    CalculateEigenVectorsFromCovarianceMatrix(XMVectorGetX(XX_YY_ZZ), XMVectorGetY(XX_YY_ZZ),
        XMVectorGetZ(XX_YY_ZZ),
        XMVectorGetX(XY_XZ_YZ), XMVectorGetY(XY_XZ_YZ),
        XMVectorGetZ(XY_XZ_YZ),
        v1, v2, v3);

    // Put them in a matrix.


    R.r[0] := XMVectorSetW(v1, 0.0);
    R.r[1] := XMVectorSetW(v2, 0.0);
    R.r[2] := XMVectorSetW(v3, 0.0);
    R.r[3] := g_XMIdentityR3;

    // Multiply by -1 to convert the matrix into a right handed coordinate
    // system (Det ~= 1) in case the eigenvectors form a left handed
    // coordinate system (Det ~= -1) because XMQuaternionRotationMatrix only
    // works on right handed matrices.
    Det := XMMatrixDeterminant(R);

    if (XMVector4Less(Det, XMVectorZero())) then
    begin
        R.r[0] := XMVectorMultiply(R.r[0], g_XMNegativeOne);
        R.r[1] := XMVectorMultiply(R.r[1], g_XMNegativeOne);
        R.r[2] := XMVectorMultiply(R.r[2], g_XMNegativeOne);
    end;

    // Get the rotation quaternion from the matrix.
    vOrientation := XMQuaternionRotationMatrix(R);

    // Make sure it is normal (in case the vectors are slightly non-orthogonal).
    vOrientation := XMQuaternionNormalize(vOrientation);

    // Rebuild the rotation matrix from the quaternion.
    R := XMMatrixRotationQuaternion(vOrientation);

    // Build the rotation into the rotated space.
    InverseR := XMMatrixTranspose(R);

    // Find the minimum OBB using the eigenvectors as the axes.


    vMin := XMVector3TransformNormal(XMLoadFloat3(PXMFLOAT3(pPoints)^), InverseR);
    vMax := vMin;

    for  i := 1 to Count - 1 do
    begin
        Point := XMVector3TransformNormal(XMLoadFloat3(PXMFLOAT3(pbyte(pPoints) + i * Stride)^), InverseR);

        vMin := XMVectorMin(vMin, Point);
        vMax := XMVectorMax(vMax, Point);
    end;

    // Rotate the center into world space.
    vCenter := XMVectorScale(XMVectorAdd(vMin, vMax), 0.5);
    vCenter := XMVector3TransformNormal(vCenter, R);

    // Store center, extents, and orientation.
    XMStoreFloat3(_Out.Center, vCenter);
    XMStoreFloat3(_Out.Extents, XMVectorScale(XMVectorSubtract(vMax, vMin), 0.5));
    XMStoreFloat4(_Out.Orientation, vOrientation);
end;

{$ENDREGION}


(****************************************************************************
 *
 * TBoundingFrustum
 *
 ****************************************************************************)

{$REGION BoundingFrustum}

{ TBoundingFrustum }

class operator TBoundingFrustum.Initialize(var t: TBoundingFrustum);
begin
    t.Origin := TXMFLOAT3.Create(0, 0, 0);
    t.Orientation := TXMFLOAT4.Create(0, 0, 0, 1.0);
    t.RightSlope := 1.0;
    t.LeftSlope := -1.0;
    t.TopSlope := 1.0;
    t.BottomSlope := -1.0;
    t._Near := 0;
    t._Far := 1.0;
end;



constructor TBoundingFrustum.Create(constref _Origin: TXMFLOAT3; constref _Orientation: TXMFLOAT4; _RightSlope, _LeftSlope, _TopSlope, _BottomSlope, NearPlane, FarPlane: single);
begin
    Origin := _Origin;
    Orientation := _Orientation;
    RightSlope := _RightSlope;
    LeftSlope := _LeftSlope;
    TopSlope := _TopSlope;
    BottomSlope := _BottomSlope;
    _Near := NearPlane;
    _Far := FarPlane;
end;



constructor TBoundingFrustum.Create(Projection: TCXMMATRIX; rhcoords: boolean);
begin
    CreateFromMatrix(@self, Projection, rhcoords);
end;



{ TBoundingFrustumHelper }

//-----------------------------------------------------------------------------
// Transform a frustum by an angle preserving transform.
//-----------------------------------------------------------------------------
procedure TBoundingFrustum.Transform(_Out: PBoundingFrustum; M: TFXMMATRIX);
var
    vOrigin, vOrientation, Rotation: TXMVECTOR;
    nM: TXMMATRIX;
    dX, dY, dZ, d: TXMVECTOR;
    Scale: single;
begin
    // Load the frustum.
    vOrigin := XMLoadFloat3(Origin);
    vOrientation := XMLoadFloat4(Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(vOrientation));
    {$ENDIF}

    // Composite the frustum rotation and the transform rotation
    nM.r[0] := XMVector3Normalize(M.r[0]);
    nM.r[1] := XMVector3Normalize(M.r[1]);
    nM.r[2] := XMVector3Normalize(M.r[2]);
    nM.r[3] := g_XMIdentityR3;
    Rotation := XMQuaternionRotationMatrix(nM);
    vOrientation := XMQuaternionMultiply(vOrientation, Rotation);

    // Transform the center.
    vOrigin := XMVector3Transform(vOrigin, M);

    // Store the frustum.
    XMStoreFloat3(_Out.Origin, vOrigin);
    XMStoreFloat4(_Out.Orientation, vOrientation);

    // Scale the near and far distances (the slopes remain the same).
    dX := XMVector3Dot(M.r[0], M.r[0]);
    dY := XMVector3Dot(M.r[1], M.r[1]);
    dZ := XMVector3Dot(M.r[2], M.r[2]);

    d := XMVectorMax(dX, XMVectorMax(dY, dZ));
    Scale := sqrt(XMVectorGetX(d));

    _Out._Near := _Near * Scale;
    _Out._Far := _Far * Scale;

    // Copy the slopes.
    _Out.RightSlope := RightSlope;
    _Out.LeftSlope := LeftSlope;
    _Out.TopSlope := TopSlope;
    _Out.BottomSlope := BottomSlope;
end;



procedure TBoundingFrustum.Transform(_Out: PBoundingFrustum; Scale: single; Rotation, Translation: TFXMVECTOR);
var
    vOrigin, vOrientation: TXMVECTOR;
begin
    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(Rotation));
    {$ENDIF}

    // Load the frustum.
    vOrigin := XMLoadFloat3(Origin);
    vOrientation := XMLoadFloat4(Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(vOrientation));
    {$ENDIF}

    // Composite the frustum rotation and the transform rotation.
    vOrientation := XMQuaternionMultiply(vOrientation, Rotation);

    // Transform the origin.
    vOrigin := XMVectorAdd(XMVector3Rotate(XMVectorScale(vOrigin, Scale), Rotation), Translation);

    // Store the frustum.
    XMStoreFloat3(_Out.Origin, vOrigin);
    XMStoreFloat4(_Out.Orientation, vOrientation);

    // Scale the near and far distances (the slopes remain the same).
    _Out._Near := _Near * Scale;
    _Out._Far := _Far * Scale;

    // Copy the slopes.
    _Out.RightSlope := RightSlope;
    _Out.LeftSlope := LeftSlope;
    _Out.TopSlope := TopSlope;
    _Out.BottomSlope := BottomSlope;
end;


//-----------------------------------------------------------------------------
// Get the corner points of the frustum
//-----------------------------------------------------------------------------
procedure TBoundingFrustum.GetCorners(var Corners: array of TXMFLOAT3);
var
    vOrigin, vOrientation: TXMVECTOR;
    vRightTop, vRightBottom, vLeftTop, vLeftBottom, vNear, vFar: TXMVECTOR;
    vCorners: array [0..BoundingFrustum_CORNER_COUNT - 1] of TXMVECTOR;
    C: TXMVECTOR;
    i: integer;
begin
    {$IFDEF UseAssert}
    assert(Corners <> nil);
	{$ENDIF}

    // Load origin and orientation of the frustum.
    vOrigin := XMLoadFloat3(Origin);
    vOrientation := XMLoadFloat4(Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(vOrientation));
	{$ENDIF}

    // Build the corners of the frustum.
    vRightTop := XMVectorSet(RightSlope, TopSlope, 1.0, 0.0);
    vRightBottom := XMVectorSet(RightSlope, BottomSlope, 1.0, 0.0);
    vLeftTop := XMVectorSet(LeftSlope, TopSlope, 1.0, 0.0);
    vLeftBottom := XMVectorSet(LeftSlope, BottomSlope, 1.0, 0.0);
    vNear := XMVectorReplicatePtr(@_Near);
    vFar := XMVectorReplicatePtr(@_Far);

    // Returns 8 corners position of bounding frustum.
    //     Near    Far
    //    0----1  4----5
    //    |    |  |    |
    //    |    |  |    |
    //    3----2  7----6


    vCorners[0] := XMVectorMultiply(vLeftTop, vNear);
    vCorners[1] := XMVectorMultiply(vRightTop, vNear);
    vCorners[2] := XMVectorMultiply(vRightBottom, vNear);
    vCorners[3] := XMVectorMultiply(vLeftBottom, vNear);
    vCorners[4] := XMVectorMultiply(vLeftTop, vFar);
    vCorners[5] := XMVectorMultiply(vRightTop, vFar);
    vCorners[6] := XMVectorMultiply(vRightBottom, vFar);
    vCorners[7] := XMVectorMultiply(vLeftBottom, vFar);

    for  i := 0 to BoundingFrustum_CORNER_COUNT - 1 do
    begin
        C := XMVectorAdd(XMVector3Rotate(vCorners[i], vOrientation), vOrigin);
        XMStoreFloat3(Corners[i], C);
    end;
end;


//-----------------------------------------------------------------------------
// Point in frustum test.
//-----------------------------------------------------------------------------
function TBoundingFrustum.Contains(Point: TFXMVECTOR): TContainmentType;
var
    Planes: array [0..5] of TXMVECTOR;
    vOrigin, vOrientation, TPoint, Zero, Outside: TXMVECTOR;
    i: integer;
    Dot: TXMVECTOR;
begin
    // Build frustum planes.
    Planes[0] := XMVectorSet(0.0, 0.0, -1.0, _Near);
    Planes[1] := XMVectorSet(0.0, 0.0, 1.0, -_Far);
    Planes[2] := XMVectorSet(1.0, 0.0, -RightSlope, 0.0);
    Planes[3] := XMVectorSet(-1.0, 0.0, LeftSlope, 0.0);
    Planes[4] := XMVectorSet(0.0, 1.0, -TopSlope, 0.0);
    Planes[5] := XMVectorSet(0.0, -1.0, BottomSlope, 0.0);

    // Load origin and orientation.
    vOrigin := XMLoadFloat3(Origin);
    vOrientation := XMLoadFloat4(Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(vOrientation));
    {$ENDIF}

    // Transform point into local space of frustum.
    TPoint := XMVector3InverseRotate(XMVectorSubtract(Point, vOrigin), vOrientation);

    // Set w to one.
    TPoint := XMVectorInsert(0, 0, 0, 0, 1, TPoint, XMVectorSplatOne());

    Zero := XMVectorZero();
    Outside := Zero;

    // Test point against each plane of the frustum.
    for i := 0 to 5 do
    begin
        Dot := XMVector4Dot(TPoint, Planes[i]);
        Outside := XMVectorOrInt(Outside, XMVectorGreater(Dot, Zero));
    end;

    if XMVector4NotEqualInt(Outside, XMVectorTrueInt()) then
        Result := ctCONTAINS
    else
        Result := ctDISJOINT;
end;


//-----------------------------------------------------------------------------
// Triangle vs frustum test.
//-----------------------------------------------------------------------------
function TBoundingFrustum.Contains(V0, V1, V2: TFXMVECTOR): TContainmentType;
var
    vOrigin, vOrientation, NearPlane, FarPlane: TXMVECTOR;
    RightPlane, LeftPlane, TopPlane, BottomPlane: TXMVECTOR;
begin
    // Load origin and orientation of the frustum.
    vOrigin := XMLoadFloat3(Origin);
    vOrientation := XMLoadFloat4(Orientation);

    // Create 6 planes (do it inline to encourage use of registers)
    NearPlane := XMVectorSet(0.0, 0.0, -1.0, _Near);
    NearPlane := XMPlaneTransform(NearPlane, vOrientation, vOrigin);
    NearPlane := XMPlaneNormalize(NearPlane);

    FarPlane := XMVectorSet(0.0, 0.0, 1.0, -_Far);
    FarPlane := XMPlaneTransform(FarPlane, vOrientation, vOrigin);
    FarPlane := XMPlaneNormalize(FarPlane);

    RightPlane := XMVectorSet(1.0, 0.0, -RightSlope, 0.0);
    RightPlane := XMPlaneTransform(RightPlane, vOrientation, vOrigin);
    RightPlane := XMPlaneNormalize(RightPlane);

    LeftPlane := XMVectorSet(-1.0, 0.0, LeftSlope, 0.0);
    LeftPlane := XMPlaneTransform(LeftPlane, vOrientation, vOrigin);
    LeftPlane := XMPlaneNormalize(LeftPlane);

    TopPlane := XMVectorSet(0.0, 1.0, -TopSlope, 0.0);
    TopPlane := XMPlaneTransform(TopPlane, vOrientation, vOrigin);
    TopPlane := XMPlaneNormalize(TopPlane);

    BottomPlane := XMVectorSet(0.0, -1.0, BottomSlope, 0.0);
    BottomPlane := XMPlaneTransform(BottomPlane, vOrientation, vOrigin);
    BottomPlane := XMPlaneNormalize(BottomPlane);

    Result := TriangleTests_ContainedBy(V0, V1, V2, NearPlane, FarPlane, RightPlane, LeftPlane, TopPlane, BottomPlane);
end;



function TBoundingFrustum.Contains(sh: PBoundingSphere): TContainmentType;
var
    vOrigin, vOrientation, NearPlane, FarPlane, RightPlane, LeftPlane: TXMVECTOR;
    TopPlane, BottomPlane: TXMVECTOR;
begin
    // Load origin and orientation of the frustum.
    vOrigin := XMLoadFloat3(Origin);
    vOrientation := XMLoadFloat4(Orientation);

    // Create 6 planes (do it inline to encourage use of registers)
    NearPlane := XMVectorSet(0.0, 0.0, -1.0, _Near);
    NearPlane := XMPlaneTransform(NearPlane, vOrientation, vOrigin);
    NearPlane := XMPlaneNormalize(NearPlane);

    FarPlane := XMVectorSet(0.0, 0.0, 1.0, -_Far);
    FarPlane := XMPlaneTransform(FarPlane, vOrientation, vOrigin);
    FarPlane := XMPlaneNormalize(FarPlane);

    RightPlane := XMVectorSet(1.0, 0.0, -RightSlope, 0.0);
    RightPlane := XMPlaneTransform(RightPlane, vOrientation, vOrigin);
    RightPlane := XMPlaneNormalize(RightPlane);

    LeftPlane := XMVectorSet(-1.0, 0.0, LeftSlope, 0.0);
    LeftPlane := XMPlaneTransform(LeftPlane, vOrientation, vOrigin);
    LeftPlane := XMPlaneNormalize(LeftPlane);

    TopPlane := XMVectorSet(0.0, 1.0, -TopSlope, 0.0);
    TopPlane := XMPlaneTransform(TopPlane, vOrientation, vOrigin);
    TopPlane := XMPlaneNormalize(TopPlane);

    BottomPlane := XMVectorSet(0.0, -1.0, BottomSlope, 0.0);
    BottomPlane := XMPlaneTransform(BottomPlane, vOrientation, vOrigin);
    BottomPlane := XMPlaneNormalize(BottomPlane);

    Result := sh.ContainedBy(NearPlane, FarPlane, RightPlane, LeftPlane, TopPlane, BottomPlane);
end;



function TBoundingFrustum.Contains(box: PBoundingBox): TContainmentType;
var
    vOrigin, vOrientation, NearPlane, FarPlane, RightPlane, LeftPlane: TXMVECTOR;
    TopPlane, BottomPlane: TXMVECTOR;
begin
    // Load origin and orientation of the frustum.
    vOrigin := XMLoadFloat3(Origin);
    vOrientation := XMLoadFloat4(Orientation);

    // Create 6 planes (do it inline to encourage use of registers)
    NearPlane := XMVectorSet(0.0, 0.0, -1.0, _Near);
    NearPlane := XMPlaneTransform(NearPlane, vOrientation, vOrigin);
    NearPlane := XMPlaneNormalize(NearPlane);

    FarPlane := XMVectorSet(0.0, 0.0, 1.0, -_Far);
    FarPlane := XMPlaneTransform(FarPlane, vOrientation, vOrigin);
    FarPlane := XMPlaneNormalize(FarPlane);

    RightPlane := XMVectorSet(1.0, 0.0, -RightSlope, 0.0);
    RightPlane := XMPlaneTransform(RightPlane, vOrientation, vOrigin);
    RightPlane := XMPlaneNormalize(RightPlane);

    LeftPlane := XMVectorSet(-1.0, 0.0, LeftSlope, 0.0);
    LeftPlane := XMPlaneTransform(LeftPlane, vOrientation, vOrigin);
    LeftPlane := XMPlaneNormalize(LeftPlane);

    TopPlane := XMVectorSet(0.0, 1.0, -TopSlope, 0.0);
    TopPlane := XMPlaneTransform(TopPlane, vOrientation, vOrigin);
    TopPlane := XMPlaneNormalize(TopPlane);

    BottomPlane := XMVectorSet(0.0, -1.0, BottomSlope, 0.0);
    BottomPlane := XMPlaneTransform(BottomPlane, vOrientation, vOrigin);
    BottomPlane := XMPlaneNormalize(BottomPlane);

    Result := box.ContainedBy(NearPlane, FarPlane, RightPlane, LeftPlane, TopPlane, BottomPlane);
end;



function TBoundingFrustum.Contains(box: PBoundingOrientedBox): TContainmentType;
var
    vOrigin, vOrientation, NearPlane, FarPlane, RightPlane, LeftPlane: TXMVECTOR;
    TopPlane, BottomPlane: TXMVECTOR;
begin
    // Load origin and orientation of the frustum.
    vOrigin := XMLoadFloat3(Origin);
    vOrientation := XMLoadFloat4(Orientation);

    // Create 6 planes (do it inline to encourage use of registers)
    NearPlane := XMVectorSet(0.0, 0.0, -1.0, _Near);
    NearPlane := XMPlaneTransform(NearPlane, vOrientation, vOrigin);
    NearPlane := XMPlaneNormalize(NearPlane);

    FarPlane := XMVectorSet(0.0, 0.0, 1.0, -_Far);
    FarPlane := XMPlaneTransform(FarPlane, vOrientation, vOrigin);
    FarPlane := XMPlaneNormalize(FarPlane);

    RightPlane := XMVectorSet(1.0, 0.0, -RightSlope, 0.0);
    RightPlane := XMPlaneTransform(RightPlane, vOrientation, vOrigin);
    RightPlane := XMPlaneNormalize(RightPlane);

    LeftPlane := XMVectorSet(-1.0, 0.0, LeftSlope, 0.0);
    LeftPlane := XMPlaneTransform(LeftPlane, vOrientation, vOrigin);
    LeftPlane := XMPlaneNormalize(LeftPlane);

    TopPlane := XMVectorSet(0.0, 1.0, -TopSlope, 0.0);
    TopPlane := XMPlaneTransform(TopPlane, vOrientation, vOrigin);
    TopPlane := XMPlaneNormalize(TopPlane);

    BottomPlane := XMVectorSet(0.0, -1.0, BottomSlope, 0.0);
    BottomPlane := XMPlaneTransform(BottomPlane, vOrientation, vOrigin);
    BottomPlane := XMPlaneNormalize(BottomPlane);

    Result := box.ContainedBy(NearPlane, FarPlane, RightPlane, LeftPlane, TopPlane, BottomPlane);
end;



function TBoundingFrustum.Contains(fr: PBoundingFrustum): TContainmentType;
var
    vOrigin, vOrientation, NearPlane, FarPlane, RightPlane, LeftPlane: TXMVECTOR;
    TopPlane, BottomPlane: TXMVECTOR;
begin
    // Load origin and orientation of the frustum.
    vOrigin := XMLoadFloat3(Origin);
    vOrientation := XMLoadFloat4(Orientation);

    // Create 6 planes (do it inline to encourage use of registers)
    NearPlane := XMVectorSet(0.0, 0.0, -1.0, _Near);
    NearPlane := XMPlaneTransform(NearPlane, vOrientation, vOrigin);
    NearPlane := XMPlaneNormalize(NearPlane);

    FarPlane := XMVectorSet(0.0, 0.0, 1.0, -_Far);
    FarPlane := XMPlaneTransform(FarPlane, vOrientation, vOrigin);
    FarPlane := XMPlaneNormalize(FarPlane);

    RightPlane := XMVectorSet(1.0, 0.0, -RightSlope, 0.0);
    RightPlane := XMPlaneTransform(RightPlane, vOrientation, vOrigin);
    RightPlane := XMPlaneNormalize(RightPlane);

    LeftPlane := XMVectorSet(-1.0, 0.0, LeftSlope, 0.0);
    LeftPlane := XMPlaneTransform(LeftPlane, vOrientation, vOrigin);
    LeftPlane := XMPlaneNormalize(LeftPlane);

    TopPlane := XMVectorSet(0.0, 1.0, -TopSlope, 0.0);
    TopPlane := XMPlaneTransform(TopPlane, vOrientation, vOrigin);
    TopPlane := XMPlaneNormalize(TopPlane);

    BottomPlane := XMVectorSet(0.0, -1.0, BottomSlope, 0.0);
    BottomPlane := XMPlaneTransform(BottomPlane, vOrientation, vOrigin);
    BottomPlane := XMPlaneNormalize(BottomPlane);

    Result := fr.ContainedBy(NearPlane, FarPlane, RightPlane, LeftPlane, TopPlane, BottomPlane);
end;


//-----------------------------------------------------------------------------
// Exact sphere vs frustum test.  The algorithm first checks the sphere against
// the planes of the frustum, then if the plane checks were indeterminate finds
// the nearest feature (plane, line, point) on the frustum to the center of the
// sphere and compares the distance to the nearest feature to the radius of the
// sphere
//-----------------------------------------------------------------------------
function TBoundingFrustum.Intersects(sh: PBoundingSphere): boolean;
    // The faces adjacent to each face are:
const
    adjacent_faces: array [0..5, 0..3] of integer =
        (
        (2, 3, 4, 5),    // 0
        (2, 3, 4, 5),    // 1
        (0, 1, 4, 5),    // 2
        (0, 1, 4, 5),    // 3
        (0, 1, 2, 3),    // 4
        (0, 1, 2, 3)
        );  // 5
    // The Edges are:
    edges: array[0..11, 0..1] of size_t =
        (
        (0, 1), (2, 3), (0, 2), (1, 3),    // Near plane
        (4, 5), (6, 7), (4, 6), (5, 7),    // Far plane
        (0, 4), (1, 5), (2, 6), (3, 7)
        ); // Near to far
var
    Zero: TXMVECTOR;
    Planes: array [0..5] of TXMVECTOR;
    vOrigin, vOrientation: TXMVECTOR;
    vCenter, vRadius: TXMVECTOR;
    Outside, InsideAll, CenterInsideAll: TXMVECTOR;
    Dist: array [0..5] of TXMVECTOR;
    i: integer;
    Intersects: TXMVECTOR;
    Point, InsideFace: TXMVECTOR;
    plane_index, j: integer;
    vRightTop, vRightBottom, vLeftTop, vLeftBottom, vNear, vFar: TXMVECTOR;
    Corners: array [0..BoundingFrustum_CORNER_COUNT - 1] of TXMVECTOR;
    RadiusSq: TXMVECTOR;
    ei0, ei1: size_t;
    Delta, DistSq: TXMVECTOR;
begin
    Zero := XMVectorZero();

    // Build the frustum planes.

    Planes[0] := XMVectorSet(0.0, 0.0, -1.0, _Near);
    Planes[1] := XMVectorSet(0.0, 0.0, 1.0, -_Far);
    Planes[2] := XMVectorSet(1.0, 0.0, -RightSlope, 0.0);
    Planes[3] := XMVectorSet(-1.0, 0.0, LeftSlope, 0.0);
    Planes[4] := XMVectorSet(0.0, 1.0, -TopSlope, 0.0);
    Planes[5] := XMVectorSet(0.0, -1.0, BottomSlope, 0.0);

    // Normalize the planes so we can compare to the sphere radius.
    Planes[2] := XMVector3Normalize(Planes[2]);
    Planes[3] := XMVector3Normalize(Planes[3]);
    Planes[4] := XMVector3Normalize(Planes[4]);
    Planes[5] := XMVector3Normalize(Planes[5]);

    // Load origin and orientation of the frustum.
    vOrigin := XMLoadFloat3(Origin);
    vOrientation := XMLoadFloat4(Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(vOrientation));
	{$ENDIF}

    // Load the sphere.
    vCenter := XMLoadFloat3(sh.Center);
    vRadius := XMVectorReplicatePtr(@sh.Radius);

    // Transform the center of the sphere into the local space of frustum.
    vCenter := XMVector3InverseRotate(XMVectorSubtract(vCenter, vOrigin), vOrientation);

    // Set w of the center to one so we can dot4 with the plane.
    vCenter := XMVectorInsert(0, 0, 0, 0, 1, vCenter, XMVectorSplatOne());

    // Check against each plane of the frustum.


    Outside := XMVectorFalseInt();
    InsideAll := XMVectorTrueInt();
    CenterInsideAll := XMVectorTrueInt();



    for i := 0 to 5 do
    begin
        Dist[i] := XMVector4Dot(vCenter, Planes[i]);

        // Outside the plane?
        Outside := XMVectorOrInt(Outside, XMVectorGreater(Dist[i], vRadius));

        // Fully inside the plane?
        InsideAll := XMVectorAndInt(InsideAll, XMVectorLessOrEqual(Dist[i], XMVectorNegate(vRadius)));

        // Check if the center is inside the plane.
        CenterInsideAll := XMVectorAndInt(CenterInsideAll, XMVectorLessOrEqual(Dist[i], Zero));
    end;

    // If the sphere is outside any of the planes it is outside.
    if (XMVector4EqualInt(Outside, XMVectorTrueInt())) then
    begin
        Result := False;
        Exit;
    end;

    // If the sphere is inside all planes it is fully inside.
    if (XMVector4EqualInt(InsideAll, XMVectorTrueInt())) then
    begin
        Result := True;
        Exit;
    end;

    // If the center of the sphere is inside all planes and the sphere intersects
    // one or more planes then it must intersect.
    if (XMVector4EqualInt(CenterInsideAll, XMVectorTrueInt())) then
    begin
        Result := True;
        Exit;
    end;

    // The sphere may be outside the frustum or intersecting the frustum.
    // Find the nearest feature (face, edge, or corner) on the frustum
    // to the sphere.
    Intersects := XMVectorFalseInt();

    // Check to see if the nearest feature is one of the planes.
    for  i := 0 to 5 do
    begin
        // Find the nearest point on the plane to the center of the sphere.
        Point := XMVectorNegativeMultiplySubtract(Planes[i], Dist[i], vCenter);

        // Set w of the point to one.
        Point := XMVectorInsert(0, 0, 0, 0, 1, Point, XMVectorSplatOne());

        // If the point is inside the face (inside the adjacent planes) then
        // this plane is the nearest feature.
        InsideFace := XMVectorTrueInt();

        for j := 0 to 3 do
        begin
            plane_index := adjacent_faces[i][j];

            InsideFace := XMVectorAndInt(InsideFace, XMVectorLessOrEqual(XMVector4Dot(Point, Planes[plane_index]), Zero));
        end;

        // Since we have already checked distance from the plane we know that the
        // sphere must intersect if this plane is the nearest feature.
        Intersects := XMVectorOrInt(Intersects, XMVectorAndInt(XMVectorGreater(Dist[i], Zero), InsideFace));
    end;

    if (XMVector4EqualInt(Intersects, XMVectorTrueInt())) then
    begin
        Result := True;
        Exit;
    end;

    // Build the corners of the frustum.
    vRightTop := XMVectorSet(RightSlope, TopSlope, 1.0, 0.0);
    vRightBottom := XMVectorSet(RightSlope, BottomSlope, 1.0, 0.0);
    vLeftTop := XMVectorSet(LeftSlope, TopSlope, 1.0, 0.0);
    vLeftBottom := XMVectorSet(LeftSlope, BottomSlope, 1.0, 0.0);
    vNear := XMVectorReplicatePtr(@_Near);
    vFar := XMVectorReplicatePtr(@_Far);


    Corners[0] := XMVectorMultiply(vRightTop, vNear);
    Corners[1] := XMVectorMultiply(vRightBottom, vNear);
    Corners[2] := XMVectorMultiply(vLeftTop, vNear);
    Corners[3] := XMVectorMultiply(vLeftBottom, vNear);
    Corners[4] := XMVectorMultiply(vRightTop, vFar);
    Corners[5] := XMVectorMultiply(vRightBottom, vFar);
    Corners[6] := XMVectorMultiply(vLeftTop, vFar);
    Corners[7] := XMVectorMultiply(vLeftBottom, vFar);



    RadiusSq := XMVectorMultiply(vRadius, vRadius);

    // Check to see if the nearest feature is one of the edges (or corners).
    for i := 0 to 11 do
    begin
        ei0 := edges[i][0];
        ei1 := edges[i][1];

        // Find the nearest point on the edge to the center of the sphere.
        // The corners of the frustum are included as the endpoints of the edges.
        Point := PointOnLineSegmentNearestPoint(Corners[ei0], Corners[ei1], vCenter);

        Delta := XMVectorSubtract(vCenter, Point);

        DistSq := XMVector3Dot(Delta, Delta);

        // If the distance to the center of the sphere to the point is less than
        // the radius of the sphere then it must intersect.
        Intersects := XMVectorOrInt(Intersects, XMVectorLessOrEqual(DistSq, RadiusSq));
    end;

    if (XMVector4EqualInt(Intersects, XMVectorTrueInt())) then
        Result := True
    else
        // The sphere must be outside the frustum.
        Result := False;
end;


//-----------------------------------------------------------------------------
// Exact axis aligned box vs frustum test.  Constructs an oriented box and uses
// the oriented box vs frustum test.
//-----------------------------------------------------------------------------
function TBoundingFrustum.Intersects(box: PBoundingBox): boolean;
var
    obox: TBoundingOrientedBox;
begin
    // Make the axis aligned box oriented and do an OBB vs frustum test.
    obox := TBoundingOrientedBox.Create(box.Center, box.Extents, TXMFLOAT4.Create(0.0, 0.0, 0.0, 1.0));
    Result := Intersects(PBoundingOrientedBox(@obox));
end;


//-----------------------------------------------------------------------------
// Exact oriented box vs frustum test.
//-----------------------------------------------------------------------------
function TBoundingFrustum.Intersects(box: PBoundingOrientedBox): boolean;
const
    SelectY: TXMVECTOR = (u: (XM_SELECT_0, XM_SELECT_1, XM_SELECT_0, XM_SELECT_0));
    SelectZ: TXMVECTOR = (u: (XM_SELECT_0, XM_SELECT_0, XM_SELECT_1, XM_SELECT_0));
var
    Planes: array [0..5] of TXMVECTOR;
    Zero, vOrigin, FrustumOrientation: TXMVECTOR;
    Center, Extents, BoxOrientation: TXMVECTOR;
    R: TXMMATRIX;
    Outside, InsideAll, CenterInsideAll, Dist, Radius: TXMVECTOR;
    i, j, k: integer;
    vRightTop, vRightBottom, vLeftTop, vLeftBottom, vNear, vFar: TXMVECTOR;
    Corners: array [0..BoundingFrustum_CORNER_COUNT - 1] of TXMVECTOR;
    FrustumMin, FrustumMax, Temp, BoxDist: TXMVECTOR;
    FrustumEdgeAxis: array [0..5] of TXMVECTOR;
    Axis, vecResult: TXMVECTOR;
begin
    Zero := XMVectorZero();

    // Build the frustum planes.

    Planes[0] := XMVectorSet(0.0, 0.0, -1.0, _Near);
    Planes[1] := XMVectorSet(0.0, 0.0, 1.0, -_Far);
    Planes[2] := XMVectorSet(1.0, 0.0, -RightSlope, 0.0);
    Planes[3] := XMVectorSet(-1.0, 0.0, LeftSlope, 0.0);
    Planes[4] := XMVectorSet(0.0, 1.0, -TopSlope, 0.0);
    Planes[5] := XMVectorSet(0.0, -1.0, BottomSlope, 0.0);

    // Load origin and orientation of the frustum.
    vOrigin := XMLoadFloat3(Origin);
    FrustumOrientation := XMLoadFloat4(Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(FrustumOrientation));
	{$ENDIF}

    // Load the box.
    Center := XMLoadFloat3(box.Center);
    Extents := XMLoadFloat3(box.Extents);
    BoxOrientation := XMLoadFloat4(box.Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(BoxOrientation));
	{$ENDIF}

    // Transform the oriented box into the space of the frustum in order to
    // minimize the number of transforms we have to do.
    Center := XMVector3InverseRotate(XMVectorSubtract(Center, vOrigin), FrustumOrientation);
    BoxOrientation := XMQuaternionMultiply(BoxOrientation, XMQuaternionConjugate(FrustumOrientation));

    // Set w of the center to one so we can dot4 with the plane.
    Center := XMVectorInsert(0, 0, 0, 0, 1, Center, XMVectorSplatOne());

    // Build the 3x3 rotation matrix that defines the box axes.
    R := XMMatrixRotationQuaternion(BoxOrientation);

    // Check against each plane of the frustum.
    Outside := XMVectorFalseInt();
    InsideAll := XMVectorTrueInt();
    CenterInsideAll := XMVectorTrueInt();

    for i := 0 to 5 do
    begin
        // Compute the distance to the center of the box.
        Dist := XMVector4Dot(Center, Planes[i]);

        // Project the axes of the box onto the normal of the plane.  Half the
        // length of the projection (sometime called the "radius") is equal to
        // h(u) * abs(n dot b(u))) + h(v) * abs(n dot b(v)) + h(w) * abs(n dot b(w))
        // where h(i) are extents of the box, n is the plane normal, and b(i) are the
        // axes of the box.
        Radius := XMVector3Dot(Planes[i], R.r[0]);
        Radius := XMVectorSelect(Radius, XMVector3Dot(Planes[i], R.r[1]), SelectY);
        Radius := XMVectorSelect(Radius, XMVector3Dot(Planes[i], R.r[2]), SelectZ);
        Radius := XMVector3Dot(Extents, XMVectorAbs(Radius));

        // Outside the plane?
        Outside := XMVectorOrInt(Outside, XMVectorGreater(Dist, Radius));

        // Fully inside the plane?
        InsideAll := XMVectorAndInt(InsideAll, XMVectorLessOrEqual(Dist, XMVectorNegate(Radius)));

        // Check if the center is inside the plane.
        CenterInsideAll := XMVectorAndInt(CenterInsideAll, XMVectorLessOrEqual(Dist, Zero));
    end;

    // If the box is outside any of the planes it is outside.
    if (XMVector4EqualInt(Outside, XMVectorTrueInt())) then
    begin
        Result := False;
        Exit;
    end;

    // If the box is inside all planes it is fully inside.
    if (XMVector4EqualInt(InsideAll, XMVectorTrueInt())) then
    begin
        Result := True;
        Exit;
    end;

    // If the center of the box is inside all planes and the box intersects
    // one or more planes then it must intersect.
    if (XMVector4EqualInt(CenterInsideAll, XMVectorTrueInt())) then
    begin
        Result := True;
        Exit;
    end;

    // Build the corners of the frustum.
    vRightTop := XMVectorSet(RightSlope, TopSlope, 1.0, 0.0);
    vRightBottom := XMVectorSet(RightSlope, BottomSlope, 1.0, 0.0);
    vLeftTop := XMVectorSet(LeftSlope, TopSlope, 1.0, 0.0);
    vLeftBottom := XMVectorSet(LeftSlope, BottomSlope, 1.0, 0.0);
    vNear := XMVectorReplicatePtr(@_Near);
    vFar := XMVectorReplicatePtr(@_Far);


    Corners[0] := XMVectorMultiply(vRightTop, vNear);
    Corners[1] := XMVectorMultiply(vRightBottom, vNear);
    Corners[2] := XMVectorMultiply(vLeftTop, vNear);
    Corners[3] := XMVectorMultiply(vLeftBottom, vNear);
    Corners[4] := XMVectorMultiply(vRightTop, vFar);
    Corners[5] := XMVectorMultiply(vRightBottom, vFar);
    Corners[6] := XMVectorMultiply(vLeftTop, vFar);
    Corners[7] := XMVectorMultiply(vLeftBottom, vFar);

    // Test against box axes (3)
    begin
        // Find the min/max values of the projection of the frustum onto each axis.
        FrustumMin := XMVector3Dot(Corners[0], R.r[0]);
        FrustumMin := XMVectorSelect(FrustumMin, XMVector3Dot(Corners[0], R.r[1]), SelectY);
        FrustumMin := XMVectorSelect(FrustumMin, XMVector3Dot(Corners[0], R.r[2]), SelectZ);
        FrustumMax := FrustumMin;

        for  i := 1 to BoundingOrientedBox_CORNER_COUNT - 1 do
        begin
            Temp := XMVector3Dot(Corners[i], R.r[0]);
            Temp := XMVectorSelect(Temp, XMVector3Dot(Corners[i], R.r[1]), SelectY);
            Temp := XMVectorSelect(Temp, XMVector3Dot(Corners[i], R.r[2]), SelectZ);

            FrustumMin := XMVectorMin(FrustumMin, Temp);
            FrustumMax := XMVectorMax(FrustumMax, Temp);
        end;

        // Project the center of the box onto the axes.
        BoxDist := XMVector3Dot(Center, R.r[0]);
        BoxDist := XMVectorSelect(BoxDist, XMVector3Dot(Center, R.r[1]), SelectY);
        BoxDist := XMVectorSelect(BoxDist, XMVector3Dot(Center, R.r[2]), SelectZ);

        // The projection of the box onto the axis is just its Center and Extents.
        // if (min > box_max OR max < box_min) reject;
        vecResult := XMVectorOrInt(XMVectorGreater(FrustumMin, XMVectorAdd(BoxDist, Extents)), XMVectorLess(FrustumMax, XMVectorSubtract(BoxDist, Extents)));

        if (XMVector3AnyTrue(vecResult)) then
        begin
            Result := False;
            Exit;
        end;
    end;

    // Test against edge/edge axes (3*6).
    FrustumEdgeAxis[0] := vRightTop;
    FrustumEdgeAxis[1] := vRightBottom;
    FrustumEdgeAxis[2] := vLeftTop;
    FrustumEdgeAxis[3] := vLeftBottom;
    FrustumEdgeAxis[4] := XMVectorSubtract(vRightTop, vLeftTop);
    FrustumEdgeAxis[5] := XMVectorSubtract(vLeftBottom, vLeftTop);

    for  i := 0 to 2 do
    begin
        for  j := 0 to 5 do
        begin
            // Compute the axis we are going to test.
            Axis := XMVector3Cross(R.r[i], FrustumEdgeAxis[j]);

            // Find the min/max values of the projection of the frustum onto the axis.
            FrustumMin := XMVector3Dot(Axis, Corners[0]);
            FrustumMax := FrustumMin;

            for  k := 1 to BoundingFrustum_CORNER_COUNT - 1 do
            begin
                Temp := XMVector3Dot(Axis, Corners[k]);
                FrustumMin := XMVectorMin(FrustumMin, Temp);
                FrustumMax := XMVectorMax(FrustumMax, Temp);
            end;

            // Project the center of the box onto the axis.
            Dist := XMVector3Dot(Center, Axis);

            // Project the axes of the box onto the axis to find the "radius" of the box.
            Radius := XMVector3Dot(Axis, R.r[0]);
            Radius := XMVectorSelect(Radius, XMVector3Dot(Axis, R.r[1]), SelectY);
            Radius := XMVectorSelect(Radius, XMVector3Dot(Axis, R.r[2]), SelectZ);
            Radius := XMVector3Dot(Extents, XMVectorAbs(Radius));

            // if (center > max + radius OR center < min - radius) reject;
            Outside := XMVectorOrInt(Outside, XMVectorGreater(Dist, XMVectorAdd(FrustumMax, Radius)));
            Outside := XMVectorOrInt(Outside, XMVectorLess(Dist, XMVectorSubtract(FrustumMin, Radius)));
        end;
    end;

    if (XMVector4EqualInt(Outside, XMVectorTrueInt())) then
        Result := False
    else
        // If we did not find a separating plane then the box must intersect the frustum.
        Result := True;
end;


//-----------------------------------------------------------------------------
// Exact frustum vs frustum test.
//-----------------------------------------------------------------------------
function TBoundingFrustum.Intersects(fr: PBoundingFrustum): boolean;
var
    AxisB: array [0..5] of TXMVECTOR;
    OriginB, OrientationB: TXMVECTOR;
    PlaneDistB: array [0..5] of TXMVECTOR;
    OriginA, OrientationA: TXMVECTOR;

    RightTopA, RightBottomA, LeftTopA, LeftBottomA, NearA, FarA: TXMVECTOR;
    RightTopB, RightBottomB, LeftTopB, LeftBottomB, NearB, FarB: TXMVECTOR;
    Outside, InsideAll: TXMVECTOR;
    CornersA: array [0..BoundingFrustum_CORNER_COUNT - 1] of TXMVECTOR;
    CornersB: array [0..BoundingFrustum_CORNER_COUNT - 1] of TXMVECTOR;
    i, j, k: integer;
    Min, Max, Temp: TXMVECTOR;
    AxisA: array [0..5] of TXMVECTOR;
    PlaneDistA: array [0..5] of TXMVECTOR;
    FrustumEdgeAxisA: array [0..5] of TXMVECTOR;
    FrustumEdgeAxisB: array [0..5] of TXMVECTOR;
    Axis: TXMVECTOR;
    MinA, MaxA: TXMVECTOR;
    MinB, MaxB: TXMVECTOR;
    TempA, TempB: TXMVECTOR;
begin
    // Load origin and orientation of frustum B.
    OriginB := XMLoadFloat3(Origin);
    OrientationB := XMLoadFloat4(Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(OrientationB));
	{$ENDIF}

    // Build the planes of frustum B.

    AxisB[0] := XMVectorSet(0.0, 0.0, -1.0, 0.0);
    AxisB[1] := XMVectorSet(0.0, 0.0, 1.0, 0.0);
    AxisB[2] := XMVectorSet(1.0, 0.0, -RightSlope, 0.0);
    AxisB[3] := XMVectorSet(-1.0, 0.0, LeftSlope, 0.0);
    AxisB[4] := XMVectorSet(0.0, 1.0, -TopSlope, 0.0);
    AxisB[5] := XMVectorSet(0.0, -1.0, BottomSlope, 0.0);


    PlaneDistB[0] := XMVectorNegate(XMVectorReplicatePtr(@_Near));
    PlaneDistB[1] := XMVectorReplicatePtr(@_Far);
    PlaneDistB[2] := XMVectorZero();
    PlaneDistB[3] := XMVectorZero();
    PlaneDistB[4] := XMVectorZero();
    PlaneDistB[5] := XMVectorZero();

    // Load origin and orientation of frustum A.
    OriginA := XMLoadFloat3(fr.Origin);
    OrientationA := XMLoadFloat4(fr.Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(OrientationA));
	{$ENDIF}

    // Transform frustum A into the space of the frustum B in order to
    // minimize the number of transforms we have to do.
    OriginA := XMVector3InverseRotate(XMVectorSubtract(OriginA, OriginB), OrientationB);
    OrientationA := XMQuaternionMultiply(OrientationA, XMQuaternionConjugate(OrientationB));

    // Build the corners of frustum A (in the local space of B).
    RightTopA := XMVectorSet(fr.RightSlope, fr.TopSlope, 1.0, 0.0);
    RightBottomA := XMVectorSet(fr.RightSlope, fr.BottomSlope, 1.0, 0.0);
    LeftTopA := XMVectorSet(fr.LeftSlope, fr.TopSlope, 1.0, 0.0);
    LeftBottomA := XMVectorSet(fr.LeftSlope, fr.BottomSlope, 1.0, 0.0);
    NearA := XMVectorReplicatePtr(@fr._Near);
    FarA := XMVectorReplicatePtr(@fr._Far);

    RightTopA := XMVector3Rotate(RightTopA, OrientationA);
    RightBottomA := XMVector3Rotate(RightBottomA, OrientationA);
    LeftTopA := XMVector3Rotate(LeftTopA, OrientationA);
    LeftBottomA := XMVector3Rotate(LeftBottomA, OrientationA);


    CornersA[0] := XMVectorMultiplyAdd(RightTopA, NearA, OriginA);
    CornersA[1] := XMVectorMultiplyAdd(RightBottomA, NearA, OriginA);
    CornersA[2] := XMVectorMultiplyAdd(LeftTopA, NearA, OriginA);
    CornersA[3] := XMVectorMultiplyAdd(LeftBottomA, NearA, OriginA);
    CornersA[4] := XMVectorMultiplyAdd(RightTopA, FarA, OriginA);
    CornersA[5] := XMVectorMultiplyAdd(RightBottomA, FarA, OriginA);
    CornersA[6] := XMVectorMultiplyAdd(LeftTopA, FarA, OriginA);
    CornersA[7] := XMVectorMultiplyAdd(LeftBottomA, FarA, OriginA);

    // Check frustum A against each plane of frustum B.
    Outside := XMVectorFalseInt();
    InsideAll := XMVectorTrueInt();

    for  i := 0 to 5 do
    begin
        // Find the min/max projection of the frustum onto the plane normal.


        Min := XMVector3Dot(AxisB[i], CornersA[0]);
        Max := Min;

        for  j := 1 to BoundingFrustum_CORNER_COUNT - 1 do
        begin
            Temp := XMVector3Dot(AxisB[i], CornersA[j]);
            Min := XMVectorMin(Min, Temp);
            Max := XMVectorMax(Max, Temp);
        end;

        // Outside the plane?
        Outside := XMVectorOrInt(Outside, XMVectorGreater(Min, PlaneDistB[i]));

        // Fully inside the plane?
        InsideAll := XMVectorAndInt(InsideAll, XMVectorLessOrEqual(Max, PlaneDistB[i]));
    end;

    // If the frustum A is outside any of the planes of frustum B it is outside.
    if (XMVector4EqualInt(Outside, XMVectorTrueInt())) then
    begin
        Result := False;
        Exit;
    end;

    // If frustum A is inside all planes of frustum B it is fully inside.
    if (XMVector4EqualInt(InsideAll, XMVectorTrueInt())) then
    begin
        Result := True;
        Exit;
    end;


    // Build the corners of frustum B.
    RightTopB := XMVectorSet(RightSlope, TopSlope, 1.0, 0.0);
    RightBottomB := XMVectorSet(RightSlope, BottomSlope, 1.0, 0.0);
    LeftTopB := XMVectorSet(LeftSlope, TopSlope, 1.0, 0.0);
    LeftBottomB := XMVectorSet(LeftSlope, BottomSlope, 1.0, 0.0);
    NearB := XMVectorReplicatePtr(@_Near);
    FarB := XMVectorReplicatePtr(@_Far);


    CornersB[0] := XMVectorMultiply(RightTopB, NearB);
    CornersB[1] := XMVectorMultiply(RightBottomB, NearB);
    CornersB[2] := XMVectorMultiply(LeftTopB, NearB);
    CornersB[3] := XMVectorMultiply(LeftBottomB, NearB);
    CornersB[4] := XMVectorMultiply(RightTopB, FarB);
    CornersB[5] := XMVectorMultiply(RightBottomB, FarB);
    CornersB[6] := XMVectorMultiply(LeftTopB, FarB);
    CornersB[7] := XMVectorMultiply(LeftBottomB, FarB);

    // Build the planes of frustum A (in the local space of B).


    AxisA[0] := XMVectorSet(0.0, 0.0, -1.0, 0.0);
    AxisA[1] := XMVectorSet(0.0, 0.0, 1.0, 0.0);
    AxisA[2] := XMVectorSet(1.0, 0.0, -fr.RightSlope, 0.0);
    AxisA[3] := XMVectorSet(-1.0, 0.0, fr.LeftSlope, 0.0);
    AxisA[4] := XMVectorSet(0.0, 1.0, -fr.TopSlope, 0.0);
    AxisA[5] := XMVectorSet(0.0, -1.0, fr.BottomSlope, 0.0);

    AxisA[0] := XMVector3Rotate(AxisA[0], OrientationA);
    AxisA[1] := XMVectorNegate(AxisA[0]);
    AxisA[2] := XMVector3Rotate(AxisA[2], OrientationA);
    AxisA[3] := XMVector3Rotate(AxisA[3], OrientationA);
    AxisA[4] := XMVector3Rotate(AxisA[4], OrientationA);
    AxisA[5] := XMVector3Rotate(AxisA[5], OrientationA);

    PlaneDistA[0] := XMVector3Dot(AxisA[0], CornersA[0]);  // Re-use corner on near plane.
    PlaneDistA[1] := XMVector3Dot(AxisA[1], CornersA[4]);  // Re-use corner on far plane.
    PlaneDistA[2] := XMVector3Dot(AxisA[2], OriginA);
    PlaneDistA[3] := XMVector3Dot(AxisA[3], OriginA);
    PlaneDistA[4] := XMVector3Dot(AxisA[4], OriginA);
    PlaneDistA[5] := XMVector3Dot(AxisA[5], OriginA);

    // Check each axis of frustum A for a seperating plane (5).
    for  i := 0 to 5 do
    begin
        // Find the minimum projection of the frustum onto the plane normal.


        Min := XMVector3Dot(AxisA[i], CornersB[0]);

        for  j := 1 to BoundingFrustum_CORNER_COUNT - 1 do
        begin
            Temp := XMVector3Dot(AxisA[i], CornersB[j]);
            Min := XMVectorMin(Min, Temp);
        end;

        // Outside the plane?
        Outside := XMVectorOrInt(Outside, XMVectorGreater(Min, PlaneDistA[i]));
    end;

    // If the frustum B is outside any of the planes of frustum A it is outside.
    if (XMVector4EqualInt(Outside, XMVectorTrueInt())) then
    begin
        Result := False;
        Exit;
    end;

    // Check edge/edge axes (6 * 6).

    FrustumEdgeAxisA[0] := RightTopA;
    FrustumEdgeAxisA[1] := RightBottomA;
    FrustumEdgeAxisA[2] := LeftTopA;
    FrustumEdgeAxisA[3] := LeftBottomA;
    FrustumEdgeAxisA[4] := XMVectorSubtract(RightTopA, LeftTopA);
    FrustumEdgeAxisA[5] := XMVectorSubtract(LeftBottomA, LeftTopA);

    FrustumEdgeAxisB[0] := RightTopB;
    FrustumEdgeAxisB[1] := RightBottomB;
    FrustumEdgeAxisB[2] := LeftTopB;
    FrustumEdgeAxisB[3] := LeftBottomB;
    FrustumEdgeAxisB[4] := XMVectorSubtract(RightTopB, LeftTopB);
    FrustumEdgeAxisB[5] := XMVectorSubtract(LeftBottomB, LeftTopB);

    for  i := 0 to 5 do
    begin
        for  j := 0 to 5 do
        begin
            // Compute the axis we are going to test.
            Axis := XMVector3Cross(FrustumEdgeAxisA[i], FrustumEdgeAxisB[j]);

            // Find the min/max values of the projection of both frustums onto the axis.


            MinA := XMVector3Dot(Axis, CornersA[0]);
            MaxA := MinA;
            MinB := XMVector3Dot(Axis, CornersB[0]);
            MaxB := MinB;

            for  k := 1 to BoundingFrustum_CORNER_COUNT - 1 do
            begin
                TempA := XMVector3Dot(Axis, CornersA[k]);
                MinA := XMVectorMin(MinA, TempA);
                MaxA := XMVectorMax(MaxA, TempA);

                TempB := XMVector3Dot(Axis, CornersB[k]);
                MinB := XMVectorMin(MinB, TempB);
                MaxB := XMVectorMax(MaxB, TempB);
            end;

            // if (MinA > MaxB OR MinB > MaxA) reject
            Outside := XMVectorOrInt(Outside, XMVectorGreater(MinA, MaxB));
            Outside := XMVectorOrInt(Outside, XMVectorGreater(MinB, MaxA));
        end;
    end;

    // If there is a seperating plane, then the frustums do not intersect.
    if (XMVector4EqualInt(Outside, XMVectorTrueInt())) then
        Result := False
    else
        // If we did not find a separating plane then the frustums intersect.
        Result := True;
end;


//-----------------------------------------------------------------------------
// Triangle vs frustum test.
//-----------------------------------------------------------------------------
function TBoundingFrustum.Intersects(V0, V1, V2: TFXMVECTOR): boolean;
var
    Planes: array [0..5] of TXMVECTOR;
    vOrigin, vOrientation: TXMVECTOR;
    TV0, TV1, TV2: TXMVECTOR;
    Outside, InsideAll: TXMVECTOR;
    i, j, k: integer;
    Dist0, Dist1, Dist2: TXMVECTOR;
    MinDist, MaxDist, PlaneDist: TXMVECTOR;
    vRightTop, vRightBottom, vLeftTop, vLeftBottom, vNear, vFar: TXMVECTOR;
    Corners: array [0..BoundingFrustum_CORNER_COUNT - 1] of TXMVECTOR;
    Normal, Dist, Temp: TXMVECTOR;
    TriangleEdgeAxis: array [0..2] of TXMVECTOR;
    FrustumEdgeAxis: array [0..5] of TXMVECTOR;
    Axis: TXMVECTOR;
    MinA, MaxA: TXMVECTOR;
    MinB, MaxB: TXMVECTOR;
begin
    // Build the frustum planes (NOTE: D is negated from the usual).
    Planes[0] := XMVectorSet(0.0, 0.0, -1.0, -_Near);
    Planes[1] := XMVectorSet(0.0, 0.0, 1.0, _Far);
    Planes[2] := XMVectorSet(1.0, 0.0, -RightSlope, 0.0);
    Planes[3] := XMVectorSet(-1.0, 0.0, LeftSlope, 0.0);
    Planes[4] := XMVectorSet(0.0, 1.0, -TopSlope, 0.0);
    Planes[5] := XMVectorSet(0.0, -1.0, BottomSlope, 0.0);

    // Load origin and orientation of the frustum.
    vOrigin := XMLoadFloat3(Origin);
    vOrientation := XMLoadFloat4(Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(vOrientation));
	{$ENDIF}

    // Transform triangle into the local space of frustum.
    TV0 := XMVector3InverseRotate(XMVectorSubtract(V0, vOrigin), vOrientation);
    TV1 := XMVector3InverseRotate(XMVectorSubtract(V1, vOrigin), vOrientation);
    TV2 := XMVector3InverseRotate(XMVectorSubtract(V2, vOrigin), vOrientation);

    // Test each vertex of the triangle against the frustum planes.
    Outside := XMVectorFalseInt();
    InsideAll := XMVectorTrueInt();

    for  i := 0 to 5 do
    begin
        Dist0 := XMVector3Dot(TV0, Planes[i]);
        Dist1 := XMVector3Dot(TV1, Planes[i]);
        Dist2 := XMVector3Dot(TV2, Planes[i]);

        MinDist := XMVectorMin(Dist0, Dist1);
        MinDist := XMVectorMin(MinDist, Dist2);
        MaxDist := XMVectorMax(Dist0, Dist1);
        MaxDist := XMVectorMax(MaxDist, Dist2);

        PlaneDist := XMVectorSplatW(Planes[i]);

        // Outside the plane?
        Outside := XMVectorOrInt(Outside, XMVectorGreater(MinDist, PlaneDist));

        // Fully inside the plane?
        InsideAll := XMVectorAndInt(InsideAll, XMVectorLessOrEqual(MaxDist, PlaneDist));
    end;

    // If the triangle is outside any of the planes it is outside.
    if (XMVector4EqualInt(Outside, XMVectorTrueInt())) then
    begin
        Result := False;
        Exit;
    end;

    // If the triangle is inside all planes it is fully inside.
    if (XMVector4EqualInt(InsideAll, XMVectorTrueInt())) then
    begin
        Result := True;
        Exit;
    end;

    // Build the corners of the frustum.
    vRightTop := XMVectorSet(RightSlope, TopSlope, 1.0, 0.0);
    vRightBottom := XMVectorSet(RightSlope, BottomSlope, 1.0, 0.0);
    vLeftTop := XMVectorSet(LeftSlope, TopSlope, 1.0, 0.0);
    vLeftBottom := XMVectorSet(LeftSlope, BottomSlope, 1.0, 0.0);
    vNear := XMVectorReplicatePtr(@_Near);
    vFar := XMVectorReplicatePtr(@_Far);


    Corners[0] := XMVectorMultiply(vRightTop, vNear);
    Corners[1] := XMVectorMultiply(vRightBottom, vNear);
    Corners[2] := XMVectorMultiply(vLeftTop, vNear);
    Corners[3] := XMVectorMultiply(vLeftBottom, vNear);
    Corners[4] := XMVectorMultiply(vRightTop, vFar);
    Corners[5] := XMVectorMultiply(vRightBottom, vFar);
    Corners[6] := XMVectorMultiply(vLeftTop, vFar);
    Corners[7] := XMVectorMultiply(vLeftBottom, vFar);

    // Test the plane of the triangle.
    Normal := XMVector3Cross(XMVectorSubtract(V1, V0), XMVectorSubtract(V2, V0));
    Dist := XMVector3Dot(Normal, V0);


    MinDist := XMVector3Dot(Corners[0], Normal);
    MaxDist := MinDist;
    for  i := 1 to BoundingFrustum_CORNER_COUNT - 1 do
    begin
        Temp := XMVector3Dot(Corners[i], Normal);
        MinDist := XMVectorMin(MinDist, Temp);
        MaxDist := XMVectorMax(MaxDist, Temp);
    end;

    Outside := XMVectorOrInt(XMVectorGreater(MinDist, Dist), XMVectorLess(MaxDist, Dist));
    if (XMVector4EqualInt(Outside, XMVectorTrueInt())) then
    begin
        Result := False;
        Exit;
    end;
    // Check the edge/edge axes (3*6).

    TriangleEdgeAxis[0] := XMVectorSubtract(V1, V0);
    TriangleEdgeAxis[1] := XMVectorSubtract(V2, V1);
    TriangleEdgeAxis[2] := XMVectorSubtract(V0, V2);


    FrustumEdgeAxis[0] := vRightTop;
    FrustumEdgeAxis[1] := vRightBottom;
    FrustumEdgeAxis[2] := vLeftTop;
    FrustumEdgeAxis[3] := vLeftBottom;
    FrustumEdgeAxis[4] := XMVectorSubtract(vRightTop, vLeftTop);
    FrustumEdgeAxis[5] := XMVectorSubtract(vLeftBottom, vLeftTop);

    for  i := 0 to 2 do
    begin
        for  j := 0 to 5 do
        begin
            // Compute the axis we are going to test.
            Axis := XMVector3Cross(TriangleEdgeAxis[i], FrustumEdgeAxis[j]);

            // Find the min/max of the projection of the triangle onto the axis.


            Dist0 := XMVector3Dot(V0, Axis);
            Dist1 := XMVector3Dot(V1, Axis);
            Dist2 := XMVector3Dot(V2, Axis);

            MinA := XMVectorMin(Dist0, Dist1);
            MinA := XMVectorMin(MinA, Dist2);
            MaxA := XMVectorMax(Dist0, Dist1);
            MaxA := XMVectorMax(MaxA, Dist2);

            // Find the min/max of the projection of the frustum onto the axis.


            MinB := XMVector3Dot(Axis, Corners[0]);
            MaxB := MinB;

            for  k := 1 to BoundingFrustum_CORNER_COUNT - 1 do
            begin
                Temp := XMVector3Dot(Axis, Corners[k]);
                MinB := XMVectorMin(MinB, Temp);
                MaxB := XMVectorMax(MaxB, Temp);
            end;

            // if (MinA > MaxB OR MinB > MaxA) reject;
            Outside := XMVectorOrInt(Outside, XMVectorGreater(MinA, MaxB));
            Outside := XMVectorOrInt(Outside, XMVectorGreater(MinB, MaxA));
        end;
    end;

    if (XMVector4EqualInt(Outside, XMVectorTrueInt())) then
        Result := False
    else
        // If we did not find a separating plane then the triangle must intersect the frustum.
        Result := True;
end;



function TBoundingFrustum.Intersects(Plane: TFXMVECTOR): TPlaneIntersectionType;
var
    vOrigin, vOrientation: TXMVECTOR;
    RightTop, RightBottom, LeftTop, LeftBottom, vNear, vFar: TXMVECTOR;
    Corners0, Corners1, Corners2, Corners3, Corners4, Corners5, Corners6, Corners7: TXMVECTOR;
    Outside, Inside: TXMVECTOR;
begin
    {$IFDEF UseAssert}
    assert(XMPlaneIsUnit(Plane));
   {$ENDIF}

    // Load origin and orientation of the frustum.
    vOrigin := XMLoadFloat3(Origin);
    vOrientation := XMLoadFloat4(Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(vOrientation));
    {$ENDIF}

    // Set w of the origin to one so we can dot4 with a plane.
    vOrigin := XMVectorInsert(0, 0, 0, 0, 1, vOrigin, XMVectorSplatOne());

    // Build the corners of the frustum (in world space).
    RightTop := XMVectorSet(RightSlope, TopSlope, 1.0, 0.0);
    RightBottom := XMVectorSet(RightSlope, BottomSlope, 1.0, 0.0);
    LeftTop := XMVectorSet(LeftSlope, TopSlope, 1.0, 0.0);
    LeftBottom := XMVectorSet(LeftSlope, BottomSlope, 1.0, 0.0);
    vNear := XMVectorReplicatePtr(@_Near);
    vFar := XMVectorReplicatePtr(@_Far);

    RightTop := XMVector3Rotate(RightTop, vOrientation);
    RightBottom := XMVector3Rotate(RightBottom, vOrientation);
    LeftTop := XMVector3Rotate(LeftTop, vOrientation);
    LeftBottom := XMVector3Rotate(LeftBottom, vOrientation);

    Corners0 := XMVectorMultiplyAdd(RightTop, vNear, vOrigin);
    Corners1 := XMVectorMultiplyAdd(RightBottom, vNear, vOrigin);
    Corners2 := XMVectorMultiplyAdd(LeftTop, vNear, vOrigin);
    Corners3 := XMVectorMultiplyAdd(LeftBottom, vNear, vOrigin);
    Corners4 := XMVectorMultiplyAdd(RightTop, vFar, vOrigin);
    Corners5 := XMVectorMultiplyAdd(RightBottom, vFar, vOrigin);
    Corners6 := XMVectorMultiplyAdd(LeftTop, vFar, vOrigin);
    Corners7 := XMVectorMultiplyAdd(LeftBottom, vFar, vOrigin);


    FastIntersectFrustumPlane(Corners0, Corners1, Corners2, Corners3,
        Corners4, Corners5, Corners6, Corners7,
        Plane, Outside, Inside);

    // If the frustum is outside any plane it is outside.
    if (XMVector4EqualInt(Outside, XMVectorTrueInt())) then
        Result := piFRONT
    // If the frustum is inside all planes it is inside.
    else if (XMVector4EqualInt(Inside, XMVectorTrueInt())) then
        Result := piBACK
    else
        // The frustum is not inside all planes or outside a plane it intersects.
        Result := piINTERSECTING;
end;


//-----------------------------------------------------------------------------
// Ray vs. frustum test
//-----------------------------------------------------------------------------
function TBoundingFrustum.Intersects(rayOrigin, Direction: TFXMVECTOR; var Dist: single): boolean;
var
    Planes: array[0..5] of TXMVECTOR;
    frOrigin, frOrientation: TXMVECTOR;
    tnear, tfar: single;
    i: integer;
    Plane: TXMVECTOR;
    AxisDotOrigin, AxisDotDirection: TXMVECTOR;
    distance, vd, vn, t: single;
begin
    // If ray starts inside the frustum, return a distance of 0 for the hit
    if (Contains(rayOrigin) = ctCONTAINS) then
    begin
        Dist := 0.0;
        Result := True;
        Exit;
    end;

    // Build the frustum planes.
    Planes[0] := XMVectorSet(0.0, 0.0, -1.0, _Near);
    Planes[1] := XMVectorSet(0.0, 0.0, 1.0, -_Far);
    Planes[2] := XMVectorSet(1.0, 0.0, -RightSlope, 0.0);
    Planes[3] := XMVectorSet(-1.0, 0.0, LeftSlope, 0.0);
    Planes[4] := XMVectorSet(0.0, 1.0, -TopSlope, 0.0);
    Planes[5] := XMVectorSet(0.0, -1.0, BottomSlope, 0.0);

    // Load origin and orientation of the frustum.
    frOrigin := XMLoadFloat3(Origin);
    frOrientation := XMLoadFloat4(Orientation);

    // This algorithm based on "Fast Ray-Convex Polyhedron Intersectin," in James Arvo, ed., Graphics Gems II pp. 247-250
    tnear := -FLT_MAX;
    tfar := FLT_MAX;

    for  i := 0 to 5 do
    begin
        Plane := XMPlaneTransform(Planes[i], frOrientation, frOrigin);
        Plane := XMPlaneNormalize(Plane);

        AxisDotOrigin := XMPlaneDotCoord(Plane, rayOrigin);
        AxisDotDirection := XMVector3Dot(Plane, Direction);

        if (XMVector3LessOrEqual(XMVectorAbs(AxisDotDirection), g_RayEpsilon)) then
        begin
            // Ray is parallel to plane - check if ray origin is inside plane's
            if (XMVector3Greater(AxisDotOrigin, g_XMZero)) then
            begin
                // Ray origin is outside half-space.
                Dist := 0.0;
                Result := False;
                Exit;
            end;
        end
        else
        begin
            // Ray not parallel - get distance to plane.
            vd := XMVectorGetX(AxisDotDirection);
            vn := XMVectorGetX(AxisDotOrigin);
            t := -vn / vd;
            if (vd < 0.0) then
            begin
                // Front face - T is a near point.
                if (t > tfar) then
                begin
                    Dist := 0.0;
                    Result := False;
                    Exit;
                end;
                if (t > tnear) then
                begin
                    // Hit near face.
                    tnear := t;
                end;
            end
            else
            begin
                // back face - T is far point.
                if (t < tnear) then
                begin
                    Dist := 0.0;
                    Result := False;
                    Exit;
                end;
                if (t < tfar) then
                begin
                    // Hit far face.
                    tfar := t;
                end;
            end;
        end;
    end;

    // Survived all tests.
    // Note: if ray originates on polyhedron, may want to change 0.0 to some
    // epsilon to avoid intersecting the originating face.
    if (tnear >= 0.0) then distance := tnear
    else
        distance := tfar;
    if (distance >= 0.0) then
    begin
        Dist := distance;
        Result := True;
    end
    else
    begin
        Dist := 0.0;
        Result := False;
    end;
end;


//-----------------------------------------------------------------------------
// Test a frustum vs 6 planes (typically forming another frustum).
//-----------------------------------------------------------------------------
function TBoundingFrustum.ContainedBy(Plane0, Plane1, Plane2: TFXMVECTOR; Plane3: TGXMVECTOR; Plane4, Plane5: THXMVECTOR): TContainmentType;
var
    vOrigin, vOrientation: TXMVECTOR;
    RightTop, RightBottom, LeftTop, LeftBottom, vNear, vFar: TXMVECTOR;
    Corners0, Corners1, Corners2, Corners3, Corners4, Corners5, Corners6, Corners7: TXMVECTOR;
    Outside, Inside: TXMVECTOR;
    AnyOutside, AllInside: TXMVECTOR;
begin
    // Load origin and orientation of the frustum.
    vOrigin := XMLoadFloat3(Origin);
    vOrientation := XMLoadFloat4(Orientation);

    {$IFDEF UseAssert}
    assert(XMQuaternionIsUnit(vOrientation));
	{$ENDIF}

    // Set w of the origin to one so we can dot4 with a plane.
    vOrigin := XMVectorInsert(0, 0, 0, 0, 1, vOrigin, XMVectorSplatOne());

    // Build the corners of the frustum (in world space).
    RightTop := XMVectorSet(RightSlope, TopSlope, 1.0, 0.0);
    RightBottom := XMVectorSet(RightSlope, BottomSlope, 1.0, 0.0);
    LeftTop := XMVectorSet(LeftSlope, TopSlope, 1.0, 0.0);
    LeftBottom := XMVectorSet(LeftSlope, BottomSlope, 1.0, 0.0);
    vNear := XMVectorReplicatePtr(@_Near);
    vFar := XMVectorReplicatePtr(@_Far);

    RightTop := XMVector3Rotate(RightTop, vOrientation);
    RightBottom := XMVector3Rotate(RightBottom, vOrientation);
    LeftTop := XMVector3Rotate(LeftTop, vOrientation);
    LeftBottom := XMVector3Rotate(LeftBottom, vOrientation);

    Corners0 := XMVectorMultiplyAdd(RightTop, vNear, vOrigin);
    Corners1 := XMVectorMultiplyAdd(RightBottom, vNear, vOrigin);
    Corners2 := XMVectorMultiplyAdd(LeftTop, vNear, vOrigin);
    Corners3 := XMVectorMultiplyAdd(LeftBottom, vNear, vOrigin);
    Corners4 := XMVectorMultiplyAdd(RightTop, vFar, vOrigin);
    Corners5 := XMVectorMultiplyAdd(RightBottom, vFar, vOrigin);
    Corners6 := XMVectorMultiplyAdd(LeftTop, vFar, vOrigin);
    Corners7 := XMVectorMultiplyAdd(LeftBottom, vFar, vOrigin);



    // Test against each plane.
    FastIntersectFrustumPlane(Corners0, Corners1, Corners2, Corners3,
        Corners4, Corners5, Corners6, Corners7,
        Plane0, Outside, Inside);

    AnyOutside := Outside;
    AllInside := Inside;

    FastIntersectFrustumPlane(Corners0, Corners1, Corners2, Corners3,
        Corners4, Corners5, Corners6, Corners7,
        Plane1, Outside, Inside);

    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectFrustumPlane(Corners0, Corners1, Corners2, Corners3,
        Corners4, Corners5, Corners6, Corners7,
        Plane2, Outside, Inside);

    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectFrustumPlane(Corners0, Corners1, Corners2, Corners3,
        Corners4, Corners5, Corners6, Corners7,
        Plane3, Outside, Inside);

    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectFrustumPlane(Corners0, Corners1, Corners2, Corners3,
        Corners4, Corners5, Corners6, Corners7,
        Plane4, Outside, Inside);

    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    FastIntersectFrustumPlane(Corners0, Corners1, Corners2, Corners3,
        Corners4, Corners5, Corners6, Corners7,
        Plane5, Outside, Inside);

    AnyOutside := XMVectorOrInt(AnyOutside, Outside);
    AllInside := XMVectorAndInt(AllInside, Inside);

    // If the frustum is outside any plane it is outside.
    if (XMVector4EqualInt(AnyOutside, XMVectorTrueInt())) then
        Result := ctDISJOINT

    // If the frustum is inside all planes it is inside.
    else if (XMVector4EqualInt(AllInside, XMVectorTrueInt())) then
        Result := ctCONTAINS
    else
        // The frustum is not inside all planes or outside a plane, it may intersect.
        Result := ctINTERSECTS;
end;


//-----------------------------------------------------------------------------
// Build the 6 frustum planes from a frustum.

// The intended use for these routines is for fast culling to a view frustum.
// When the volume being tested against a view frustum is small relative to the
// view frustum it is usually either inside all six planes of the frustum
// (CONTAINS) or outside one of the planes of the frustum (DISJOINT). If neither
// of these cases is true then it may or may not be intersecting the frustum
// (INTERSECTS)
//-----------------------------------------------------------------------------
procedure TBoundingFrustum.GetPlanes(var NearPlane, FarPlane, RightPlane, LeftPlane, TopPlane, BottomPlane: TXMVECTOR);
var
    vOrigin, vOrientation: TXMVECTOR;
    vNearPlane, vFarPlane, vRightPlane, vLeftPlane, vTopPlane, vBottomPlane: TXMVECTOR;
begin
    // Load origin and orientation of the frustum.
    vOrigin := XMLoadFloat3(Origin);
    vOrientation := XMLoadFloat4(Orientation);

    if (@NearPlane <> nil) then
    begin
        vNearPlane := XMVectorSet(0.0, 0.0, -1.0, _Near);
        vNearPlane := XMPlaneTransform(vNearPlane, vOrientation, vOrigin);
        NearPlane := XMPlaneNormalize(vNearPlane);
    end;

    if (@FarPlane <> nil) then
    begin
        vFarPlane := XMVectorSet(0.0, 0.0, 1.0, -_Far);
        vFarPlane := XMPlaneTransform(vFarPlane, vOrientation, vOrigin);
        FarPlane := XMPlaneNormalize(vFarPlane);
    end;

    if (@RightPlane <> nil) then
    begin
        vRightPlane := XMVectorSet(1.0, 0.0, -RightSlope, 0.0);
        vRightPlane := XMPlaneTransform(vRightPlane, vOrientation, vOrigin);
        RightPlane := XMPlaneNormalize(vRightPlane);
    end;

    if (@LeftPlane <> nil) then
    begin
        vLeftPlane := XMVectorSet(-1.0, 0.0, LeftSlope, 0.0);
        vLeftPlane := XMPlaneTransform(vLeftPlane, vOrientation, vOrigin);
        LeftPlane := XMPlaneNormalize(vLeftPlane);
    end;

    if (@TopPlane <> nil) then
    begin
        vTopPlane := XMVectorSet(0.0, 1.0, -TopSlope, 0.0);
        vTopPlane := XMPlaneTransform(vTopPlane, vOrientation, vOrigin);
        TopPlane := XMPlaneNormalize(vTopPlane);
    end;

    if (@BottomPlane <> nil) then
    begin
        vBottomPlane := XMVectorSet(0.0, -1.0, BottomSlope, 0.0);
        vBottomPlane := XMPlaneTransform(vBottomPlane, vOrientation, vOrigin);
        BottomPlane := XMPlaneNormalize(vBottomPlane);
    end;
end;


//-----------------------------------------------------------------------------
// Build a frustum from a persepective projection matrix.  The matrix may only
// contain a projection; any rotation, translation or scale will cause the
// constructed frustum to be incorrect.
//-----------------------------------------------------------------------------
procedure TBoundingFrustum.CreateFromMatrix(_Out: PBoundingFrustum; Projection: TFXMMATRIX; rhcoords: boolean);
// Corners of the projection frustum in homogenous space.
const
    HomogenousPoints: array [0..5] of TXMVECTOR =
        (
        (f: (1.0, 0.0, 1.0, 1.0)),   // right (at far plane)
        (f: (-1.0, 0.0, 1.0, 1.0)),   // left
        (f: (0.0, 1.0, 1.0, 1.0)),   // top
        (f: (0.0, -1.0, 1.0, 1.0)),   // bottom
        (f: (0.0, 0.0, 0.0, 1.0)),     // near
        (f: (0.0, 0.0, 1.0, 1.0))      // far
        );
var
    Determinant: TXMVECTOR;
    matInverse: TXMMATRIX;
    Points: array [0..5] of TXMVECTOR;
    i: integer;
begin
    matInverse := XMMatrixInverse(Determinant, Projection);

    // Compute the frustum corners in world space.

    for i := 0 to 5 do
    begin
        // Transform point.
        Points[i] := XMVector4Transform(HomogenousPoints[i], matInverse);
    end;

    _Out.Origin := TXMFLOAT3.Create(0.0, 0.0, 0.0);
    _Out.Orientation := TXMFLOAT4.Create(0.0, 0.0, 0.0, 1.0);

    // Compute the slopes.
    Points[0] := XMVectorMultiply(Points[0], XMVectorReciprocal(XMVectorSplatZ(Points[0])));
    Points[1] := XMVectorMultiply(Points[1], XMVectorReciprocal(XMVectorSplatZ(Points[1])));
    Points[2] := XMVectorMultiply(Points[2], XMVectorReciprocal(XMVectorSplatZ(Points[2])));
    Points[3] := XMVectorMultiply(Points[3], XMVectorReciprocal(XMVectorSplatZ(Points[3])));

    _Out.RightSlope := XMVectorGetX(Points[0]);
    _Out.LeftSlope := XMVectorGetX(Points[1]);
    _Out.TopSlope := XMVectorGetY(Points[2]);
    _Out.BottomSlope := XMVectorGetY(Points[3]);

    // Compute near and far.
    Points[4] := XMVectorMultiply(Points[4], XMVectorReciprocal(XMVectorSplatW(Points[4])));
    Points[5] := XMVectorMultiply(Points[5], XMVectorReciprocal(XMVectorSplatW(Points[5])));

    if (rhcoords) then
    begin
        _Out._Near := XMVectorGetZ(Points[5]);
        _Out._Far := XMVectorGetZ(Points[4]);
    end
    else
    begin
        _Out._Near := XMVectorGetZ(Points[4]);
        _Out._Far := XMVectorGetZ(Points[5]);
    end;
end;

{$ENDREGION}


end.
