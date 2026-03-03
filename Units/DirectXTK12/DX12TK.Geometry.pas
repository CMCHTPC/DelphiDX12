//--------------------------------------------------------------------------------------
// File: Geometry.h

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkId=248929
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.Geometry;

{$mode ObjFPC}{$H+}
{$MODESWITCH ADVANCEDRECORDS}

interface

uses
    Windows, Classes, SysUtils,
    CStdVector,
    DirectX.Math,
    DX12TK.VertexTypes;

const
    USHRT_MAX = $FFFF;

type
    TVertexCollection = specialize TCStdVector<TVertexPositionNormalTexture>;
    TIndexCollection = specialize TCStdVector<uint16>;


procedure ComputeBox(vertices: TVertexCollection; indices: TIndexCollection; const size: TXMFLOAT3; rhcoords, invertn: boolean);
procedure ComputeSphere(vertices: TVertexCollection; indices: TIndexCollection; diameter: single; tessellation: size_t; rhcoords: boolean; invertn: boolean);
procedure ComputeGeoSphere(vertices: TVertexCollection; indices: TIndexCollection; diameter: single; tessellation: size_t; rhcoords: boolean);
procedure ComputeCylinder(vertices: TVertexCollection; indices: TIndexCollection; Height: single; diameter: single; tessellation: size_t; rhcoords: boolean);
procedure ComputeCone(vertices: TVertexCollection; indices: TIndexCollection; diameter: single; Height: single; tessellation: size_t; rhcoords: boolean);
procedure ComputeTorus(vertices: TVertexCollection; indices: TIndexCollection; diameter: single; thickness: single; tessellation: size_t; rhcoords: boolean);
procedure ComputeTetrahedron(vertices: TVertexCollection; indices: TIndexCollection; size: single; rhcoords: boolean);
procedure ComputeOctahedron(vertices: TVertexCollection; indices: TIndexCollection; size: single; rhcoords: boolean);
procedure ComputeDodecahedron(vertices: TVertexCollection; indices: TIndexCollection; size: single; rhcoords: boolean);
procedure ComputeIcosahedron(vertices: TVertexCollection; indices: TIndexCollection; size: single; rhcoords: boolean);
procedure ComputeTeapot(vertices: TVertexCollection; indices: TIndexCollection; size: single; tessellation: size_t; rhcoords: boolean);


implementation

uses
    fgl,
    Math,
    DX12TK.TeapotData,
    DX12TK.Bezier;

    //--------------------------------------------------------------------------------------
    // File: Geometry.cpp

    // Copyright (c) Microsoft Corporation.
    // Licensed under the MIT License.

    // http://go.microsoft.com/fwlink/?LinkId=248929
    // http://go.microsoft.com/fwlink/?LinkID=615561
    //--------------------------------------------------------------------------------------


const
    SQRT2 = single(1.41421356237309504880);
    SQRT3 = single(1.73205080756887729352);
    SQRT6 = single(2.44948974278317809820);


type
    // An undirected edge between two vertices, represented by a pair of indexes into a vertex array.
    // Becuse this edge is undirected, (a,b) is the same as (b,a).

    { TUndirectedEdge }

    TUndirectedEdge = record
        First: uint16;
        second: uint16;
        class operator <(const a, b: TUndirectedEdge): boolean;
        class operator >(const a, b: TUndirectedEdge): boolean;
        class operator =(const a, b: TUndirectedEdge): boolean;
    end;



procedure CheckIndexOverflow(Value: size_t); inline;
begin
    // Use >=, not > comparison, because some D3D level 9_x hardware does not support 0xFFFF index values.
    if (Value >= USHRT_MAX) then
        raise Exception.Create('Index value out of range: cannot tesselate primitive so finely');
end;


// Collection types used when generating the geometry.
procedure index_push_back(indices: TIndexCollection; Value: size_t); inline;
begin
    CheckIndexOverflow(Value);
    indices.push_back(uint16(Value));
end;


// Helper for flipping winding of geometric primitives for LH vs. RH coords
procedure ReverseWinding(indices: TIndexCollection; vertices: TVertexCollection); inline;
var
    i: integer;
    temp: TIndexCollection.TValueType;
begin
    assert((indices.size() mod 3) = 0);
    i := 0;
    while i < indices.size() - 1 do
    begin
        // swap i, i+2
        temp := indices.Item[i];
        indices.Item[i] := indices.Item[i + 2];
        indices.Item[i + 2] := temp;
        Inc(i, 3);
    end;
    i := 0;
    while i < vertices.size() - 1 do
    begin
        vertices.PtrItem[i]^.textureCoordinate.x := (1.0 - vertices.PtrItem[i]^.textureCoordinate.x);
        Inc(i);
    end;
end;

// Helper for inverting normals of geometric primitives for 'inside' vs. 'outside' viewing

procedure InvertNormals(vertices: TVertexCollection); inline;
var
    i: integer;
begin
    i := 0;
    while i < vertices.size() - 1 do
    begin
        vertices.PtrItem[i]^.normal.x := -vertices.PtrItem[i]^.normal.x;
        vertices.PtrItem[i]^.normal.y := -vertices.PtrItem[i]^.normal.y;
        vertices.PtrItem[i]^.normal.z := -vertices.PtrItem[i]^.normal.z;
        Inc(i);
    end;
end;


//--------------------------------------------------------------------------------------
// Cube (aka a Hexahedron) or Box
//--------------------------------------------------------------------------------------
procedure ComputeBox(vertices: TVertexCollection; indices: TIndexCollection; const size: TXMFLOAT3; rhcoords, invertn: boolean);
const
    // A box has six faces, each one pointing in a different direction.
    FaceCount = 6;

    faceNormals: array [0..FaceCount - 1] of TXMVECTORF32 = (
        (f: (0, 0, 1, 0)),
        (f: (0, 0, -1, 0)),
        (f: (1, 0, 0, 0)),
        (f: (-1, 0, 0, 0)),
        (f: (0, 1, 0, 0)),
        (f: (0, -1, 0, 0))
        );
    textureCoordinates: array [0..3] of TXMVECTORF32 = (
        (f: (1, 0, 0, 0)),
        (f: (1, 1, 0, 0)),
        (f: (0, 1, 0, 0)),
        (f: (0, 0, 0, 0))
        );
var
    tsize: TXMVECTOR;
    i: integer;
    normal: TXMVECTOR;
    basis: TXMVECTOR;
    side1, side2: TXMVECTOR;
    vbase: size_t;
    x: TVertexPositionNormalTexture;
begin
    vertices.Clear();
    indices.Clear();
    tsize := XMLoadFloat3(size);
    tsize := XMVectorDivide(tsize, g_XMTwo);

    // Create each face in turn.
    for i := 0 to FaceCount - 1 do
    begin
        normal := faceNormals[i];

        // Get two vectors perpendicular both to the face normal and to each other.
        if (i >= 4) then
            basis := g_XMIdentityR2
        else
            basis := g_XMIdentityR1;

        side1 := XMVector3Cross(normal, basis);
        side2 := XMVector3Cross(normal, side1);

        // Six indices (two triangles) per face.
        vbase := vertices.size();
        index_push_back(indices, vbase + 0);
        index_push_back(indices, vbase + 1);
        index_push_back(indices, vbase + 2);

        index_push_back(indices, vbase + 0);
        index_push_back(indices, vbase + 2);
        index_push_back(indices, vbase + 3);

        // Four vertices per face.
        // (normal - side1 - side2) * tsize // normal // t0
        vertices.push_back(TVertexPositionNormalTexture.Create(XMVectorMultiply(XMVectorSubtract(XMVectorSubtract(normal, side1), side2), tsize), normal, textureCoordinates[0]));

        // (normal - side1 + side2) * tsize // normal // t1
        vertices.push_back(TVertexPositionNormalTexture.Create(XMVectorMultiply(XMVectorAdd(XMVectorSubtract(normal, side1), side2), tsize), normal, textureCoordinates[1]));

        // (normal + side1 + side2) * tsize // normal // t2
        vertices.push_back(TVertexPositionNormalTexture.Create(XMVectorMultiply(XMVectorAdd(normal, XMVectorAdd(side1, side2)), tsize), normal, textureCoordinates[2]));

        // (normal + side1 - side2) * tsize // normal // t3
        vertices.push_back(TVertexPositionNormalTexture.Create(XMVectorMultiply(XMVectorSubtract(XMVectorAdd(normal, side1), side2), tsize), normal, textureCoordinates[3]));
    end;

    // Build RH above
    if (not rhcoords) then
        ReverseWinding(indices, vertices);

    if (invertn) then
        InvertNormals(vertices);
end;


//--------------------------------------------------------------------------------------
// Sphere
//--------------------------------------------------------------------------------------
procedure ComputeSphere(vertices: TVertexCollection; indices: TIndexCollection; diameter: single; tessellation: size_t; rhcoords: boolean; invertn: boolean);
var
    verticalSegments: size_t;
    horizontalSegments: size_t;
    radius: single;
    i, j: size_t;
    v, u: single;
    latitude, longitude: single;
    dy, dxz: single;
    dx, dz: single;
    normal: TXMVECTOR;
    textureCoordinate: TXMVECTOR;
    stride: size_t;
    nextI, nextJ: size_t;
begin
    vertices.Clear();
    indices.Clear();

    if (tessellation < 3) then
        raise Exception.Create('tesselation parameter must be at least 3');

    verticalSegments := tessellation;
    horizontalSegments := tessellation * 2;

    radius := diameter / 2;

    // Create rings of vertices at progressively higher latitudes.
    for  i := 0 to verticalSegments do
    begin
        v := 1 - (i / verticalSegments);

        latitude := (i * XM_PI / verticalSegments) - XM_PIDIV2;


        XMScalarSinCos(dy, dxz, latitude);

        // Create a single ring of vertices at this latitude.
        for  j := 0 to horizontalSegments do
        begin
            u := j / horizontalSegments;

            longitude := j * XM_2PI / horizontalSegments;

            XMScalarSinCos(dx, dz, longitude);

            dx := dx * dxz;
            dz := dz * dxz;

            normal := XMVectorSet(dx, dy, dz, 0);
            textureCoordinate := XMVectorSet(u, v, 0, 0);

            vertices.push_back(TVertexPositionNormalTexture.Create(XMVectorScale(normal, radius), normal, textureCoordinate));
        end;
    end;


    // Fill the index buffer with triangles joining each pair of latitude rings.
    stride := horizontalSegments + 1;

    for  i := 0 to verticalSegments - 1 do
    begin
        for  j := 0 to horizontalSegments do
        begin
            nextI := i + 1;
            nextJ := (j + 1) mod stride;

            index_push_back(indices, i * stride + j);
            index_push_back(indices, nextI * stride + j);
            index_push_back(indices, i * stride + nextJ);

            index_push_back(indices, i * stride + nextJ);
            index_push_back(indices, nextI * stride + j);
            index_push_back(indices, nextI * stride + nextJ);
        end;
    end;

    // Build RH above
    if (not rhcoords) then
        ReverseWinding(indices, vertices);

    if (invertn) then
        InvertNormals(vertices);
end;


//--------------------------------------------------------------------------------------
// Geodesic sphere
//--------------------------------------------------------------------------------------
procedure ComputeGeoSphere(vertices: TVertexCollection; indices: TIndexCollection; diameter: single; tessellation: size_t; rhcoords: boolean);
type

    // Key: an edge
    // Value: the index of the vertex which lies midway between the two vertices pointed to by the key value
    // This map is used to avoid duplicating vertices when subdividing triangles along edges.
    TEdgeSubdivisionMap = specialize TFPGMap<TUndirectedEdge, uint16>;
var
    radius: single;
    iSubdivision: size_t;
    triangleCount: size_t;
    iTriangle: size_t;
    iv0, iv1, iv2: uint16;

    v01: TXMFLOAT3; // vertex on the midpoint of v0 and v1
    v12: TXMFLOAT3; // ditto v1 and v2
    v20: TXMFLOAT3; // ditto v2 and v0
    iv01: uint16; // index of v01
    iv12: uint16; // index of v12
    iv20: uint16; // index of v20

    vertexPositions: specialize TCStdVector<TXMFLOAT3>;
    i: integer;
    indicesToAdd: array [0..11] of uint16;
    normalFloat3: TXMFLOAT3;
    longitude: single;
    latitude: single;
    u, v: single;
    // We use this to keep track of which edges have already been subdivided.
    subdividedEdges: TEdgeSubdivisionMap;

    // The new index collection after subdivision.
    newIndices: TIndexCollection;

    normal: TXMVECTOR;
    pos: TXMVECTOR;
    texcoord: TXMVECTOR;

    preFixupVertexCount: size_t;
    isOnPrimeMeridian: boolean;
    newIndex: size_t;
    vP: TVertexPositionNormalTexture;

    triIndex0, triIndex1, triIndex2: Puint16;
    iTemp: Puint16;
    j: size_t;

    v0, v1, v2: TVertexPositionNormalTexture;

// Makes an undirected edge. Rather than overloading comparison operators to give us the (a,b)==(b,a) property,
// we'll just ensure that the larger of the two goes first. This'll simplify things greatly.
    function makeUndirectedEdge(a, b: uint16): TUndirectedEdge;
    var
        lEdge: TUndirectedEdge;
    begin
        lEdge.First := max(a, b);
        lEdge.Second := min(a, b);
        Result := lEdge;
    end;


    // Function that, when given the index of two vertices, creates a new vertex at the midpoint of those vertices.
    procedure divideEdge(i0: uint16; i1: uint16; outVertex: PXMFLOAT3; outIndex: puint16);
    var
        edge: TUndirectedEdge;
        it: TUndirectedEdge;
        entry: TUndirectedEdge;
        lIndex: integer;
    begin
        edge := makeUndirectedEdge(i0, i1);

        // Check to see if we've already generated this vertex
        if subdividedEdges.find(edge, lIndex) then
        begin
            if (lIndex <> -1) then
            begin

                // We've already generated this vertex before
                outIndex^ := edge.second; // the index of this vertex
                outVertex := vertexPositions.PtrItem[outIndex^]; // and the vertex itself
            end
            else
            begin
                // Haven't generated this vertex before: so add it now

                // outVertex := (vertices[i0] + vertices[i1]) / 2
                XMStoreFloat3(@outVertex,
                    XMVectorScale(XMVectorAdd(XMLoadFloat3(vertexPositions.Item[i0]), XMLoadFloat3(vertexPositions.Item[i1])), 0.5)
                    );

                outIndex^ := uint16(vertexPositions.Size);
                CheckIndexOverflow(outIndex^);
                vertexPositions.push_back(outVertex^);

                // Now add it to the map.
                subdividedEdges.InsertKey(outIndex^, entry);
            end;
        end;

    end;

    // And one last fix we need to do: the poles. A common use-case of a sphere mesh is to map a rectangular texture onto
    // it. If that happens, then the poles become singularities which map the entire top and bottom rows of the texture
    // onto a single point. In general there's no real way to do that right. But to match the behavior of non-geodesic
    // spheres, we need to duplicate the pole vertex for every triangle that uses it. This will introduce seams near the
    // poles, but reduce stretching.
    procedure fixPole(poleIndex: size_t);
    var
        i: size_t;
        pPoleIndex, pOtherIndex0, pOtherIndex1: Puint16;
        overwrittenPoleVertex: boolean;
        poleVertex: TVertexPositionNormalTexture;
        otherVertex0: TVertexPositionNormalTexture;
        otherVertex1: TVertexPositionNormalTexture;
        newPoleVertex: TVertexPositionNormalTexture;
    begin
        poleVertex := vertices.Item[poleIndex];
        overwrittenPoleVertex := False; // overwriting the original pole vertex saves us one vertex
        i := 0;
        while (i < indices.size()) do
        begin
            // These pointers point to the three indices which make up this triangle. pPoleIndex is the pointer to the
            // entry in the index array which represents the pole index, and the other two pointers point to the other
            // two indices making up this triangle.

            if (indices.Item[i + 0] = poleIndex) then
            begin
                pPoleIndex := indices.PtrItem[i + 0];
                pOtherIndex0 := indices.PtrItem[i + 1];
                pOtherIndex1 := indices.PtrItem[i + 2];
            end
            else if (indices.Item[i + 1] = poleIndex) then
            begin
                pPoleIndex := indices.PtrItem[i + 1];
                pOtherIndex0 := indices.PtrItem[i + 2];
                pOtherIndex1 := indices.PtrItem[i + 0];
            end
            else if (indices.Item[i + 2] = poleIndex) then
            begin
                pPoleIndex := indices.PtrItem[i + 2];
                pOtherIndex0 := indices.PtrItem[i + 0];
                pOtherIndex1 := indices.PtrItem[i + 1];
            end
            else
            begin
                continue;
            end;

            otherVertex0 := vertices.Item[pOtherIndex0^];
            otherVertex1 := vertices.Item[pOtherIndex1^];

            // Calculate the texcoords for the new pole vertex, add it to the vertices and update the index
            newPoleVertex := poleVertex;
            newPoleVertex.textureCoordinate.x := (otherVertex0.textureCoordinate.x + otherVertex1.textureCoordinate.x) / 2;
            newPoleVertex.textureCoordinate.y := poleVertex.textureCoordinate.y;

            if (not overwrittenPoleVertex) then
            begin
                vertices.Item[poleIndex] := newPoleVertex;
                overwrittenPoleVertex := True;
            end
            else
            begin
                CheckIndexOverflow(vertices.size());

                pPoleIndex^ := uint16(vertices.size());
                vertices.push_back(newPoleVertex);
            end;
            Inc(i, 3);
        end;
    end;

const
    OctahedronVertices: array of TXMFLOAT3 = (
        // when looking down the negative z-axis (into the screen)
        (f: (0, 1, 0)), // 0 top
        (f: (0, 0, -1)), // 1 front
        (f: (1, 0, 0)), // 2 right
        (f: (0, 0, 1)), // 3 back
        (f: (-1, 0, 0)), // 4 left
        (f: (0, -1, 0)) // 5 bottom
        );

    OctahedronIndices: array of uint16 =
        (0, 1, 2, // top front-right face
        0, 2, 3, // top back-right face
        0, 3, 4, // top back-left face
        0, 4, 1, // top front-left face
        5, 1, 4, // bottom front-left face
        5, 4, 3, // bottom back-left face
        5, 3, 2, // bottom back-right face
        5, 2, 1 // bottom front-right face
        );

    // We know these values by looking at the above index list for the octahedron. Despite the subdivisions that are
    // about to go on, these values aren't ever going to change because the vertices don't move around in the array.
    // We'll need these values later on to fix the singularities that show up at the poles.
    northPoleIndex: uint16 = 0;
    southPoleIndex: uint16 = 5;
begin
    vertices.Clear();
    indices.Clear();
    radius := diameter / 2.0;

    // Start with an octahedron; copy the data into the vertex/index collection.
    vertexPositions.reserve(Length(OctahedronVertices));
    for i := 0 to Length(OctahedronVertices) - 1 do
    begin
        vertexPositions.Item[i] := OctahedronVertices[i];
    end;

    for i := 0 to Length(OctahedronIndices) - 1 do
        indices.insert(0, OctahedronIndices[i]);


    for  iSubdivision := 0 to tessellation - 1 do
    begin
        assert(indices.size() mod 3 = 0); // sanity


        triangleCount := indices.size() div 3;
        for  iTriangle := 0 to triangleCount - 1 do
        begin
            // For each edge on this triangle, create a new vertex in the middle of that edge.
            // The winding order of the triangles we output are the same as the winding order of the inputs.

            // Indices of the vertices making up this triangle
            iv0 := indices.Item[iTriangle * 3 + 0];
            iv1 := indices.Item[iTriangle * 3 + 1];
            iv2 := indices.Item[iTriangle * 3 + 2];

            // Get the new vertices


            // Add/get new vertices and their indices
            divideEdge(iv0, iv1, @v01, @iv01);
            divideEdge(iv1, iv2, @v12, @iv12);
            divideEdge(iv0, iv2, @v20, @iv20);

            // Add the new indices. We have four new triangles from our original one:
            //        v0
            //        o
            //       /a\
            //  v20 o---o v01
            //     /b\c/d\
            // v2 o---o---o v1
            //       v12
            indicesToAdd := [iv0, iv01, iv20, // a
                iv20, iv12, iv2, // b
                iv20, iv01, iv12, // c
                iv01, iv1, iv12 // d
                ];
            for i := 0 to Length(indicesToAdd) - 1 do
                newIndices.push_back(indicesToAdd[i]);
        end;

        indices := newIndices;
    end;

    // Now that we've completed subdivision, fill in the final vertex collection
    vertices.reserve(vertexPositions.Size);
    for i := 0 to (vertexPositions.Size) - 1 do
    begin
        normal := XMVector3Normalize(XMLoadFloat3(vertexPositions.Item[i]));
        pos := XMVectorScale(normal, radius);


        XMStoreFloat3(@normalFloat3, normal);

        // calculate texture coordinates for this vertex
        longitude := ArcTan2(normalFloat3.x, -normalFloat3.z);
        latitude := ArcCos(normalFloat3.y);

        u := longitude / XM_2PI + 0.5;
        v := latitude / XM_PI;

        texcoord := XMVectorSet(1.0 - u, v, 0.0, 0.0);
        vertices.push_back(TVertexPositionNormalTexture.Create(pos, normal, texcoord));
    end;

    // There are a couple of fixes to do. One is a texture coordinate wraparound fixup. At some point, there will be
    // a set of triangles somewhere in the mesh with texture coordinates such that the wraparound across 0.0/1.0
    // occurs across that triangle. Eg. when the left hand side of the triangle has a U coordinate of 0.98 and the
    // right hand side has a U coordinate of 0.0. The intent is that such a triangle should render with a U of 0.98 to
    // 1.0, not 0.98 to 0.0. If we don't do this fixup, there will be a visible seam across one side of the sphere.

    // Luckily this is relatively easy to fix. There is a straight edge which runs down the prime meridian of the
    // completed sphere. If you imagine the vertices along that edge, they circumscribe a semicircular arc starting at
    // y:=1 and ending at y=-1, and sweeping across the range of z:=0 to z:=1. x stays zero. It's along this edge that we
    // need to duplicate our vertices - and provide the correct texture coordinates.
    preFixupVertexCount := vertices.size();
    for i := 0 to preFixupVertexCount - 1 do
    begin

        // This vertex is on the prime meridian if position.x and texcoord.u are both zero (allowing for small epsilon).
        isOnPrimeMeridian := XMVector2NearEqual(XMVectorSet(vertices.Item[i].position.x, vertices.Item[i].textureCoordinate.x, 0.0, 0.0), XMVectorZero(), XMVectorSplatEpsilon());

        if (isOnPrimeMeridian) then
        begin

            newIndex := vertices.size(); // the index of this vertex that we're about to add
            CheckIndexOverflow(newIndex);

            // copy this vertex, correct the texture coordinate, and add the vertex
            vp := vertices.Item[i];
            vp.textureCoordinate.x := 1.0;
            vertices.push_back(vp);


            // Now find all the triangles which contain this vertex and update them if necessary
            j := 0;
            while j < indices.size do
            begin
                triIndex0 := indices.PtrItem[j + 0];
                triIndex1 := indices.PtrItem[j + 1];
                triIndex2 := indices.PtrItem[j + 2];

                if (triIndex0^ = i) then
                begin
                    // nothing; just keep going
                end
                else if (triIndex1^ = i) then
                begin
                    // swap the pointers (not the values)
                    iTemp := triIndex0;
                    triIndex0 := triIndex1;
                    triIndex1 := iTemp;
                end
                else if (triIndex2^ = i) then
                begin
                    // swap the pointers (not the values)

                    iTemp := triIndex0;
                    triIndex0 := triIndex1;
                    triIndex1 := iTemp;
                end
                else
                begin
                    // this triangle doesn't use the vertex we're interested in
                    continue;
                end;

                // If we got to this point then triIndex0 is the pointer to the index to the vertex we're looking at
                assert(triIndex0^ = i);
                assert((triIndex1^ <> i) and (triIndex2^ <> i)); // assume no degenerate triangles

                v0 := vertices.Item[triIndex0^];
                v1 := vertices.Item[triIndex1^];
                v2 := vertices.Item[triIndex2^];

                // check the other two vertices to see if we might need to fix this triangle

                if ((abs(v0.textureCoordinate.x - v1.textureCoordinate.x) > 0.5) or (abs(v0.textureCoordinate.x - v2.textureCoordinate.x) > 0.5)) then
                begin
                    // yep; replace the specified index to point to the new, corrected vertex
                    triIndex0^ := uint16(newIndex);
                end;

                Inc(j, 3);
            end;
        end;
    end;

    fixPole(northPoleIndex);
    fixPole(southPoleIndex);

    // Build RH above
    if (not rhcoords) then
        ReverseWinding(indices, vertices);
end;


//--------------------------------------------------------------------------------------
// Cylinder / Cone
//--------------------------------------------------------------------------------------

// Helper computes a point on a unit circle, aligned to the x/z plane and centered on the origin.
function GetCircleVector(i, tessellation: size_t): TXMVECTOR; inline;
var
    angle: single;
    dx, dz: single;
    v: TXMVECTORF32;
begin
    angle := i * XM_2PI / tessellation;
    XMScalarSinCos(dx, dz, angle);
    v.Create(dx, 0, dz, 0);
    Result := v;
end;



function GetCircleTangent(i, tessellation: size_t): TXMVECTOR; inline;
var
    angle: single;
    dx, dz: single;
    v: TXMVECTORF32;
begin
    angle := (i * XM_2PI / tessellation) + XM_PIDIV2;
    XMScalarSinCos(dx, dz, angle);
    v.Create(dx, 0, dz, 0);
    Result := v;
end;


// Helper creates a triangle fan to close the end of a cylinder / cone
procedure CreateCylinderCap(vertices: TVertexCollection; indices: TIndexCollection; tessellation: size_t; Height, radius: single; isTop: boolean);
var
    i, i1, i2, iTemp: size_t;
    vbase: size_t;
    normal: TXMVECTOR;
    textureScale: TXMVECTOR;
    circleVector: TXMVECTOR;
    position: TXMVECTOR;
    textureCoordinate: TXMVECTOR;
begin
    // Create cap indices.
    for  i := 0 to tessellation - 3 do
    begin
        i1 := (i + 1) mod tessellation;
        i2 := (i + 2) mod tessellation;

        if (isTop) then
        begin
            iTemp := i1;
            i1 := i2;
            i2 := iTemp;

        end;

        vbase := vertices.size();
        index_push_back(indices, vbase);
        index_push_back(indices, vbase + i1);
        index_push_back(indices, vbase + i2);
    end;

    // Which end of the cylinder is this?
    normal := g_XMIdentityR1;
    textureScale := g_XMNegativeOneHalf;

    if (not isTop) then
    begin
        normal := XMVectorNegate(normal);
        textureScale := XMVectorMultiply(textureScale, g_XMNegateX);
    end;

    // Create cap vertices.
    for  i := 0 to tessellation - 1 do
    begin

        circleVector := GetCircleVector(i, tessellation);

        position := XMVectorAdd(XMVectorScale(circleVector, radius), XMVectorScale(normal, Height));

        textureCoordinate := XMVectorMultiplyAdd(XMVectorSwizzle(0, 2, 3, 3, circleVector), textureScale, g_XMOneHalf);

        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, textureCoordinate));
    end;
end;



procedure ComputeCylinder(vertices: TVertexCollection; indices: TIndexCollection; Height: single; diameter: single; tessellation: size_t; rhcoords: boolean);
var
    topOffset: TXMVECTOR;
    radius: single;
    stride, i: size_t;

    normal: TXMVECTOR;
    sideOffset: TXMVECTOR;
    u: single;
    textureCoordinate: TXMVECTOR;
begin
    vertices.Clear();
    indices.Clear();

    if (tessellation < 3) then
        raise Exception.Create('tesselation parameter must be at least 3');

    Height := Height / 2;

    topOffset := XMVectorScale(g_XMIdentityR1, Height);

    radius := diameter / 2;
    stride := tessellation + 1;

    // Create a ring of triangles around the outside of the cylinder.
    for  i := 0 to tessellation do
    begin
        normal := GetCircleVector(i, tessellation);

        sideOffset := XMVectorScale(normal, radius);

        u := i / tessellation;

        textureCoordinate := XMLoadFloat(@u);

        vertices.push_back(TVertexPositionNormalTexture.Create(XMVectorAdd(sideOffset, topOffset), normal, textureCoordinate));
        vertices.push_back(TVertexPositionNormalTexture.Create(XMVectorSubtract(sideOffset, topOffset), normal, XMVectorAdd(textureCoordinate, g_XMIdentityR1)));

        index_push_back(indices, i * 2);
        index_push_back(indices, (i * 2 + 2) mod (stride * 2));
        index_push_back(indices, i * 2 + 1);

        index_push_back(indices, i * 2 + 1);
        index_push_back(indices, (i * 2 + 2) mod (stride * 2));
        index_push_back(indices, (i * 2 + 3) mod (stride * 2));
    end;

    // Create flat triangle fan caps to seal the top and bottom.
    CreateCylinderCap(vertices, indices, tessellation, Height, radius, True);
    CreateCylinderCap(vertices, indices, tessellation, Height, radius, False);

    // Build RH above
    if (not rhcoords) then
        ReverseWinding(indices, vertices);

end;


// Creates a cone primitive.
procedure ComputeCone(vertices: TVertexCollection; indices: TIndexCollection; diameter: single; Height: single; tessellation: size_t; rhcoords: boolean);
var
    topOffset: TXMVECTOR;
    radius: single;
    stride, i: size_t;
    circlevec: TXMVECTOR;
    sideOffset: TXMVECTOR;
    u: single;
    textureCoordinate: TXMVECTOR;
    pt: TXMVECTOR;
    normal: TXMVECTOR;
begin
    vertices.Clear();
    indices.Clear();

    if (tessellation < 3) then
        raise Exception.Create('tesselation parameter must be at least 3');

    Height := Height / 2;

    topOffset := XMVectorScale(g_XMIdentityR1, Height);

    radius := diameter / 2;
    stride := tessellation + 1;

    // Create a ring of triangles around the outside of the cone.
    for  i := 0 to tessellation do
    begin
        circlevec := GetCircleVector(i, tessellation);

        sideOffset := XMVectorScale(circlevec, radius);

        u := single(i) / single(tessellation);

        textureCoordinate := XMLoadFloat(@u);

        pt := XMVectorSubtract(sideOffset, topOffset);

        normal := XMVector3Cross(GetCircleTangent(i, tessellation), XMVectorSubtract(topOffset, pt));
        normal := XMVector3Normalize(normal);

        // Duplicate the top vertex for distinct normals
        vertices.push_back(TVertexPositionNormalTexture.Create(topOffset, normal, g_XMZero));
        vertices.push_back(TVertexPositionNormalTexture.Create(pt, normal, XMVectorAdd(textureCoordinate, g_XMIdentityR1)));

        index_push_back(indices, i * 2);
        index_push_back(indices, (i * 2 + 3) mod (stride * 2));
        index_push_back(indices, (i * 2 + 1) mod (stride * 2));
    end;

    // Create flat triangle fan caps to seal the bottom.
    CreateCylinderCap(vertices, indices, tessellation, Height, radius, False);

    // Build RH above
    if (not rhcoords) then
        ReverseWinding(indices, vertices);
end;


//--------------------------------------------------------------------------------------
// Torus
//--------------------------------------------------------------------------------------
procedure ComputeTorus(vertices: TVertexCollection; indices: TIndexCollection; diameter: single; thickness: single; tessellation: size_t; rhcoords: boolean);
var
    stride, i, j: size_t;
    u: single;
    outerAngle: single;
    transform: TXMMATRIX;
    v, innerAngle: single;
    dx, dy: single;
    normal, position: TXMVECTOR;
    textureCoordinate: TXMVECTOR;
    nextI, nextJ: size_t;
begin
    vertices.Clear();
    indices.Clear();

    if (tessellation < 3) then
        raise Exception.Create('tesselation parameter must be at least 3');

    stride := tessellation + 1;

    // First we loop around the main ring of the torus.
    for  i := 0 to tessellation do
    begin
        u := i / tessellation;

        outerAngle := i * XM_2PI / tessellation - XM_PIDIV2;

        // Create a transform matrix that will align geometry to
        // slice perpendicularly though the current ring position.
        transform := XMMatrixTranslation(diameter / 2, 0, 0) * XMMatrixRotationY(outerAngle);

        // Now we loop along the other axis, around the side of the tube.
        for j := 0 to tessellation do
        begin
            v := 1 - single(j) / single(tessellation);

            innerAngle := single(j) * XM_2PI / single(tessellation) + XM_PI;


            XMScalarSinCos(dy, dx, innerAngle);

            // Create a vertex.
            normal := XMVectorSet(dx, dy, 0, 0);
            position := XMVectorScale(normal, thickness / 2);
            textureCoordinate := XMVectorSet(u, v, 0, 0);

            position := XMVector3Transform(position, transform);
            normal := XMVector3TransformNormal(normal, transform);

            vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, textureCoordinate));

            // And create indices for two triangles.
            nextI := (i + 1) mod stride;
            nextJ := (j + 1) mod stride;

            index_push_back(indices, i * stride + j);
            index_push_back(indices, i * stride + nextJ);
            index_push_back(indices, nextI * stride + j);

            index_push_back(indices, i * stride + nextJ);
            index_push_back(indices, nextI * stride + nextJ);
            index_push_back(indices, nextI * stride + j);
        end;
    end;

    // Build RH above
    if (not rhcoords) then
        ReverseWinding(indices, vertices);
end;


//--------------------------------------------------------------------------------------
// Tetrahedron
//--------------------------------------------------------------------------------------
procedure ComputeTetrahedron(vertices: TVertexCollection; indices: TIndexCollection; size: single; rhcoords: boolean);
const
    verts: array [0..4 - 1] of TXMVECTORF32 = (
        (f: (0.0, 0.0, 1.0, 0)),
        (f: (2.0 * SQRT2 / 3.0, 0.0, -1.0 / 3.0, 0)),
        (f: (-SQRT2 / 3.0, SQRT6 / 3.0, -1.0 / 3.0, 0)),
        (f: (-SQRT2 / 3.0, -SQRT6 / 3.0, -1.0 / 3.0, 0))
        );

    faces: array [0..4 * 3 - 1] of uint32 = (
        0, 1, 2,
        0, 2, 3,
        0, 3, 1,
        1, 3, 2
        );
var
    j: size_t;
    v0, v1, v2: uint32;
    normal: TXMVECTOR;
    base: size_t;
    position: TXMVECTOR;
begin
    vertices.Clear();
    indices.Clear();


    j := 0;
    while (j < length(faces)) do
    begin
        v0 := faces[j];
        v1 := faces[j + 1];
        v2 := faces[j + 2];

        normal := XMVector3Cross(XMVectorSubtract(verts[v1], verts[v0]), XMVectorSubtract(verts[v2], verts[v0]));
        normal := XMVector3Normalize(normal);

        base := vertices.size();
        index_push_back(indices, base);
        index_push_back(indices, base + 1);
        index_push_back(indices, base + 2);

        // Duplicate vertices to use face normals
        position := XMVectorScale(verts[v0], size);
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, g_XMZero (* 0, 0 *)));

        position := XMVectorScale(verts[v1], size);
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, g_XMIdentityR0 (* 1, 0 *)));

        position := XMVectorScale(verts[v2], size);
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, g_XMIdentityR1 (* 0, 1 *)));
        Inc(j, 3);
    end;

    // Built LH above
    if (rhcoords) then
        ReverseWinding(indices, vertices);

    assert(vertices.size() = 4 * 3);
    assert(indices.size() = 4 * 3);
end;


//--------------------------------------------------------------------------------------
// Octahedron
//--------------------------------------------------------------------------------------
procedure ComputeOctahedron(vertices: TVertexCollection; indices: TIndexCollection; size: single; rhcoords: boolean);
const
    verts: array [0..6 - 1] of TXMVECTORF32 = (
        (f: (1, 0, 0, 0)),
        (f: (-1, 0, 0, 0)),
        (f: (0, 1, 0, 0)),
        (f: (0, -1, 0, 0)),
        (f: (0, 0, 1, 0)),
        (f: (0, 0, -1, 0))
        );

    faces: array [0..8 * 3 - 1] of uint32 = (
        4, 0, 2,
        4, 2, 1,
        4, 1, 3,
        4, 3, 0,
        5, 2, 0,
        5, 1, 2,
        5, 3, 1,
        5, 0, 3
        );
var
    j: size_t;
    v0, v1, v2: uint32;
    normal: TXMVECTOR;
    base: size_t;
    position: TXMVECTOR;
begin
    vertices.Clear();
    indices.Clear();
    j := 0;
    while j < length(faces) do
    begin
        v0 := faces[j];
        v1 := faces[j + 1];
        v2 := faces[j + 2];

        normal := XMVector3Cross(XMVectorSubtract(verts[v1], verts[v0]), XMVectorSubtract(verts[v2], verts[v0]));
        normal := XMVector3Normalize(normal);

        base := vertices.size();
        index_push_back(indices, base);
        index_push_back(indices, base + 1);
        index_push_back(indices, base + 2);

        // Duplicate vertices to use face normals
        position := XMVectorScale(verts[v0], size);
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, g_XMZero (* 0, 0 *)));

        position := XMVectorScale(verts[v1], size);
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, g_XMIdentityR0 (* 1, 0 *)));

        position := XMVectorScale(verts[v2], size);
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, g_XMIdentityR1 (* 0, 1*)));
        Inc(j, 3);
    end;

    // Built LH above
    if (rhcoords) then
        ReverseWinding(indices, vertices);

    assert(vertices.size() = 8 * 3);
    assert(indices.size() = 8 * 3);
end;


//--------------------------------------------------------------------------------------
// Dodecahedron
//--------------------------------------------------------------------------------------
procedure ComputeDodecahedron(vertices: TVertexCollection; indices: TIndexCollection; size: single; rhcoords: boolean);
const
    a = single(1.0 / SQRT3);
    b = single(0.356822089773089931942); // sqrt( ( 3 - sqrt(5) ) / 6 )
    c = single(0.934172358962715696451); // sqrt( ( 3 + sqrt(5) ) / 6 );

    verts: array [0..20 - 1] of TXMVECTORF32 = (
        (f: (a, a, a, 0)),
        (f: (a, a, -a, 0)),
        (f: (a, -a, a, 0)),
        (f: (a, -a, -a, 0)),
        (f: (-a, a, a, 0)),
        (f: (-a, a, -a, 0)),
        (f: (-a, -a, a, 0)),
        (f: (-a, -a, -a, 0)),
        (f: (b, c, 0, 0)),
        (f: (-b, c, 0, 0)),
        (f: (b, -c, 0, 0)),
        (f: (-b, -c, 0, 0)),
        (f: (c, 0, b, 0)),
        (f: (c, 0, -b, 0)),
        (f: (-c, 0, b, 0)),
        (f: (-c, 0, -b, 0)),
        (f: (0, b, c, 0)),
        (f: (0, -b, c, 0)),
        (f: (0, b, -c, 0)),
        (f: (0, -b, -c, 0))
        );

    faces: array [0..12 * 5 - 1] of uint32 = (
        0, 8, 9, 4, 16,
        0, 16, 17, 2, 12,
        12, 2, 10, 3, 13,
        9, 5, 15, 14, 4,
        3, 19, 18, 1, 13,
        7, 11, 6, 14, 15,
        0, 12, 13, 1, 8,
        8, 1, 18, 5, 9,
        16, 4, 14, 6, 17,
        6, 11, 10, 2, 17,
        7, 15, 5, 18, 19,
        7, 19, 3, 10, 11
        );

    textureCoordinates: array [0..5 - 1] of TXMVECTORF32 = (
        (f: (0.654508, 0.0244717, 0, 0)),
        (f: (0.0954915, 0.206107, 0, 0)),
        (f: (0.0954915, 0.793893, 0, 0)),
        (f: (0.654508, 0.975528, 0, 0)),
        (f: (1.0, 0.5, 0, 0))
        );

    textureIndex: array [0..12 - 1, 0..5 - 1] of uint32 = (
        (0, 1, 2, 3, 4), (2, 3, 4, 0, 1), (4, 0, 1, 2, 3), (1, 2, 3, 4, 0), (2, 3, 4, 0, 1), (0, 1, 2, 3, 4), (1, 2, 3, 4, 0),
        (4, 0, 1, 2, 3), (4, 0, 1, 2, 3), (1, 2, 3, 4, 0), (0, 1, 2, 3, 4), (2, 3, 4, 0, 1));
var
    t: size_t = 0;
    j: size_t;
    v0, v1, v2, v3, v4: uint32;
    normal: TXMVECTOR;
    base: size_t;
    position: TXMVECTOR;
begin
    vertices.Clear();
    indices.Clear();
    j := 0;

    while j < Length(faces) do
    begin
        v0 := faces[j];
        v1 := faces[j + 1];
        v2 := faces[j + 2];
        v3 := faces[j + 3];
        v4 := faces[j + 4];

        normal := XMVector3Cross(XMVectorSubtract(verts[v1], verts[v0]), XMVectorSubtract(verts[v2], verts[v0]));
        normal := XMVector3Normalize(normal);

        base := vertices.size();

        index_push_back(indices, base);
        index_push_back(indices, base + 1);
        index_push_back(indices, base + 2);

        index_push_back(indices, base);
        index_push_back(indices, base + 2);
        index_push_back(indices, base + 3);

        index_push_back(indices, base);
        index_push_back(indices, base + 3);
        index_push_back(indices, base + 4);

        // Duplicate vertices to use face normals
        position := XMVectorScale(verts[v0], size);
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, textureCoordinates[textureIndex[t][0]]));

        position := XMVectorScale(verts[v1], size);
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, textureCoordinates[textureIndex[t][1]]));

        position := XMVectorScale(verts[v2], size);
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, textureCoordinates[textureIndex[t][2]]));

        position := XMVectorScale(verts[v3], size);
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, textureCoordinates[textureIndex[t][3]]));

        position := XMVectorScale(verts[v4], size);
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, textureCoordinates[textureIndex[t][4]]));
        Inc(j, 5);
        Inc(t);
    end;

    // Built LH above
    if (rhcoords) then
        ReverseWinding(indices, vertices);

    assert(vertices.size() = 12 * 5);
    assert(indices.size() = 12 * 3 * 3);
end;


//--------------------------------------------------------------------------------------
// Icosahedron
//--------------------------------------------------------------------------------------
procedure ComputeIcosahedron(vertices: TVertexCollection; indices: TIndexCollection; size: single; rhcoords: boolean);
const
    t = 1.618033988749894848205; // (1 + sqrt(5)) / 2
    t2 = 1.519544995837552493271; // sqrt( 1 + sqr( (1 + sqrt(5)) / 2 ) )
const
    faces: array [0..20 * 3 - 1] of uint32 = (
        0, 8, 4,
        0, 5, 10,
        2, 4, 9,
        2, 11, 5,
        1, 6, 8,
        1, 10, 7,
        3, 9, 6,
        3, 7, 11,
        0, 10, 8,
        1, 8, 10,
        2, 9, 11,
        3, 11, 9,
        4, 2, 0,
        5, 0, 2,
        6, 1, 3,
        7, 3, 1,
        8, 6, 4,
        9, 4, 6,
        10, 5, 7,
        11, 7, 5
        );

    verts: array [0..11] of TXMVECTORF32 = (
        (f: (t / t2, 1.0 / t2, 0, 0)),
        (f: (-t / t2, 1.0 / t2, 0, 0)),
        (f: (t / t2, -1.0 / t2, 0, 0)),
        (f: (-t / t2, -1.0 / t2, 0, 0)),
        (f: (1.0 / t2, 0, t / t2, 0)),
        (f: (1.0 / t2, 0, -t / t2, 0)),
        (f: (-1.0 / t2, 0, t / t2, 0)),
        (f: (-1.0 / t2, 0, -t / t2, 0)),
        (f: (0, t / t2, 1.0 / t2, 0)),
        (f: (0, -t / t2, 1.0 / t2, 0)),
        (f: (0, t / t2, -1.0 / t2, 0)),
        (f: (0, -t / t2, -1.0 / t2, 0))
        );
var
    j: size_t;
    v0, v1, v2: uint32;
    normal: TXMVECTOR;
    base: size_t;

    position: TXMVECTOR;
begin
    vertices.Clear();
    indices.Clear();

    j := 0;
    while j < Length(faces) do
    begin
        v0 := faces[j];
        v1 := faces[j + 1];
        v2 := faces[j + 2];

        normal := XMVector3Cross(XMVectorSubtract(verts[v1], verts[v0]), XMVectorSubtract(verts[v2], verts[v0]));
        normal := XMVector3Normalize(normal);

        base := vertices.size();
        index_push_back(indices, base);
        index_push_back(indices, base + 1);
        index_push_back(indices, base + 2);

        // Duplicate vertices to use face normals
        position := XMVectorScale(verts[v0], size);
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, g_XMZero (* 0, 0 *)));

        position := XMVectorScale(verts[v1], size);
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, g_XMIdentityR0 (* 1, 0 *)));

        position := XMVectorScale(verts[v2], size);
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, g_XMIdentityR1 (* 0, 1 *)));
        Inc(j, 3);
    end;

    // Built LH above
    if (rhcoords) then
        ReverseWinding(indices, vertices);

    assert(vertices.size() = 20 * 3);
    assert(indices.size() = 20 * 3);
end;


//--------------------------------------------------------------------------------------
// Teapot
//--------------------------------------------------------------------------------------

// Include the teapot control point data.

// Tessellates the specified bezier patch.
procedure TessellatePatch(vertices: TVertexCollection; indices: TIndexCollection; const patch: TTeapotPatch; tessellation: size_t; scale: TFXMVECTOR; isMirrored: boolean);
var
    controlPoints: array[0..15] of TXMVECTOR;
    i: integer;
    vbase: size_t;
    index: size_t;
    normal: TFXMVECTOR;
    position: TFXMVECTOR;
    textureCoordinate: TFXMVECTOR;



    procedure StoreVertices(var position, normal, textureCoordinate: TXMVECTOR);
    begin
        vertices.push_back(TVertexPositionNormalTexture.Create(position, normal, textureCoordinate));
    end;



    procedure StoreIndices(var Index: size_t);
    begin
        index_push_back(indices, vbase + index);
    end;

begin
    // Look up the 16 control points for this patch.
    for  i := 0 to 15 do
    begin
        controlPoints[i] := XMVectorMultiply(TeapotControlPoints[patch.indices[i]], scale);
    end;

    // Create the index data.
    vbase := vertices.size();

    DX12TK.Bezier.CreatePatchIndices(tessellation, isMirrored, POutputIndexFunc(@StoreIndices));

    // Create the vertex data.
    DX12TK.Bezier.CreatePatchVertices(controlPoints, tessellation, isMirrored, POutputVertexFunc(@StoreVertices));
end;

// Creates a teapot primitive.

procedure ComputeTeapot(vertices: TVertexCollection; indices: TIndexCollection; size: single; tessellation: size_t; rhcoords: boolean);
var
    scaleVector, scaleNegateX, scaleNegateZ, scaleNegateXZ: TXMVECTOR;
    i: size_t;
    patch: TTeapotPatch;
begin
    vertices.Clear();
    indices.Clear();

    if (tessellation < 1) then
        raise Exception.Create('tesselation parameter must be non-zero');

    scaleVector := XMVectorReplicate(size);

    scaleNegateX := XMVectorMultiply(scaleVector, g_XMNegateX);
    scaleNegateZ := XMVectorMultiply(scaleVector, g_XMNegateZ);
    scaleNegateXZ := XMVectorMultiply(scaleVector, XMVectorMultiply(g_XMNegateX, g_XMNegateZ));

    for  i := 0 to Length(TeapotPatches) - 1 do
    begin
        patch := TeapotPatches[i];

        // Because the teapot is symmetrical from left to right, we only store
        // data for one side, then tessellate each patch twice, mirroring in X.
        TessellatePatch(vertices, indices, patch, tessellation, scaleVector, False);
        TessellatePatch(vertices, indices, patch, tessellation, scaleNegateX, True);

        if (patch.mirrorZ) then
        begin
            // Some parts of the teapot (the body, lid, and rim, but not the
            // handle or spout) are also symmetrical from front to back, so
            // we tessellate them four times, mirroring in Z as well as X.
            TessellatePatch(vertices, indices, patch, tessellation, scaleNegateZ, True);
            TessellatePatch(vertices, indices, patch, tessellation, scaleNegateXZ, False);
        end;
    end;

    // Built RH above
    if (not rhcoords) then
        ReverseWinding(indices, vertices);

end;

{ TUndirectedEdge }

class operator TUndirectedEdge.<(const a, b: TUndirectedEdge): boolean;
var
    aMin, aMax, bMin, bMax: uint16;
begin
    if a.First < a.second then
    begin
        aMin := a.First;
        aMax := a.second;
    end
    else
    begin
        aMin := a.second;
        aMax := a.First;
    end;

    if b.First < b.second then
    begin
        bMin := b.First;
        bMax := b.second;
    end
    else
    begin
        bMin := b.second;
        bMax := b.First;
    end;

    if aMin <> bMin then
        Result := aMin < bMin
    else
        Result := aMax < bMax;
end;



class operator TUndirectedEdge.>(const a, b: TUndirectedEdge): boolean;
var
    aMin, aMax, bMin, bMax: uint16;
begin
    if a.First < a.second then
    begin
        aMin := a.First;
        aMax := a.second;
    end
    else
    begin
        aMin := a.second;
        aMax := a.First;
    end;

    if b.First < b.second then
    begin
        bMin := b.First;
        bMax := b.second;
    end
    else
    begin
        bMin := b.second;
        bMax := b.First;
    end;

    if aMin <> bMin then
        Result := aMin > bMin
    else
        Result := aMax > bMax;

end;



class operator TUndirectedEdge.=(const a, b: TUndirectedEdge): boolean;
begin
    Result := (a.First = b.First) and (a.second = b.second);
end;

end.
