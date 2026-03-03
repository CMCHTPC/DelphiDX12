//--------------------------------------------------------------------------------------
// File: Bezier.h

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkId=248929
// http://go.microsoft.com/fwlink/?LinkID=615561
//--------------------------------------------------------------------------------------
unit DX12TK.Bezier;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DirectX.Math;

type
    TOutputVertexFunc = procedure(var APosition, ANormal, ATextureCoordinate: TXMVECTOR);
    POutputVertexFunc = ^TOutputVertexFunc;

    TOutputIndexFunc = procedure (var Index: size_t);
    POutputIndexFunc = ^TOutputIndexFunc;


    // Performs a cubic bezier interpolation between four control points,
    // returning the value at the specified time (t ranges 0 to 1).
generic function CubicInterpolate<T1>(constref p1, p2, p3, p4: T1; t: single): T1; inline;
function CubicInterpolate(p1, p2, p3, p4: PXMVECTOR; t: single): TXMVECTOR; inline;

// Computes the tangent of a cubic bezier curve at the specified time.
generic function CubicTangent<T1>(constref p1, p2, p3, p4: T1; t: single): T1; inline;
function CubicTangent(p1, p2, p3, p4: PXMVECTOR; t: single): TXMVECTOR; inline;

// Creates vertices for a patch that is tessellated at the specified level.
// Calls the specified outputVertex function for each generated vertex,
// passing the position, normal, and texture coordinate as parameters.
procedure CreatePatchVertices({_In_reads_(16)} constref PatchArray: PXMVECTOR; tessellation: size_t; isMirrored: boolean; outputVertex: POutputVertexFunc); inline;

// Creates indices for a patch that is tessellated at the specified level.
// Calls the specified outputIndex function for each generated index value.
procedure CreatePatchIndices(tessellation: size_t; isMirrored: bool; outputIndex: POutputIndexFunc); inline;

implementation



generic function CubicInterpolate<T1>(constref p1, p2, p3, p4: T1; t: single): T1;
begin
    Result := p1 * (1 - t) * (1 - t) * (1 - t) + p2 * 3 * t * (1 - t) * (1 - t) + p3 * 3 * t * t * (1 - t) + p4 * t * t * t;
end;



function CubicInterpolate(p1, p2, p3, p4: PXMVECTOR; t: single): TXMVECTOR;
var
    T0, T1, T2, T3: TXMVECTOR;
    r: TXMVECTOR;
begin
    T0 := XMVectorReplicate((1 - t) * (1 - t) * (1 - t));
    T1 := XMVectorReplicate(3 * t * (1 - t) * (1 - t));
    T2 := XMVectorReplicate(3 * t * t * (1 - t));
    T3 := XMVectorReplicate(t * t * t);

    r := XMVectorMultiply(p1^, T0);
    r := XMVectorMultiplyAdd(p2^, T1, r);
    r := XMVectorMultiplyAdd(p3^, T2, r);
    r := XMVectorMultiplyAdd(p4^, T3, r);

    Result := r;
end;



generic function CubicTangent<T1>(constref p1, p2, p3, p4: T1; t: single): T1;
begin
    Result := p1 * (-1 + 2 * t - t * t) + p2 * (1 - 4 * t + 3 * t * t) + p3 * (2 * t - 3 * t * t) + p4 * (t * t);
end;



function CubicTangent(p1, p2, p3, p4: PXMVECTOR; t: single): TXMVECTOR;
var
    T0, T1, T2, T3: TXMVECTOR;
    r: TXMVECTOR;
begin
    T0 := XMVectorReplicate(-1 + 2 * t - t * t);
    T1 := XMVectorReplicate(1 - 4 * t + 3 * t * t);
    T2 := XMVectorReplicate(2 * t - 3 * t * t);
    T3 := XMVectorReplicate(t * t);

    r := XMVectorMultiply(p1^, T0);
    r := XMVectorMultiplyAdd(p2^, T1, r);
    r := XMVectorMultiplyAdd(p3^, T2, r);
    r := XMVectorMultiplyAdd(p4^, T3, r);

    Result := r;
end;



procedure CreatePatchVertices(constref PatchArray: PXMVECTOR;
  tessellation: size_t; isMirrored: boolean; outputVertex: POutputVertexFunc);
var
    i, j: size_t;
    u, v: single;
    p1, p2, p3, p4: TXMVECTOR;
    position: TXMVECTOR;
    q1, q2, q3, q4: TXMVECTOR;
    tangent1, tangent2, normal: TXMVECTOR;
    textureCoordinate: TXMVECTOR;
    mirroredU: single;
    patch: array[0..15] of TXMVECTOR absolute PatchArray;
begin
    for  i := 0 to tessellation do
    begin
        u := i / tessellation;

        for j := 0 to tessellation do
        begin
            v := j / tessellation;

            // Perform four horizontal bezier interpolations
            // between the control points of this patch.
            p1 := CubicInterpolate(@patch[0], @patch[1], @patch[2], @patch[3], u);
            p2 := CubicInterpolate(@patch[4], @patch[5], @patch[6], @patch[7], u);
            p3 := CubicInterpolate(@patch[8], @patch[9], @patch[10], @patch[11], u);
            p4 := CubicInterpolate(@patch[12], @patch[13], @patch[14], @patch[15], u);

            // Perform a vertical interpolation between the results of the
            // previous horizontal interpolations, to compute the position.
            position := CubicInterpolate(@p1, @p2, @p3, @p4, v);

            // Perform another four bezier interpolations between the control
            // points, but this time vertically rather than horizontally.
            q1 := CubicInterpolate(@patch[0], @patch[4], @patch[8], @patch[12], v);
            q2 := CubicInterpolate(@patch[1], @patch[5], @patch[9], @patch[13], v);
            q3 := CubicInterpolate(@patch[2], @patch[6], @patch[10], @patch[14], v);
            q4 := CubicInterpolate(@patch[3], @patch[7], @patch[11], @patch[15], v);

            // Compute vertical and horizontal tangent vectors.
            tangent1 := CubicTangent(@p1, @p2, @p3, @p4, v);
            tangent2 := CubicTangent(@q1, @q2, @q3, @q4, u);

            // Cross the two tangent vectors to compute the normal.
            normal := XMVector3Cross(tangent1, tangent2);

            if (not XMVector3NearEqual(normal, XMVectorZero(), g_XMEpsilon)) then
            begin
                normal := XMVector3Normalize(normal);

                // If this patch is mirrored, we must invert the normal.
                if (isMirrored) then
                begin
                    normal := XMVectorNegate(normal);
                end;
            end
            else
            begin
                // In a tidy and well constructed bezier patch, the preceding
                // normal computation will always work. But the classic teapot
                // model is not tidy or well constructed! At the top and bottom
                // of the teapot, it contains degenerate geometry where a patch
                // has several control points in the same place, which causes
                // the tangent computation to fail and produce a zero normal.
                // We 'fix' these cases by just hard-coding a normal that points
                // either straight up or straight down, depending on whether we
                // are on the top or bottom of the teapot. This is not a robust
                // solution for all possible degenerate bezier patches, but hey,
                // it's good enough to make the teapot work correctly!

                normal := XMVectorSelect(g_XMIdentityR1, g_XMNegIdentityR1, XMVectorLess(position, XMVectorZero()));
            end;

            // Compute the texture coordinate.
            if isMirrored then
                mirroredU := 1 - u
            else
                mirroredU := u;

            textureCoordinate := XMVectorSet(mirroredU, v, 0, 0);

            // Output this vertex.
            outputVertex^(position, normal, textureCoordinate);
        end;
    end;
end;



procedure CreatePatchIndices(tessellation: size_t; isMirrored: bool; outputIndex: POutputIndexFunc);
var
    stride: size_t;
    i, j, n: size_t;
    // Make a list of six index values (two triangles).
    indices: array[0..5] of size_t;
begin
    stride := tessellation + 1;
    n := 0;
    for  i := 0 to tessellation - 1 do
    begin
        for  j := 0 to tessellation - 1 do
        begin
            // Make a list of six index values (two triangles).
            // If this patch is mirrored, reverse indices to fix the winding order.
            if (isMirrored) then
            begin
                indices[5] := i * stride + j;
                indices[4] := (i + 1) * stride + j;
                indices[3] := (i + 1) * stride + j + 1;

                indices[2] := i * stride + j;
                indices[1] := (i + 1) * stride + j + 1;
                indices[0] := i * stride + j + 1;
            end
            else
            begin
                indices[0] := i * stride + j;
                indices[1] := (i + 1) * stride + j;
                indices[2] := (i + 1) * stride + j + 1;

                indices[3] := i * stride + j;
                indices[4] := (i + 1) * stride + j + 1;
                indices[5] := i * stride + j + 1;
            end;
            // Output these index values.
            for n:=0 to 5 do
            begin
                outputIndex^(indices[n]);
            end;
        end;
    end;
end;

end.
