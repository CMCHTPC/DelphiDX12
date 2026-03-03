//-------------------------------------------------------------------------------------
// DirectXSH.h -- C++ Spherical Harmonics Math Library

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/p/?LinkId=262885
//-------------------------------------------------------------------------------------
unit DirectX.SH;

{$mode Delphi}

interface

uses
    Classes, SysUtils, Windows,
    Math,
    DirectX.Math;

const
    DIRECTX_SHMATH_VERSION = 106;

    XM_SH_MINORDER = 2;
    XM_SH_MAXORDER = 6;

const
    fExtraNormFac: array [0..XM_SH_MAXORDER - 1] of single = (2.0 * sqrt(XM_PI), 2.0 / 3.0 * sqrt(3.0 * XM_PI),
        2.0 / 5.0 * sqrt(5.0 * XM_PI), 2.0 / 7.0 * sqrt(7.0 * XM_PI), 2.0 / 3.0 * sqrt(XM_PI), 2.0 / 11.0 * sqrt(11.0 * XM_PI));

    // computes the integral of a constant function over a solid angular
    // extent.  No error checking - only used internaly.  This function
    // only returns the Yl0 coefficients, since the rest are zero for
    // circularly symmetric functions.
    ComputeCapInt_t1: single = sqrt(0.3141593E1);
    ComputeCapInt_t5: single = sqrt(3.0);
    ComputeCapInt_t11: single = sqrt(5.0);
    ComputeCapInt_t18: single = sqrt(7.0);
    ComputeCapInt_t32: single = sqrt(11.0);

    SHEvalHemisphereLight_fSqrtPi: single = sqrt(XM_PI);
    SHEvalHemisphereLight_fSqrtPi3: single = sqrt(XM_PI / 3.0);

    M_PIjs: single = (4.0 * arctan(1.0));
    maxang: single = ((4.0 * arctan(1.0)) / 2);

    fx_1_001: single = (sqrt(1.0) / 1.0); // 1
    fx_1_002: single = (-sqrt(1.0) / 1.0); // -1.00000030843

    fx_2_001: single = (sqrt(4.0) / 2.0); // 1
    fx_2_002: single = (-sqrt(4.0) / 2.0); // -1
    fx_2_003: single = (-sqrt(1.0) / 2.0); // -0.500000257021
    fx_2_004: single = (-sqrt(3.0) / 2.0); // -0.866025848959
    fx_2_005: single = (sqrt(1.0) / 2.0); // 0.5

    fx_3_001: single = (-sqrt(10.0) / 4.0); // -0.790569415042
    fx_3_002: single = (sqrt(6.0) / 4.0); // 0.612372435696
    fx_3_003: single = (-sqrt(16.0) / 4.0); // -1
    fx_3_004: single = (-sqrt(6.0) / 4.0); // -0.612372435695
    fx_3_005: single = (-sqrt(1.0) / 4.0); // -0.25
    fx_3_006: single = (-sqrt(15.0) / 4.0); // -0.968245836551
    fx_3_007: single = (sqrt(1.0) / 4.0); // 0.25
    fx_3_008: single = (sqrt(10.0) / 4.0); // 0.790569983984

    fx_4_001: single = (-sqrt(56.0) / 8.0); // -0.935414346694
    fx_4_002: single = (sqrt(8.0) / 8.0); // 0.353553390593
    fx_4_003: single = (-sqrt(36.0) / 8.0); // -0.75
    fx_4_004: single = (sqrt(28.0) / 8.0); // 0.661437827766
    fx_4_005: single = (-sqrt(8.0) / 8.0); // -0.353553390593
    fx_4_006: single = (sqrt(36.0) / 8.0); // 0.749999999999
    fx_4_007: single = (sqrt(9.0) / 8.0); // 0.37500034698
    fx_4_008: single = (sqrt(20.0) / 8.0); // 0.559017511622
    fx_4_009: single = (sqrt(35.0) / 8.0); // 0.739510657141
    fx_4_010: single = (sqrt(16.0) / 8.0); // 0.5
    fx_4_011: single = (-sqrt(28.0) / 8.0); // -0.661437827766
    fx_4_012: single = (sqrt(1.0) / 8.0); // 0.125
    fx_4_013: single = (sqrt(56.0) / 8.0); // 0.935414346692


    fx_5_001: single = (sqrt(126.0) / 16.0); // 0.70156076002
    fx_5_002: single = (-sqrt(120.0) / 16.0); // -0.684653196882
    fx_5_003: single = (sqrt(10.0) / 16.0); // 0.197642353761
    fx_5_004: single = (-sqrt(64.0) / 16.0); // -0.5
    fx_5_005: single = (sqrt(192.0) / 16.0); // 0.866025403784
    fx_5_006: single = (sqrt(70.0) / 16.0); // 0.522912516584
    fx_5_007: single = (sqrt(24.0) / 16.0); // 0.306186217848
    fx_5_008: single = (-sqrt(162.0) / 16.0); // -0.795495128835
    fx_5_009: single = (sqrt(64.0) / 16.0); // 0.5
    fx_5_010: single = (sqrt(60.0) / 16.0); // 0.484122918274
    fx_5_011: single = (sqrt(112.0) / 16.0); // 0.661437827763
    fx_5_012: single = (sqrt(84.0) / 16.0); // 0.572821961867
    fx_5_013: single = (sqrt(4.0) / 16.0); // 0.125
    fx_5_014: single = (sqrt(42.0) / 16.0); // 0.405046293649
    fx_5_015: single = (sqrt(210.0) / 16.0); // 0.905711046633
    fx_5_016: single = (sqrt(169.0) / 16.0); // 0.8125
    fx_5_017: single = (-sqrt(45.0) / 16.0); // -0.419262745781
    fx_5_018: single = (sqrt(1.0) / 16.0); // 0.0625
    fx_5_019: single = (-sqrt(126.0) / 16.0); // -0.701561553415
    fx_5_020: single = (sqrt(120.0) / 16.0); // 0.684653196881
    fx_5_021: single = (-sqrt(10.0) / 16.0); // -0.197642353761
    fx_5_022: single = (-sqrt(70.0) / 16.0); // -0.522913107945
    fx_5_023: single = (-sqrt(60.0) / 16.0); // -0.48412346577


    ROT_TOL = 1e-4;

    NSH0 = 1;
    NSH1 = 4;
    NSH2 = 9;
    NSH3 = 16;
    NSH4 = 25;
    NSH5 = 36;
    NSH6 = 49;
    NSH7 = 64;
    NSH8 = 81;
    NSH9 = 100;
    NL0 = 1;
    NL1 = 3;
    NL2 = 5;
    NL3 = 7;
    NL4 = 9;
    NL5 = 11;
    NL6 = 13;
    NL7 = 15;
    NL8 = 17;
    NL9 = 19;

function XMSHEvalDirection({var} AResult: PSingle; order: size_t; dir: TXMVECTOR): PSingle;
function XMSHRotate({var} Aresult: Psingle; order: size_t; rotMatrix: TXMMATRIX; const input: Psingle): PSingle;
function XMSHRotateZ({var} AResult: Psingle; order: size_t; angle: single; const input: Psingle): Psingle;
function XMSHAdd({var} AResult: Psingle; order: size_t; const inputA: Psingle; const inputB: Psingle): Psingle;
function XMSHScale({var} AResult: Psingle; order: size_t; const input: Psingle; scale: single): Psingle;
function XMSHDot(order: size_t; const inputA: Psingle; const inputB: Psingle): single;
function XMSHMultiply(AResult: PSingle; order: size_t; const inputF: PSingle; const inputG: PSingle): PSingle;
function XMSHMultiply2(var y: PSingle; const f: PSingle; const g: PSingle): PSingle;
function XMSHMultiply3(var y: PSingle; const f: PSingle; const g: PSingle): PSingle;
function XMSHMultiply4(var y: PSingle; const f: PSingle; const g: PSingle): PSingle;
function XMSHMultiply5(var y: PSingle; const f: PSingle; const g: PSingle): PSingle;
function XMSHMultiply6(var y: PSingle; const f: PSingle; const g: PSingle): PSingle;
function XMSHEvalDirectionalLight(order: size_t; dir: TFXMVECTOR; color: TFXMVECTOR; var resultR: Psingle;
    var resultG: Psingle; var resultB: Psingle): boolean;
function XMSHEvalSphericalLight(order: size_t; pos: TXMVECTOR; radius: single; color: TXMVECTOR;    {var} resultR: Psingle;
    {var} resultG: Psingle;    {var} resultB: Psingle): boolean;
function XMSHEvalConeLight(order: size_t; dir: TFXMVECTOR; radius: single; color: TFXMVECTOR;    {var} resultR: psingle;
    {var} resultG: Psingle;    {var} resultB: Psingle): boolean;
function XMSHEvalHemisphereLight(order: size_t; dir: TFXMVECTOR; topColor: TFXMVECTOR; bottomColor: TFXMVECTOR;
    {var} resultR: Psingle;    {var} resultG: Psingle;    {var} resultB: Psingle): boolean;

implementation



procedure ComputeCapInt(order: size_t; angle: single; {var} pR: PSingle);
var
    t2, t3, t7, t8, t13, t19, t20, t33: single;
begin
    t2 := cos(angle);
    t3 := ComputeCapInt_t1 * t2;
    t7 := sin(angle);
    t8 := t7 * t7;

    pR[0] := -t3 + ComputeCapInt_t1;
    pR[1] := ComputeCapInt_t5 * ComputeCapInt_t1 * t8 / 2.0;

    if (order > 2) then
    begin
        t13 := t2 * t2;

        pR[2] := -ComputeCapInt_t11 * ComputeCapInt_t1 * t2 * (t13 - 1.0) / 2.0;
        if (order > 3) then
        begin
            t19 := ComputeCapInt_t18 * ComputeCapInt_t1;
            t20 := t13 * t13;

            pR[3] := -5.0 / 8.0 * t19 * t20 + 3.0 / 4.0 * t19 * t13 - t19 / 8.0;
            if (order > 4) then
            begin
                pR[4] := -3.0 / 8.0 * t3 * (7.0 * t20 - 10.0 * t13 + 3.0);
                if (order > 5) then
                begin
                    t33 := ComputeCapInt_t32 * ComputeCapInt_t1;
                    pR[5] := -21.0 / 16.0 * t33 * t20 * t13 + 35.0 / 16.0 * t33 * t20 - 15.0 / 16.0 * t33 * t13 + t33 / 16.0;
                end;
            end;
        end;
    end;
end;

// input pF only consists of Yl0 values, normalizes coefficients for directional
// lights.
function CosWtInt(order: size_t): single;
var
    fCW0, fCW1, fCW2, fCW4, fRet: single;
begin
    fCW0 := 0.25;
    fCW1 := 0.5;
    fCW2 := 5.0 / 16.0;
    //const single fCW3 := 0.0;
    fCW4 := -3.0 / 32.0;
    //const single fCW5 := 0.0;

    // order has to be at least linear...

    fRet := fCW0 + fCW1;

    if (order > 2) then fRet := fRet + fCW2;
    if (order > 4) then fRet := fRet + fCW4;

    // odd degrees >= 3 evaluate to zero integrated against cosine...

    Result := fRet;
end;

// routine generated programmatically for evaluating SH basis for degree 1
// inputs (x,y,z) are a point on the sphere (i.e., must be unit length)
// output is vector b with SH basis evaluated at (x,y,z).

procedure sh_eval_basis_1(x, y, z: single; {var} b: PSingle);
var
    p_0_0, p_1_0, s1, c1, p_1_1: single;
begin
    // l:=0
    p_0_0 := (0.282094791773878140);
    b[0] := p_0_0; // l:=0,m:=0
    // l:=1
    p_1_0 := (0.488602511902919920) * z;
    b[2] := p_1_0; // l:=1,m:=0

    s1 := y;
    c1 := x;

    // l:=1
    p_1_1 := (-0.488602511902919920);
    b[1] := p_1_1 * s1; // l:=1,m=-1
    b[3] := p_1_1 * c1; // l:=1,m=+1
end;

// routine generated programmatically for evaluating SH basis for degree 2
// inputs (x,y,z) are a point on the sphere (i.e., must be unit length)
// output is vector b with SH basis evaluated at (x,y,z).

procedure sh_eval_basis_2(x, y, z: single; {var} b: Psingle);
var
    z2, p_0_0, p_1_0, p_2_0: single;
    s1, c1, p_1_1, p_2_1, s2, c2, p_2_2: single;
begin
    z2 := z * z;


    { m:=0 }

    // l:=0
    p_0_0 := (0.282094791773878140);
    b[0] := p_0_0; // l:=0,m:=0
    // l:=1
    p_1_0 := (0.488602511902919920) * z;
    b[2] := p_1_0; // l:=1,m:=0
    // l:=2
    p_2_0 := (0.946174695757560080) * z2 + (-0.315391565252520050);
    b[6] := p_2_0; // l:=2,m:=0


    { m:=1 }

    s1 := y;
    c1 := x;

    // l:=1
    p_1_1 := (-0.488602511902919920);
    b[1] := p_1_1 * s1; // l:=1,m=-1
    b[3] := p_1_1 * c1; // l:=1,m=+1
    // l:=2
    p_2_1 := (-1.092548430592079200) * z;
    b[5] := p_2_1 * s1; // l:=2,m=-1
    b[7] := p_2_1 * c1; // l:=2,m=+1


    { m:=2 }

    s2 := x * s1 + y * c1;
    c2 := x * c1 - y * s1;

    // l:=2
    p_2_2 := (0.546274215296039590);
    b[4] := p_2_2 * s2; // l:=2,m=-2
    b[8] := p_2_2 * c2; // l:=2,m=+2
end;


// routine generated programmatically for evaluating SH basis for degree 3
// inputs (x,y,z) are a point on the sphere (i.e., must be unit length)
// output is vector b with SH basis evaluated at (x,y,z).

procedure sh_eval_basis_3(x, y, z: single; {var} b: PSingle);
var
    z2: single;
    p_0_0, p_1_0, p_2_0: single;
    s1, c1: single;
    s2, c2: single;
    s3, c3: single;
    p_1_1, p_2_1, p_2_2: single;
    p_3_0, p_3_1, p_3_2, p_3_3: single;

begin
    z2 := z * z;

    { m:=0 }

    // l:=0
    p_0_0 := (0.282094791773878140);
    b[0] := p_0_0; // l:=0,m:=0
    // l:=1
    p_1_0 := (0.488602511902919920) * z;
    b[2] := p_1_0; // l:=1,m:=0
    // l:=2
    p_2_0 := (0.946174695757560080) * z2 + (-0.315391565252520050);
    b[6] := p_2_0; // l:=2,m:=0
    // l:=3
    p_3_0 := z * ((1.865881662950577000) * z2 + (-1.119528997770346200));
    b[12] := p_3_0; // l:=3,m:=0


    { m:=1 }

    s1 := y;
    c1 := x;

    // l:=1
    p_1_1 := (-0.488602511902919920);
    b[1] := p_1_1 * s1; // l:=1,m=-1
    b[3] := p_1_1 * c1; // l:=1,m=+1
    // l:=2
    p_2_1 := (-1.092548430592079200) * z;
    b[5] := p_2_1 * s1; // l:=2,m=-1
    b[7] := p_2_1 * c1; // l:=2,m=+1
    // l:=3
    p_3_1 := (-2.285228997322328800) * z2 + (0.457045799464465770);
    b[11] := p_3_1 * s1; // l:=3,m=-1
    b[13] := p_3_1 * c1; // l:=3,m=+1


    { m:=2 }

    s2 := x * s1 + y * c1;
    c2 := x * c1 - y * s1;

    // l:=2
    p_2_2 := (0.546274215296039590);
    b[4] := p_2_2 * s2; // l:=2,m=-2
    b[8] := p_2_2 * c2; // l:=2,m=+2
    // l:=3
    p_3_2 := (1.445305721320277100) * z;
    b[10] := p_3_2 * s2; // l:=3,m=-2
    b[14] := p_3_2 * c2; // l:=3,m=+2


    { m:=3 }

    s3 := x * s2 + y * c2;
    c3 := x * c2 - y * s2;

    // l:=3
    p_3_3 := (-0.590043589926643520);
    b[9] := p_3_3 * s3; // l:=3,m=-3
    b[15] := p_3_3 * c3; // l:=3,m=+3
end;

// routine generated programmatically for evaluating SH basis for degree 4
// inputs (x,y,z) are a point on the sphere (i.e., must be unit length)
// output is vector b with SH basis evaluated at (x,y,z).

procedure sh_eval_basis_4(x, y, z: single;{var} b: Psingle);
var
    z2: single;
    p_0_0, p_1_0, p_2_0: single;
    s1, c1: single;
    s2, c2: single;
    s3, c3: single;
    s4, c4: single;
    p_1_1, p_2_1, p_2_2: single;
    p_3_0, p_3_1, p_3_2, p_3_3: single;
    p_4_0, p_4_1, p_4_2, p_4_3, p_4_4: single;
begin
    z2 := z * z;

    { m:=0 }

    // l:=0
    p_0_0 := (0.282094791773878140);
    b[0] := p_0_0; // l:=0,m:=0
    // l:=1
    p_1_0 := (0.488602511902919920) * z;
    b[2] := p_1_0; // l:=1,m:=0
    // l:=2
    p_2_0 := (0.946174695757560080) * z2 + (-0.315391565252520050);
    b[6] := p_2_0; // l:=2,m:=0
    // l:=3
    p_3_0 := z * ((1.865881662950577000) * z2 + (-1.119528997770346200));
    b[12] := p_3_0; // l:=3,m:=0
    // l:=4
    p_4_0 := (1.984313483298443000) * z * p_3_0 + (-1.006230589874905300) * p_2_0;
    b[20] := p_4_0; // l:=4,m:=0


    { m:=1 }

    s1 := y;
    c1 := x;

    // l:=1
    p_1_1 := (-0.488602511902919920);
    b[1] := p_1_1 * s1; // l:=1,m=-1
    b[3] := p_1_1 * c1; // l:=1,m=+1
    // l:=2
    p_2_1 := (-1.092548430592079200) * z;
    b[5] := p_2_1 * s1; // l:=2,m=-1
    b[7] := p_2_1 * c1; // l:=2,m=+1
    // l:=3
    p_3_1 := (-2.285228997322328800) * z2 + (0.457045799464465770);
    b[11] := p_3_1 * s1; // l:=3,m=-1
    b[13] := p_3_1 * c1; // l:=3,m=+1
    // l:=4
    p_4_1 := z * ((-4.683325804901024000) * z2 + (2.007139630671867200));
    b[19] := p_4_1 * s1; // l:=4,m=-1
    b[21] := p_4_1 * c1; // l:=4,m=+1


    { m:=2 }

    s2 := x * s1 + y * c1;
    c2 := x * c1 - y * s1;

    // l:=2
    p_2_2 := (0.546274215296039590);
    b[4] := p_2_2 * s2; // l:=2,m=-2
    b[8] := p_2_2 * c2; // l:=2,m=+2
    // l:=3
    p_3_2 := (1.445305721320277100) * z;
    b[10] := p_3_2 * s2; // l:=3,m=-2
    b[14] := p_3_2 * c2; // l:=3,m=+2
    // l:=4
    p_4_2 := (3.311611435151459800) * z2 + (-0.473087347878779980);
    b[18] := p_4_2 * s2; // l:=4,m=-2
    b[22] := p_4_2 * c2; // l:=4,m=+2


    { m:=3 }

    s3 := x * s2 + y * c2;
    c3 := x * c2 - y * s2;

    // l:=3
    p_3_3 := (-0.590043589926643520);
    b[9] := p_3_3 * s3; // l:=3,m=-3
    b[15] := p_3_3 * c3; // l:=3,m=+3
    // l:=4
    p_4_3 := (-1.770130769779930200) * z;
    b[17] := p_4_3 * s3; // l:=4,m=-3
    b[23] := p_4_3 * c3; // l:=4,m=+3


    { m:=4 }

    s4 := x * s3 + y * c3;
    c4 := x * c3 - y * s3;

    // l:=4
    p_4_4 := (0.625835735449176030);
    b[16] := p_4_4 * s4; // l:=4,m=-4
    b[24] := p_4_4 * c4; // l:=4,m=+4
end;

// routine generated programmatically for evaluating SH basis for degree 5
// inputs (x,y,z) are a point on the sphere (i.e., must be unit length)
// output is vector b with SH basis evaluated at (x,y,z).

procedure sh_eval_basis_5(x, y, z: single; {var} b: Psingle);
var
    z2: single;
    p_0_0, p_1_0, p_2_0: single;
    s1, c1: single;
    s2, c2: single;
    s3, c3: single;
    s4, c4: single;
    s5, c5: single;
    p_1_1, p_2_1, p_2_2: single;
    p_3_0, p_3_1, p_3_2, p_3_3: single;
    p_4_0, p_4_1, p_4_2, p_4_3, p_4_4: single;
    p_5_0, p_5_1, p_5_2, p_5_3, p_5_4, p_5_5: single;
begin
    z2 := z * z;

    { m:=0 }

    // l:=0
    p_0_0 := (0.282094791773878140);
    b[0] := p_0_0; // l:=0,m:=0
    // l:=1
    p_1_0 := (0.488602511902919920) * z;
    b[2] := p_1_0; // l:=1,m:=0
    // l:=2
    p_2_0 := (0.946174695757560080) * z2 + (-0.315391565252520050);
    b[6] := p_2_0; // l:=2,m:=0
    // l:=3
    p_3_0 := z * ((1.865881662950577000) * z2 + (-1.119528997770346200));
    b[12] := p_3_0; // l:=3,m:=0
    // l:=4
    p_4_0 := (1.984313483298443000) * z * p_3_0 + (-1.006230589874905300) * p_2_0;
    b[20] := p_4_0; // l:=4,m:=0
    // l:=5
    p_5_0 := (1.989974874213239700) * z * p_4_0 + (-1.002853072844814000) * p_3_0;
    b[30] := p_5_0; // l:=5,m:=0


    { m:=1 }

    s1 := y;
    c1 := x;

    // l:=1
    p_1_1 := (-0.488602511902919920);
    b[1] := p_1_1 * s1; // l:=1,m=-1
    b[3] := p_1_1 * c1; // l:=1,m=+1
    // l:=2
    p_2_1 := (-1.092548430592079200) * z;
    b[5] := p_2_1 * s1; // l:=2,m=-1
    b[7] := p_2_1 * c1; // l:=2,m=+1
    // l:=3
    p_3_1 := (-2.285228997322328800) * z2 + (0.457045799464465770);
    b[11] := p_3_1 * s1; // l:=3,m=-1
    b[13] := p_3_1 * c1; // l:=3,m=+1
    // l:=4
    p_4_1 := z * ((-4.683325804901024000) * z2 + (2.007139630671867200));
    b[19] := p_4_1 * s1; // l:=4,m=-1
    b[21] := p_4_1 * c1; // l:=4,m=+1
    // l:=5
    p_5_1 := (2.031009601158990200) * z * p_4_1 + (-0.991031208965114650) * p_3_1;
    b[29] := p_5_1 * s1; // l:=5,m=-1
    b[31] := p_5_1 * c1; // l:=5,m=+1


    { m:=2 }

    s2 := x * s1 + y * c1;
    c2 := x * c1 - y * s1;

    // l:=2
    p_2_2 := (0.546274215296039590);
    b[4] := p_2_2 * s2; // l:=2,m=-2
    b[8] := p_2_2 * c2; // l:=2,m=+2
    // l:=3
    p_3_2 := (1.445305721320277100) * z;
    b[10] := p_3_2 * s2; // l:=3,m=-2
    b[14] := p_3_2 * c2; // l:=3,m=+2
    // l:=4
    p_4_2 := (3.311611435151459800) * z2 + (-0.473087347878779980);
    b[18] := p_4_2 * s2; // l:=4,m=-2
    b[22] := p_4_2 * c2; // l:=4,m=+2
    // l:=5
    p_5_2 := z * ((7.190305177459987500) * z2 + (-2.396768392486662100));
    b[28] := p_5_2 * s2; // l:=5,m=-2
    b[32] := p_5_2 * c2; // l:=5,m=+2


    { m:=3 }

    s3 := x * s2 + y * c2;
    c3 := x * c2 - y * s2;

    // l:=3
    p_3_3 := (-0.590043589926643520);
    b[9] := p_3_3 * s3; // l:=3,m=-3
    b[15] := p_3_3 * c3; // l:=3,m=+3
    // l:=4
    p_4_3 := (-1.770130769779930200) * z;
    b[17] := p_4_3 * s3; // l:=4,m=-3
    b[23] := p_4_3 * c3; // l:=4,m=+3
    // l:=5
    p_5_3 := (-4.403144694917253700) * z2 + (0.489238299435250430);
    b[27] := p_5_3 * s3; // l:=5,m=-3
    b[33] := p_5_3 * c3; // l:=5,m=+3


    { m:=4 }

    s4 := x * s3 + y * c3;
    c4 := x * c3 - y * s3;

    // l:=4
    p_4_4 := (0.625835735449176030);
    b[16] := p_4_4 * s4; // l:=4,m=-4
    b[24] := p_4_4 * c4; // l:=4,m=+4
    // l:=5
    p_5_4 := (2.075662314881041100) * z;
    b[26] := p_5_4 * s4; // l:=5,m=-4
    b[34] := p_5_4 * c4; // l:=5,m=+4


    { m:=5 }

    s5 := x * s4 + y * c4;
    c5 := x * c4 - y * s4;

    // l:=5
    p_5_5 := (-0.656382056840170150);
    b[25] := p_5_5 * s5; // l:=5,m=-5
    b[35] := p_5_5 * c5; // l:=5,m=+5
end;



procedure rot(ct, st, x, y: single; var xout, yout: single);
begin
    xout := x * ct - y * st;
    yout := y * ct + x * st;
end;



procedure rot_inv(ct, st, x, y: single; var xout, yout: single);
begin
    xout := x * ct + y * st;
    yout := y * ct - x * st;
end;



procedure rot_1(ct, st: single; var ctm, stm: Psingle);
begin
    ctm[0] := ct;
    stm[0] := st;
end;



procedure rot_2(ct, st: single; ctm, stm: Psingle);
var
    ct2: single;
begin
    ct2 := (2.0) * ct;
    ctm[0] := ct;
    stm[0] := st;
    ctm[1] := ct2 * ct - (1.0);
    stm[1] := ct2 * st;
end;



procedure rot_3(ct, st: single; {var} ctm, stm: Psingle);
var
    ct2: single;
begin
    ct2 := (2.0) * ct;
    ctm[0] := ct;
    stm[0] := st;
    ctm[1] := ct2 * ct - (1.0);
    stm[1] := ct2 * st;
    ctm[2] := ct2 * ctm[1] - ct;
    stm[2] := ct2 * stm[1] - st;
end;



procedure rot_4(ct, st: single; {var} ctm, stm: PSingle);
var
    ct2: single;
begin
    ct2 := (2.0) * ct;
    ctm[0] := ct;
    stm[0] := st;
    ctm[1] := ct2 * ct - (1.0);
    stm[1] := ct2 * st;
    ctm[2] := ct2 * ctm[1] - ct;
    stm[2] := ct2 * stm[1] - st;
    ctm[3] := ct2 * ctm[2] - ctm[1];
    stm[3] := ct2 * stm[2] - stm[1];
end;



procedure rot_5(ct, st: single; {var} ctm, stm: Psingle);
var
    ct2: single;
begin
    ct2 := (2.0) * ct;
    ctm[0] := ct;
    stm[0] := st;
    ctm[1] := ct2 * ct - (1.0);
    stm[1] := ct2 * st;
    ctm[2] := ct2 * ctm[1] - ct;
    stm[2] := ct2 * stm[1] - st;
    ctm[3] := ct2 * ctm[2] - ctm[1];
    stm[3] := ct2 * stm[2] - stm[1];
    ctm[4] := ct2 * ctm[3] - ctm[2];
    stm[4] := ct2 * stm[3] - stm[2];
end;



procedure sh_rotz_1(ctm, stm: Psingle; {var}  y, yr: Psingle);
begin
    yr[1] := y[1];
    rot_inv(ctm[0], stm[0], y[0], y[2], yr[0], yr[2]);
end;



procedure sh_rotz_2(ctm, stm, y: Psingle;  {var}  yr: Psingle);
begin
    yr[2] := y[2];
    rot_inv(ctm[0], stm[0], y[1], y[3], yr[1], yr[3]);
    rot_inv(ctm[1], stm[1], y[0], y[4], yr[0], yr[4]);
end;



procedure sh_rotz_3(ctm, stm, y: Psingle; {var}   yr: Psingle);
begin
    yr[3] := y[3];
    rot_inv(ctm[0], stm[0], y[2], y[4], yr[2], yr[4]);
    rot_inv(ctm[1], stm[1], y[1], y[5], yr[1], yr[5]);
    rot_inv(ctm[2], stm[2], y[0], y[6], yr[0], yr[6]);
end;



procedure sh_rotz_4(ctm, stm, y: Psingle; {var}    yr: Psingle);
begin
    yr[4] := y[4];
    rot_inv(ctm[0], stm[0], y[3], y[5], yr[3], yr[5]);
    rot_inv(ctm[1], stm[1], y[2], y[6], yr[2], yr[6]);
    rot_inv(ctm[2], stm[2], y[1], y[7], yr[1], yr[7]);
    rot_inv(ctm[3], stm[3], y[0], y[8], yr[0], yr[8]);
end;



procedure sh_rotz_5(ctm, stm, y: Psingle;  {var}  yr: Psingle);
begin
    yr[5] := y[5];
    rot_inv(ctm[0], stm[0], y[4], y[6], yr[4], yr[6]);
    rot_inv(ctm[1], stm[1], y[3], y[7], yr[3], yr[7]);
    rot_inv(ctm[2], stm[2], y[2], y[8], yr[2], yr[8]);
    rot_inv(ctm[3], stm[3], y[1], y[9], yr[1], yr[9]);
    rot_inv(ctm[4], stm[4], y[0], y[10], yr[0], yr[10]);
end;


// rotation code generated programmatically by rotatex (2000x4000 samples, eps:=1e-008)



procedure sh_rotx90_1(y: Psingle; {var} yr: Psingle);
begin
    yr[0] := fx_1_001 * y[1];
    yr[1] := fx_1_002 * y[0];
    yr[2] := fx_1_001 * y[2];
end;



procedure sh_rotx90_inv_1(y: Psingle; {var} yr: Psingle);
begin
    yr[0] := fx_1_002 * y[1];
    yr[1] := fx_1_001 * y[0];
    yr[2] := fx_1_001 * y[2];
end;



procedure sh_rotx90_2(y: Psingle; var yr: Psingle);
begin
    yr[0] := fx_2_001 * y[3];
    yr[1] := fx_2_002 * y[1];
    yr[2] := fx_2_003 * y[2] + fx_2_004 * y[4];
    yr[3] := fx_2_002 * y[0];
    yr[4] := fx_2_004 * y[2] + fx_2_005 * y[4];
end;



procedure sh_rotx90_inv_2(y: Psingle; var yr: Psingle);
begin
    yr[0] := fx_2_002 * y[3];
    yr[1] := fx_2_002 * y[1];
    yr[2] := fx_2_003 * y[2] + fx_2_004 * y[4];
    yr[3] := fx_2_001 * y[0];
    yr[4] := fx_2_004 * y[2] + fx_2_005 * y[4];
end;



procedure sh_rotx90_3(y: Psingle; var yr: Psingle);
begin
    yr[0] := fx_3_001 * y[3] + fx_3_002 * y[5];
    yr[1] := fx_3_003 * y[1];
    yr[2] := fx_3_004 * y[3] + fx_3_001 * y[5];
    yr[3] := fx_3_008 * y[0] + fx_3_002 * y[2];
    yr[4] := fx_3_005 * y[4] + fx_3_006 * y[6];
    yr[5] := fx_3_004 * y[0] - fx_3_001 * y[2];
    yr[6] := fx_3_006 * y[4] + fx_3_007 * y[6];
end;



procedure sh_rotx90_inv_3(y: Psingle; var yr: Psingle);
begin
    yr[0] := fx_3_008 * y[3] + fx_3_004 * y[5];
    yr[1] := fx_3_003 * y[1];
    yr[2] := fx_3_002 * y[3] - fx_3_001 * y[5];
    yr[3] := fx_3_001 * y[0] + fx_3_004 * y[2];
    yr[4] := fx_3_005 * y[4] + fx_3_006 * y[6];
    yr[5] := fx_3_002 * y[0] + fx_3_001 * y[2];
    yr[6] := fx_3_006 * y[4] + fx_3_007 * y[6];
end;



procedure sh_rotx90_4(y: Psingle; var yr: Psingle);
begin
    yr[0] := fx_4_001 * y[5] + fx_4_002 * y[7];
    yr[1] := fx_4_003 * y[1] + fx_4_004 * y[3];
    yr[2] := fx_4_005 * y[5] + fx_4_001 * y[7];
    yr[3] := fx_4_004 * y[1] + fx_4_006 * y[3];
    yr[4] := fx_4_007 * y[4] + fx_4_008 * y[6] + fx_4_009 * y[8];
    yr[5] := fx_4_013 * y[0] + fx_4_002 * y[2];
    yr[6] := fx_4_008 * y[4] + fx_4_010 * y[6] + fx_4_011 * y[8];
    yr[7] := fx_4_005 * y[0] - fx_4_001 * y[2];
    yr[8] := fx_4_009 * y[4] + fx_4_011 * y[6] + fx_4_012 * y[8];
end;



procedure sh_rotx90_inv_4(y: Psingle; var yr: Psingle);
begin
    yr[0] := fx_4_013 * y[5] + fx_4_005 * y[7];
    yr[1] := fx_4_003 * y[1] + fx_4_004 * y[3];
    yr[2] := fx_4_002 * y[5] - fx_4_001 * y[7];
    yr[3] := fx_4_004 * y[1] + fx_4_006 * y[3];
    yr[4] := fx_4_007 * y[4] + fx_4_008 * y[6] + fx_4_009 * y[8];
    yr[5] := fx_4_001 * y[0] + fx_4_005 * y[2];
    yr[6] := fx_4_008 * y[4] + fx_4_010 * y[6] + fx_4_011 * y[8];
    yr[7] := fx_4_002 * y[0] + fx_4_001 * y[2];
    yr[8] := fx_4_009 * y[4] + fx_4_011 * y[6] + fx_4_012 * y[8];
end;



procedure sh_rotx90_5(y: Psingle; var yr: Psingle);
begin
    yr[0] := fx_5_001 * y[5] + fx_5_002 * y[7] + fx_5_003 * y[9];
    yr[1] := fx_5_004 * y[1] + fx_5_005 * y[3];
    yr[2] := fx_5_006 * y[5] + fx_5_007 * y[7] + fx_5_008 * y[9];
    yr[3] := fx_5_005 * y[1] + fx_5_009 * y[3];
    yr[4] := fx_5_010 * y[5] + fx_5_011 * y[7] + fx_5_012 * y[9];
    yr[5] := fx_5_019 * y[0] + fx_5_022 * y[2] + fx_5_023 * y[4];
    yr[6] := fx_5_013 * y[6] + fx_5_014 * y[8] + fx_5_015 * y[10];
    yr[7] := fx_5_020 * y[0] - fx_5_007 * y[2] - fx_5_011 * y[4];
    yr[8] := fx_5_014 * y[6] + fx_5_016 * y[8] + fx_5_017 * y[10];
    yr[9] := fx_5_021 * y[0] - fx_5_008 * y[2] - fx_5_012 * y[4];
    yr[10] := fx_5_015 * y[6] + fx_5_017 * y[8] + fx_5_018 * y[10];
end;



procedure sh_rotx90_inv_5(y: Psingle; var yr: Psingle);
begin
    yr[0] := fx_5_019 * y[5] + fx_5_020 * y[7] + fx_5_021 * y[9];
    yr[1] := fx_5_004 * y[1] + fx_5_005 * y[3];
    yr[2] := fx_5_022 * y[5] - fx_5_007 * y[7] - fx_5_008 * y[9];
    yr[3] := fx_5_005 * y[1] + fx_5_009 * y[3];
    yr[4] := fx_5_023 * y[5] - fx_5_011 * y[7] - fx_5_012 * y[9];
    yr[5] := fx_5_001 * y[0] + fx_5_006 * y[2] + fx_5_010 * y[4];
    yr[6] := fx_5_013 * y[6] + fx_5_014 * y[8] + fx_5_015 * y[10];
    yr[7] := fx_5_002 * y[0] + fx_5_007 * y[2] + fx_5_011 * y[4];
    yr[8] := fx_5_014 * y[6] + fx_5_016 * y[8] + fx_5_017 * y[10];
    yr[9] := fx_5_003 * y[0] + fx_5_008 * y[2] + fx_5_012 * y[4];
    yr[10] := fx_5_015 * y[6] + fx_5_017 * y[8] + fx_5_018 * y[10];
end;



procedure sh_rot_1(m, y: Psingle; {var} yr: PSingle);
var
    yr0, yr1, yr2: single;
begin
    yr0 := m[4] * y[0] - m[5] * y[1] + m[3] * y[2];
    yr1 := m[8] * y[1] - m[7] * y[0] - m[6] * y[2];
    yr2 := m[1] * y[0] - m[2] * y[1] + m[0] * y[2];

    yr[0] := yr0;
    yr[1] := yr1;
    yr[2] := yr2;
end;



procedure sh_roty_1(ctm, stm: Psingle; y: Psingle; {var}  yr: Psingle);
begin
    yr[0] := y[0];
    rot_inv(ctm[0], stm[0], y[1], y[2], yr[1], yr[2]);
end;



procedure sh_roty_2(ctm, stm: Psingle; y: Psingle; {var}  yr: Psingle);
var
    ytmp: array[0..NL2 - 1] of single;
begin

    sh_rotx90_2(y, yr);
    sh_rotz_2(ctm, stm, yr, @ytmp[0]);
    sh_rotx90_inv_2(ytmp, yr);
end;



procedure sh_roty_3(ctm, stm: Psingle; y: Psingle; {var}  yr: Psingle);
var
    ytmp: array[0..NL3 - 1] of single;
begin

    sh_rotx90_3(y, yr);
    sh_rotz_3(ctm, stm, yr, ytmp);
    sh_rotx90_inv_3(ytmp, yr);
end;



procedure sh_roty_4(ctm, stm: Psingle; y: Psingle; {var}  yr: Psingle);
var
    ytmp: array[0..NL4 - 1] of single;
begin

    sh_rotx90_4(y, yr);
    sh_rotz_4(ctm, stm, yr, ytmp);
    sh_rotx90_inv_4(ytmp, yr);
end;



procedure sh_roty_5(ctm, stm: Psingle; y: Psingle; {var} yr: Psingle);
var
    ytmp: array [0..NL5 - 1] of single;
begin

    sh_rotx90_5(y, yr);
    sh_rotz_5(ctm, stm, yr, ytmp);
    sh_rotx90_inv_5(ytmp, yr);
end;



    {
    Finds cosine,sine pairs for zyz rotation (i.e. rotation R_z2 R_y R_z1 v).
    The rotation is one which maps mx to (1,0,0) and mz to (0,0,1).
    }
procedure zyz(m: Psingle; var zc1, zs1, yc, ys, zc2, zs2: single);
var
    cz, cxylen, len67inv, len25inv: single;
begin
    cz := m[8];

    // rotate so that (cx,cy,0) aligns to (1,0,0)
    cxylen := sqrt(1.0 - cz * cz);
    if (cxylen >= ROT_TOL) then
    begin
        // if above is a NaN, will do the correct thing
        yc := cz;
        ys := cxylen;
        len67inv := 1.0 / sqrt(m[6] * m[6] + m[7] * m[7]);
        zc1 := -m[6] * len67inv;
        zs1 := m[7] * len67inv;
        len25inv := 1.0 / sqrt(m[2] * m[2] + m[5] * m[5]);
        zc2 := m[2] * len25inv;
        zs2 := m[5] * len25inv;
    end
    else
    begin  // m[6],m[7],m[8] already aligned to (0,0,1)
        zc1 := 1.0;
        zs1 := 0.0;        // identity
        yc := cz;
        ys := 0.0;           // identity
        zc2 := m[0] * cz;
        zs2 := -m[1];  // align x axis (mx[0],mx[1],0) to (1,0,0)

    end;
end;



procedure sh_rotzyz_2(zc1m, zs1m, ycm, ysm, zc2m, zs2m, y, yr: Psingle);
var
    ytmp: array [0..NL2 - 1] of single;
begin

    sh_rotz_2(zc1m, zs1m, y, yr);
    sh_roty_2(ycm, ysm, yr, ytmp);
    sh_rotz_2(zc2m, zs2m, ytmp, yr);
end;



procedure sh_rotzyz_3(zc1m, zs1m, ycm, ysm, zc2m, zs2m, y, yr: Psingle);
var
    ytmp: array [0..NL3 - 1] of single;
begin

    sh_rotz_3(zc1m, zs1m, y, yr);
    sh_roty_3(ycm, ysm, yr, ytmp);
    sh_rotz_3(zc2m, zs2m, ytmp, yr);
end;



procedure sh_rotzyz_4(zc1m, zs1m, ycm, ysm, zc2m, zs2m, y, yr: Psingle);
var
    ytmp: array [0..NL4 - 1] of single;
begin

    sh_rotz_4(zc1m, zs1m, y, yr);
    sh_roty_4(ycm, ysm, yr, ytmp);
    sh_rotz_4(zc2m, zs2m, ytmp, yr);
end;



procedure sh_rotzyz_5(zc1m, zs1m, ycm, ysm, zc2m, zs2m, y, yr: Psingle);
var
    ytmp: array [0..NL5 - 1] of single;
begin

    sh_rotz_5(zc1m, zs1m, y, yr);
    sh_roty_5(ycm, ysm, yr, @ytmp[0]);
    sh_rotz_5(zc2m, zs2m, ytmp, yr);
end;



procedure sh3_rot(m: PSingle; zc1, zs1, yc, ys, zc2, zs2: single; y, yr: PSingle); overload;
var
    zc1m, zs1m: array [0..2] of single;
    ycm, ysm: array [0..2] of single;
    zc2m, zs2m: array [0..2] of single;
begin
    rot_3(zc1, zs1, @zc1m[0], @zs1m[0]);
    rot_3(yc, ys, ycm, @ysm[0]);
    rot_3(zc2, zs2, zc2m, @zs2m[0]);

    yr[0] := y[0];
    sh_rot_1(m, y + NSH0, yr + NSH0);
    sh_rotzyz_2(zc1m, zs1m, ycm, ysm, zc2m, zs2m, y + NSH1, yr + NSH1);
    sh_rotzyz_3(zc1m, zs1m, ycm, ysm, zc2m, zs2m, y + NSH2, yr + NSH2);
end;



procedure sh4_rot(m: PSingle; zc1, zs1, yc, ys, zc2, zs2: single; y, yr: PSingle); overload;
var
    zc1m, zs1m: array [0..3] of single;
    ycm, ysm: array [0..3] of single;
    zc2m, zs2m: array [0..3] of single;
begin

    rot_4(zc1, zs1, zc1m, zs1m);

    rot_4(yc, ys, ycm, ysm);

    rot_4(zc2, zs2, zc2m, zs2m);

    yr[0] := y[0];
    sh_rot_1(m, y + NSH0, yr + NSH0);
    sh_rotzyz_2(zc1m, zs1m, ycm, ysm, zc2m, zs2m, y + NSH1, yr + NSH1);
    sh_rotzyz_3(zc1m, zs1m, ycm, ysm, zc2m, zs2m, y + NSH2, yr + NSH2);
    sh_rotzyz_4(zc1m, zs1m, ycm, ysm, zc2m, zs2m, y + NSH3, yr + NSH3);
end;



procedure sh5_rot(m: PSingle; zc1, zs1, yc, ys, zc2, zs2: single; y, yr: PSingle); overload;
var
    zc1m, zs1m: array [0..4] of single;
    ycm, ysm: array [0..4] of single;
    zc2m, zs2m: array [0..4] of single;

begin

    rot_5(zc1, zs1, zc1m, zs1m);

    rot_5(yc, ys, ycm, ysm);

    rot_5(zc2, zs2, zc2m, zs2m);

    yr[0] := y[0];
    sh_rot_1(m, y + NSH0, yr + NSH0);
    sh_rotzyz_2(zc1m, zs1m, ycm, ysm, zc2m, zs2m, y + NSH1, yr + NSH1);
    sh_rotzyz_3(zc1m, zs1m, ycm, ysm, zc2m, zs2m, y + NSH2, yr + NSH2);
    sh_rotzyz_4(zc1m, zs1m, ycm, ysm, zc2m, zs2m, y + NSH3, yr + NSH3);
    sh_rotzyz_5(zc1m, zs1m, ycm, ysm, zc2m, zs2m, y + NSH4, yr + NSH4);
end;



procedure sh1_rot(m: PSingle; y, yr: PSingle);
begin
    yr[0] := y[0];
    sh_rot_1(m, y + NSH0, yr + NSH0);
end;



procedure sh3_rot(m: PSingle; y, yr: PSingle); overload;
var
    zc1, zs1, yc, ys, zc2, zs2: single;
begin

    zyz(m, zc1, zs1, yc, ys, zc2, zs2);
    sh3_rot(m, zc1, zs1, yc, ys, zc2, zs2, y, yr);
end;



procedure sh4_rot(m: PSingle; y, yr: PSingle); overload;
var
    zc1, zs1, yc, ys, zc2, zs2: single;
begin

    zyz(m, zc1, zs1, yc, ys, zc2, zs2);
    sh4_rot(m, zc1, zs1, yc, ys, zc2, zs2, y, yr);
end;



procedure sh5_rot(m: PSingle; y, yr: PSingle); overload;
var
    zc1, zs1, yc, ys, zc2, zs2: single;
begin

    zyz(m, zc1, zs1, yc, ys, zc2, zs2);
    sh5_rot(m, zc1, zs1, yc, ys, zc2, zs2, y, yr);
end;

// here was vor XMSHMultiply5



// simple matrix vector multiply for a square matrix (only used by ZRotation)
procedure SimpMatMul(dim: size_t; const matrix: Psingle; const input: Psingle; {var} Result: Psingle);
var
    iR, iC: size_t;
begin
    for  iR := 0 to dim - 1 do
    begin
        Result[iR + 0] := matrix[iR * dim + 0] * input[0];
        for  iC := 1 to dim - 1 do
        begin
            Result[iR] := Result[iR] + matrix[iR * dim + iC] * input[iC];
        end;
    end;
end;




//-------------------------------------------------------------------------------------
// Evaluates the Spherical Harmonic basis functions

// http://msdn.microsoft.com/en-us/library/windows/desktop/bb205448.aspx
//-------------------------------------------------------------------------------------

function XMSHEvalDirection({var} AResult: PSingle; order: size_t; dir: TXMVECTOR): PSingle;
var
    dv: TXMFLOAT4A;
    fX, fY, fZ: single;
begin
    Result := nil;
    if (AResult = nil) then
        Exit;



    XMStoreFloat4A(dv, dir);

    fX := dv.x;
    fY := dv.y;
    fZ := dv.z;

    case (order) of

        2:
        begin
            sh_eval_basis_1(fX, fY, fZ, AResult);
        end;

        3:
        begin
            sh_eval_basis_2(fX, fY, fZ, AResult);
        end;

        4:
        begin
            sh_eval_basis_3(fX, fY, fZ, AResult);
        end;

        5:
        begin
            sh_eval_basis_4(fX, fY, fZ, AResult);
        end;

        6:
        begin
            sh_eval_basis_5(fX, fY, fZ, AResult);
        end;

        else
        begin
            assert((order < XM_SH_MINORDER) or (order > XM_SH_MAXORDER));
            Exit;
        end;
    end;

    Result := AResult;
end;




//-------------------------------------------------------------------------------------
// Rotates SH vector by a rotation matrix

// http://msdn.microsoft.com/en-us/library/windows/desktop/bb204992.aspx
//-------------------------------------------------------------------------------------

function XMSHRotate({var} Aresult: Psingle; order: size_t; rotMatrix: TXMMATRIX; const input: Psingle): PSingle;
var
    mat: TXMFLOAT3X3;
    mRot: array [0..3 * 3 - 1] of single;
    R: array [0..25 - 1] of single;
    iR, uBase: integer;
    r00, r01, r02, r10, r11, r12, r20, r21, r22: single;
    t41, t43, t48, t50, t55, t57, t58, t61, t63, t68, t70, t72, t74, t76, t78, v173, v577, v115, v288, v866: single;
begin
    Result := nil;
    if (Aresult = nil) or (input = nil) then
        Exit;

    if (AResult = input) then
        Exit;


    XMStoreFloat3x3(mat, rotMatrix);


    r00 := mat._11;
    mRot[0 * 3 + 0] := mat._11;
    r10 := mat._12;
    mRot[1 * 3 + 0] := mat._12;
    r20 := mat._13;
    mRot[2 * 3 + 0] := mat._13;

    r01 := mat._21;
    mRot[0 * 3 + 1] := mat._21;
    r11 := mat._22;
    mRot[1 * 3 + 1] := mat._22;
    r21 := mat._23;
    mRot[2 * 3 + 1] := mat._23;

    r02 := mat._31;
    mRot[0 * 3 + 2] := mat._31;
    r12 := mat._32;
    mRot[1 * 3 + 2] := mat._32;
    r22 := mat._33;
    mRot[2 * 3 + 2] := mat._33;

    AResult[0] := input[0]; // rotate the constant term

    case (order) of

        2:
        begin
            // do linear by hand...

            AResult[1] := r11 * input[1] - r12 * input[2] + r10 * input[3];
            AResult[2] := -r21 * input[1] + r22 * input[2] - r20 * input[3];
            AResult[3] := r01 * input[1] - r02 * input[2] + r00 * input[3];
        end;


        3:
        begin

            // do linear by hand...

            AResult[1] := r11 * input[1] - r12 * input[2] + r10 * input[3];
            AResult[2] := -r21 * input[1] + r22 * input[2] - r20 * input[3];
            AResult[3] := r01 * input[1] - r02 * input[2] + r00 * input[3];

            // direct code for quadratics is faster than ZYZ reccurence relations

            t41 := r01 * r00;
            t43 := r11 * r10;
            t48 := r11 * r12;
            t50 := r01 * r02;
            t55 := r02 * r02;
            t57 := r22 * r22;
            t58 := r12 * r12;
            t61 := r00 * r02;
            t63 := r10 * r12;
            t68 := r10 * r10;
            t70 := r01 * r01;
            t72 := r11 * r11;
            t74 := r00 * r00;
            t76 := r21 * r21;
            t78 := r20 * r20;

            v173 := 0.1732050808e1;
            v577 := 0.5773502693e0;
            v115 := 0.1154700539e1;
            v288 := 0.2886751347e0;
            v866 := 0.8660254040e0;

            R[0] := r11 * r00 + r01 * r10;
            R[1] := -r01 * r12 - r11 * r02;
            R[2] := v173 * r02 * r12;
            R[3] := -r10 * r02 - r00 * r12;
            R[4] := r00 * r10 - r01 * r11;
            R[5] := -r11 * r20 - r21 * r10;
            R[6] := r11 * r22 + r21 * r12;
            R[7] := -v173 * r22 * r12;
            R[8] := r20 * r12 + r10 * r22;
            R[9] := -r10 * r20 + r11 * r21;
            R[10] := -v577 * (t41 + t43) + v115 * r21 * r20;
            R[11] := v577 * (t48 + t50) - v115 * r21 * r22;
            R[12] := -0.5000000000e0 * (t55 + t58) + t57;
            R[13] := v577 * (t61 + t63) - v115 * r20 * r22;
            R[14] := v288 * (t70 - t68 + t72 - t74) - v577 * (t76 - t78);
            R[15] := -r01 * r20 - r21 * r00;
            R[16] := r01 * r22 + r21 * r02;
            R[17] := -v173 * r22 * r02;
            R[18] := r00 * r22 + r20 * r02;
            R[19] := -r00 * r20 + r01 * r21;
            R[20] := t41 - t43;
            R[21] := -t50 + t48;
            R[22] := v866 * (t55 - t58);
            R[23] := t63 - t61;
            R[24] := 0.5000000000e0 * (t74 - t68 - t70 + t72);

            // blow the matrix multiply out by hand, looping is ineficient on a P4...
            for iR := 0 to 4 do
            begin
                uBase := iR * 5;
                AResult[4 + iR] := R[uBase + 0] * input[4] + R[uBase + 1] * input[5] + R[uBase + 2] * input[6] +
                    R[uBase + 3] * input[7] + R[uBase + 4] * input[8];
            end;
        end;


        4:
        begin
            sh3_rot(mRot, input, AResult);
        end;

        5:
        begin
            sh4_rot(mRot, (input), AResult);
        end;

        6:
        begin
            sh5_rot(mRot, (input), AResult);
        end;

        else
        begin
            assert((order < XM_SH_MINORDER) or (order > XM_SH_MAXORDER));
            Result := nil;
            Exit;

        end;
    end;

    Result := AResult;
end;



//-------------------------------------------------------------------------------------
// Rotates the SH vector in the Z axis by an angle

// http://msdn.microsoft.com/en-us/library/windows/desktop/bb205461.aspx
//-------------------------------------------------------------------------------------

function XMSHRotateZ({var} AResult: Psingle; order: size_t; angle: single; const input: Psingle): Psingle;
var
    R: array [0..(2 * (XM_SH_MAXORDER - 1) + 1) * (2 * (XM_SH_MAXORDER - 1) + 1) - 1] of single; // used to store rotation matrices...
    ca, sa, t1, t2: single;
    j: integer;
    t3, t4, t5, t6, t7, t8, t9, t12, t13, t15: single;
    t10, t11, t14, t17, t20, t23, t21, t26, t29, t30, t35, t32, t33: single;
begin
    Result := nil;
    if (Aresult = nil) or (input = nil) then
        Exit;

    if (Result = input) then
        Exit;

    if (order < XM_SH_MINORDER) or (order > XM_SH_MAXORDER) then
        Exit;


    // these are actually very sparse matrices, most of the entries are zero's...

    ca := cos(angle);
    sa := sin(angle);

    t1 := ca;
    t2 := sa;
    R[0] := t1;
    R[1] := 0.0;
    R[2] := t2;
    R[3] := 0.0;
    R[4] := 1.0;
    R[5] := 0.0;
    R[6] := -t2;
    R[7] := 0.0;
    R[8] := t1;

    Result[0] := input[0];
    SimpMatMul(3, R, input + 1, AResult + 1);

    if (order > 2) then
    begin

        for j := 0 to 5 * 5 - 1 do R[j] := 0.0;
        t1 := sa;
        t2 := t1 * t1;
        t3 := ca;
        t4 := t3 * t3;
        t5 := -t2 + t4;
        t7 := 2.0 * t3 * t1;
        R[0] := t5;
        R[4] := t7;
        R[6] := t3;
        R[8] := t1;
        R[12] := 1.0;
        R[16] := -t1;
        R[18] := t3;
        R[20] := -t7;
        R[24] := t5;

        SimpMatMul(5, R, input + 4, AResult + 4); // un-roll matrix/vector multiply
        if (order > 3) then
        begin
            for j := 0 to 7 * 7 - 1 do R[j] := 0.0;
            t1 := ca;
            t2 := t1 * t1;
            t4 := sa;
            t5 := t4 * t4;
            t8 := t2 * t1 - 3.0 * t1 * t5;
            t12 := 3.0 * t4 * t2 - t5 * t4;
            t13 := -t5 + t2;
            t15 := 2.0 * t1 * t4;
            R[0] := t8;
            R[6] := t12;
            R[8] := t13;
            R[12] := t15;
            R[16] := t1;
            R[18] := t4;
            R[24] := 1.0;
            R[30] := -t4;
            R[32] := t1;
            R[36] := -t15;
            R[40] := t13;
            R[42] := -t12;
            R[48] := t8;
            SimpMatMul(7, R, input + 9, AResult + 9);
            if (order > 4) then
            begin
                for j := 0 to 9 * 9 do R[j] := 0.0;
                t1 := ca;
                t2 := t1 * t1;
                t3 := t2 * t2;
                t4 := sa;
                t5 := t4 * t4;
                t6 := t5 * t5;
                t9 := t3 + t6 - 6.0 * t5 * t2;
                t10 := t5 * t4;
                t12 := t2 * t1;
                t14 := -t10 * t1 + t4 * t12;
                t17 := t12 - 3.0 * t1 * t5;
                t20 := 3.0 * t4 * t2 - t10;
                t21 := -t5 + t2;
                t23 := 2.0 * t1 * t4;
                R[0] := t9;
                R[8] := 4.0 * t14;
                R[10] := t17;
                R[16] := t20;
                R[20] := t21;
                R[24] := t23;
                R[30] := t1;
                R[32] := t4;
                R[40] := 1.0;
                R[48] := -t4;
                R[50] := t1;
                R[56] := -t23;
                R[60] := t21;
                R[64] := -t20;
                R[70] := t17;
                R[72] := -4.0 * t14;
                R[80] := t9;

                SimpMatMul(9, R, input + 16, AResult + 16);
                if (order > 5) then
                begin
                    for j := 0 to 11 * 11 - 1 do R[j] := 0.0;
                    t1 := ca;
                    t2 := sa;
                    t3 := t2 * t2;
                    t4 := t3 * t3;
                    t7 := t1 * t1;
                    t8 := t7 * t1;
                    t11 := t7 * t7;
                    t13 := 5.0 * t1 * t4 - 10.0 * t3 * t8 + t11 * t1;
                    t14 := t3 * t2;
                    t20 := -10.0 * t14 * t7 + 5.0 * t2 * t11 + t4 * t2;
                    t23 := t11 + t4 - 6.0 * t3 * t7;
                    t26 := -t14 * t1 + t2 * t8;
                    t29 := t8 - 3.0 * t1 * t3;
                    t32 := 3.0 * t2 * t7 - t14;
                    t33 := -t3 + t7;
                    t35 := 2.0 * t1 * t2;
                    R[0] := t13;
                    R[10] := t20;
                    R[12] := t23;
                    R[20] := 4.0 * t26;
                    R[24] := t29;
                    R[30] := t32;
                    R[36] := t33;
                    R[40] := t35;
                    R[48] := t1;
                    R[50] := t2;
                    R[60] := 1.0;
                    R[70] := -t2;
                    R[72] := t1;
                    R[80] := -t35;
                    R[84] := t33;
                    R[90] := -t32;
                    R[96] := t29;
                    R[100] := -4.0 * t26;
                    R[108] := t23;
                    R[110] := -t20;
                    R[120] := t13;
                    SimpMatMul(11, R, input + 25, AResult + 25);
                end;
            end;
        end;
    end;

    Result := AResult;
end;


//-------------------------------------------------------------------------------------
// Adds two SH vectors, result[i] := inputA[i] + inputB[i];

// http://msdn.microsoft.com/en-us/library/windows/desktop/bb205438.aspx
//-------------------------------------------------------------------------------------

function XMSHAdd({var} AResult: Psingle; order: size_t; const inputA: Psingle; const inputB: Psingle): Psingle;
var
    numcoeff, i: size_t;
begin
    Result := nil;
    if (AResult = nil) or (inputA = nil) or (inputB = nil) then
        Exit;


    numcoeff := order * order;

    for i := 0 to numcoeff - 1 do
    begin
        AResult[i] := inputA[i] + inputB[i];
    end;

    Result := AResult;
end;


//-------------------------------------------------------------------------------------
// Scales a SH vector, result[i] := input[i] * scale;

// http://msdn.microsoft.com/en-us/library/windows/desktop/bb204994.aspx
//-------------------------------------------------------------------------------------

function XMSHScale({var} AResult: Psingle; order: size_t; const input: Psingle; scale: single): Psingle;
var
    numcoeff, i: size_t;
begin
    Result := nil;
    if (AResult = nil) or (input = nil) then
        Exit;

    numcoeff := order * order;

    for  i := 0 to numcoeff - 1 do
    begin
        AResult[i] := scale * input[i];
    end;

    Result := AResult;
end;


//-------------------------------------------------------------------------------------
// Computes the dot product of two SH vectors

// http://msdn.microsoft.com/en-us/library/windows/desktop/bb205446.aspx
//-------------------------------------------------------------------------------------

function XMSHDot(order: size_t; const inputA: Psingle; const inputB: Psingle): single;
var
    numcoeff, i: size_t;
begin
    Result := 0.0;
    if (inputA = nil) or (inputB = nil) then
        Exit;

    Result := inputA[0] * inputB[0];

    numcoeff := order * order;

    for i := 1 to numcoeff - 1 do
    begin
        Result := Result + inputA[i] * inputB[i];
    end;
end;



//-------------------------------------------------------------------------------------
// Computes the product of two functions represented using SH (f and g), where:
// result[i] := int(y_i(s) * f(s) * g(s)), where y_i(s) is the ith SH basis
// function, f(s) and g(s) are SH functions (sum_i(y_i(s)*c_i)).  The order O
// determines the lengths of the arrays, where there should always be O^2
// coefficients.  In general the product of two SH functions of order O generates
// and SH function of order 2*O - 1, but we truncate the result.  This means
// that the product commutes (f*g == g*f) but doesn't associate
// (f*(g*h) != (f*g)*h.
//-------------------------------------------------------------------------------------
function XMSHMultiply(AResult: PSingle; order: size_t; const inputF: PSingle; const inputG: PSingle): PSingle;
begin
    case (order) of
        2:
            Result := XMSHMultiply2(AResult, inputF, inputG);
        3:
            Result := XMSHMultiply3(AResult, inputF, inputG);
        4:
            Result := XMSHMultiply4(AResult, inputF, inputG);
        5:
            Result := XMSHMultiply5(AResult, inputF, inputG);
        6:
            Result := XMSHMultiply6(AResult, inputF, inputG);
        else
        begin
            assert((order < XM_SH_MINORDER) or (order > XM_SH_MAXORDER));
            Result := nil;

        end;
    end;
end;




//-------------------------------------------------------------------------------------
// http://msdn.microsoft.com/en-us/library/windows/desktop/bb205454.aspx
//-------------------------------------------------------------------------------------

function XMSHMultiply2(var y: PSingle; const f: PSingle; const g: PSingle): PSingle;
var
    tf, tg, t: single;
begin
    Result := nil;
    if (y = nil) or (f = nil) or (g = nil) then
        Exit;

    // [0,0]: 0,
    y[0] := (0.282094792935999980) * f[0] * g[0];

    // [1,1]: 0,
    tf := (0.282094791773000010) * f[0];
    tg := (0.282094791773000010) * g[0];
    y[1] := tf * g[1] + tg * f[1];
    t := f[1] * g[1];
    y[0] += (0.282094791773000010) * t;

    // [2,2]: 0,
    tf := (0.282094795249000000) * f[0];
    tg := (0.282094795249000000) * g[0];
    y[2] := tf * g[2] + tg * f[2];
    t := f[2] * g[2];
    y[0] += (0.282094795249000000) * t;

    // [3,3]: 0,
    tf := (0.282094791773000010) * f[0];
    tg := (0.282094791773000010) * g[0];
    y[3] := tf * g[3] + tg * f[3];
    t := f[3] * g[3];
    y[0] += (0.282094791773000010) * t;

    // multiply count:=20

    Result := y;
end;


//-------------------------------------------------------------------------------------
// http://msdn.microsoft.com/en-us/library/windows/desktop/bb232906.aspx
//-------------------------------------------------------------------------------------
function XMSHMultiply3(var y: PSingle; const f: PSingle; const g: PSingle): PSingle;
var
    tf, tg, t: single;
begin
    Result := nil;
    if (y = nil) or (f = nil) or (g = nil) then
        Exit;


    // [0,0]: 0,
    y[0] := (0.282094792935999980) * f[0] * g[0];

    // [1,1]: 0,6,8,
    tf := (0.282094791773000010) * f[0] + (-0.126156626101000010) * f[6] + (-0.218509686119999990) * f[8];
    tg := (0.282094791773000010) * g[0] + (-0.126156626101000010) * g[6] + (-0.218509686119999990) * g[8];
    y[1] := tf * g[1] + tg * f[1];
    t := f[1] * g[1];
    y[0] += (0.282094791773000010) * t;
    y[6] := (-0.126156626101000010) * t;
    y[8] := (-0.218509686119999990) * t;

    // [1,2]: 5,
    tf := (0.218509686118000010) * f[5];
    tg := (0.218509686118000010) * g[5];
    y[1] += tf * g[2] + tg * f[2];
    y[2] := tf * g[1] + tg * f[1];
    t := f[1] * g[2] + f[2] * g[1];
    y[5] := (0.218509686118000010) * t;

    // [1,3]: 4,
    tf := (0.218509686114999990) * f[4];
    tg := (0.218509686114999990) * g[4];
    y[1] += tf * g[3] + tg * f[3];
    y[3] := tf * g[1] + tg * f[1];
    t := f[1] * g[3] + f[3] * g[1];
    y[4] := (0.218509686114999990) * t;

    // [2,2]: 0,6,
    tf := (0.282094795249000000) * f[0] + (0.252313259986999990) * f[6];
    tg := (0.282094795249000000) * g[0] + (0.252313259986999990) * g[6];
    y[2] += tf * g[2] + tg * f[2];
    t := f[2] * g[2];
    y[0] += (0.282094795249000000) * t;
    y[6] += (0.252313259986999990) * t;

    // [2,3]: 7,
    tf := (0.218509686118000010) * f[7];
    tg := (0.218509686118000010) * g[7];
    y[2] += tf * g[3] + tg * f[3];
    y[3] += tf * g[2] + tg * f[2];
    t := f[2] * g[3] + f[3] * g[2];
    y[7] := (0.218509686118000010) * t;

    // [3,3]: 0,6,8,
    tf := (0.282094791773000010) * f[0] + (-0.126156626101000010) * f[6] + (0.218509686119999990) * f[8];
    tg := (0.282094791773000010) * g[0] + (-0.126156626101000010) * g[6] + (0.218509686119999990) * g[8];
    y[3] += tf * g[3] + tg * f[3];
    t := f[3] * g[3];
    y[0] += (0.282094791773000010) * t;
    y[6] += (-0.126156626101000010) * t;
    y[8] += (0.218509686119999990) * t;

    // [4,4]: 0,6,
    tf := (0.282094791770000020) * f[0] + (-0.180223751576000010) * f[6];
    tg := (0.282094791770000020) * g[0] + (-0.180223751576000010) * g[6];
    y[4] += tf * g[4] + tg * f[4];
    t := f[4] * g[4];
    y[0] += (0.282094791770000020) * t;
    y[6] += (-0.180223751576000010) * t;

    // [4,5]: 7,
    tf := (0.156078347226000000) * f[7];
    tg := (0.156078347226000000) * g[7];
    y[4] += tf * g[5] + tg * f[5];
    y[5] += tf * g[4] + tg * f[4];
    t := f[4] * g[5] + f[5] * g[4];
    y[7] += (0.156078347226000000) * t;

    // [5,5]: 0,6,8,
    tf := (0.282094791773999990) * f[0] + (0.090111875786499998) * f[6] + (-0.156078347227999990) * f[8];
    tg := (0.282094791773999990) * g[0] + (0.090111875786499998) * g[6] + (-0.156078347227999990) * g[8];
    y[5] += tf * g[5] + tg * f[5];
    t := f[5] * g[5];
    y[0] += (0.282094791773999990) * t;
    y[6] += (0.090111875786499998) * t;
    y[8] += (-0.156078347227999990) * t;

    // [6,6]: 0,6,
    tf := (0.282094797560000000) * f[0];
    tg := (0.282094797560000000) * g[0];
    y[6] += tf * g[6] + tg * f[6];
    t := f[6] * g[6];
    y[0] += (0.282094797560000000) * t;
    y[6] += (0.180223764527000010) * t;

    // [7,7]: 0,6,8,
    tf := (0.282094791773999990) * f[0] + (0.090111875786499998) * f[6] + (0.156078347227999990) * f[8];
    tg := (0.282094791773999990) * g[0] + (0.090111875786499998) * g[6] + (0.156078347227999990) * g[8];
    y[7] += tf * g[7] + tg * f[7];
    t := f[7] * g[7];
    y[0] += (0.282094791773999990) * t;
    y[6] += (0.090111875786499998) * t;
    y[8] += (0.156078347227999990) * t;

    // [8,8]: 0,6,
    tf := (0.282094791770000020) * f[0] + (-0.180223751576000010) * f[6];
    tg := (0.282094791770000020) * g[0] + (-0.180223751576000010) * g[6];
    y[8] += tf * g[8] + tg * f[8];
    t := f[8] * g[8];
    y[0] += (0.282094791770000020) * t;
    y[6] += (-0.180223751576000010) * t;

    // multiply count:=120

    Result := y;
end;


//-------------------------------------------------------------------------------------
// http://msdn.microsoft.com/en-us/library/windows/desktop/bb232907.aspx
//-------------------------------------------------------------------------------------
function XMSHMultiply4(var y: PSingle; const f: PSingle; const g: PSingle): PSingle;
var
    tf, tg, t: single;
begin
    Result := nil;
    if (y = nil) or (f = nil) or (g = nil) then
        exit;



    // [0,0]: 0,
    y[0] := (0.282094792935999980) * f[0] * g[0];

    // [1,1]: 0,6,8,
    tf := (0.282094791773000010) * f[0] + (-0.126156626101000010) * f[6] + (-0.218509686119999990) * f[8];
    tg := (0.282094791773000010) * g[0] + (-0.126156626101000010) * g[6] + (-0.218509686119999990) * g[8];
    y[1] := tf * g[1] + tg * f[1];
    t := f[1] * g[1];
    y[0] += (0.282094791773000010) * t;
    y[6] := (-0.126156626101000010) * t;
    y[8] := (-0.218509686119999990) * t;

    // [1,4]: 3,13,15,
    tf := (0.218509686114999990) * f[3] + (-0.058399170082300000) * f[13] + (-0.226179013157999990) * f[15];
    tg := (0.218509686114999990) * g[3] + (-0.058399170082300000) * g[13] + (-0.226179013157999990) * g[15];
    y[1] += tf * g[4] + tg * f[4];
    y[4] := tf * g[1] + tg * f[1];
    t := f[1] * g[4] + f[4] * g[1];
    y[3] := (0.218509686114999990) * t;
    y[13] := (-0.058399170082300000) * t;
    y[15] := (-0.226179013157999990) * t;

    // [1,5]: 2,12,14,
    tf := (0.218509686118000010) * f[2] + (-0.143048168103000000) * f[12] + (-0.184674390923000000) * f[14];
    tg := (0.218509686118000010) * g[2] + (-0.143048168103000000) * g[12] + (-0.184674390923000000) * g[14];
    y[1] += tf * g[5] + tg * f[5];
    y[5] := tf * g[1] + tg * f[1];
    t := f[1] * g[5] + f[5] * g[1];
    y[2] := (0.218509686118000010) * t;
    y[12] := (-0.143048168103000000) * t;
    y[14] := (-0.184674390923000000) * t;

    // [1,6]: 11,
    tf := (0.202300659402999990) * f[11];
    tg := (0.202300659402999990) * g[11];
    y[1] += tf * g[6] + tg * f[6];
    y[6] += tf * g[1] + tg * f[1];
    t := f[1] * g[6] + f[6] * g[1];
    y[11] := (0.202300659402999990) * t;

    // [1,8]: 9,11,
    tf := (0.226179013155000000) * f[9] + (0.058399170081799998) * f[11];
    tg := (0.226179013155000000) * g[9] + (0.058399170081799998) * g[11];
    y[1] += tf * g[8] + tg * f[8];
    y[8] += tf * g[1] + tg * f[1];
    t := f[1] * g[8] + f[8] * g[1];
    y[9] := (0.226179013155000000) * t;
    y[11] += (0.058399170081799998) * t;

    // [2,2]: 0,6,
    tf := (0.282094795249000000) * f[0] + (0.252313259986999990) * f[6];
    tg := (0.282094795249000000) * g[0] + (0.252313259986999990) * g[6];
    y[2] += tf * g[2] + tg * f[2];
    t := f[2] * g[2];
    y[0] += (0.282094795249000000) * t;
    y[6] += (0.252313259986999990) * t;

    // [2,6]: 12,
    tf := (0.247766706973999990) * f[12];
    tg := (0.247766706973999990) * g[12];
    y[2] += tf * g[6] + tg * f[6];
    y[6] += tf * g[2] + tg * f[2];
    t := f[2] * g[6] + f[6] * g[2];
    y[12] += (0.247766706973999990) * t;

    // [3,3]: 0,6,8,
    tf := (0.282094791773000010) * f[0] + (-0.126156626101000010) * f[6] + (0.218509686119999990) * f[8];
    tg := (0.282094791773000010) * g[0] + (-0.126156626101000010) * g[6] + (0.218509686119999990) * g[8];
    y[3] += tf * g[3] + tg * f[3];
    t := f[3] * g[3];
    y[0] += (0.282094791773000010) * t;
    y[6] += (-0.126156626101000010) * t;
    y[8] += (0.218509686119999990) * t;

    // [3,6]: 13,
    tf := (0.202300659402999990) * f[13];
    tg := (0.202300659402999990) * g[13];
    y[3] += tf * g[6] + tg * f[6];
    y[6] += tf * g[3] + tg * f[3];
    t := f[3] * g[6] + f[6] * g[3];
    y[13] += (0.202300659402999990) * t;

    // [3,7]: 2,12,14,
    tf := (0.218509686118000010) * f[2] + (-0.143048168103000000) * f[12] + (0.184674390923000000) * f[14];
    tg := (0.218509686118000010) * g[2] + (-0.143048168103000000) * g[12] + (0.184674390923000000) * g[14];
    y[3] += tf * g[7] + tg * f[7];
    y[7] := tf * g[3] + tg * f[3];
    t := f[3] * g[7] + f[7] * g[3];
    y[2] += (0.218509686118000010) * t;
    y[12] += (-0.143048168103000000) * t;
    y[14] += (0.184674390923000000) * t;

    // [3,8]: 13,15,
    tf := (-0.058399170081799998) * f[13] + (0.226179013155000000) * f[15];
    tg := (-0.058399170081799998) * g[13] + (0.226179013155000000) * g[15];
    y[3] += tf * g[8] + tg * f[8];
    y[8] += tf * g[3] + tg * f[3];
    t := f[3] * g[8] + f[8] * g[3];
    y[13] += (-0.058399170081799998) * t;
    y[15] += (0.226179013155000000) * t;

    // [4,4]: 0,6,
    tf := (0.282094791770000020) * f[0] + (-0.180223751576000010) * f[6];
    tg := (0.282094791770000020) * g[0] + (-0.180223751576000010) * g[6];
    y[4] += tf * g[4] + tg * f[4];
    t := f[4] * g[4];
    y[0] += (0.282094791770000020) * t;
    y[6] += (-0.180223751576000010) * t;

    // [4,5]: 7,
    tf := (0.156078347226000000) * f[7];
    tg := (0.156078347226000000) * g[7];
    y[4] += tf * g[5] + tg * f[5];
    y[5] += tf * g[4] + tg * f[4];
    t := f[4] * g[5] + f[5] * g[4];
    y[7] += (0.156078347226000000) * t;

    // [4,9]: 3,13,
    tf := (0.226179013157999990) * f[3] + (-0.094031597258400004) * f[13];
    tg := (0.226179013157999990) * g[3] + (-0.094031597258400004) * g[13];
    y[4] += tf * g[9] + tg * f[9];
    y[9] += tf * g[4] + tg * f[4];
    t := f[4] * g[9] + f[9] * g[4];
    y[3] += (0.226179013157999990) * t;
    y[13] += (-0.094031597258400004) * t;

    // [4,10]: 2,12,
    tf := (0.184674390919999990) * f[2] + (-0.188063194517999990) * f[12];
    tg := (0.184674390919999990) * g[2] + (-0.188063194517999990) * g[12];
    y[4] += tf * g[10] + tg * f[10];
    y[10] := tf * g[4] + tg * f[4];
    t := f[4] * g[10] + f[10] * g[4];
    y[2] += (0.184674390919999990) * t;
    y[12] += (-0.188063194517999990) * t;

    // [4,11]: 3,13,15,
    tf := (-0.058399170082300000) * f[3] + (0.145673124078000010) * f[13] + (0.094031597258400004) * f[15];
    tg := (-0.058399170082300000) * g[3] + (0.145673124078000010) * g[13] + (0.094031597258400004) * g[15];
    y[4] += tf * g[11] + tg * f[11];
    y[11] += tf * g[4] + tg * f[4];
    t := f[4] * g[11] + f[11] * g[4];
    y[3] += (-0.058399170082300000) * t;
    y[13] += (0.145673124078000010) * t;
    y[15] += (0.094031597258400004) * t;

    // [5,5]: 0,6,8,
    tf := (0.282094791773999990) * f[0] + (0.090111875786499998) * f[6] + (-0.156078347227999990) * f[8];
    tg := (0.282094791773999990) * g[0] + (0.090111875786499998) * g[6] + (-0.156078347227999990) * g[8];
    y[5] += tf * g[5] + tg * f[5];
    t := f[5] * g[5];
    y[0] += (0.282094791773999990) * t;
    y[6] += (0.090111875786499998) * t;
    y[8] += (-0.156078347227999990) * t;

    // [5,9]: 14,
    tf := (0.148677009677999990) * f[14];
    tg := (0.148677009677999990) * g[14];
    y[5] += tf * g[9] + tg * f[9];
    y[9] += tf * g[5] + tg * f[5];
    t := f[5] * g[9] + f[9] * g[5];
    y[14] += (0.148677009677999990) * t;

    // [5,10]: 3,13,15,
    tf := (0.184674390919999990) * f[3] + (0.115164716490000000) * f[13] + (-0.148677009678999990) * f[15];
    tg := (0.184674390919999990) * g[3] + (0.115164716490000000) * g[13] + (-0.148677009678999990) * g[15];
    y[5] += tf * g[10] + tg * f[10];
    y[10] += tf * g[5] + tg * f[5];
    t := f[5] * g[10] + f[10] * g[5];
    y[3] += (0.184674390919999990) * t;
    y[13] += (0.115164716490000000) * t;
    y[15] += (-0.148677009678999990) * t;

    // [5,11]: 2,12,14,
    tf := (0.233596680327000010) * f[2] + (0.059470803871800003) * f[12] + (-0.115164716491000000) * f[14];
    tg := (0.233596680327000010) * g[2] + (0.059470803871800003) * g[12] + (-0.115164716491000000) * g[14];
    y[5] += tf * g[11] + tg * f[11];
    y[11] += tf * g[5] + tg * f[5];
    t := f[5] * g[11] + f[11] * g[5];
    y[2] += (0.233596680327000010) * t;
    y[12] += (0.059470803871800003) * t;
    y[14] += (-0.115164716491000000) * t;

    // [6,6]: 0,6,
    tf := (0.282094797560000000) * f[0];
    tg := (0.282094797560000000) * g[0];
    y[6] += tf * g[6] + tg * f[6];
    t := f[6] * g[6];
    y[0] += (0.282094797560000000) * t;
    y[6] += (0.180223764527000010) * t;

    // [7,7]: 6,0,8,
    tf := (0.090111875786499998) * f[6] + (0.282094791773999990) * f[0] + (0.156078347227999990) * f[8];
    tg := (0.090111875786499998) * g[6] + (0.282094791773999990) * g[0] + (0.156078347227999990) * g[8];
    y[7] += tf * g[7] + tg * f[7];
    t := f[7] * g[7];
    y[6] += (0.090111875786499998) * t;
    y[0] += (0.282094791773999990) * t;
    y[8] += (0.156078347227999990) * t;

    // [7,10]: 9,1,11,
    tf := (0.148677009678999990) * f[9] + (0.184674390919999990) * f[1] + (0.115164716490000000) * f[11];
    tg := (0.148677009678999990) * g[9] + (0.184674390919999990) * g[1] + (0.115164716490000000) * g[11];
    y[7] += tf * g[10] + tg * f[10];
    y[10] += tf * g[7] + tg * f[7];
    t := f[7] * g[10] + f[10] * g[7];
    y[9] += (0.148677009678999990) * t;
    y[1] += (0.184674390919999990) * t;
    y[11] += (0.115164716490000000) * t;

    // [7,13]: 12,2,14,
    tf := (0.059470803871800003) * f[12] + (0.233596680327000010) * f[2] + (0.115164716491000000) * f[14];
    tg := (0.059470803871800003) * g[12] + (0.233596680327000010) * g[2] + (0.115164716491000000) * g[14];
    y[7] += tf * g[13] + tg * f[13];
    y[13] += tf * g[7] + tg * f[7];
    t := f[7] * g[13] + f[13] * g[7];
    y[12] += (0.059470803871800003) * t;
    y[2] += (0.233596680327000010) * t;
    y[14] += (0.115164716491000000) * t;

    // [7,14]: 15,
    tf := (0.148677009677999990) * f[15];
    tg := (0.148677009677999990) * g[15];
    y[7] += tf * g[14] + tg * f[14];
    y[14] += tf * g[7] + tg * f[7];
    t := f[7] * g[14] + f[14] * g[7];
    y[15] += (0.148677009677999990) * t;

    // [8,8]: 0,6,
    tf := (0.282094791770000020) * f[0] + (-0.180223751576000010) * f[6];
    tg := (0.282094791770000020) * g[0] + (-0.180223751576000010) * g[6];
    y[8] += tf * g[8] + tg * f[8];
    t := f[8] * g[8];
    y[0] += (0.282094791770000020) * t;
    y[6] += (-0.180223751576000010) * t;

    // [8,9]: 11,
    tf := (-0.094031597259499999) * f[11];
    tg := (-0.094031597259499999) * g[11];
    y[8] += tf * g[9] + tg * f[9];
    y[9] += tf * g[8] + tg * f[8];
    t := f[8] * g[9] + f[9] * g[8];
    y[11] += (-0.094031597259499999) * t;

    // [8,13]: 15,
    tf := (-0.094031597259499999) * f[15];
    tg := (-0.094031597259499999) * g[15];
    y[8] += tf * g[13] + tg * f[13];
    y[13] += tf * g[8] + tg * f[8];
    t := f[8] * g[13] + f[13] * g[8];
    y[15] += (-0.094031597259499999) * t;

    // [8,14]: 2,12,
    tf := (0.184674390919999990) * f[2] + (-0.188063194517999990) * f[12];
    tg := (0.184674390919999990) * g[2] + (-0.188063194517999990) * g[12];
    y[8] += tf * g[14] + tg * f[14];
    y[14] += tf * g[8] + tg * f[8];
    t := f[8] * g[14] + f[14] * g[8];
    y[2] += (0.184674390919999990) * t;
    y[12] += (-0.188063194517999990) * t;

    // [9,9]: 6,0,
    tf := (-0.210261043508000010) * f[6] + (0.282094791766999970) * f[0];
    tg := (-0.210261043508000010) * g[6] + (0.282094791766999970) * g[0];
    y[9] += tf * g[9] + tg * f[9];
    t := f[9] * g[9];
    y[6] += (-0.210261043508000010) * t;
    y[0] += (0.282094791766999970) * t;

    // [10,10]: 0,
    tf := (0.282094791771999980) * f[0];
    tg := (0.282094791771999980) * g[0];
    y[10] += tf * g[10] + tg * f[10];
    t := f[10] * g[10];
    y[0] += (0.282094791771999980) * t;

    // [11,11]: 0,6,8,
    tf := (0.282094791773999990) * f[0] + (0.126156626101000010) * f[6] + (-0.145673124078999990) * f[8];
    tg := (0.282094791773999990) * g[0] + (0.126156626101000010) * g[6] + (-0.145673124078999990) * g[8];
    y[11] += tf * g[11] + tg * f[11];
    t := f[11] * g[11];
    y[0] += (0.282094791773999990) * t;
    y[6] += (0.126156626101000010) * t;
    y[8] += (-0.145673124078999990) * t;

    // [12,12]: 0,6,
    tf := (0.282094799871999980) * f[0] + (0.168208852954000010) * f[6];
    tg := (0.282094799871999980) * g[0] + (0.168208852954000010) * g[6];
    y[12] += tf * g[12] + tg * f[12];
    t := f[12] * g[12];
    y[0] += (0.282094799871999980) * t;
    y[6] += (0.168208852954000010) * t;

    // [13,13]: 0,8,6,
    tf := (0.282094791773999990) * f[0] + (0.145673124078999990) * f[8] + (0.126156626101000010) * f[6];
    tg := (0.282094791773999990) * g[0] + (0.145673124078999990) * g[8] + (0.126156626101000010) * g[6];
    y[13] += tf * g[13] + tg * f[13];
    t := f[13] * g[13];
    y[0] += (0.282094791773999990) * t;
    y[8] += (0.145673124078999990) * t;
    y[6] += (0.126156626101000010) * t;

    // [14,14]: 0,
    tf := (0.282094791771999980) * f[0];
    tg := (0.282094791771999980) * g[0];
    y[14] += tf * g[14] + tg * f[14];
    t := f[14] * g[14];
    y[0] += (0.282094791771999980) * t;

    // [15,15]: 0,6,
    tf := (0.282094791766999970) * f[0] + (-0.210261043508000010) * f[6];
    tg := (0.282094791766999970) * g[0] + (-0.210261043508000010) * g[6];
    y[15] += tf * g[15] + tg * f[15];
    t := f[15] * g[15];
    y[0] += (0.282094791766999970) * t;
    y[6] += (-0.210261043508000010) * t;

    // multiply count:=399

    Result := y;
end;




//-------------------------------------------------------------------------------------
// http://msdn.microsoft.com/en-us/library/windows/desktop/bb232908.aspx
//-------------------------------------------------------------------------------------
function XMSHMultiply5(var y: PSingle; const f: PSingle; const g: PSingle): PSingle;
var
    tf, tg, t: single;
begin
    Result := nil;
    if ((y = nil) or (f = nil) or (g = nil)) then
        Exit;


    // [0,0]: 0,
    y[0] := (0.282094792935999980) * f[0] * g[0];

    // [1,1]: 0,6,8,
    tf := (0.282094791773000010) * f[0] + (-0.126156626101000010) * f[6] + (-0.218509686119999990) * f[8];
    tg := (0.282094791773000010) * g[0] + (-0.126156626101000010) * g[6] + (-0.218509686119999990) * g[8];
    y[1] := tf * g[1] + tg * f[1];
    t := f[1] * g[1];
    y[0] += (0.282094791773000010) * t;
    y[6] := (-0.126156626101000010) * t;
    y[8] := (-0.218509686119999990) * t;

    // [1,4]: 3,13,15,
    tf := (0.218509686114999990) * f[3] + (-0.058399170082300000) * f[13] + (-0.226179013157999990) * f[15];
    tg := (0.218509686114999990) * g[3] + (-0.058399170082300000) * g[13] + (-0.226179013157999990) * g[15];
    y[1] += tf * g[4] + tg * f[4];
    y[4] := tf * g[1] + tg * f[1];
    t := f[1] * g[4] + f[4] * g[1];
    y[3] := (0.218509686114999990) * t;
    y[13] := (-0.058399170082300000) * t;
    y[15] := (-0.226179013157999990) * t;

    // [1,5]: 2,12,14,
    tf := (0.218509686118000010) * f[2] + (-0.143048168103000000) * f[12] + (-0.184674390923000000) * f[14];
    tg := (0.218509686118000010) * g[2] + (-0.143048168103000000) * g[12] + (-0.184674390923000000) * g[14];
    y[1] += tf * g[5] + tg * f[5];
    y[5] := tf * g[1] + tg * f[1];
    t := f[1] * g[5] + f[5] * g[1];
    y[2] := (0.218509686118000010) * t;
    y[12] := (-0.143048168103000000) * t;
    y[14] := (-0.184674390923000000) * t;

    // [1,9]: 8,22,24,
    tf := (0.226179013155000000) * f[8] + (-0.043528171378199997) * f[22] + (-0.230329432978999990) * f[24];
    tg := (0.226179013155000000) * g[8] + (-0.043528171378199997) * g[22] + (-0.230329432978999990) * g[24];
    y[1] += tf * g[9] + tg * f[9];
    y[9] := tf * g[1] + tg * f[1];
    t := f[1] * g[9] + f[9] * g[1];
    y[8] += (0.226179013155000000) * t;
    y[22] := (-0.043528171378199997) * t;
    y[24] := (-0.230329432978999990) * t;

    // [1,10]: 7,21,23,
    tf := (0.184674390919999990) * f[7] + (-0.075393004386799994) * f[21] + (-0.199471140200000010) * f[23];
    tg := (0.184674390919999990) * g[7] + (-0.075393004386799994) * g[21] + (-0.199471140200000010) * g[23];
    y[1] += tf * g[10] + tg * f[10];
    y[10] := tf * g[1] + tg * f[1];
    t := f[1] * g[10] + f[10] * g[1];
    y[7] := (0.184674390919999990) * t;
    y[21] := (-0.075393004386799994) * t;
    y[23] := (-0.199471140200000010) * t;

    // [1,11]: 6,8,20,22,
    tf := (0.202300659402999990) * f[6] + (0.058399170081799998) * f[8] + (-0.150786008773000000) * f[20] + (-0.168583882836999990) * f[22];
    tg := (0.202300659402999990) * g[6] + (0.058399170081799998) * g[8] + (-0.150786008773000000) * g[20] + (-0.168583882836999990) * g[22];
    y[1] += tf * g[11] + tg * f[11];
    y[11] := tf * g[1] + tg * f[1];
    t := f[1] * g[11] + f[11] * g[1];
    y[6] += (0.202300659402999990) * t;
    y[8] += (0.058399170081799998) * t;
    y[20] := (-0.150786008773000000) * t;
    y[22] += (-0.168583882836999990) * t;

    // [1,12]: 19,
    tf := (0.194663900273000010) * f[19];
    tg := (0.194663900273000010) * g[19];
    y[1] += tf * g[12] + tg * f[12];
    y[12] += tf * g[1] + tg * f[1];
    t := f[1] * g[12] + f[12] * g[1];
    y[19] := (0.194663900273000010) * t;

    // [1,13]: 18,
    tf := (0.168583882834000000) * f[18];
    tg := (0.168583882834000000) * g[18];
    y[1] += tf * g[13] + tg * f[13];
    y[13] += tf * g[1] + tg * f[1];
    t := f[1] * g[13] + f[13] * g[1];
    y[18] := (0.168583882834000000) * t;

    // [1,14]: 17,19,
    tf := (0.199471140196999990) * f[17] + (0.075393004386399995) * f[19];
    tg := (0.199471140196999990) * g[17] + (0.075393004386399995) * g[19];
    y[1] += tf * g[14] + tg * f[14];
    y[14] += tf * g[1] + tg * f[1];
    t := f[1] * g[14] + f[14] * g[1];
    y[17] := (0.199471140196999990) * t;
    y[19] += (0.075393004386399995) * t;

    // [1,15]: 16,18,
    tf := (0.230329432973999990) * f[16] + (0.043528171377799997) * f[18];
    tg := (0.230329432973999990) * g[16] + (0.043528171377799997) * g[18];
    y[1] += tf * g[15] + tg * f[15];
    y[15] += tf * g[1] + tg * f[1];
    t := f[1] * g[15] + f[15] * g[1];
    y[16] := (0.230329432973999990) * t;
    y[18] += (0.043528171377799997) * t;

    // [2,2]: 0,6,
    tf := (0.282094795249000000) * f[0] + (0.252313259986999990) * f[6];
    tg := (0.282094795249000000) * g[0] + (0.252313259986999990) * g[6];
    y[2] += tf * g[2] + tg * f[2];
    t := f[2] * g[2];
    y[0] += (0.282094795249000000) * t;
    y[6] += (0.252313259986999990) * t;

    // [2,10]: 4,18,
    tf := (0.184674390919999990) * f[4] + (0.213243618621000000) * f[18];
    tg := (0.184674390919999990) * g[4] + (0.213243618621000000) * g[18];
    y[2] += tf * g[10] + tg * f[10];
    y[10] += tf * g[2] + tg * f[2];
    t := f[2] * g[10] + f[10] * g[2];
    y[4] += (0.184674390919999990) * t;
    y[18] += (0.213243618621000000) * t;

    // [2,12]: 6,20,
    tf := (0.247766706973999990) * f[6] + (0.246232537174000010) * f[20];
    tg := (0.247766706973999990) * g[6] + (0.246232537174000010) * g[20];
    y[2] += tf * g[12] + tg * f[12];
    y[12] += tf * g[2] + tg * f[2];
    t := f[2] * g[12] + f[12] * g[2];
    y[6] += (0.247766706973999990) * t;
    y[20] += (0.246232537174000010) * t;

    // [2,14]: 8,22,
    tf := (0.184674390919999990) * f[8] + (0.213243618621000000) * f[22];
    tg := (0.184674390919999990) * g[8] + (0.213243618621000000) * g[22];
    y[2] += tf * g[14] + tg * f[14];
    y[14] += tf * g[2] + tg * f[2];
    t := f[2] * g[14] + f[14] * g[2];
    y[8] += (0.184674390919999990) * t;
    y[22] += (0.213243618621000000) * t;

    // [3,3]: 0,6,8,
    tf := (0.282094791773000010) * f[0] + (-0.126156626101000010) * f[6] + (0.218509686119999990) * f[8];
    tg := (0.282094791773000010) * g[0] + (-0.126156626101000010) * g[6] + (0.218509686119999990) * g[8];
    y[3] += tf * g[3] + tg * f[3];
    t := f[3] * g[3];
    y[0] += (0.282094791773000010) * t;
    y[6] += (-0.126156626101000010) * t;
    y[8] += (0.218509686119999990) * t;

    // [3,7]: 2,12,14,
    tf := (0.218509686118000010) * f[2] + (-0.143048168103000000) * f[12] + (0.184674390923000000) * f[14];
    tg := (0.218509686118000010) * g[2] + (-0.143048168103000000) * g[12] + (0.184674390923000000) * g[14];
    y[3] += tf * g[7] + tg * f[7];
    y[7] += tf * g[3] + tg * f[3];
    t := f[3] * g[7] + f[7] * g[3];
    y[2] += (0.218509686118000010) * t;
    y[12] += (-0.143048168103000000) * t;
    y[14] += (0.184674390923000000) * t;

    // [3,9]: 4,16,18,
    tf := (0.226179013157999990) * f[4] + (0.230329432973999990) * f[16] + (-0.043528171377799997) * f[18];
    tg := (0.226179013157999990) * g[4] + (0.230329432973999990) * g[16] + (-0.043528171377799997) * g[18];
    y[3] += tf * g[9] + tg * f[9];
    y[9] += tf * g[3] + tg * f[3];
    t := f[3] * g[9] + f[9] * g[3];
    y[4] += (0.226179013157999990) * t;
    y[16] += (0.230329432973999990) * t;
    y[18] += (-0.043528171377799997) * t;

    // [3,10]: 5,17,19,
    tf := (0.184674390919999990) * f[5] + (0.199471140200000010) * f[17] + (-0.075393004386799994) * f[19];
    tg := (0.184674390919999990) * g[5] + (0.199471140200000010) * g[17] + (-0.075393004386799994) * g[19];
    y[3] += tf * g[10] + tg * f[10];
    y[10] += tf * g[3] + tg * f[3];
    t := f[3] * g[10] + f[10] * g[3];
    y[5] += (0.184674390919999990) * t;
    y[17] += (0.199471140200000010) * t;
    y[19] += (-0.075393004386799994) * t;

    // [3,12]: 21,
    tf := (0.194663900273000010) * f[21];
    tg := (0.194663900273000010) * g[21];
    y[3] += tf * g[12] + tg * f[12];
    y[12] += tf * g[3] + tg * f[3];
    t := f[3] * g[12] + f[12] * g[3];
    y[21] += (0.194663900273000010) * t;

    // [3,13]: 8,6,20,22,
    tf := (-0.058399170081799998) * f[8] + (0.202300659402999990) * f[6] + (-0.150786008773000000) * f[20] + (0.168583882836999990) * f[22];
    tg := (-0.058399170081799998) * g[8] + (0.202300659402999990) * g[6] + (-0.150786008773000000) * g[20] + (0.168583882836999990) * g[22];
    y[3] += tf * g[13] + tg * f[13];
    y[13] += tf * g[3] + tg * f[3];
    t := f[3] * g[13] + f[13] * g[3];
    y[8] += (-0.058399170081799998) * t;
    y[6] += (0.202300659402999990) * t;
    y[20] += (-0.150786008773000000) * t;
    y[22] += (0.168583882836999990) * t;

    // [3,14]: 21,23,
    tf := (-0.075393004386399995) * f[21] + (0.199471140196999990) * f[23];
    tg := (-0.075393004386399995) * g[21] + (0.199471140196999990) * g[23];
    y[3] += tf * g[14] + tg * f[14];
    y[14] += tf * g[3] + tg * f[3];
    t := f[3] * g[14] + f[14] * g[3];
    y[21] += (-0.075393004386399995) * t;
    y[23] += (0.199471140196999990) * t;

    // [3,15]: 8,22,24,
    tf := (0.226179013155000000) * f[8] + (-0.043528171378199997) * f[22] + (0.230329432978999990) * f[24];
    tg := (0.226179013155000000) * g[8] + (-0.043528171378199997) * g[22] + (0.230329432978999990) * g[24];
    y[3] += tf * g[15] + tg * f[15];
    y[15] += tf * g[3] + tg * f[3];
    t := f[3] * g[15] + f[15] * g[3];
    y[8] += (0.226179013155000000) * t;
    y[22] += (-0.043528171378199997) * t;
    y[24] += (0.230329432978999990) * t;

    // [4,4]: 0,6,20,24,
    tf := (0.282094791770000020) * f[0] + (-0.180223751576000010) * f[6] + (0.040299255967500003) * f[20] + (-0.238413613505999990) * f[24];
    tg := (0.282094791770000020) * g[0] + (-0.180223751576000010) * g[6] + (0.040299255967500003) * g[20] + (-0.238413613505999990) * g[24];
    y[4] += tf * g[4] + tg * f[4];
    t := f[4] * g[4];
    y[0] += (0.282094791770000020) * t;
    y[6] += (-0.180223751576000010) * t;
    y[20] += (0.040299255967500003) * t;
    y[24] += (-0.238413613505999990) * t;

    // [4,5]: 7,21,23,
    tf := (0.156078347226000000) * f[7] + (-0.063718718434399996) * f[21] + (-0.168583882835000000) * f[23];
    tg := (0.156078347226000000) * g[7] + (-0.063718718434399996) * g[21] + (-0.168583882835000000) * g[23];
    y[4] += tf * g[5] + tg * f[5];
    y[5] += tf * g[4] + tg * f[4];
    t := f[4] * g[5] + f[5] * g[4];
    y[7] += (0.156078347226000000) * t;
    y[21] += (-0.063718718434399996) * t;
    y[23] += (-0.168583882835000000) * t;

    // [4,11]: 3,13,15,
    tf := (-0.058399170082300000) * f[3] + (0.145673124078000010) * f[13] + (0.094031597258400004) * f[15];
    tg := (-0.058399170082300000) * g[3] + (0.145673124078000010) * g[13] + (0.094031597258400004) * g[15];
    y[4] += tf * g[11] + tg * f[11];
    y[11] += tf * g[4] + tg * f[4];
    t := f[4] * g[11] + f[11] * g[4];
    y[3] += (-0.058399170082300000) * t;
    y[13] += (0.145673124078000010) * t;
    y[15] += (0.094031597258400004) * t;

    // [4,16]: 8,22,
    tf := (0.238413613494000000) * f[8] + (-0.075080816693699995) * f[22];
    tg := (0.238413613494000000) * g[8] + (-0.075080816693699995) * g[22];
    y[4] += tf * g[16] + tg * f[16];
    y[16] += tf * g[4] + tg * f[4];
    t := f[4] * g[16] + f[16] * g[4];
    y[8] += (0.238413613494000000) * t;
    y[22] += (-0.075080816693699995) * t;

    // [4,18]: 6,20,24,
    tf := (0.156078347226000000) * f[6] + (-0.190364615029000010) * f[20] + (0.075080816691500005) * f[24];
    tg := (0.156078347226000000) * g[6] + (-0.190364615029000010) * g[20] + (0.075080816691500005) * g[24];
    y[4] += tf * g[18] + tg * f[18];
    y[18] += tf * g[4] + tg * f[4];
    t := f[4] * g[18] + f[18] * g[4];
    y[6] += (0.156078347226000000) * t;
    y[20] += (-0.190364615029000010) * t;
    y[24] += (0.075080816691500005) * t;

    // [4,19]: 7,21,23,
    tf := (-0.063718718434399996) * f[7] + (0.141889406569999990) * f[21] + (0.112621225039000000) * f[23];
    tg := (-0.063718718434399996) * g[7] + (0.141889406569999990) * g[21] + (0.112621225039000000) * g[23];
    y[4] += tf * g[19] + tg * f[19];
    y[19] += tf * g[4] + tg * f[4];
    t := f[4] * g[19] + f[19] * g[4];
    y[7] += (-0.063718718434399996) * t;
    y[21] += (0.141889406569999990) * t;
    y[23] += (0.112621225039000000) * t;

    // [5,5]: 0,6,8,20,22,
    tf := (0.282094791773999990) * f[0] + (0.090111875786499998) * f[6] + (-0.156078347227999990) * f[8] +
        (-0.161197023870999990) * f[20] + (-0.180223751574000000) * f[22];
    tg := (0.282094791773999990) * g[0] + (0.090111875786499998) * g[6] + (-0.156078347227999990) * g[8] +
        (-0.161197023870999990) * g[20] + (-0.180223751574000000) * g[22];
    y[5] += tf * g[5] + tg * f[5];
    t := f[5] * g[5];
    y[0] += (0.282094791773999990) * t;
    y[6] += (0.090111875786499998) * t;
    y[8] += (-0.156078347227999990) * t;
    y[20] += (-0.161197023870999990) * t;
    y[22] += (-0.180223751574000000) * t;

    // [5,11]: 2,12,14,
    tf := (0.233596680327000010) * f[2] + (0.059470803871800003) * f[12] + (-0.115164716491000000) * f[14];
    tg := (0.233596680327000010) * g[2] + (0.059470803871800003) * g[12] + (-0.115164716491000000) * g[14];
    y[5] += tf * g[11] + tg * f[11];
    y[11] += tf * g[5] + tg * f[5];
    t := f[5] * g[11] + f[11] * g[5];
    y[2] += (0.233596680327000010) * t;
    y[12] += (0.059470803871800003) * t;
    y[14] += (-0.115164716491000000) * t;

    // [5,17]: 8,22,24,
    tf := (0.168583882832999990) * f[8] + (0.132725386548000010) * f[22] + (-0.140463346189000000) * f[24];
    tg := (0.168583882832999990) * g[8] + (0.132725386548000010) * g[22] + (-0.140463346189000000) * g[24];
    y[5] += tf * g[17] + tg * f[17];
    y[17] += tf * g[5] + tg * f[5];
    t := f[5] * g[17] + f[17] * g[5];
    y[8] += (0.168583882832999990) * t;
    y[22] += (0.132725386548000010) * t;
    y[24] += (-0.140463346189000000) * t;

    // [5,18]: 7,21,23,
    tf := (0.180223751571000010) * f[7] + (0.090297865407399994) * f[21] + (-0.132725386549000010) * f[23];
    tg := (0.180223751571000010) * g[7] + (0.090297865407399994) * g[21] + (-0.132725386549000010) * g[23];
    y[5] += tf * g[18] + tg * f[18];
    y[18] += tf * g[5] + tg * f[5];
    t := f[5] * g[18] + f[18] * g[5];
    y[7] += (0.180223751571000010) * t;
    y[21] += (0.090297865407399994) * t;
    y[23] += (-0.132725386549000010) * t;

    // [5,19]: 6,8,20,22,
    tf := (0.220728115440999990) * f[6] + (0.063718718433900007) * f[8] + (0.044869370061299998) * f[20] + (-0.090297865408399999) * f[22];
    tg := (0.220728115440999990) * g[6] + (0.063718718433900007) * g[8] + (0.044869370061299998) * g[20] + (-0.090297865408399999) * g[22];
    y[5] += tf * g[19] + tg * f[19];
    y[19] += tf * g[5] + tg * f[5];
    t := f[5] * g[19] + f[19] * g[5];
    y[6] += (0.220728115440999990) * t;
    y[8] += (0.063718718433900007) * t;
    y[20] += (0.044869370061299998) * t;
    y[22] += (-0.090297865408399999) * t;

    // [6,6]: 0,6,20,
    tf := (0.282094797560000000) * f[0] + (0.241795553185999990) * f[20];
    tg := (0.282094797560000000) * g[0] + (0.241795553185999990) * g[20];
    y[6] += tf * g[6] + tg * f[6];
    t := f[6] * g[6];
    y[0] += (0.282094797560000000) * t;
    y[6] += (0.180223764527000010) * t;
    y[20] += (0.241795553185999990) * t;

    // [7,7]: 6,0,8,20,22,
    tf := (0.090111875786499998) * f[6] + (0.282094791773999990) * f[0] + (0.156078347227999990) * f[8] +
        (-0.161197023870999990) * f[20] + (0.180223751574000000) * f[22];
    tg := (0.090111875786499998) * g[6] + (0.282094791773999990) * g[0] + (0.156078347227999990) * g[8] +
        (-0.161197023870999990) * g[20] + (0.180223751574000000) * g[22];
    y[7] += tf * g[7] + tg * f[7];
    t := f[7] * g[7];
    y[6] += (0.090111875786499998) * t;
    y[0] += (0.282094791773999990) * t;
    y[8] += (0.156078347227999990) * t;
    y[20] += (-0.161197023870999990) * t;
    y[22] += (0.180223751574000000) * t;

    // [7,13]: 12,2,14,
    tf := (0.059470803871800003) * f[12] + (0.233596680327000010) * f[2] + (0.115164716491000000) * f[14];
    tg := (0.059470803871800003) * g[12] + (0.233596680327000010) * g[2] + (0.115164716491000000) * g[14];
    y[7] += tf * g[13] + tg * f[13];
    y[13] += tf * g[7] + tg * f[7];
    t := f[7] * g[13] + f[13] * g[7];
    y[12] += (0.059470803871800003) * t;
    y[2] += (0.233596680327000010) * t;
    y[14] += (0.115164716491000000) * t;

    // [7,17]: 16,4,18,
    tf := (0.140463346187999990) * f[16] + (0.168583882835000000) * f[4] + (0.132725386549000010) * f[18];
    tg := (0.140463346187999990) * g[16] + (0.168583882835000000) * g[4] + (0.132725386549000010) * g[18];
    y[7] += tf * g[17] + tg * f[17];
    y[17] += tf * g[7] + tg * f[7];
    t := f[7] * g[17] + f[17] * g[7];
    y[16] += (0.140463346187999990) * t;
    y[4] += (0.168583882835000000) * t;
    y[18] += (0.132725386549000010) * t;

    // [7,21]: 8,20,6,22,
    tf := (-0.063718718433900007) * f[8] + (0.044869370061299998) * f[20] + (0.220728115440999990) * f[6] + (0.090297865408399999) * f[22];
    tg := (-0.063718718433900007) * g[8] + (0.044869370061299998) * g[20] + (0.220728115440999990) * g[6] + (0.090297865408399999) * g[22];
    y[7] += tf * g[21] + tg * f[21];
    y[21] += tf * g[7] + tg * f[7];
    t := f[7] * g[21] + f[21] * g[7];
    y[8] += (-0.063718718433900007) * t;
    y[20] += (0.044869370061299998) * t;
    y[6] += (0.220728115440999990) * t;
    y[22] += (0.090297865408399999) * t;

    // [7,23]: 8,22,24,
    tf := (0.168583882832999990) * f[8] + (0.132725386548000010) * f[22] + (0.140463346189000000) * f[24];
    tg := (0.168583882832999990) * g[8] + (0.132725386548000010) * g[22] + (0.140463346189000000) * g[24];
    y[7] += tf * g[23] + tg * f[23];
    y[23] += tf * g[7] + tg * f[7];
    t := f[7] * g[23] + f[23] * g[7];
    y[8] += (0.168583882832999990) * t;
    y[22] += (0.132725386548000010) * t;
    y[24] += (0.140463346189000000) * t;

    // [8,8]: 0,6,20,24,
    tf := (0.282094791770000020) * f[0] + (-0.180223751576000010) * f[6] + (0.040299255967500003) * f[20] + (0.238413613505999990) * f[24];
    tg := (0.282094791770000020) * g[0] + (-0.180223751576000010) * g[6] + (0.040299255967500003) * g[20] + (0.238413613505999990) * g[24];
    y[8] += tf * g[8] + tg * f[8];
    t := f[8] * g[8];
    y[0] += (0.282094791770000020) * t;
    y[6] += (-0.180223751576000010) * t;
    y[20] += (0.040299255967500003) * t;
    y[24] += (0.238413613505999990) * t;

    // [8,22]: 6,20,24,
    tf := (0.156078347226000000) * f[6] + (-0.190364615029000010) * f[20] + (-0.075080816691500005) * f[24];
    tg := (0.156078347226000000) * g[6] + (-0.190364615029000010) * g[20] + (-0.075080816691500005) * g[24];
    y[8] += tf * g[22] + tg * f[22];
    y[22] += tf * g[8] + tg * f[8];
    t := f[8] * g[22] + f[22] * g[8];
    y[6] += (0.156078347226000000) * t;
    y[20] += (-0.190364615029000010) * t;
    y[24] += (-0.075080816691500005) * t;

    // [9,9]: 6,0,20,
    tf := (-0.210261043508000010) * f[6] + (0.282094791766999970) * f[0] + (0.076934943209800002) * f[20];
    tg := (-0.210261043508000010) * g[6] + (0.282094791766999970) * g[0] + (0.076934943209800002) * g[20];
    y[9] += tf * g[9] + tg * f[9];
    t := f[9] * g[9];
    y[6] += (-0.210261043508000010) * t;
    y[0] += (0.282094791766999970) * t;
    y[20] += (0.076934943209800002) * t;

    // [9,10]: 7,21,
    tf := (0.148677009678999990) * f[7] + (-0.099322584599600000) * f[21];
    tg := (0.148677009678999990) * g[7] + (-0.099322584599600000) * g[21];
    y[9] += tf * g[10] + tg * f[10];
    y[10] += tf * g[9] + tg * f[9];
    t := f[9] * g[10] + f[10] * g[9];
    y[7] += (0.148677009678999990) * t;
    y[21] += (-0.099322584599600000) * t;

    // [9,11]: 8,22,24,
    tf := (-0.094031597259499999) * f[8] + (0.133255230518000010) * f[22] + (0.117520066950999990) * f[24];
    tg := (-0.094031597259499999) * g[8] + (0.133255230518000010) * g[22] + (0.117520066950999990) * g[24];
    y[9] += tf * g[11] + tg * f[11];
    y[11] += tf * g[9] + tg * f[9];
    t := f[9] * g[11] + f[11] * g[9];
    y[8] += (-0.094031597259499999) * t;
    y[22] += (0.133255230518000010) * t;
    y[24] += (0.117520066950999990) * t;

    // [9,13]: 4,16,18,
    tf := (-0.094031597258400004) * f[4] + (-0.117520066953000000) * f[16] + (0.133255230519000010) * f[18];
    tg := (-0.094031597258400004) * g[4] + (-0.117520066953000000) * g[16] + (0.133255230519000010) * g[18];
    y[9] += tf * g[13] + tg * f[13];
    y[13] += tf * g[9] + tg * f[9];
    t := f[9] * g[13] + f[13] * g[9];
    y[4] += (-0.094031597258400004) * t;
    y[16] += (-0.117520066953000000) * t;
    y[18] += (0.133255230519000010) * t;

    // [9,14]: 5,19,
    tf := (0.148677009677999990) * f[5] + (-0.099322584600699995) * f[19];
    tg := (0.148677009677999990) * g[5] + (-0.099322584600699995) * g[19];
    y[9] += tf * g[14] + tg * f[14];
    y[14] += tf * g[9] + tg * f[9];
    t := f[9] * g[14] + f[14] * g[9];
    y[5] += (0.148677009677999990) * t;
    y[19] += (-0.099322584600699995) * t;

    // [9,17]: 2,12,
    tf := (0.162867503964999990) * f[2] + (-0.203550726872999990) * f[12];
    tg := (0.162867503964999990) * g[2] + (-0.203550726872999990) * g[12];
    y[9] += tf * g[17] + tg * f[17];
    y[17] += tf * g[9] + tg * f[9];
    t := f[9] * g[17] + f[17] * g[9];
    y[2] += (0.162867503964999990) * t;
    y[12] += (-0.203550726872999990) * t;

    // [10,10]: 0,20,24,
    tf := (0.282094791771999980) * f[0] + (-0.179514867494000000) * f[20] + (-0.151717754049000010) * f[24];
    tg := (0.282094791771999980) * g[0] + (-0.179514867494000000) * g[20] + (-0.151717754049000010) * g[24];
    y[10] += tf * g[10] + tg * f[10];
    t := f[10] * g[10];
    y[0] += (0.282094791771999980) * t;
    y[20] += (-0.179514867494000000) * t;
    y[24] += (-0.151717754049000010) * t;

    // [10,11]: 7,21,23,
    tf := (0.115164716490000000) * f[7] + (0.102579924281000000) * f[21] + (-0.067850242288900006) * f[23];
    tg := (0.115164716490000000) * g[7] + (0.102579924281000000) * g[21] + (-0.067850242288900006) * g[23];
    y[10] += tf * g[11] + tg * f[11];
    y[11] += tf * g[10] + tg * f[10];
    t := f[10] * g[11] + f[11] * g[10];
    y[7] += (0.115164716490000000) * t;
    y[21] += (0.102579924281000000) * t;
    y[23] += (-0.067850242288900006) * t;

    // [10,12]: 4,18,
    tf := (-0.188063194517999990) * f[4] + (-0.044418410173299998) * f[18];
    tg := (-0.188063194517999990) * g[4] + (-0.044418410173299998) * g[18];
    y[10] += tf * g[12] + tg * f[12];
    y[12] += tf * g[10] + tg * f[10];
    t := f[10] * g[12] + f[12] * g[10];
    y[4] += (-0.188063194517999990) * t;
    y[18] += (-0.044418410173299998) * t;

    // [10,13]: 5,17,19,
    tf := (0.115164716490000000) * f[5] + (0.067850242288900006) * f[17] + (0.102579924281000000) * f[19];
    tg := (0.115164716490000000) * g[5] + (0.067850242288900006) * g[17] + (0.102579924281000000) * g[19];
    y[10] += tf * g[13] + tg * f[13];
    y[13] += tf * g[10] + tg * f[10];
    t := f[10] * g[13] + f[13] * g[10];
    y[5] += (0.115164716490000000) * t;
    y[17] += (0.067850242288900006) * t;
    y[19] += (0.102579924281000000) * t;

    // [10,14]: 16,
    tf := (0.151717754044999990) * f[16];
    tg := (0.151717754044999990) * g[16];
    y[10] += tf * g[14] + tg * f[14];
    y[14] += tf * g[10] + tg * f[10];
    t := f[10] * g[14] + f[14] * g[10];
    y[16] += (0.151717754044999990) * t;

    // [10,15]: 5,19,
    tf := (-0.148677009678999990) * f[5] + (0.099322584599600000) * f[19];
    tg := (-0.148677009678999990) * g[5] + (0.099322584599600000) * g[19];
    y[10] += tf * g[15] + tg * f[15];
    y[15] += tf * g[10] + tg * f[10];
    t := f[10] * g[15] + f[15] * g[10];
    y[5] += (-0.148677009678999990) * t;
    y[19] += (0.099322584599600000) * t;

    // [11,11]: 0,6,8,20,22,
    tf := (0.282094791773999990) * f[0] + (0.126156626101000010) * f[6] + (-0.145673124078999990) * f[8] +
        (0.025644981070299999) * f[20] + (-0.114687841910000000) * f[22];
    tg := (0.282094791773999990) * g[0] + (0.126156626101000010) * g[6] + (-0.145673124078999990) * g[8] +
        (0.025644981070299999) * g[20] + (-0.114687841910000000) * g[22];
    y[11] += tf * g[11] + tg * f[11];
    t := f[11] * g[11];
    y[0] += (0.282094791773999990) * t;
    y[6] += (0.126156626101000010) * t;
    y[8] += (-0.145673124078999990) * t;
    y[20] += (0.025644981070299999) * t;
    y[22] += (-0.114687841910000000) * t;

    // [11,14]: 17,
    tf := (0.067850242288500007) * f[17];
    tg := (0.067850242288500007) * g[17];
    y[11] += tf * g[14] + tg * f[14];
    y[14] += tf * g[11] + tg * f[11];
    t := f[11] * g[14] + f[14] * g[11];
    y[17] += (0.067850242288500007) * t;

    // [11,15]: 16,
    tf := (-0.117520066953000000) * f[16];
    tg := (-0.117520066953000000) * g[16];
    y[11] += tf * g[15] + tg * f[15];
    y[15] += tf * g[11] + tg * f[11];
    t := f[11] * g[15] + f[15] * g[11];
    y[16] += (-0.117520066953000000) * t;

    // [11,18]: 3,13,15,
    tf := (0.168583882834000000) * f[3] + (0.114687841909000000) * f[13] + (-0.133255230519000010) * f[15];
    tg := (0.168583882834000000) * g[3] + (0.114687841909000000) * g[13] + (-0.133255230519000010) * g[15];
    y[11] += tf * g[18] + tg * f[18];
    y[18] += tf * g[11] + tg * f[11];
    t := f[11] * g[18] + f[18] * g[11];
    y[3] += (0.168583882834000000) * t;
    y[13] += (0.114687841909000000) * t;
    y[15] += (-0.133255230519000010) * t;

    // [11,19]: 2,14,12,
    tf := (0.238413613504000000) * f[2] + (-0.102579924282000000) * f[14] + (0.099322584599300004) * f[12];
    tg := (0.238413613504000000) * g[2] + (-0.102579924282000000) * g[14] + (0.099322584599300004) * g[12];
    y[11] += tf * g[19] + tg * f[19];
    y[19] += tf * g[11] + tg * f[11];
    t := f[11] * g[19] + f[19] * g[11];
    y[2] += (0.238413613504000000) * t;
    y[14] += (-0.102579924282000000) * t;
    y[12] += (0.099322584599300004) * t;

    // [12,12]: 0,6,20,
    tf := (0.282094799871999980) * f[0] + (0.168208852954000010) * f[6] + (0.153869910786000010) * f[20];
    tg := (0.282094799871999980) * g[0] + (0.168208852954000010) * g[6] + (0.153869910786000010) * g[20];
    y[12] += tf * g[12] + tg * f[12];
    t := f[12] * g[12];
    y[0] += (0.282094799871999980) * t;
    y[6] += (0.168208852954000010) * t;
    y[20] += (0.153869910786000010) * t;

    // [12,14]: 8,22,
    tf := (-0.188063194517999990) * f[8] + (-0.044418410173299998) * f[22];
    tg := (-0.188063194517999990) * g[8] + (-0.044418410173299998) * g[22];
    y[12] += tf * g[14] + tg * f[14];
    y[14] += tf * g[12] + tg * f[12];
    t := f[12] * g[14] + f[14] * g[12];
    y[8] += (-0.188063194517999990) * t;
    y[22] += (-0.044418410173299998) * t;

    // [13,13]: 0,8,6,20,22,
    tf := (0.282094791773999990) * f[0] + (0.145673124078999990) * f[8] + (0.126156626101000010) * f[6] +
        (0.025644981070299999) * f[20] + (0.114687841910000000) * f[22];
    tg := (0.282094791773999990) * g[0] + (0.145673124078999990) * g[8] + (0.126156626101000010) * g[6] +
        (0.025644981070299999) * g[20] + (0.114687841910000000) * g[22];
    y[13] += tf * g[13] + tg * f[13];
    t := f[13] * g[13];
    y[0] += (0.282094791773999990) * t;
    y[8] += (0.145673124078999990) * t;
    y[6] += (0.126156626101000010) * t;
    y[20] += (0.025644981070299999) * t;
    y[22] += (0.114687841910000000) * t;

    // [13,14]: 23,
    tf := (0.067850242288500007) * f[23];
    tg := (0.067850242288500007) * g[23];
    y[13] += tf * g[14] + tg * f[14];
    y[14] += tf * g[13] + tg * f[13];
    t := f[13] * g[14] + f[14] * g[13];
    y[23] += (0.067850242288500007) * t;

    // [13,15]: 8,22,24,
    tf := (-0.094031597259499999) * f[8] + (0.133255230518000010) * f[22] + (-0.117520066950999990) * f[24];
    tg := (-0.094031597259499999) * g[8] + (0.133255230518000010) * g[22] + (-0.117520066950999990) * g[24];
    y[13] += tf * g[15] + tg * f[15];
    y[15] += tf * g[13] + tg * f[13];
    t := f[13] * g[15] + f[15] * g[13];
    y[8] += (-0.094031597259499999) * t;
    y[22] += (0.133255230518000010) * t;
    y[24] += (-0.117520066950999990) * t;

    // [13,21]: 2,12,14,
    tf := (0.238413613504000000) * f[2] + (0.099322584599300004) * f[12] + (0.102579924282000000) * f[14];
    tg := (0.238413613504000000) * g[2] + (0.099322584599300004) * g[12] + (0.102579924282000000) * g[14];
    y[13] += tf * g[21] + tg * f[21];
    y[21] += tf * g[13] + tg * f[13];
    t := f[13] * g[21] + f[21] * g[13];
    y[2] += (0.238413613504000000) * t;
    y[12] += (0.099322584599300004) * t;
    y[14] += (0.102579924282000000) * t;

    // [14,14]: 0,20,24,
    tf := (0.282094791771999980) * f[0] + (-0.179514867494000000) * f[20] + (0.151717754049000010) * f[24];
    tg := (0.282094791771999980) * g[0] + (-0.179514867494000000) * g[20] + (0.151717754049000010) * g[24];
    y[14] += tf * g[14] + tg * f[14];
    t := f[14] * g[14];
    y[0] += (0.282094791771999980) * t;
    y[20] += (-0.179514867494000000) * t;
    y[24] += (0.151717754049000010) * t;

    // [14,15]: 7,21,
    tf := (0.148677009677999990) * f[7] + (-0.099322584600699995) * f[21];
    tg := (0.148677009677999990) * g[7] + (-0.099322584600699995) * g[21];
    y[14] += tf * g[15] + tg * f[15];
    y[15] += tf * g[14] + tg * f[14];
    t := f[14] * g[15] + f[15] * g[14];
    y[7] += (0.148677009677999990) * t;
    y[21] += (-0.099322584600699995) * t;

    // [15,15]: 0,6,20,
    tf := (0.282094791766999970) * f[0] + (-0.210261043508000010) * f[6] + (0.076934943209800002) * f[20];
    tg := (0.282094791766999970) * g[0] + (-0.210261043508000010) * g[6] + (0.076934943209800002) * g[20];
    y[15] += tf * g[15] + tg * f[15];
    t := f[15] * g[15];
    y[0] += (0.282094791766999970) * t;
    y[6] += (-0.210261043508000010) * t;
    y[20] += (0.076934943209800002) * t;

    // [15,23]: 12,2,
    tf := (-0.203550726872999990) * f[12] + (0.162867503964999990) * f[2];
    tg := (-0.203550726872999990) * g[12] + (0.162867503964999990) * g[2];
    y[15] += tf * g[23] + tg * f[23];
    y[23] += tf * g[15] + tg * f[15];
    t := f[15] * g[23] + f[23] * g[15];
    y[12] += (-0.203550726872999990) * t;
    y[2] += (0.162867503964999990) * t;

    // [16,16]: 0,6,20,
    tf := (0.282094791763999990) * f[0] + (-0.229375683829000000) * f[6] + (0.106525305981000000) * f[20];
    tg := (0.282094791763999990) * g[0] + (-0.229375683829000000) * g[6] + (0.106525305981000000) * g[20];
    y[16] += tf * g[16] + tg * f[16];
    t := f[16] * g[16];
    y[0] += (0.282094791763999990) * t;
    y[6] += (-0.229375683829000000) * t;
    y[20] += (0.106525305981000000) * t;

    // [16,18]: 8,22,
    tf := (-0.075080816693699995) * f[8] + (0.135045473380000000) * f[22];
    tg := (-0.075080816693699995) * g[8] + (0.135045473380000000) * g[22];
    y[16] += tf * g[18] + tg * f[18];
    y[18] += tf * g[16] + tg * f[16];
    t := f[16] * g[18] + f[18] * g[16];
    y[8] += (-0.075080816693699995) * t;
    y[22] += (0.135045473380000000) * t;

    // [16,23]: 19,5,
    tf := (-0.119098912754999990) * f[19] + (0.140463346187999990) * f[5];
    tg := (-0.119098912754999990) * g[19] + (0.140463346187999990) * g[5];
    y[16] += tf * g[23] + tg * f[23];
    y[23] += tf * g[16] + tg * f[16];
    t := f[16] * g[23] + f[23] * g[16];
    y[19] += (-0.119098912754999990) * t;
    y[5] += (0.140463346187999990) * t;

    // [17,17]: 0,6,20,
    tf := (0.282094791768999990) * f[0] + (-0.057343920955899998) * f[6] + (-0.159787958979000000) * f[20];
    tg := (0.282094791768999990) * g[0] + (-0.057343920955899998) * g[6] + (-0.159787958979000000) * g[20];
    y[17] += tf * g[17] + tg * f[17];
    t := f[17] * g[17];
    y[0] += (0.282094791768999990) * t;
    y[6] += (-0.057343920955899998) * t;
    y[20] += (-0.159787958979000000) * t;

    // [17,19]: 8,22,24,
    tf := (-0.112621225039000000) * f[8] + (0.045015157794100001) * f[22] + (0.119098912753000000) * f[24];
    tg := (-0.112621225039000000) * g[8] + (0.045015157794100001) * g[22] + (0.119098912753000000) * g[24];
    y[17] += tf * g[19] + tg * f[19];
    y[19] += tf * g[17] + tg * f[17];
    t := f[17] * g[19] + f[19] * g[17];
    y[8] += (-0.112621225039000000) * t;
    y[22] += (0.045015157794100001) * t;
    y[24] += (0.119098912753000000) * t;

    // [17,21]: 16,4,18,
    tf := (-0.119098912754999990) * f[16] + (-0.112621225039000000) * f[4] + (0.045015157794399997) * f[18];
    tg := (-0.119098912754999990) * g[16] + (-0.112621225039000000) * g[4] + (0.045015157794399997) * g[18];
    y[17] += tf * g[21] + tg * f[21];
    y[21] += tf * g[17] + tg * f[17];
    t := f[17] * g[21] + f[21] * g[17];
    y[16] += (-0.119098912754999990) * t;
    y[4] += (-0.112621225039000000) * t;
    y[18] += (0.045015157794399997) * t;

    // [18,18]: 6,0,20,24,
    tf := (0.065535909662600006) * f[6] + (0.282094791771999980) * f[0] + (-0.083698454702400005) * f[20] + (-0.135045473384000000) * f[24];
    tg := (0.065535909662600006) * g[6] + (0.282094791771999980) * g[0] + (-0.083698454702400005) * g[20] + (-0.135045473384000000) * g[24];
    y[18] += tf * g[18] + tg * f[18];
    t := f[18] * g[18];
    y[6] += (0.065535909662600006) * t;
    y[0] += (0.282094791771999980) * t;
    y[20] += (-0.083698454702400005) * t;
    y[24] += (-0.135045473384000000) * t;

    // [18,19]: 7,21,23,
    tf := (0.090297865407399994) * f[7] + (0.102084782359000000) * f[21] + (-0.045015157794399997) * f[23];
    tg := (0.090297865407399994) * g[7] + (0.102084782359000000) * g[21] + (-0.045015157794399997) * g[23];
    y[18] += tf * g[19] + tg * f[19];
    y[19] += tf * g[18] + tg * f[18];
    t := f[18] * g[19] + f[19] * g[18];
    y[7] += (0.090297865407399994) * t;
    y[21] += (0.102084782359000000) * t;
    y[23] += (-0.045015157794399997) * t;

    // [19,19]: 6,8,0,20,22,
    tf := (0.139263808033999990) * f[6] + (-0.141889406570999990) * f[8] + (0.282094791773999990) * f[0] +
        (0.068480553847200004) * f[20] + (-0.102084782360000000) * f[22];
    tg := (0.139263808033999990) * g[6] + (-0.141889406570999990) * g[8] + (0.282094791773999990) * g[0] +
        (0.068480553847200004) * g[20] + (-0.102084782360000000) * g[22];
    y[19] += tf * g[19] + tg * f[19];
    t := f[19] * g[19];
    y[6] += (0.139263808033999990) * t;
    y[8] += (-0.141889406570999990) * t;
    y[0] += (0.282094791773999990) * t;
    y[20] += (0.068480553847200004) * t;
    y[22] += (-0.102084782360000000) * t;

    // [20,20]: 6,0,20,
    tf := (0.163839797503000010) * f[6] + (0.282094802232000010) * f[0];
    tg := (0.163839797503000010) * g[6] + (0.282094802232000010) * g[0];
    y[20] += tf * g[20] + tg * f[20];
    t := f[20] * g[20];
    y[6] += (0.163839797503000010) * t;
    y[0] += (0.282094802232000010) * t;
    y[20] += (0.136961139005999990) * t;

    // [21,21]: 6,20,0,8,22,
    tf := (0.139263808033999990) * f[6] + (0.068480553847200004) * f[20] + (0.282094791773999990) * f[0] +
        (0.141889406570999990) * f[8] + (0.102084782360000000) * f[22];
    tg := (0.139263808033999990) * g[6] + (0.068480553847200004) * g[20] + (0.282094791773999990) * g[0] +
        (0.141889406570999990) * g[8] + (0.102084782360000000) * g[22];
    y[21] += tf * g[21] + tg * f[21];
    t := f[21] * g[21];
    y[6] += (0.139263808033999990) * t;
    y[20] += (0.068480553847200004) * t;
    y[0] += (0.282094791773999990) * t;
    y[8] += (0.141889406570999990) * t;
    y[22] += (0.102084782360000000) * t;

    // [21,23]: 8,22,24,
    tf := (-0.112621225039000000) * f[8] + (0.045015157794100001) * f[22] + (-0.119098912753000000) * f[24];
    tg := (-0.112621225039000000) * g[8] + (0.045015157794100001) * g[22] + (-0.119098912753000000) * g[24];
    y[21] += tf * g[23] + tg * f[23];
    y[23] += tf * g[21] + tg * f[21];
    t := f[21] * g[23] + f[23] * g[21];
    y[8] += (-0.112621225039000000) * t;
    y[22] += (0.045015157794100001) * t;
    y[24] += (-0.119098912753000000) * t;

    // [22,22]: 6,20,0,24,
    tf := (0.065535909662600006) * f[6] + (-0.083698454702400005) * f[20] + (0.282094791771999980) * f[0] + (0.135045473384000000) * f[24];
    tg := (0.065535909662600006) * g[6] + (-0.083698454702400005) * g[20] + (0.282094791771999980) * g[0] + (0.135045473384000000) * g[24];
    y[22] += tf * g[22] + tg * f[22];
    t := f[22] * g[22];
    y[6] += (0.065535909662600006) * t;
    y[20] += (-0.083698454702400005) * t;
    y[0] += (0.282094791771999980) * t;
    y[24] += (0.135045473384000000) * t;

    // [23,23]: 6,20,0,
    tf := (-0.057343920955899998) * f[6] + (-0.159787958979000000) * f[20] + (0.282094791768999990) * f[0];
    tg := (-0.057343920955899998) * g[6] + (-0.159787958979000000) * g[20] + (0.282094791768999990) * g[0];
    y[23] += tf * g[23] + tg * f[23];
    t := f[23] * g[23];
    y[6] += (-0.057343920955899998) * t;
    y[20] += (-0.159787958979000000) * t;
    y[0] += (0.282094791768999990) * t;

    // [24,24]: 6,0,20,
    tf := (-0.229375683829000000) * f[6] + (0.282094791763999990) * f[0] + (0.106525305981000000) * f[20];
    tg := (-0.229375683829000000) * g[6] + (0.282094791763999990) * g[0] + (0.106525305981000000) * g[20];
    y[24] += tf * g[24] + tg * f[24];
    t := f[24] * g[24];
    y[6] += (-0.229375683829000000) * t;
    y[0] += (0.282094791763999990) * t;
    y[20] += (0.106525305981000000) * t;

    // multiply count:=1135

    Result := y;
end;


//-------------------------------------------------------------------------------------
// http://msdn.microsoft.com/en-us/library/windows/desktop/bb232909.aspx
//-------------------------------------------------------------------------------------
function XMSHMultiply6(var y: Psingle; const f: Psingle; const g: Psingle): PSingle;
var
    tf, tg, t: single;
begin
    Result := nil;
    if (y = nil) or (f = nil) or (g = nil) then
        Exit;

    // [0,0]: 0,
    y[0] := (0.282094792935999980) * f[0] * g[0];

    // [1,1]: 0,6,8,
    tf := (0.282094791773000010) * f[0] + (-0.126156626101000010) * f[6] + (-0.218509686119999990) * f[8];
    tg := (0.282094791773000010) * g[0] + (-0.126156626101000010) * g[6] + (-0.218509686119999990) * g[8];
    y[1] := tf * g[1] + tg * f[1];
    t := f[1] * g[1];
    y[0] += (0.282094791773000010) * t;
    y[6] := (-0.126156626101000010) * t;
    y[8] := (-0.218509686119999990) * t;

    // [1,4]: 3,13,15,
    tf := (0.218509686114999990) * f[3] + (-0.058399170082300000) * f[13] + (-0.226179013157999990) * f[15];
    tg := (0.218509686114999990) * g[3] + (-0.058399170082300000) * g[13] + (-0.226179013157999990) * g[15];
    y[1] += tf * g[4] + tg * f[4];
    y[4] := tf * g[1] + tg * f[1];
    t := f[1] * g[4] + f[4] * g[1];
    y[3] := (0.218509686114999990) * t;
    y[13] := (-0.058399170082300000) * t;
    y[15] := (-0.226179013157999990) * t;

    // [1,5]: 2,12,
    tf := (0.218509686118000010) * f[2] + (-0.143048168103000000) * f[12];
    tg := (0.218509686118000010) * g[2] + (-0.143048168103000000) * g[12];
    y[1] += tf * g[5] + tg * f[5];
    y[5] := tf * g[1] + tg * f[1];
    t := f[1] * g[5] + f[5] * g[1];
    y[2] := (0.218509686118000010) * t;
    y[12] := (-0.143048168103000000) * t;

    // [1,11]: 6,8,20,22,
    tf := (0.202300659402999990) * f[6] + (0.058399170081799998) * f[8] + (-0.150786008773000000) * f[20] + (-0.168583882836999990) * f[22];
    tg := (0.202300659402999990) * g[6] + (0.058399170081799998) * g[8] + (-0.150786008773000000) * g[20] + (-0.168583882836999990) * g[22];
    y[1] += tf * g[11] + tg * f[11];
    y[11] := tf * g[1] + tg * f[1];
    t := f[1] * g[11] + f[11] * g[1];
    y[6] += (0.202300659402999990) * t;
    y[8] += (0.058399170081799998) * t;
    y[20] := (-0.150786008773000000) * t;
    y[22] := (-0.168583882836999990) * t;

    // [1,16]: 15,33,35,
    tf := (0.230329432973999990) * f[15] + (-0.034723468517399998) * f[33] + (-0.232932108051999990) * f[35];
    tg := (0.230329432973999990) * g[15] + (-0.034723468517399998) * g[33] + (-0.232932108051999990) * g[35];
    y[1] += tf * g[16] + tg * f[16];
    y[16] := tf * g[1] + tg * f[1];
    t := f[1] * g[16] + f[16] * g[1];
    y[15] += (0.230329432973999990) * t;
    y[33] := (-0.034723468517399998) * t;
    y[35] := (-0.232932108051999990) * t;

    // [1,18]: 15,13,31,33,
    tf := (0.043528171377799997) * f[15] + (0.168583882834000000) * f[13] + (-0.085054779966799998) * f[31] + (-0.183739324705999990) * f[33];
    tg := (0.043528171377799997) * g[15] + (0.168583882834000000) * g[13] + (-0.085054779966799998) * g[31] + (-0.183739324705999990) * g[33];
    y[1] += tf * g[18] + tg * f[18];
    y[18] := tf * g[1] + tg * f[1];
    t := f[1] * g[18] + f[18] * g[1];
    y[15] += (0.043528171377799997) * t;
    y[13] += (0.168583882834000000) * t;
    y[31] := (-0.085054779966799998) * t;
    y[33] += (-0.183739324705999990) * t;

    // [1,19]: 14,12,30,32,
    tf := (0.075393004386399995) * f[14] + (0.194663900273000010) * f[12] + (-0.155288072037000010) * f[30] + (-0.159122922869999990) * f[32];
    tg := (0.075393004386399995) * g[14] + (0.194663900273000010) * g[12] + (-0.155288072037000010) * g[30] + (-0.159122922869999990) * g[32];
    y[1] += tf * g[19] + tg * f[19];
    y[19] := tf * g[1] + tg * f[1];
    t := f[1] * g[19] + f[19] * g[1];
    y[14] := (0.075393004386399995) * t;
    y[12] += (0.194663900273000010) * t;
    y[30] := (-0.155288072037000010) * t;
    y[32] := (-0.159122922869999990) * t;

    // [1,24]: 9,25,27,
    tf := (-0.230329432978999990) * f[9] + (0.232932108049000000) * f[25] + (0.034723468517100002) * f[27];
    tg := (-0.230329432978999990) * g[9] + (0.232932108049000000) * g[25] + (0.034723468517100002) * g[27];
    y[1] += tf * g[24] + tg * f[24];
    y[24] := tf * g[1] + tg * f[1];
    t := f[1] * g[24] + f[24] * g[1];
    y[9] := (-0.230329432978999990) * t;
    y[25] := (0.232932108049000000) * t;
    y[27] := (0.034723468517100002) * t;

    // [1,29]: 22,20,
    tf := (0.085054779965999999) * f[22] + (0.190188269815000010) * f[20];
    tg := (0.085054779965999999) * g[22] + (0.190188269815000010) * g[20];
    y[1] += tf * g[29] + tg * f[29];
    y[29] := tf * g[1] + tg * f[1];
    t := f[1] * g[29] + f[29] * g[1];
    y[22] += (0.085054779965999999) * t;
    y[20] += (0.190188269815000010) * t;

    // [2,2]: 0,6,
    tf := (0.282094795249000000) * f[0] + (0.252313259986999990) * f[6];
    tg := (0.282094795249000000) * g[0] + (0.252313259986999990) * g[6];
    y[2] += tf * g[2] + tg * f[2];
    t := f[2] * g[2];
    y[0] += (0.282094795249000000) * t;
    y[6] += (0.252313259986999990) * t;

    // [2,12]: 6,20,
    tf := (0.247766706973999990) * f[6] + (0.246232537174000010) * f[20];
    tg := (0.247766706973999990) * g[6] + (0.246232537174000010) * g[20];
    y[2] += tf * g[12] + tg * f[12];
    y[12] += tf * g[2] + tg * f[2];
    t := f[2] * g[12] + f[12] * g[2];
    y[6] += (0.247766706973999990) * t;
    y[20] += (0.246232537174000010) * t;

    // [2,20]: 30,
    tf := (0.245532020560000010) * f[30];
    tg := (0.245532020560000010) * g[30];
    y[2] += tf * g[20] + tg * f[20];
    y[20] += tf * g[2] + tg * f[2];
    t := f[2] * g[20] + f[20] * g[2];
    y[30] += (0.245532020560000010) * t;

    // [3,3]: 0,6,8,
    tf := (0.282094791773000010) * f[0] + (-0.126156626101000010) * f[6] + (0.218509686119999990) * f[8];
    tg := (0.282094791773000010) * g[0] + (-0.126156626101000010) * g[6] + (0.218509686119999990) * g[8];
    y[3] += tf * g[3] + tg * f[3];
    t := f[3] * g[3];
    y[0] += (0.282094791773000010) * t;
    y[6] += (-0.126156626101000010) * t;
    y[8] += (0.218509686119999990) * t;

    // [3,7]: 2,12,
    tf := (0.218509686118000010) * f[2] + (-0.143048168103000000) * f[12];
    tg := (0.218509686118000010) * g[2] + (-0.143048168103000000) * g[12];
    y[3] += tf * g[7] + tg * f[7];
    y[7] := tf * g[3] + tg * f[3];
    t := f[3] * g[7] + f[7] * g[3];
    y[2] += (0.218509686118000010) * t;
    y[12] += (-0.143048168103000000) * t;

    // [3,13]: 8,6,20,22,
    tf := (-0.058399170081799998) * f[8] + (0.202300659402999990) * f[6] + (-0.150786008773000000) * f[20] + (0.168583882836999990) * f[22];
    tg := (-0.058399170081799998) * g[8] + (0.202300659402999990) * g[6] + (-0.150786008773000000) * g[20] + (0.168583882836999990) * g[22];
    y[3] += tf * g[13] + tg * f[13];
    y[13] += tf * g[3] + tg * f[3];
    t := f[3] * g[13] + f[13] * g[3];
    y[8] += (-0.058399170081799998) * t;
    y[6] += (0.202300659402999990) * t;
    y[20] += (-0.150786008773000000) * t;
    y[22] += (0.168583882836999990) * t;

    // [3,16]: 9,25,27,
    tf := (0.230329432973999990) * f[9] + (0.232932108051999990) * f[25] + (-0.034723468517399998) * f[27];
    tg := (0.230329432973999990) * g[9] + (0.232932108051999990) * g[25] + (-0.034723468517399998) * g[27];
    y[3] += tf * g[16] + tg * f[16];
    y[16] += tf * g[3] + tg * f[3];
    t := f[3] * g[16] + f[16] * g[3];
    y[9] += (0.230329432973999990) * t;
    y[25] += (0.232932108051999990) * t;
    y[27] += (-0.034723468517399998) * t;

    // [3,21]: 12,14,30,32,
    tf := (0.194663900273000010) * f[12] + (-0.075393004386399995) * f[14] + (-0.155288072037000010) * f[30] + (0.159122922869999990) * f[32];
    tg := (0.194663900273000010) * g[12] + (-0.075393004386399995) * g[14] + (-0.155288072037000010) * g[30] + (0.159122922869999990) * g[32];
    y[3] += tf * g[21] + tg * f[21];
    y[21] := tf * g[3] + tg * f[3];
    t := f[3] * g[21] + f[21] * g[3];
    y[12] += (0.194663900273000010) * t;
    y[14] += (-0.075393004386399995) * t;
    y[30] += (-0.155288072037000010) * t;
    y[32] += (0.159122922869999990) * t;

    // [3,24]: 15,33,35,
    tf := (0.230329432978999990) * f[15] + (-0.034723468517100002) * f[33] + (0.232932108049000000) * f[35];
    tg := (0.230329432978999990) * g[15] + (-0.034723468517100002) * g[33] + (0.232932108049000000) * g[35];
    y[3] += tf * g[24] + tg * f[24];
    y[24] += tf * g[3] + tg * f[3];
    t := f[3] * g[24] + f[24] * g[3];
    y[15] += (0.230329432978999990) * t;
    y[33] += (-0.034723468517100002) * t;
    y[35] += (0.232932108049000000) * t;

    // [3,31]: 20,22,
    tf := (0.190188269815000010) * f[20] + (-0.085054779965999999) * f[22];
    tg := (0.190188269815000010) * g[20] + (-0.085054779965999999) * g[22];
    y[3] += tf * g[31] + tg * f[31];
    y[31] += tf * g[3] + tg * f[3];
    t := f[3] * g[31] + f[31] * g[3];
    y[20] += (0.190188269815000010) * t;
    y[22] += (-0.085054779965999999) * t;

    // [4,4]: 0,6,20,24,
    tf := (0.282094791770000020) * f[0] + (-0.180223751576000010) * f[6] + (0.040299255967500003) * f[20] + (-0.238413613505999990) * f[24];
    tg := (0.282094791770000020) * g[0] + (-0.180223751576000010) * g[6] + (0.040299255967500003) * g[20] + (-0.238413613505999990) * g[24];
    y[4] += tf * g[4] + tg * f[4];
    t := f[4] * g[4];
    y[0] += (0.282094791770000020) * t;
    y[6] += (-0.180223751576000010) * t;
    y[20] += (0.040299255967500003) * t;
    y[24] += (-0.238413613505999990) * t;

    // [4,5]: 7,21,23,
    tf := (0.156078347226000000) * f[7] + (-0.063718718434399996) * f[21] + (-0.168583882835000000) * f[23];
    tg := (0.156078347226000000) * g[7] + (-0.063718718434399996) * g[21] + (-0.168583882835000000) * g[23];
    y[4] += tf * g[5] + tg * f[5];
    y[5] += tf * g[4] + tg * f[4];
    t := f[4] * g[5] + f[5] * g[4];
    y[7] += (0.156078347226000000) * t;
    y[21] += (-0.063718718434399996) * t;
    y[23] := (-0.168583882835000000) * t;

    // [4,9]: 3,13,31,35,
    tf := (0.226179013157999990) * f[3] + (-0.094031597258400004) * f[13] + (0.016943317729299998) * f[31] + (-0.245532000542000000) * f[35];
    tg := (0.226179013157999990) * g[3] + (-0.094031597258400004) * g[13] + (0.016943317729299998) * g[31] + (-0.245532000542000000) * g[35];
    y[4] += tf * g[9] + tg * f[9];
    y[9] += tf * g[4] + tg * f[4];
    t := f[4] * g[9] + f[9] * g[4];
    y[3] += (0.226179013157999990) * t;
    y[13] += (-0.094031597258400004) * t;
    y[31] += (0.016943317729299998) * t;
    y[35] += (-0.245532000542000000) * t;

    // [4,10]: 2,12,30,34,
    tf := (0.184674390919999990) * f[2] + (-0.188063194517999990) * f[12] + (0.053579475144400000) * f[30] + (-0.190188269816000010) * f[34];
    tg := (0.184674390919999990) * g[2] + (-0.188063194517999990) * g[12] + (0.053579475144400000) * g[30] + (-0.190188269816000010) * g[34];
    y[4] += tf * g[10] + tg * f[10];
    y[10] := tf * g[4] + tg * f[4];
    t := f[4] * g[10] + f[10] * g[4];
    y[2] += (0.184674390919999990) * t;
    y[12] += (-0.188063194517999990) * t;
    y[30] += (0.053579475144400000) * t;
    y[34] := (-0.190188269816000010) * t;

    // [4,11]: 3,13,15,31,33,
    tf := (-0.058399170082300000) * f[3] + (0.145673124078000010) * f[13] + (0.094031597258400004) * f[15] +
        (-0.065621187395699998) * f[31] + (-0.141757966610000010) * f[33];
    tg := (-0.058399170082300000) * g[3] + (0.145673124078000010) * g[13] + (0.094031597258400004) * g[15] +
        (-0.065621187395699998) * g[31] + (-0.141757966610000010) * g[33];
    y[4] += tf * g[11] + tg * f[11];
    y[11] += tf * g[4] + tg * f[4];
    t := f[4] * g[11] + f[11] * g[4];
    y[3] += (-0.058399170082300000) * t;
    y[13] += (0.145673124078000010) * t;
    y[15] += (0.094031597258400004) * t;
    y[31] += (-0.065621187395699998) * t;
    y[33] += (-0.141757966610000010) * t;

    // [4,16]: 8,22,
    tf := (0.238413613494000000) * f[8] + (-0.075080816693699995) * f[22];
    tg := (0.238413613494000000) * g[8] + (-0.075080816693699995) * g[22];
    y[4] += tf * g[16] + tg * f[16];
    y[16] += tf * g[4] + tg * f[4];
    t := f[4] * g[16] + f[16] * g[4];
    y[8] += (0.238413613494000000) * t;
    y[22] += (-0.075080816693699995) * t;

    // [4,18]: 6,20,24,
    tf := (0.156078347226000000) * f[6] + (-0.190364615029000010) * f[20] + (0.075080816691500005) * f[24];
    tg := (0.156078347226000000) * g[6] + (-0.190364615029000010) * g[20] + (0.075080816691500005) * g[24];
    y[4] += tf * g[18] + tg * f[18];
    y[18] += tf * g[4] + tg * f[4];
    t := f[4] * g[18] + f[18] * g[4];
    y[6] += (0.156078347226000000) * t;
    y[20] += (-0.190364615029000010) * t;
    y[24] += (0.075080816691500005) * t;

    // [4,19]: 7,21,23,
    tf := (-0.063718718434399996) * f[7] + (0.141889406569999990) * f[21] + (0.112621225039000000) * f[23];
    tg := (-0.063718718434399996) * g[7] + (0.141889406569999990) * g[21] + (0.112621225039000000) * g[23];
    y[4] += tf * g[19] + tg * f[19];
    y[19] += tf * g[4] + tg * f[4];
    t := f[4] * g[19] + f[19] * g[4];
    y[7] += (-0.063718718434399996) * t;
    y[21] += (0.141889406569999990) * t;
    y[23] += (0.112621225039000000) * t;

    // [4,25]: 15,33,
    tf := (0.245532000542000000) * f[15] + (-0.062641347680800000) * f[33];
    tg := (0.245532000542000000) * g[15] + (-0.062641347680800000) * g[33];
    y[4] += tf * g[25] + tg * f[25];
    y[25] += tf * g[4] + tg * f[4];
    t := f[4] * g[25] + f[25] * g[4];
    y[15] += (0.245532000542000000) * t;
    y[33] += (-0.062641347680800000) * t;

    // [4,26]: 14,32,
    tf := (0.190188269806999990) * f[14] + (-0.097043558542400002) * f[32];
    tg := (0.190188269806999990) * g[14] + (-0.097043558542400002) * g[32];
    y[4] += tf * g[26] + tg * f[26];
    y[26] := tf * g[4] + tg * f[4];
    t := f[4] * g[26] + f[26] * g[4];
    y[14] += (0.190188269806999990) * t;
    y[32] += (-0.097043558542400002) * t;

    // [4,27]: 13,31,35,
    tf := (0.141757966610000010) * f[13] + (-0.121034582549000000) * f[31] + (0.062641347680800000) * f[35];
    tg := (0.141757966610000010) * g[13] + (-0.121034582549000000) * g[31] + (0.062641347680800000) * g[35];
    y[4] += tf * g[27] + tg * f[27];
    y[27] += tf * g[4] + tg * f[4];
    t := f[4] * g[27] + f[27] * g[4];
    y[13] += (0.141757966610000010) * t;
    y[31] += (-0.121034582549000000) * t;
    y[35] += (0.062641347680800000) * t;

    // [4,28]: 12,30,34,
    tf := (0.141757966609000000) * f[12] + (-0.191372478254000000) * f[30] + (0.097043558538899996) * f[34];
    tg := (0.141757966609000000) * g[12] + (-0.191372478254000000) * g[30] + (0.097043558538899996) * g[34];
    y[4] += tf * g[28] + tg * f[28];
    y[28] := tf * g[4] + tg * f[4];
    t := f[4] * g[28] + f[28] * g[4];
    y[12] += (0.141757966609000000) * t;
    y[30] += (-0.191372478254000000) * t;
    y[34] += (0.097043558538899996) * t;

    // [4,29]: 13,15,31,33,
    tf := (-0.065621187395699998) * f[13] + (-0.016943317729299998) * f[15] + (0.140070311613999990) * f[31] + (0.121034582549000000) * f[33];
    tg := (-0.065621187395699998) * g[13] + (-0.016943317729299998) * g[15] + (0.140070311613999990) * g[31] + (0.121034582549000000) * g[33];
    y[4] += tf * g[29] + tg * f[29];
    y[29] += tf * g[4] + tg * f[4];
    t := f[4] * g[29] + f[29] * g[4];
    y[13] += (-0.065621187395699998) * t;
    y[15] += (-0.016943317729299998) * t;
    y[31] += (0.140070311613999990) * t;
    y[33] += (0.121034582549000000) * t;

    // [5,5]: 0,6,8,20,22,
    tf := (0.282094791773999990) * f[0] + (0.090111875786499998) * f[6] + (-0.156078347227999990) * f[8] +
        (-0.161197023870999990) * f[20] + (-0.180223751574000000) * f[22];
    tg := (0.282094791773999990) * g[0] + (0.090111875786499998) * g[6] + (-0.156078347227999990) * g[8] +
        (-0.161197023870999990) * g[20] + (-0.180223751574000000) * g[22];
    y[5] += tf * g[5] + tg * f[5];
    t := f[5] * g[5];
    y[0] += (0.282094791773999990) * t;
    y[6] += (0.090111875786499998) * t;
    y[8] += (-0.156078347227999990) * t;
    y[20] += (-0.161197023870999990) * t;
    y[22] += (-0.180223751574000000) * t;

    // [5,10]: 3,13,15,31,33,
    tf := (0.184674390919999990) * f[3] + (0.115164716490000000) * f[13] + (-0.148677009678999990) * f[15] +
        (-0.083004965974099995) * f[31] + (-0.179311220383999990) * f[33];
    tg := (0.184674390919999990) * g[3] + (0.115164716490000000) * g[13] + (-0.148677009678999990) * g[15] +
        (-0.083004965974099995) * g[31] + (-0.179311220383999990) * g[33];
    y[5] += tf * g[10] + tg * f[10];
    y[10] += tf * g[5] + tg * f[5];
    t := f[5] * g[10] + f[10] * g[5];
    y[3] += (0.184674390919999990) * t;
    y[13] += (0.115164716490000000) * t;
    y[15] += (-0.148677009678999990) * t;
    y[31] += (-0.083004965974099995) * t;
    y[33] += (-0.179311220383999990) * t;

    // [5,11]: 2,12,14,30,32,
    tf := (0.233596680327000010) * f[2] + (0.059470803871800003) * f[12] + (-0.115164716491000000) * f[14] +
        (-0.169433177294000010) * f[30] + (-0.173617342585000000) * f[32];
    tg := (0.233596680327000010) * g[2] + (0.059470803871800003) * g[12] + (-0.115164716491000000) * g[14] +
        (-0.169433177294000010) * g[30] + (-0.173617342585000000) * g[32];
    y[5] += tf * g[11] + tg * f[11];
    y[11] += tf * g[5] + tg * f[5];
    t := f[5] * g[11] + f[11] * g[5];
    y[2] += (0.233596680327000010) * t;
    y[12] += (0.059470803871800003) * t;
    y[14] += (-0.115164716491000000) * t;
    y[30] += (-0.169433177294000010) * t;
    y[32] += (-0.173617342585000000) * t;

    // [5,14]: 9,1,27,29,
    tf := (0.148677009677999990) * f[9] + (-0.184674390923000000) * f[1] + (0.179311220382000010) * f[27] + (0.083004965973399999) * f[29];
    tg := (0.148677009677999990) * g[9] + (-0.184674390923000000) * g[1] + (0.179311220382000010) * g[27] + (0.083004965973399999) * g[29];
    y[5] += tf * g[14] + tg * f[14];
    y[14] += tf * g[5] + tg * f[5];
    t := f[5] * g[14] + f[14] * g[5];
    y[9] += (0.148677009677999990) * t;
    y[1] += (-0.184674390923000000) * t;
    y[27] += (0.179311220382000010) * t;
    y[29] += (0.083004965973399999) * t;

    // [5,17]: 8,22,24,
    tf := (0.168583882832999990) * f[8] + (0.132725386548000010) * f[22] + (-0.140463346189000000) * f[24];
    tg := (0.168583882832999990) * g[8] + (0.132725386548000010) * g[22] + (-0.140463346189000000) * g[24];
    y[5] += tf * g[17] + tg * f[17];
    y[17] := tf * g[5] + tg * f[5];
    t := f[5] * g[17] + f[17] * g[5];
    y[8] += (0.168583882832999990) * t;
    y[22] += (0.132725386548000010) * t;
    y[24] += (-0.140463346189000000) * t;

    // [5,18]: 7,21,23,
    tf := (0.180223751571000010) * f[7] + (0.090297865407399994) * f[21] + (-0.132725386549000010) * f[23];
    tg := (0.180223751571000010) * g[7] + (0.090297865407399994) * g[21] + (-0.132725386549000010) * g[23];
    y[5] += tf * g[18] + tg * f[18];
    y[18] += tf * g[5] + tg * f[5];
    t := f[5] * g[18] + f[18] * g[5];
    y[7] += (0.180223751571000010) * t;
    y[21] += (0.090297865407399994) * t;
    y[23] += (-0.132725386549000010) * t;

    // [5,19]: 6,8,20,22,
    tf := (0.220728115440999990) * f[6] + (0.063718718433900007) * f[8] + (0.044869370061299998) * f[20] + (-0.090297865408399999) * f[22];
    tg := (0.220728115440999990) * g[6] + (0.063718718433900007) * g[8] + (0.044869370061299998) * g[20] + (-0.090297865408399999) * g[22];
    y[5] += tf * g[19] + tg * f[19];
    y[19] += tf * g[5] + tg * f[5];
    t := f[5] * g[19] + f[19] * g[5];
    y[6] += (0.220728115440999990) * t;
    y[8] += (0.063718718433900007) * t;
    y[20] += (0.044869370061299998) * t;
    y[22] += (-0.090297865408399999) * t;

    // [5,26]: 15,33,35,
    tf := (0.155288072035000000) * f[15] + (0.138662534056999990) * f[33] + (-0.132882365179999990) * f[35];
    tg := (0.155288072035000000) * g[15] + (0.138662534056999990) * g[33] + (-0.132882365179999990) * g[35];
    y[5] += tf * g[26] + tg * f[26];
    y[26] += tf * g[5] + tg * f[5];
    t := f[5] * g[26] + f[26] * g[5];
    y[15] += (0.155288072035000000) * t;
    y[33] += (0.138662534056999990) * t;
    y[35] += (-0.132882365179999990) * t;

    // [5,28]: 15,13,31,33,
    tf := (0.044827805096399997) * f[15] + (0.173617342584000000) * f[13] + (0.074118242118699995) * f[31] + (-0.114366930522000000) * f[33];
    tg := (0.044827805096399997) * g[15] + (0.173617342584000000) * g[13] + (0.074118242118699995) * g[31] + (-0.114366930522000000) * g[33];
    y[5] += tf * g[28] + tg * f[28];
    y[28] += tf * g[5] + tg * f[5];
    t := f[5] * g[28] + f[28] * g[5];
    y[15] += (0.044827805096399997) * t;
    y[13] += (0.173617342584000000) * t;
    y[31] += (0.074118242118699995) * t;
    y[33] += (-0.114366930522000000) * t;

    // [5,29]: 12,30,32,
    tf := (0.214317900578999990) * f[12] + (0.036165998945399999) * f[30] + (-0.074118242119099995) * f[32];
    tg := (0.214317900578999990) * g[12] + (0.036165998945399999) * g[30] + (-0.074118242119099995) * g[32];
    y[5] += tf * g[29] + tg * f[29];
    y[29] += tf * g[5] + tg * f[5];
    t := f[5] * g[29] + f[29] * g[5];
    y[12] += (0.214317900578999990) * t;
    y[30] += (0.036165998945399999) * t;
    y[32] += (-0.074118242119099995) * t;

    // [5,32]: 9,27,
    tf := (-0.044827805096799997) * f[9] + (0.114366930522000000) * f[27];
    tg := (-0.044827805096799997) * g[9] + (0.114366930522000000) * g[27];
    y[5] += tf * g[32] + tg * f[32];
    y[32] += tf * g[5] + tg * f[5];
    t := f[5] * g[32] + f[32] * g[5];
    y[9] += (-0.044827805096799997) * t;
    y[27] += (0.114366930522000000) * t;

    // [5,34]: 9,27,25,
    tf := (-0.155288072036000010) * f[9] + (-0.138662534059000000) * f[27] + (0.132882365179000010) * f[25];
    tg := (-0.155288072036000010) * g[9] + (-0.138662534059000000) * g[27] + (0.132882365179000010) * g[25];
    y[5] += tf * g[34] + tg * f[34];
    y[34] += tf * g[5] + tg * f[5];
    t := f[5] * g[34] + f[34] * g[5];
    y[9] += (-0.155288072036000010) * t;
    y[27] += (-0.138662534059000000) * t;
    y[25] += (0.132882365179000010) * t;

    // [6,6]: 0,6,20,
    tf := (0.282094797560000000) * f[0] + (0.241795553185999990) * f[20];
    tg := (0.282094797560000000) * g[0] + (0.241795553185999990) * g[20];
    y[6] += tf * g[6] + tg * f[6];
    t := f[6] * g[6];
    y[0] += (0.282094797560000000) * t;
    y[6] += (0.180223764527000010) * t;
    y[20] += (0.241795553185999990) * t;

    // [7,7]: 6,0,8,20,22,
    tf := (0.090111875786499998) * f[6] + (0.282094791773999990) * f[0] + (0.156078347227999990) * f[8] +
        (-0.161197023870999990) * f[20] + (0.180223751574000000) * f[22];
    tg := (0.090111875786499998) * g[6] + (0.282094791773999990) * g[0] + (0.156078347227999990) * g[8] +
        (-0.161197023870999990) * g[20] + (0.180223751574000000) * g[22];
    y[7] += tf * g[7] + tg * f[7];
    t := f[7] * g[7];
    y[6] += (0.090111875786499998) * t;
    y[0] += (0.282094791773999990) * t;
    y[8] += (0.156078347227999990) * t;
    y[20] += (-0.161197023870999990) * t;
    y[22] += (0.180223751574000000) * t;

    // [7,10]: 9,1,11,27,29,
    tf := (0.148677009678999990) * f[9] + (0.184674390919999990) * f[1] + (0.115164716490000000) * f[11] +
        (0.179311220383999990) * f[27] + (-0.083004965974099995) * f[29];
    tg := (0.148677009678999990) * g[9] + (0.184674390919999990) * g[1] + (0.115164716490000000) * g[11] +
        (0.179311220383999990) * g[27] + (-0.083004965974099995) * g[29];
    y[7] += tf * g[10] + tg * f[10];
    y[10] += tf * g[7] + tg * f[7];
    t := f[7] * g[10] + f[10] * g[7];
    y[9] += (0.148677009678999990) * t;
    y[1] += (0.184674390919999990) * t;
    y[11] += (0.115164716490000000) * t;
    y[27] += (0.179311220383999990) * t;
    y[29] += (-0.083004965974099995) * t;

    // [7,13]: 12,2,14,30,32,
    tf := (0.059470803871800003) * f[12] + (0.233596680327000010) * f[2] + (0.115164716491000000) * f[14] +
        (-0.169433177294000010) * f[30] + (0.173617342585000000) * f[32];
    tg := (0.059470803871800003) * g[12] + (0.233596680327000010) * g[2] + (0.115164716491000000) * g[14] +
        (-0.169433177294000010) * g[30] + (0.173617342585000000) * g[32];
    y[7] += tf * g[13] + tg * f[13];
    y[13] += tf * g[7] + tg * f[7];
    t := f[7] * g[13] + f[13] * g[7];
    y[12] += (0.059470803871800003) * t;
    y[2] += (0.233596680327000010) * t;
    y[14] += (0.115164716491000000) * t;
    y[30] += (-0.169433177294000010) * t;
    y[32] += (0.173617342585000000) * t;

    // [7,14]: 3,15,31,33,
    tf := (0.184674390923000000) * f[3] + (0.148677009677999990) * f[15] + (-0.083004965973399999) * f[31] + (0.179311220382000010) * f[33];
    tg := (0.184674390923000000) * g[3] + (0.148677009677999990) * g[15] + (-0.083004965973399999) * g[31] + (0.179311220382000010) * g[33];
    y[7] += tf * g[14] + tg * f[14];
    y[14] += tf * g[7] + tg * f[7];
    t := f[7] * g[14] + f[14] * g[7];
    y[3] += (0.184674390923000000) * t;
    y[15] += (0.148677009677999990) * t;
    y[31] += (-0.083004965973399999) * t;
    y[33] += (0.179311220382000010) * t;

    // [7,17]: 16,4,18,
    tf := (0.140463346187999990) * f[16] + (0.168583882835000000) * f[4] + (0.132725386549000010) * f[18];
    tg := (0.140463346187999990) * g[16] + (0.168583882835000000) * g[4] + (0.132725386549000010) * g[18];
    y[7] += tf * g[17] + tg * f[17];
    y[17] += tf * g[7] + tg * f[7];
    t := f[7] * g[17] + f[17] * g[7];
    y[16] += (0.140463346187999990) * t;
    y[4] += (0.168583882835000000) * t;
    y[18] += (0.132725386549000010) * t;

    // [7,21]: 8,20,6,22,
    tf := (-0.063718718433900007) * f[8] + (0.044869370061299998) * f[20] + (0.220728115440999990) * f[6] + (0.090297865408399999) * f[22];
    tg := (-0.063718718433900007) * g[8] + (0.044869370061299998) * g[20] + (0.220728115440999990) * g[6] + (0.090297865408399999) * g[22];
    y[7] += tf * g[21] + tg * f[21];
    y[21] += tf * g[7] + tg * f[7];
    t := f[7] * g[21] + f[21] * g[7];
    y[8] += (-0.063718718433900007) * t;
    y[20] += (0.044869370061299998) * t;
    y[6] += (0.220728115440999990) * t;
    y[22] += (0.090297865408399999) * t;

    // [7,23]: 8,22,24,
    tf := (0.168583882832999990) * f[8] + (0.132725386548000010) * f[22] + (0.140463346189000000) * f[24];
    tg := (0.168583882832999990) * g[8] + (0.132725386548000010) * g[22] + (0.140463346189000000) * g[24];
    y[7] += tf * g[23] + tg * f[23];
    y[23] += tf * g[7] + tg * f[7];
    t := f[7] * g[23] + f[23] * g[7];
    y[8] += (0.168583882832999990) * t;
    y[22] += (0.132725386548000010) * t;
    y[24] += (0.140463346189000000) * t;

    // [7,26]: 9,25,27,
    tf := (0.155288072035000000) * f[9] + (0.132882365179999990) * f[25] + (0.138662534056999990) * f[27];
    tg := (0.155288072035000000) * g[9] + (0.132882365179999990) * g[25] + (0.138662534056999990) * g[27];
    y[7] += tf * g[26] + tg * f[26];
    y[26] += tf * g[7] + tg * f[7];
    t := f[7] * g[26] + f[26] * g[7];
    y[9] += (0.155288072035000000) * t;
    y[25] += (0.132882365179999990) * t;
    y[27] += (0.138662534056999990) * t;

    // [7,28]: 27,11,9,29,
    tf := (0.114366930522000000) * f[27] + (0.173617342584000000) * f[11] + (-0.044827805096399997) * f[9] + (0.074118242118699995) * f[29];
    tg := (0.114366930522000000) * g[27] + (0.173617342584000000) * g[11] + (-0.044827805096399997) * g[9] + (0.074118242118699995) * g[29];
    y[7] += tf * g[28] + tg * f[28];
    y[28] += tf * g[7] + tg * f[7];
    t := f[7] * g[28] + f[28] * g[7];
    y[27] += (0.114366930522000000) * t;
    y[11] += (0.173617342584000000) * t;
    y[9] += (-0.044827805096399997) * t;
    y[29] += (0.074118242118699995) * t;

    // [7,31]: 30,12,32,
    tf := (0.036165998945399999) * f[30] + (0.214317900578999990) * f[12] + (0.074118242119099995) * f[32];
    tg := (0.036165998945399999) * g[30] + (0.214317900578999990) * g[12] + (0.074118242119099995) * g[32];
    y[7] += tf * g[31] + tg * f[31];
    y[31] += tf * g[7] + tg * f[7];
    t := f[7] * g[31] + f[31] * g[7];
    y[30] += (0.036165998945399999) * t;
    y[12] += (0.214317900578999990) * t;
    y[32] += (0.074118242119099995) * t;

    // [7,32]: 15,33,
    tf := (-0.044827805096799997) * f[15] + (0.114366930522000000) * f[33];
    tg := (-0.044827805096799997) * g[15] + (0.114366930522000000) * g[33];
    y[7] += tf * g[32] + tg * f[32];
    y[32] += tf * g[7] + tg * f[7];
    t := f[7] * g[32] + f[32] * g[7];
    y[15] += (-0.044827805096799997) * t;
    y[33] += (0.114366930522000000) * t;

    // [7,34]: 15,33,35,
    tf := (0.155288072036000010) * f[15] + (0.138662534059000000) * f[33] + (0.132882365179000010) * f[35];
    tg := (0.155288072036000010) * g[15] + (0.138662534059000000) * g[33] + (0.132882365179000010) * g[35];
    y[7] += tf * g[34] + tg * f[34];
    y[34] += tf * g[7] + tg * f[7];
    t := f[7] * g[34] + f[34] * g[7];
    y[15] += (0.155288072036000010) * t;
    y[33] += (0.138662534059000000) * t;
    y[35] += (0.132882365179000010) * t;

    // [8,8]: 0,6,20,24,
    tf := (0.282094791770000020) * f[0] + (-0.180223751576000010) * f[6] + (0.040299255967500003) * f[20] + (0.238413613505999990) * f[24];
    tg := (0.282094791770000020) * g[0] + (-0.180223751576000010) * g[6] + (0.040299255967500003) * g[20] + (0.238413613505999990) * g[24];
    y[8] += tf * g[8] + tg * f[8];
    t := f[8] * g[8];
    y[0] += (0.282094791770000020) * t;
    y[6] += (-0.180223751576000010) * t;
    y[20] += (0.040299255967500003) * t;
    y[24] += (0.238413613505999990) * t;

    // [8,9]: 1,11,25,29,
    tf := (0.226179013155000000) * f[1] + (-0.094031597259499999) * f[11] + (0.245532000541000000) * f[25] + (0.016943317729199998) * f[29];
    tg := (0.226179013155000000) * g[1] + (-0.094031597259499999) * g[11] + (0.245532000541000000) * g[25] + (0.016943317729199998) * g[29];
    y[8] += tf * g[9] + tg * f[9];
    y[9] += tf * g[8] + tg * f[8];
    t := f[8] * g[9] + f[9] * g[8];
    y[1] += (0.226179013155000000) * t;
    y[11] += (-0.094031597259499999) * t;
    y[25] += (0.245532000541000000) * t;
    y[29] += (0.016943317729199998) * t;

    // [8,14]: 2,12,30,34,
    tf := (0.184674390919999990) * f[2] + (-0.188063194517999990) * f[12] + (0.053579475144400000) * f[30] + (0.190188269816000010) * f[34];
    tg := (0.184674390919999990) * g[2] + (-0.188063194517999990) * g[12] + (0.053579475144400000) * g[30] + (0.190188269816000010) * g[34];
    y[8] += tf * g[14] + tg * f[14];
    y[14] += tf * g[8] + tg * f[8];
    t := f[8] * g[14] + f[14] * g[8];
    y[2] += (0.184674390919999990) * t;
    y[12] += (-0.188063194517999990) * t;
    y[30] += (0.053579475144400000) * t;
    y[34] += (0.190188269816000010) * t;

    // [8,15]: 13,3,31,35,
    tf := (-0.094031597259499999) * f[13] + (0.226179013155000000) * f[3] + (0.016943317729199998) * f[31] + (0.245532000541000000) * f[35];
    tg := (-0.094031597259499999) * g[13] + (0.226179013155000000) * g[3] + (0.016943317729199998) * g[31] + (0.245532000541000000) * g[35];
    y[8] += tf * g[15] + tg * f[15];
    y[15] += tf * g[8] + tg * f[8];
    t := f[8] * g[15] + f[15] * g[8];
    y[13] += (-0.094031597259499999) * t;
    y[3] += (0.226179013155000000) * t;
    y[31] += (0.016943317729199998) * t;
    y[35] += (0.245532000541000000) * t;

    // [8,22]: 6,20,24,
    tf := (0.156078347226000000) * f[6] + (-0.190364615029000010) * f[20] + (-0.075080816691500005) * f[24];
    tg := (0.156078347226000000) * g[6] + (-0.190364615029000010) * g[20] + (-0.075080816691500005) * g[24];
    y[8] += tf * g[22] + tg * f[22];
    y[22] += tf * g[8] + tg * f[8];
    t := f[8] * g[22] + f[22] * g[8];
    y[6] += (0.156078347226000000) * t;
    y[20] += (-0.190364615029000010) * t;
    y[24] += (-0.075080816691500005) * t;

    // [8,26]: 10,28,
    tf := (0.190188269806999990) * f[10] + (-0.097043558542400002) * f[28];
    tg := (0.190188269806999990) * g[10] + (-0.097043558542400002) * g[28];
    y[8] += tf * g[26] + tg * f[26];
    y[26] += tf * g[8] + tg * f[8];
    t := f[8] * g[26] + f[26] * g[8];
    y[10] += (0.190188269806999990) * t;
    y[28] += (-0.097043558542400002) * t;

    // [8,27]: 25,11,29,
    tf := (-0.062641347680800000) * f[25] + (0.141757966609000000) * f[11] + (-0.121034582550000010) * f[29];
    tg := (-0.062641347680800000) * g[25] + (0.141757966609000000) * g[11] + (-0.121034582550000010) * g[29];
    y[8] += tf * g[27] + tg * f[27];
    y[27] += tf * g[8] + tg * f[8];
    t := f[8] * g[27] + f[27] * g[8];
    y[25] += (-0.062641347680800000) * t;
    y[11] += (0.141757966609000000) * t;
    y[29] += (-0.121034582550000010) * t;

    // [8,32]: 30,12,34,
    tf := (-0.191372478254000000) * f[30] + (0.141757966609000000) * f[12] + (-0.097043558538899996) * f[34];
    tg := (-0.191372478254000000) * g[30] + (0.141757966609000000) * g[12] + (-0.097043558538899996) * g[34];
    y[8] += tf * g[32] + tg * f[32];
    y[32] += tf * g[8] + tg * f[8];
    t := f[8] * g[32] + f[32] * g[8];
    y[30] += (-0.191372478254000000) * t;
    y[12] += (0.141757966609000000) * t;
    y[34] += (-0.097043558538899996) * t;

    // [8,33]: 13,31,35,
    tf := (0.141757966609000000) * f[13] + (-0.121034582550000010) * f[31] + (-0.062641347680800000) * f[35];
    tg := (0.141757966609000000) * g[13] + (-0.121034582550000010) * g[31] + (-0.062641347680800000) * g[35];
    y[8] += tf * g[33] + tg * f[33];
    y[33] += tf * g[8] + tg * f[8];
    t := f[8] * g[33] + f[33] * g[8];
    y[13] += (0.141757966609000000) * t;
    y[31] += (-0.121034582550000010) * t;
    y[35] += (-0.062641347680800000) * t;

    // [9,9]: 6,0,20,
    tf := (-0.210261043508000010) * f[6] + (0.282094791766999970) * f[0] + (0.076934943209800002) * f[20];
    tg := (-0.210261043508000010) * g[6] + (0.282094791766999970) * g[0] + (0.076934943209800002) * g[20];
    y[9] += tf * g[9] + tg * f[9];
    t := f[9] * g[9];
    y[6] += (-0.210261043508000010) * t;
    y[0] += (0.282094791766999970) * t;
    y[20] += (0.076934943209800002) * t;

    // [9,17]: 2,12,30,
    tf := (0.162867503964999990) * f[2] + (-0.203550726872999990) * f[12] + (0.098140130728100003) * f[30];
    tg := (0.162867503964999990) * g[2] + (-0.203550726872999990) * g[12] + (0.098140130728100003) * g[30];
    y[9] += tf * g[17] + tg * f[17];
    y[17] += tf * g[9] + tg * f[9];
    t := f[9] * g[17] + f[17] * g[9];
    y[2] += (0.162867503964999990) * t;
    y[12] += (-0.203550726872999990) * t;
    y[30] += (0.098140130728100003) * t;

    // [9,18]: 3,13,31,35,
    tf := (-0.043528171377799997) * f[3] + (0.133255230519000010) * f[13] + (-0.101584686310000010) * f[31] + (0.098140130731999994) * f[35];
    tg := (-0.043528171377799997) * g[3] + (0.133255230519000010) * g[13] + (-0.101584686310000010) * g[31] + (0.098140130731999994) * g[35];
    y[9] += tf * g[18] + tg * f[18];
    y[18] += tf * g[9] + tg * f[9];
    t := f[9] * g[18] + f[18] * g[9];
    y[3] += (-0.043528171377799997) * t;
    y[13] += (0.133255230519000010) * t;
    y[31] += (-0.101584686310000010) * t;
    y[35] += (0.098140130731999994) * t;

    // [9,19]: 14,32,34,
    tf := (-0.099322584600699995) * f[14] + (0.126698363970000010) * f[32] + (0.131668802180999990) * f[34];
    tg := (-0.099322584600699995) * g[14] + (0.126698363970000010) * g[32] + (0.131668802180999990) * g[34];
    y[9] += tf * g[19] + tg * f[19];
    y[19] += tf * g[9] + tg * f[9];
    t := f[9] * g[19] + f[19] * g[9];
    y[14] += (-0.099322584600699995) * t;
    y[32] += (0.126698363970000010) * t;
    y[34] += (0.131668802180999990) * t;

    // [9,22]: 1,11,25,29,
    tf := (-0.043528171378199997) * f[1] + (0.133255230518000010) * f[11] + (-0.098140130732499997) * f[25] + (-0.101584686311000000) * f[29];
    tg := (-0.043528171378199997) * g[1] + (0.133255230518000010) * g[11] + (-0.098140130732499997) * g[25] + (-0.101584686311000000) * g[29];
    y[9] += tf * g[22] + tg * f[22];
    y[22] += tf * g[9] + tg * f[9];
    t := f[9] * g[22] + f[22] * g[9];
    y[1] += (-0.043528171378199997) * t;
    y[11] += (0.133255230518000010) * t;
    y[25] += (-0.098140130732499997) * t;
    y[29] += (-0.101584686311000000) * t;

    // [9,27]: 6,20,
    tf := (0.126792179874999990) * f[6] + (-0.196280261464999990) * f[20];
    tg := (0.126792179874999990) * g[6] + (-0.196280261464999990) * g[20];
    y[9] += tf * g[27] + tg * f[27];
    y[27] += tf * g[9] + tg * f[9];
    t := f[9] * g[27] + f[27] * g[9];
    y[6] += (0.126792179874999990) * t;
    y[20] += (-0.196280261464999990) * t;

    // [10,10]: 0,20,24,
    tf := (0.282094791771999980) * f[0] + (-0.179514867494000000) * f[20] + (-0.151717754049000010) * f[24];
    tg := (0.282094791771999980) * g[0] + (-0.179514867494000000) * g[20] + (-0.151717754049000010) * g[24];
    y[10] += tf * g[10] + tg * f[10];
    t := f[10] * g[10];
    y[0] += (0.282094791771999980) * t;
    y[20] += (-0.179514867494000000) * t;
    y[24] += (-0.151717754049000010) * t;

    // [10,16]: 14,32,
    tf := (0.151717754044999990) * f[14] + (-0.077413979111300005) * f[32];
    tg := (0.151717754044999990) * g[14] + (-0.077413979111300005) * g[32];
    y[10] += tf * g[16] + tg * f[16];
    y[16] += tf * g[10] + tg * f[10];
    t := f[10] * g[16] + f[16] * g[10];
    y[14] += (0.151717754044999990) * t;
    y[32] += (-0.077413979111300005) * t;

    // [10,17]: 13,3,31,35,
    tf := (0.067850242288900006) * f[13] + (0.199471140200000010) * f[3] + (-0.113793659091000000) * f[31] + (-0.149911525925999990) * f[35];
    tg := (0.067850242288900006) * g[13] + (0.199471140200000010) * g[3] + (-0.113793659091000000) * g[31] + (-0.149911525925999990) * g[35];
    y[10] += tf * g[17] + tg * f[17];
    y[17] += tf * g[10] + tg * f[10];
    t := f[10] * g[17] + f[17] * g[10];
    y[13] += (0.067850242288900006) * t;
    y[3] += (0.199471140200000010) * t;
    y[31] += (-0.113793659091000000) * t;
    y[35] += (-0.149911525925999990) * t;

    // [10,18]: 12,2,30,34,
    tf := (-0.044418410173299998) * f[12] + (0.213243618621000000) * f[2] + (-0.171327458205000000) * f[30] + (-0.101358691177000000) * f[34];
    tg := (-0.044418410173299998) * g[12] + (0.213243618621000000) * g[2] + (-0.171327458205000000) * g[30] + (-0.101358691177000000) * g[34];
    y[10] += tf * g[18] + tg * f[18];
    y[18] += tf * g[10] + tg * f[10];
    t := f[10] * g[18] + f[18] * g[10];
    y[12] += (-0.044418410173299998) * t;
    y[2] += (0.213243618621000000) * t;
    y[30] += (-0.171327458205000000) * t;
    y[34] += (-0.101358691177000000) * t;

    // [10,19]: 3,15,13,31,33,
    tf := (-0.075393004386799994) * f[3] + (0.099322584599600000) * f[15] + (0.102579924281000000) * f[13] +
        (0.097749909976500002) * f[31] + (-0.025339672794100002) * f[33];
    tg := (-0.075393004386799994) * g[3] + (0.099322584599600000) * g[15] + (0.102579924281000000) * g[13] +
        (0.097749909976500002) * g[31] + (-0.025339672794100002) * g[33];
    y[10] += tf * g[19] + tg * f[19];
    y[19] += tf * g[10] + tg * f[10];
    t := f[10] * g[19] + f[19] * g[10];
    y[3] += (-0.075393004386799994) * t;
    y[15] += (0.099322584599600000) * t;
    y[13] += (0.102579924281000000) * t;
    y[31] += (0.097749909976500002) * t;
    y[33] += (-0.025339672794100002) * t;

    // [10,21]: 11,1,9,27,29,
    tf := (0.102579924281000000) * f[11] + (-0.075393004386799994) * f[1] + (-0.099322584599600000) * f[9] +
        (0.025339672794100002) * f[27] + (0.097749909976500002) * f[29];
    tg := (0.102579924281000000) * g[11] + (-0.075393004386799994) * g[1] + (-0.099322584599600000) * g[9] +
        (0.025339672794100002) * g[27] + (0.097749909976500002) * g[29];
    y[10] += tf * g[21] + tg * f[21];
    y[21] += tf * g[10] + tg * f[10];
    t := f[10] * g[21] + f[21] * g[10];
    y[11] += (0.102579924281000000) * t;
    y[1] += (-0.075393004386799994) * t;
    y[9] += (-0.099322584599600000) * t;
    y[27] += (0.025339672794100002) * t;
    y[29] += (0.097749909976500002) * t;

    // [10,23]: 11,1,25,29,
    tf := (-0.067850242288900006) * f[11] + (-0.199471140200000010) * f[1] + (0.149911525925999990) * f[25] + (0.113793659091000000) * f[29];
    tg := (-0.067850242288900006) * g[11] + (-0.199471140200000010) * g[1] + (0.149911525925999990) * g[25] + (0.113793659091000000) * g[29];
    y[10] += tf * g[23] + tg * f[23];
    y[23] += tf * g[10] + tg * f[10];
    t := f[10] * g[23] + f[23] * g[10];
    y[11] += (-0.067850242288900006) * t;
    y[1] += (-0.199471140200000010) * t;
    y[25] += (0.149911525925999990) * t;
    y[29] += (0.113793659091000000) * t;

    // [10,28]: 6,20,24,
    tf := (0.190188269814000000) * f[6] + (-0.065426753820500005) * f[20] + (0.077413979109600004) * f[24];
    tg := (0.190188269814000000) * g[6] + (-0.065426753820500005) * g[20] + (0.077413979109600004) * g[24];
    y[10] += tf * g[28] + tg * f[28];
    y[28] += tf * g[10] + tg * f[10];
    t := f[10] * g[28] + f[28] * g[10];
    y[6] += (0.190188269814000000) * t;
    y[20] += (-0.065426753820500005) * t;
    y[24] += (0.077413979109600004) * t;

    // [11,11]: 0,6,8,20,22,
    tf := (0.282094791773999990) * f[0] + (0.126156626101000010) * f[6] + (-0.145673124078999990) * f[8] +
        (0.025644981070299999) * f[20] + (-0.114687841910000000) * f[22];
    tg := (0.282094791773999990) * g[0] + (0.126156626101000010) * g[6] + (-0.145673124078999990) * g[8] +
        (0.025644981070299999) * g[20] + (-0.114687841910000000) * g[22];
    y[11] += tf * g[11] + tg * f[11];
    t := f[11] * g[11];
    y[0] += (0.282094791773999990) * t;
    y[6] += (0.126156626101000010) * t;
    y[8] += (-0.145673124078999990) * t;
    y[20] += (0.025644981070299999) * t;
    y[22] += (-0.114687841910000000) * t;

    // [11,16]: 15,33,35,
    tf := (-0.117520066953000000) * f[15] + (0.119929220739999990) * f[33] + (0.134084945035999990) * f[35];
    tg := (-0.117520066953000000) * g[15] + (0.119929220739999990) * g[33] + (0.134084945035999990) * g[35];
    y[11] += tf * g[16] + tg * f[16];
    y[16] += tf * g[11] + tg * f[11];
    t := f[11] * g[16] + f[16] * g[11];
    y[15] += (-0.117520066953000000) * t;
    y[33] += (0.119929220739999990) * t;
    y[35] += (0.134084945035999990) * t;

    // [11,18]: 3,13,15,31,33,
    tf := (0.168583882834000000) * f[3] + (0.114687841909000000) * f[13] + (-0.133255230519000010) * f[15] +
        (0.075189952564900006) * f[31] + (-0.101990215611000000) * f[33];
    tg := (0.168583882834000000) * g[3] + (0.114687841909000000) * g[13] + (-0.133255230519000010) * g[15] +
        (0.075189952564900006) * g[31] + (-0.101990215611000000) * g[33];
    y[11] += tf * g[18] + tg * f[18];
    y[18] += tf * g[11] + tg * f[11];
    t := f[11] * g[18] + f[18] * g[11];
    y[3] += (0.168583882834000000) * t;
    y[13] += (0.114687841909000000) * t;
    y[15] += (-0.133255230519000010) * t;
    y[31] += (0.075189952564900006) * t;
    y[33] += (-0.101990215611000000) * t;

    // [11,19]: 2,14,12,30,32,
    tf := (0.238413613504000000) * f[2] + (-0.102579924282000000) * f[14] + (0.099322584599300004) * f[12] +
        (0.009577496073830001) * f[30] + (-0.104682806112000000) * f[32];
    tg := (0.238413613504000000) * g[2] + (-0.102579924282000000) * g[14] + (0.099322584599300004) * g[12] +
        (0.009577496073830001) * g[30] + (-0.104682806112000000) * g[32];
    y[11] += tf * g[19] + tg * f[19];
    y[19] += tf * g[11] + tg * f[11];
    t := f[11] * g[19] + f[19] * g[11];
    y[2] += (0.238413613504000000) * t;
    y[14] += (-0.102579924282000000) * t;
    y[12] += (0.099322584599300004) * t;
    y[30] += (0.009577496073830001) * t;
    y[32] += (-0.104682806112000000) * t;

    // [11,24]: 9,25,27,
    tf := (0.117520066950999990) * f[9] + (-0.134084945037000000) * f[25] + (-0.119929220742000010) * f[27];
    tg := (0.117520066950999990) * g[9] + (-0.134084945037000000) * g[25] + (-0.119929220742000010) * g[27];
    y[11] += tf * g[24] + tg * f[24];
    y[24] += tf * g[11] + tg * f[11];
    t := f[11] * g[24] + f[24] * g[11];
    y[9] += (0.117520066950999990) * t;
    y[25] += (-0.134084945037000000) * t;
    y[27] += (-0.119929220742000010) * t;

    // [11,29]: 6,20,22,8,
    tf := (0.227318461243000010) * f[6] + (0.086019920779800002) * f[20] + (-0.075189952565200002) * f[22] + (0.065621187395299999) * f[8];
    tg := (0.227318461243000010) * g[6] + (0.086019920779800002) * g[20] + (-0.075189952565200002) * g[22] + (0.065621187395299999) * g[8];
    y[11] += tf * g[29] + tg * f[29];
    y[29] += tf * g[11] + tg * f[11];
    t := f[11] * g[29] + f[29] * g[11];
    y[6] += (0.227318461243000010) * t;
    y[20] += (0.086019920779800002) * t;
    y[22] += (-0.075189952565200002) * t;
    y[8] += (0.065621187395299999) * t;

    // [12,12]: 0,6,20,
    tf := (0.282094799871999980) * f[0] + (0.168208852954000010) * f[6] + (0.153869910786000010) * f[20];
    tg := (0.282094799871999980) * g[0] + (0.168208852954000010) * g[6] + (0.153869910786000010) * g[20];
    y[12] += tf * g[12] + tg * f[12];
    t := f[12] * g[12];
    y[0] += (0.282094799871999980) * t;
    y[6] += (0.168208852954000010) * t;
    y[20] += (0.153869910786000010) * t;

    // [12,30]: 20,6,
    tf := (0.148373961712999990) * f[20] + (0.239614719999000000) * f[6];
    tg := (0.148373961712999990) * g[20] + (0.239614719999000000) * g[6];
    y[12] += tf * g[30] + tg * f[30];
    y[30] += tf * g[12] + tg * f[12];
    t := f[12] * g[30] + f[30] * g[12];
    y[20] += (0.148373961712999990) * t;
    y[6] += (0.239614719999000000) * t;

    // [13,13]: 0,8,6,20,22,
    tf := (0.282094791773999990) * f[0] + (0.145673124078999990) * f[8] + (0.126156626101000010) * f[6] +
        (0.025644981070299999) * f[20] + (0.114687841910000000) * f[22];
    tg := (0.282094791773999990) * g[0] + (0.145673124078999990) * g[8] + (0.126156626101000010) * g[6] +
        (0.025644981070299999) * g[20] + (0.114687841910000000) * g[22];
    y[13] += tf * g[13] + tg * f[13];
    t := f[13] * g[13];
    y[0] += (0.282094791773999990) * t;
    y[8] += (0.145673124078999990) * t;
    y[6] += (0.126156626101000010) * t;
    y[20] += (0.025644981070299999) * t;
    y[22] += (0.114687841910000000) * t;

    // [13,16]: 9,25,27,
    tf := (-0.117520066953000000) * f[9] + (-0.134084945035999990) * f[25] + (0.119929220739999990) * f[27];
    tg := (-0.117520066953000000) * g[9] + (-0.134084945035999990) * g[25] + (0.119929220739999990) * g[27];
    y[13] += tf * g[16] + tg * f[16];
    y[16] += tf * g[13] + tg * f[13];
    t := f[13] * g[16] + f[16] * g[13];
    y[9] += (-0.117520066953000000) * t;
    y[25] += (-0.134084945035999990) * t;
    y[27] += (0.119929220739999990) * t;

    // [13,21]: 2,12,14,30,32,
    tf := (0.238413613504000000) * f[2] + (0.099322584599300004) * f[12] + (0.102579924282000000) * f[14] +
        (0.009577496073830001) * f[30] + (0.104682806112000000) * f[32];
    tg := (0.238413613504000000) * g[2] + (0.099322584599300004) * g[12] + (0.102579924282000000) * g[14] +
        (0.009577496073830001) * g[30] + (0.104682806112000000) * g[32];
    y[13] += tf * g[21] + tg * f[21];
    y[21] += tf * g[13] + tg * f[13];
    t := f[13] * g[21] + f[21] * g[13];
    y[2] += (0.238413613504000000) * t;
    y[12] += (0.099322584599300004) * t;
    y[14] += (0.102579924282000000) * t;
    y[30] += (0.009577496073830001) * t;
    y[32] += (0.104682806112000000) * t;

    // [13,24]: 15,33,35,
    tf := (-0.117520066950999990) * f[15] + (0.119929220742000010) * f[33] + (-0.134084945037000000) * f[35];
    tg := (-0.117520066950999990) * g[15] + (0.119929220742000010) * g[33] + (-0.134084945037000000) * g[35];
    y[13] += tf * g[24] + tg * f[24];
    y[24] += tf * g[13] + tg * f[13];
    t := f[13] * g[24] + f[24] * g[13];
    y[15] += (-0.117520066950999990) * t;
    y[33] += (0.119929220742000010) * t;
    y[35] += (-0.134084945037000000) * t;

    // [13,31]: 6,22,20,8,
    tf := (0.227318461243000010) * f[6] + (0.075189952565200002) * f[22] + (0.086019920779800002) * f[20] + (-0.065621187395299999) * f[8];
    tg := (0.227318461243000010) * g[6] + (0.075189952565200002) * g[22] + (0.086019920779800002) * g[20] + (-0.065621187395299999) * g[8];
    y[13] += tf * g[31] + tg * f[31];
    y[31] += tf * g[13] + tg * f[13];
    t := f[13] * g[31] + f[31] * g[13];
    y[6] += (0.227318461243000010) * t;
    y[22] += (0.075189952565200002) * t;
    y[20] += (0.086019920779800002) * t;
    y[8] += (-0.065621187395299999) * t;

    // [14,14]: 0,20,24,
    tf := (0.282094791771999980) * f[0] + (-0.179514867494000000) * f[20] + (0.151717754049000010) * f[24];
    tg := (0.282094791771999980) * g[0] + (-0.179514867494000000) * g[20] + (0.151717754049000010) * g[24];
    y[14] += tf * g[14] + tg * f[14];
    t := f[14] * g[14];
    y[0] += (0.282094791771999980) * t;
    y[20] += (-0.179514867494000000) * t;
    y[24] += (0.151717754049000010) * t;

    // [14,17]: 11,1,25,29,
    tf := (0.067850242288500007) * f[11] + (0.199471140196999990) * f[1] + (0.149911525925999990) * f[25] + (-0.113793659092000000) * f[29];
    tg := (0.067850242288500007) * g[11] + (0.199471140196999990) * g[1] + (0.149911525925999990) * g[25] + (-0.113793659092000000) * g[29];
    y[14] += tf * g[17] + tg * f[17];
    y[17] += tf * g[14] + tg * f[14];
    t := f[14] * g[17] + f[17] * g[14];
    y[11] += (0.067850242288500007) * t;
    y[1] += (0.199471140196999990) * t;
    y[25] += (0.149911525925999990) * t;
    y[29] += (-0.113793659092000000) * t;

    // [14,22]: 12,2,30,34,
    tf := (-0.044418410173299998) * f[12] + (0.213243618621000000) * f[2] + (-0.171327458205000000) * f[30] + (0.101358691177000000) * f[34];
    tg := (-0.044418410173299998) * g[12] + (0.213243618621000000) * g[2] + (-0.171327458205000000) * g[30] + (0.101358691177000000) * g[34];
    y[14] += tf * g[22] + tg * f[22];
    y[22] += tf * g[14] + tg * f[14];
    t := f[14] * g[22] + f[22] * g[14];
    y[12] += (-0.044418410173299998) * t;
    y[2] += (0.213243618621000000) * t;
    y[30] += (-0.171327458205000000) * t;
    y[34] += (0.101358691177000000) * t;

    // [14,23]: 13,3,31,35,
    tf := (0.067850242288500007) * f[13] + (0.199471140196999990) * f[3] + (-0.113793659092000000) * f[31] + (0.149911525925999990) * f[35];
    tg := (0.067850242288500007) * g[13] + (0.199471140196999990) * g[3] + (-0.113793659092000000) * g[31] + (0.149911525925999990) * g[35];
    y[14] += tf * g[23] + tg * f[23];
    y[23] += tf * g[14] + tg * f[14];
    t := f[14] * g[23] + f[23] * g[14];
    y[13] += (0.067850242288500007) * t;
    y[3] += (0.199471140196999990) * t;
    y[31] += (-0.113793659092000000) * t;
    y[35] += (0.149911525925999990) * t;

    // [14,32]: 20,6,24,
    tf := (-0.065426753820500005) * f[20] + (0.190188269814000000) * f[6] + (-0.077413979109600004) * f[24];
    tg := (-0.065426753820500005) * g[20] + (0.190188269814000000) * g[6] + (-0.077413979109600004) * g[24];
    y[14] += tf * g[32] + tg * f[32];
    y[32] += tf * g[14] + tg * f[14];
    t := f[14] * g[32] + f[32] * g[14];
    y[20] += (-0.065426753820500005) * t;
    y[6] += (0.190188269814000000) * t;
    y[24] += (-0.077413979109600004) * t;

    // [15,15]: 0,6,20,
    tf := (0.282094791766999970) * f[0] + (-0.210261043508000010) * f[6] + (0.076934943209800002) * f[20];
    tg := (0.282094791766999970) * g[0] + (-0.210261043508000010) * g[6] + (0.076934943209800002) * g[20];
    y[15] += tf * g[15] + tg * f[15];
    t := f[15] * g[15];
    y[0] += (0.282094791766999970) * t;
    y[6] += (-0.210261043508000010) * t;
    y[20] += (0.076934943209800002) * t;

    // [15,21]: 14,32,34,
    tf := (-0.099322584600699995) * f[14] + (0.126698363970000010) * f[32] + (-0.131668802180999990) * f[34];
    tg := (-0.099322584600699995) * g[14] + (0.126698363970000010) * g[32] + (-0.131668802180999990) * g[34];
    y[15] += tf * g[21] + tg * f[21];
    y[21] += tf * g[15] + tg * f[15];
    t := f[15] * g[21] + f[21] * g[15];
    y[14] += (-0.099322584600699995) * t;
    y[32] += (0.126698363970000010) * t;
    y[34] += (-0.131668802180999990) * t;

    // [15,22]: 13,3,31,35,
    tf := (0.133255230518000010) * f[13] + (-0.043528171378199997) * f[3] + (-0.101584686311000000) * f[31] + (-0.098140130732499997) * f[35];
    tg := (0.133255230518000010) * g[13] + (-0.043528171378199997) * g[3] + (-0.101584686311000000) * g[31] + (-0.098140130732499997) * g[35];
    y[15] += tf * g[22] + tg * f[22];
    y[22] += tf * g[15] + tg * f[15];
    t := f[15] * g[22] + f[22] * g[15];
    y[13] += (0.133255230518000010) * t;
    y[3] += (-0.043528171378199997) * t;
    y[31] += (-0.101584686311000000) * t;
    y[35] += (-0.098140130732499997) * t;

    // [15,23]: 12,2,30,
    tf := (-0.203550726872999990) * f[12] + (0.162867503964999990) * f[2] + (0.098140130728100003) * f[30];
    tg := (-0.203550726872999990) * g[12] + (0.162867503964999990) * g[2] + (0.098140130728100003) * g[30];
    y[15] += tf * g[23] + tg * f[23];
    y[23] += tf * g[15] + tg * f[15];
    t := f[15] * g[23] + f[23] * g[15];
    y[12] += (-0.203550726872999990) * t;
    y[2] += (0.162867503964999990) * t;
    y[30] += (0.098140130728100003) * t;

    // [15,33]: 6,20,
    tf := (0.126792179874999990) * f[6] + (-0.196280261464999990) * f[20];
    tg := (0.126792179874999990) * g[6] + (-0.196280261464999990) * g[20];
    y[15] += tf * g[33] + tg * f[33];
    y[33] += tf * g[15] + tg * f[15];
    t := f[15] * g[33] + f[33] * g[15];
    y[6] += (0.126792179874999990) * t;
    y[20] += (-0.196280261464999990) * t;

    // [16,16]: 0,6,20,
    tf := (0.282094791763999990) * f[0] + (-0.229375683829000000) * f[6] + (0.106525305981000000) * f[20];
    tg := (0.282094791763999990) * g[0] + (-0.229375683829000000) * g[6] + (0.106525305981000000) * g[20];
    y[16] += tf * g[16] + tg * f[16];
    t := f[16] * g[16];
    y[0] += (0.282094791763999990) * t;
    y[6] += (-0.229375683829000000) * t;
    y[20] += (0.106525305981000000) * t;

    // [16,18]: 8,22,
    tf := (-0.075080816693699995) * f[8] + (0.135045473380000000) * f[22];
    tg := (-0.075080816693699995) * g[8] + (0.135045473380000000) * g[22];
    y[16] += tf * g[18] + tg * f[18];
    y[18] += tf * g[16] + tg * f[16];
    t := f[16] * g[18] + f[18] * g[16];
    y[8] += (-0.075080816693699995) * t;
    y[22] += (0.135045473380000000) * t;

    // [16,23]: 19,5,
    tf := (-0.119098912754999990) * f[19] + (0.140463346187999990) * f[5];
    tg := (-0.119098912754999990) * g[19] + (0.140463346187999990) * g[5];
    y[16] += tf * g[23] + tg * f[23];
    y[23] += tf * g[16] + tg * f[16];
    t := f[16] * g[23] + f[23] * g[16];
    y[19] += (-0.119098912754999990) * t;
    y[5] += (0.140463346187999990) * t;

    // [16,26]: 12,2,30,
    tf := (-0.207723503645000000) * f[12] + (0.147319200325000010) * f[2] + (0.130197596199999990) * f[30];
    tg := (-0.207723503645000000) * g[12] + (0.147319200325000010) * g[2] + (0.130197596199999990) * g[30];
    y[16] += tf * g[26] + tg * f[26];
    y[26] += tf * g[16] + tg * f[16];
    t := f[16] * g[26] + f[26] * g[16];
    y[12] += (-0.207723503645000000) * t;
    y[2] += (0.147319200325000010) * t;
    y[30] += (0.130197596199999990) * t;

    // [16,28]: 14,32,
    tf := (-0.077413979111300005) * f[14] + (0.128376561115000010) * f[32];
    tg := (-0.077413979111300005) * g[14] + (0.128376561115000010) * g[32];
    y[16] += tf * g[28] + tg * f[28];
    y[28] += tf * g[16] + tg * f[16];
    t := f[16] * g[28] + f[28] * g[16];
    y[14] += (-0.077413979111300005) * t;
    y[32] += (0.128376561115000010) * t;

    // [16,29]: 15,33,35,
    tf := (0.035835708931099997) * f[15] + (-0.118853600623999990) * f[33] + (-0.053152946071899999) * f[35];
    tg := (0.035835708931099997) * g[15] + (-0.118853600623999990) * g[33] + (-0.053152946071899999) * g[35];
    y[16] += tf * g[29] + tg * f[29];
    y[29] += tf * g[16] + tg * f[16];
    t := f[16] * g[29] + f[29] * g[16];
    y[15] += (0.035835708931099997) * t;
    y[33] += (-0.118853600623999990) * t;
    y[35] += (-0.053152946071899999) * t;

    // [16,31]: 27,9,25,
    tf := (-0.118853600623999990) * f[27] + (0.035835708931099997) * f[9] + (0.053152946071899999) * f[25];
    tg := (-0.118853600623999990) * g[27] + (0.035835708931099997) * g[9] + (0.053152946071899999) * g[25];
    y[16] += tf * g[31] + tg * f[31];
    y[31] += tf * g[16] + tg * f[16];
    t := f[16] * g[31] + f[31] * g[16];
    y[27] += (-0.118853600623999990) * t;
    y[9] += (0.035835708931099997) * t;
    y[25] += (0.053152946071899999) * t;

    // [17,17]: 0,6,20,
    tf := (0.282094791768999990) * f[0] + (-0.057343920955899998) * f[6] + (-0.159787958979000000) * f[20];
    tg := (0.282094791768999990) * g[0] + (-0.057343920955899998) * g[6] + (-0.159787958979000000) * g[20];
    y[17] += tf * g[17] + tg * f[17];
    t := f[17] * g[17];
    y[0] += (0.282094791768999990) * t;
    y[6] += (-0.057343920955899998) * t;
    y[20] += (-0.159787958979000000) * t;

    // [17,19]: 8,22,24,
    tf := (-0.112621225039000000) * f[8] + (0.045015157794100001) * f[22] + (0.119098912753000000) * f[24];
    tg := (-0.112621225039000000) * g[8] + (0.045015157794100001) * g[22] + (0.119098912753000000) * g[24];
    y[17] += tf * g[19] + tg * f[19];
    y[19] += tf * g[17] + tg * f[17];
    t := f[17] * g[19] + f[19] * g[17];
    y[8] += (-0.112621225039000000) * t;
    y[22] += (0.045015157794100001) * t;
    y[24] += (0.119098912753000000) * t;

    // [17,21]: 16,4,18,
    tf := (-0.119098912754999990) * f[16] + (-0.112621225039000000) * f[4] + (0.045015157794399997) * f[18];
    tg := (-0.119098912754999990) * g[16] + (-0.112621225039000000) * g[4] + (0.045015157794399997) * g[18];
    y[17] += tf * g[21] + tg * f[21];
    y[21] += tf * g[17] + tg * f[17];
    t := f[17] * g[21] + f[21] * g[17];
    y[16] += (-0.119098912754999990) * t;
    y[4] += (-0.112621225039000000) * t;
    y[18] += (0.045015157794399997) * t;

    // [17,26]: 3,13,31,
    tf := (0.208340811096000000) * f[3] + (0.029982305185199998) * f[13] + (-0.118853600623999990) * f[31];
    tg := (0.208340811096000000) * g[3] + (0.029982305185199998) * g[13] + (-0.118853600623999990) * g[31];
    y[17] += tf * g[26] + tg * f[26];
    y[26] += tf * g[17] + tg * f[17];
    t := f[17] * g[26] + f[26] * g[17];
    y[3] += (0.208340811096000000) * t;
    y[13] += (0.029982305185199998) * t;
    y[31] += (-0.118853600623999990) * t;

    // [17,27]: 12,2,30,
    tf := (-0.103861751821000010) * f[12] + (0.196425600433000000) * f[2] + (-0.130197596204999990) * f[30];
    tg := (-0.103861751821000010) * g[12] + (0.196425600433000000) * g[2] + (-0.130197596204999990) * g[30];
    y[17] += tf * g[27] + tg * f[27];
    y[27] += tf * g[17] + tg * f[17];
    t := f[17] * g[27] + f[27] * g[17];
    y[12] += (-0.103861751821000010) * t;
    y[2] += (0.196425600433000000) * t;
    y[30] += (-0.130197596204999990) * t;

    // [17,28]: 13,3,31,35,
    tf := (0.121172043789000000) * f[13] + (-0.060142811686500000) * f[3] + (0.034310079156700000) * f[31] + (0.099440056652200001) * f[35];
    tg := (0.121172043789000000) * g[13] + (-0.060142811686500000) * g[3] + (0.034310079156700000) * g[31] + (0.099440056652200001) * g[35];
    y[17] += tf * g[28] + tg * f[28];
    y[28] += tf * g[17] + tg * f[17];
    t := f[17] * g[28] + f[28] * g[17];
    y[13] += (0.121172043789000000) * t;
    y[3] += (-0.060142811686500000) * t;
    y[31] += (0.034310079156700000) * t;
    y[35] += (0.099440056652200001) * t;

    // [17,32]: 11,1,25,29,
    tf := (0.121172043788000010) * f[11] + (-0.060142811686900000) * f[1] + (-0.099440056652700004) * f[25] + (0.034310079156599997) * f[29];
    tg := (0.121172043788000010) * g[11] + (-0.060142811686900000) * g[1] + (-0.099440056652700004) * g[25] + (0.034310079156599997) * g[29];
    y[17] += tf * g[32] + tg * f[32];
    y[32] += tf * g[17] + tg * f[17];
    t := f[17] * g[32] + f[32] * g[17];
    y[11] += (0.121172043788000010) * t;
    y[1] += (-0.060142811686900000) * t;
    y[25] += (-0.099440056652700004) * t;
    y[29] += (0.034310079156599997) * t;

    // [17,34]: 29,11,1,
    tf := (0.118853600623000000) * f[29] + (-0.029982305185400002) * f[11] + (-0.208340811100000000) * f[1];
    tg := (0.118853600623000000) * g[29] + (-0.029982305185400002) * g[11] + (-0.208340811100000000) * g[1];
    y[17] += tf * g[34] + tg * f[34];
    y[34] += tf * g[17] + tg * f[17];
    t := f[17] * g[34] + f[34] * g[17];
    y[29] += (0.118853600623000000) * t;
    y[11] += (-0.029982305185400002) * t;
    y[1] += (-0.208340811100000000) * t;

    // [18,18]: 6,0,20,24,
    tf := (0.065535909662600006) * f[6] + (0.282094791771999980) * f[0] + (-0.083698454702400005) * f[20] + (-0.135045473384000000) * f[24];
    tg := (0.065535909662600006) * g[6] + (0.282094791771999980) * g[0] + (-0.083698454702400005) * g[20] + (-0.135045473384000000) * g[24];
    y[18] += tf * g[18] + tg * f[18];
    t := f[18] * g[18];
    y[6] += (0.065535909662600006) * t;
    y[0] += (0.282094791771999980) * t;
    y[20] += (-0.083698454702400005) * t;
    y[24] += (-0.135045473384000000) * t;

    // [18,19]: 7,21,23,
    tf := (0.090297865407399994) * f[7] + (0.102084782359000000) * f[21] + (-0.045015157794399997) * f[23];
    tg := (0.090297865407399994) * g[7] + (0.102084782359000000) * g[21] + (-0.045015157794399997) * g[23];
    y[18] += tf * g[19] + tg * f[19];
    y[19] += tf * g[18] + tg * f[18];
    t := f[18] * g[19] + f[19] * g[18];
    y[7] += (0.090297865407399994) * t;
    y[21] += (0.102084782359000000) * t;
    y[23] += (-0.045015157794399997) * t;

    // [18,25]: 15,33,
    tf := (-0.098140130731999994) * f[15] + (0.130197596202000000) * f[33];
    tg := (-0.098140130731999994) * g[15] + (0.130197596202000000) * g[33];
    y[18] += tf * g[25] + tg * f[25];
    y[25] += tf * g[18] + tg * f[18];
    t := f[18] * g[25] + f[25] * g[18];
    y[15] += (-0.098140130731999994) * t;
    y[33] += (0.130197596202000000) * t;

    // [18,26]: 14,32,
    tf := (0.101358691174000000) * f[14] + (0.084042186965900004) * f[32];
    tg := (0.101358691174000000) * g[14] + (0.084042186965900004) * g[32];
    y[18] += tf * g[26] + tg * f[26];
    y[26] += tf * g[18] + tg * f[18];
    t := f[18] * g[26] + f[26] * g[18];
    y[14] += (0.101358691174000000) * t;
    y[32] += (0.084042186965900004) * t;

    // [18,27]: 13,3,35,
    tf := (0.101990215611000000) * f[13] + (0.183739324705999990) * f[3] + (-0.130197596202000000) * f[35];
    tg := (0.101990215611000000) * g[13] + (0.183739324705999990) * g[3] + (-0.130197596202000000) * g[35];
    y[18] += tf * g[27] + tg * f[27];
    y[27] += tf * g[18] + tg * f[18];
    t := f[18] * g[27] + f[27] * g[18];
    y[13] += (0.101990215611000000) * t;
    y[3] += (0.183739324705999990) * t;
    y[35] += (-0.130197596202000000) * t;

    // [18,28]: 2,12,30,34,
    tf := (0.225033795606000010) * f[2] + (0.022664492358099999) * f[12] + (-0.099440056651100006) * f[30] + (-0.084042186968800003) * f[34];
    tg := (0.225033795606000010) * g[2] + (0.022664492358099999) * g[12] + (-0.099440056651100006) * g[30] + (-0.084042186968800003) * g[34];
    y[18] += tf * g[28] + tg * f[28];
    y[28] += tf * g[18] + tg * f[18];
    t := f[18] * g[28] + f[28] * g[18];
    y[2] += (0.225033795606000010) * t;
    y[12] += (0.022664492358099999) * t;
    y[30] += (-0.099440056651100006) * t;
    y[34] += (-0.084042186968800003) * t;

    // [18,29]: 3,13,15,31,
    tf := (-0.085054779966799998) * f[3] + (0.075189952564900006) * f[13] + (0.101584686310000010) * f[15] + (0.097043558538999999) * f[31];
    tg := (-0.085054779966799998) * g[3] + (0.075189952564900006) * g[13] + (0.101584686310000010) * g[15] + (0.097043558538999999) * g[31];
    y[18] += tf * g[29] + tg * f[29];
    y[29] += tf * g[18] + tg * f[18];
    t := f[18] * g[29] + f[29] * g[18];
    y[3] += (-0.085054779966799998) * t;
    y[13] += (0.075189952564900006) * t;
    y[15] += (0.101584686310000010) * t;
    y[31] += (0.097043558538999999) * t;

    // [19,19]: 6,8,0,20,22,
    tf := (0.139263808033999990) * f[6] + (-0.141889406570999990) * f[8] + (0.282094791773999990) * f[0] +
        (0.068480553847200004) * f[20] + (-0.102084782360000000) * f[22];
    tg := (0.139263808033999990) * g[6] + (-0.141889406570999990) * g[8] + (0.282094791773999990) * g[0] +
        (0.068480553847200004) * g[20] + (-0.102084782360000000) * g[22];
    y[19] += tf * g[19] + tg * f[19];
    t := f[19] * g[19];
    y[6] += (0.139263808033999990) * t;
    y[8] += (-0.141889406570999990) * t;
    y[0] += (0.282094791773999990) * t;
    y[20] += (0.068480553847200004) * t;
    y[22] += (-0.102084782360000000) * t;

    // [19,25]: 34,
    tf := (-0.130197596205999990) * f[34];
    tg := (-0.130197596205999990) * g[34];
    y[19] += tf * g[25] + tg * f[25];
    y[25] += tf * g[19] + tg * f[19];
    t := f[19] * g[25] + f[25] * g[19];
    y[34] += (-0.130197596205999990) * t;

    // [19,26]: 15,35,
    tf := (-0.131668802182000000) * f[15] + (0.130197596204999990) * f[35];
    tg := (-0.131668802182000000) * g[15] + (0.130197596204999990) * g[35];
    y[19] += tf * g[26] + tg * f[26];
    y[26] += tf * g[19] + tg * f[19];
    t := f[19] * g[26] + f[26] * g[19];
    y[15] += (-0.131668802182000000) * t;
    y[35] += (0.130197596204999990) * t;

    // [19,27]: 14,32,
    tf := (0.025339672793899998) * f[14] + (0.084042186967699994) * f[32];
    tg := (0.025339672793899998) * g[14] + (0.084042186967699994) * g[32];
    y[19] += tf * g[27] + tg * f[27];
    y[27] += tf * g[19] + tg * f[19];
    t := f[19] * g[27] + f[27] * g[19];
    y[14] += (0.025339672793899998) * t;
    y[32] += (0.084042186967699994) * t;

    // [19,28]: 13,3,15,31,33,
    tf := (0.104682806111000000) * f[13] + (0.159122922869999990) * f[3] + (-0.126698363970000010) * f[15] +
        (0.090775936911399999) * f[31] + (-0.084042186968400004) * f[33];
    tg := (0.104682806111000000) * g[13] + (0.159122922869999990) * g[3] + (-0.126698363970000010) * g[15] +
        (0.090775936911399999) * g[31] + (-0.084042186968400004) * g[33];
    y[19] += tf * g[28] + tg * f[28];
    y[28] += tf * g[19] + tg * f[19];
    t := f[19] * g[28] + f[28] * g[19];
    y[13] += (0.104682806111000000) * t;
    y[3] += (0.159122922869999990) * t;
    y[15] += (-0.126698363970000010) * t;
    y[31] += (0.090775936911399999) * t;
    y[33] += (-0.084042186968400004) * t;

    // [19,29]: 12,14,2,30,32,
    tf := (0.115089467124000010) * f[12] + (-0.097749909977199997) * f[14] + (0.240571246744999990) * f[2] +
        (0.053152946072499999) * f[30] + (-0.090775936912099994) * f[32];
    tg := (0.115089467124000010) * g[12] + (-0.097749909977199997) * g[14] + (0.240571246744999990) * g[2] +
        (0.053152946072499999) * g[30] + (-0.090775936912099994) * g[32];
    y[19] += tf * g[29] + tg * f[29];
    y[29] += tf * g[19] + tg * f[19];
    t := f[19] * g[29] + f[29] * g[19];
    y[12] += (0.115089467124000010) * t;
    y[14] += (-0.097749909977199997) * t;
    y[2] += (0.240571246744999990) * t;
    y[30] += (0.053152946072499999) * t;
    y[32] += (-0.090775936912099994) * t;

    // [20,20]: 6,0,20,
    tf := (0.163839797503000010) * f[6] + (0.282094802232000010) * f[0];
    tg := (0.163839797503000010) * g[6] + (0.282094802232000010) * g[0];
    y[20] += tf * g[20] + tg * f[20];
    t := f[20] * g[20];
    y[6] += (0.163839797503000010) * t;
    y[0] += (0.282094802232000010) * t;
    y[20] += (0.136961139005999990) * t;

    // [21,21]: 6,20,0,8,22,
    tf := (0.139263808033999990) * f[6] + (0.068480553847200004) * f[20] + (0.282094791773999990) * f[0] +
        (0.141889406570999990) * f[8] + (0.102084782360000000) * f[22];
    tg := (0.139263808033999990) * g[6] + (0.068480553847200004) * g[20] + (0.282094791773999990) * g[0] +
        (0.141889406570999990) * g[8] + (0.102084782360000000) * g[22];
    y[21] += tf * g[21] + tg * f[21];
    t := f[21] * g[21];
    y[6] += (0.139263808033999990) * t;
    y[20] += (0.068480553847200004) * t;
    y[0] += (0.282094791773999990) * t;
    y[8] += (0.141889406570999990) * t;
    y[22] += (0.102084782360000000) * t;

    // [21,23]: 8,22,24,
    tf := (-0.112621225039000000) * f[8] + (0.045015157794100001) * f[22] + (-0.119098912753000000) * f[24];
    tg := (-0.112621225039000000) * g[8] + (0.045015157794100001) * g[22] + (-0.119098912753000000) * g[24];
    y[21] += tf * g[23] + tg * f[23];
    y[23] += tf * g[21] + tg * f[21];
    t := f[21] * g[23] + f[23] * g[21];
    y[8] += (-0.112621225039000000) * t;
    y[22] += (0.045015157794100001) * t;
    y[24] += (-0.119098912753000000) * t;

    // [21,26]: 9,25,
    tf := (-0.131668802182000000) * f[9] + (-0.130197596204999990) * f[25];
    tg := (-0.131668802182000000) * g[9] + (-0.130197596204999990) * g[25];
    y[21] += tf * g[26] + tg * f[26];
    y[26] += tf * g[21] + tg * f[21];
    t := f[21] * g[26] + f[26] * g[21];
    y[9] += (-0.131668802182000000) * t;
    y[25] += (-0.130197596204999990) * t;

    // [21,28]: 27,1,11,9,29,
    tf := (0.084042186968400004) * f[27] + (0.159122922869999990) * f[1] + (0.104682806111000000) * f[11] +
        (0.126698363970000010) * f[9] + (0.090775936911399999) * f[29];
    tg := (0.084042186968400004) * g[27] + (0.159122922869999990) * g[1] + (0.104682806111000000) * g[11] +
        (0.126698363970000010) * g[9] + (0.090775936911399999) * g[29];
    y[21] += tf * g[28] + tg * f[28];
    y[28] += tf * g[21] + tg * f[21];
    t := f[21] * g[28] + f[28] * g[21];
    y[27] += (0.084042186968400004) * t;
    y[1] += (0.159122922869999990) * t;
    y[11] += (0.104682806111000000) * t;
    y[9] += (0.126698363970000010) * t;
    y[29] += (0.090775936911399999) * t;

    // [21,31]: 14,2,30,12,32,
    tf := (0.097749909977199997) * f[14] + (0.240571246744999990) * f[2] + (0.053152946072499999) * f[30] +
        (0.115089467124000010) * f[12] + (0.090775936912099994) * f[32];
    tg := (0.097749909977199997) * g[14] + (0.240571246744999990) * g[2] + (0.053152946072499999) * g[30] +
        (0.115089467124000010) * g[12] + (0.090775936912099994) * g[32];
    y[21] += tf * g[31] + tg * f[31];
    y[31] += tf * g[21] + tg * f[21];
    t := f[21] * g[31] + f[31] * g[21];
    y[14] += (0.097749909977199997) * t;
    y[2] += (0.240571246744999990) * t;
    y[30] += (0.053152946072499999) * t;
    y[12] += (0.115089467124000010) * t;
    y[32] += (0.090775936912099994) * t;

    // [21,33]: 32,14,
    tf := (0.084042186967699994) * f[32] + (0.025339672793899998) * f[14];
    tg := (0.084042186967699994) * g[32] + (0.025339672793899998) * g[14];
    y[21] += tf * g[33] + tg * f[33];
    y[33] += tf * g[21] + tg * f[21];
    t := f[21] * g[33] + f[33] * g[21];
    y[32] += (0.084042186967699994) * t;
    y[14] += (0.025339672793899998) * t;

    // [21,34]: 35,
    tf := (-0.130197596205999990) * f[35];
    tg := (-0.130197596205999990) * g[35];
    y[21] += tf * g[34] + tg * f[34];
    y[34] += tf * g[21] + tg * f[21];
    t := f[21] * g[34] + f[34] * g[21];
    y[35] += (-0.130197596205999990) * t;

    // [22,22]: 6,20,0,24,
    tf := (0.065535909662600006) * f[6] + (-0.083698454702400005) * f[20] + (0.282094791771999980) * f[0] + (0.135045473384000000) * f[24];
    tg := (0.065535909662600006) * g[6] + (-0.083698454702400005) * g[20] + (0.282094791771999980) * g[0] + (0.135045473384000000) * g[24];
    y[22] += tf * g[22] + tg * f[22];
    t := f[22] * g[22];
    y[6] += (0.065535909662600006) * t;
    y[20] += (-0.083698454702400005) * t;
    y[0] += (0.282094791771999980) * t;
    y[24] += (0.135045473384000000) * t;

    // [22,26]: 10,28,
    tf := (0.101358691174000000) * f[10] + (0.084042186965900004) * f[28];
    tg := (0.101358691174000000) * g[10] + (0.084042186965900004) * g[28];
    y[22] += tf * g[26] + tg * f[26];
    y[26] += tf * g[22] + tg * f[22];
    t := f[22] * g[26] + f[26] * g[22];
    y[10] += (0.101358691174000000) * t;
    y[28] += (0.084042186965900004) * t;

    // [22,27]: 1,11,25,
    tf := (0.183739324704000010) * f[1] + (0.101990215611000000) * f[11] + (0.130197596200999990) * f[25];
    tg := (0.183739324704000010) * g[1] + (0.101990215611000000) * g[11] + (0.130197596200999990) * g[25];
    y[22] += tf * g[27] + tg * f[27];
    y[27] += tf * g[22] + tg * f[22];
    t := f[22] * g[27] + f[27] * g[22];
    y[1] += (0.183739324704000010) * t;
    y[11] += (0.101990215611000000) * t;
    y[25] += (0.130197596200999990) * t;

    // [22,32]: 2,30,12,34,
    tf := (0.225033795606000010) * f[2] + (-0.099440056651100006) * f[30] + (0.022664492358099999) * f[12] + (0.084042186968800003) * f[34];
    tg := (0.225033795606000010) * g[2] + (-0.099440056651100006) * g[30] + (0.022664492358099999) * g[12] + (0.084042186968800003) * g[34];
    y[22] += tf * g[32] + tg * f[32];
    y[32] += tf * g[22] + tg * f[22];
    t := f[22] * g[32] + f[32] * g[22];
    y[2] += (0.225033795606000010) * t;
    y[30] += (-0.099440056651100006) * t;
    y[12] += (0.022664492358099999) * t;
    y[34] += (0.084042186968800003) * t;

    // [22,33]: 3,13,35,
    tf := (0.183739324704000010) * f[3] + (0.101990215611000000) * f[13] + (0.130197596200999990) * f[35];
    tg := (0.183739324704000010) * g[3] + (0.101990215611000000) * g[13] + (0.130197596200999990) * g[35];
    y[22] += tf * g[33] + tg * f[33];
    y[33] += tf * g[22] + tg * f[22];
    t := f[22] * g[33] + f[33] * g[22];
    y[3] += (0.183739324704000010) * t;
    y[13] += (0.101990215611000000) * t;
    y[35] += (0.130197596200999990) * t;

    // [23,23]: 6,20,0,
    tf := (-0.057343920955899998) * f[6] + (-0.159787958979000000) * f[20] + (0.282094791768999990) * f[0];
    tg := (-0.057343920955899998) * g[6] + (-0.159787958979000000) * g[20] + (0.282094791768999990) * g[0];
    y[23] += tf * g[23] + tg * f[23];
    t := f[23] * g[23];
    y[6] += (-0.057343920955899998) * t;
    y[20] += (-0.159787958979000000) * t;
    y[0] += (0.282094791768999990) * t;

    // [23,26]: 1,11,29,
    tf := (0.208340811096000000) * f[1] + (0.029982305185199998) * f[11] + (-0.118853600623999990) * f[29];
    tg := (0.208340811096000000) * g[1] + (0.029982305185199998) * g[11] + (-0.118853600623999990) * g[29];
    y[23] += tf * g[26] + tg * f[26];
    y[26] += tf * g[23] + tg * f[23];
    t := f[23] * g[26] + f[26] * g[23];
    y[1] += (0.208340811096000000) * t;
    y[11] += (0.029982305185199998) * t;
    y[29] += (-0.118853600623999990) * t;

    // [23,28]: 25,11,1,29,
    tf := (-0.099440056652200001) * f[25] + (-0.121172043789000000) * f[11] + (0.060142811686500000) * f[1] + (-0.034310079156700000) * f[29];
    tg := (-0.099440056652200001) * g[25] + (-0.121172043789000000) * g[11] + (0.060142811686500000) * g[1] + (-0.034310079156700000) * g[29];
    y[23] += tf * g[28] + tg * f[28];
    y[28] += tf * g[23] + tg * f[23];
    t := f[23] * g[28] + f[28] * g[23];
    y[25] += (-0.099440056652200001) * t;
    y[11] += (-0.121172043789000000) * t;
    y[1] += (0.060142811686500000) * t;
    y[29] += (-0.034310079156700000) * t;

    // [23,32]: 31,13,3,35,
    tf := (0.034310079156599997) * f[31] + (0.121172043788000010) * f[13] + (-0.060142811686900000) * f[3] + (-0.099440056652700004) * f[35];
    tg := (0.034310079156599997) * g[31] + (0.121172043788000010) * g[13] + (-0.060142811686900000) * g[3] + (-0.099440056652700004) * g[35];
    y[23] += tf * g[32] + tg * f[32];
    y[32] += tf * g[23] + tg * f[23];
    t := f[23] * g[32] + f[32] * g[23];
    y[31] += (0.034310079156599997) * t;
    y[13] += (0.121172043788000010) * t;
    y[3] += (-0.060142811686900000) * t;
    y[35] += (-0.099440056652700004) * t;

    // [23,33]: 2,30,12,
    tf := (0.196425600433000000) * f[2] + (-0.130197596204999990) * f[30] + (-0.103861751821000010) * f[12];
    tg := (0.196425600433000000) * g[2] + (-0.130197596204999990) * g[30] + (-0.103861751821000010) * g[12];
    y[23] += tf * g[33] + tg * f[33];
    y[33] += tf * g[23] + tg * f[23];
    t := f[23] * g[33] + f[33] * g[23];
    y[2] += (0.196425600433000000) * t;
    y[30] += (-0.130197596204999990) * t;
    y[12] += (-0.103861751821000010) * t;

    // [23,34]: 3,13,31,
    tf := (0.208340811100000000) * f[3] + (0.029982305185400002) * f[13] + (-0.118853600623000000) * f[31];
    tg := (0.208340811100000000) * g[3] + (0.029982305185400002) * g[13] + (-0.118853600623000000) * g[31];
    y[23] += tf * g[34] + tg * f[34];
    y[34] += tf * g[23] + tg * f[23];
    t := f[23] * g[34] + f[34] * g[23];
    y[3] += (0.208340811100000000) * t;
    y[13] += (0.029982305185400002) * t;
    y[31] += (-0.118853600623000000) * t;

    // [24,24]: 6,0,20,
    tf := (-0.229375683829000000) * f[6] + (0.282094791763999990) * f[0] + (0.106525305981000000) * f[20];
    tg := (-0.229375683829000000) * g[6] + (0.282094791763999990) * g[0] + (0.106525305981000000) * g[20];
    y[24] += tf * g[24] + tg * f[24];
    t := f[24] * g[24];
    y[6] += (-0.229375683829000000) * t;
    y[0] += (0.282094791763999990) * t;
    y[20] += (0.106525305981000000) * t;

    // [24,29]: 9,27,25,
    tf := (-0.035835708931400000) * f[9] + (0.118853600623000000) * f[27] + (0.053152946071199997) * f[25];
    tg := (-0.035835708931400000) * g[9] + (0.118853600623000000) * g[27] + (0.053152946071199997) * g[25];
    y[24] += tf * g[29] + tg * f[29];
    y[29] += tf * g[24] + tg * f[24];
    t := f[24] * g[29] + f[29] * g[24];
    y[9] += (-0.035835708931400000) * t;
    y[27] += (0.118853600623000000) * t;
    y[25] += (0.053152946071199997) * t;

    // [24,31]: 15,33,35,
    tf := (0.035835708931400000) * f[15] + (-0.118853600623000000) * f[33] + (0.053152946071199997) * f[35];
    tg := (0.035835708931400000) * g[15] + (-0.118853600623000000) * g[33] + (0.053152946071199997) * g[35];
    y[24] += tf * g[31] + tg * f[31];
    y[31] += tf * g[24] + tg * f[24];
    t := f[24] * g[31] + f[31] * g[24];
    y[15] += (0.035835708931400000) * t;
    y[33] += (-0.118853600623000000) * t;
    y[35] += (0.053152946071199997) * t;

    // [24,34]: 12,30,2,
    tf := (-0.207723503645000000) * f[12] + (0.130197596199999990) * f[30] + (0.147319200325000010) * f[2];
    tg := (-0.207723503645000000) * g[12] + (0.130197596199999990) * g[30] + (0.147319200325000010) * g[2];
    y[24] += tf * g[34] + tg * f[34];
    y[34] += tf * g[24] + tg * f[24];
    t := f[24] * g[34] + f[34] * g[24];
    y[12] += (-0.207723503645000000) * t;
    y[30] += (0.130197596199999990) * t;
    y[2] += (0.147319200325000010) * t;

    // [25,25]: 0,6,20,
    tf := (0.282094791761999970) * f[0] + (-0.242608896358999990) * f[6] + (0.130197596198000000) * f[20];
    tg := (0.282094791761999970) * g[0] + (-0.242608896358999990) * g[6] + (0.130197596198000000) * g[20];
    y[25] += tf * g[25] + tg * f[25];
    t := f[25] * g[25];
    y[0] += (0.282094791761999970) * t;
    y[6] += (-0.242608896358999990) * t;
    y[20] += (0.130197596198000000) * t;

    // [26,26]: 6,20,0,
    tf := (-0.097043558542400002) * f[6] + (-0.130197596207000000) * f[20] + (0.282094791766000000) * f[0];
    tg := (-0.097043558542400002) * g[6] + (-0.130197596207000000) * g[20] + (0.282094791766000000) * g[0];
    y[26] += tf * g[26] + tg * f[26];
    t := f[26] * g[26];
    y[6] += (-0.097043558542400002) * t;
    y[20] += (-0.130197596207000000) * t;
    y[0] += (0.282094791766000000) * t;

    // [27,27]: 0,20,6,
    tf := (0.282094791770000020) * f[0] + (-0.130197596204999990) * f[20] + (0.016173926423100001) * f[6];
    tg := (0.282094791770000020) * g[0] + (-0.130197596204999990) * g[20] + (0.016173926423100001) * g[6];
    y[27] += tf * g[27] + tg * f[27];
    t := f[27] * g[27];
    y[0] += (0.282094791770000020) * t;
    y[20] += (-0.130197596204999990) * t;
    y[6] += (0.016173926423100001) * t;

    // [28,28]: 6,0,20,24,
    tf := (0.097043558538800007) * f[6] + (0.282094791771999980) * f[0] + (-0.021699599367299999) * f[20] + (-0.128376561118000000) * f[24];
    tg := (0.097043558538800007) * g[6] + (0.282094791771999980) * g[0] + (-0.021699599367299999) * g[20] + (-0.128376561118000000) * g[24];
    y[28] += tf * g[28] + tg * f[28];
    t := f[28] * g[28];
    y[6] += (0.097043558538800007) * t;
    y[0] += (0.282094791771999980) * t;
    y[20] += (-0.021699599367299999) * t;
    y[24] += (-0.128376561118000000) * t;

    // [29,29]: 20,6,0,22,8,
    tf := (0.086798397468799998) * f[20] + (0.145565337808999990) * f[6] + (0.282094791773999990) * f[0] +
        (-0.097043558539500002) * f[22] + (-0.140070311615000000) * f[8];
    tg := (0.086798397468799998) * g[20] + (0.145565337808999990) * g[6] + (0.282094791773999990) * g[0] +
        (-0.097043558539500002) * g[22] + (-0.140070311615000000) * g[8];
    y[29] += tf * g[29] + tg * f[29];
    t := f[29] * g[29];
    y[20] += (0.086798397468799998) * t;
    y[6] += (0.145565337808999990) * t;
    y[0] += (0.282094791773999990) * t;
    y[22] += (-0.097043558539500002) * t;
    y[8] += (-0.140070311615000000) * t;

    // [30,30]: 0,20,6,
    tf := (0.282094804531000000) * f[0] + (0.130197634486000000) * f[20] + (0.161739292769000010) * f[6];
    tg := (0.282094804531000000) * g[0] + (0.130197634486000000) * g[20] + (0.161739292769000010) * g[6];
    y[30] += tf * g[30] + tg * f[30];
    t := f[30] * g[30];
    y[0] += (0.282094804531000000) * t;
    y[20] += (0.130197634486000000) * t;
    y[6] += (0.161739292769000010) * t;

    // [31,31]: 6,8,20,22,0,
    tf := (0.145565337808999990) * f[6] + (0.140070311615000000) * f[8] + (0.086798397468799998) * f[20] +
        (0.097043558539500002) * f[22] + (0.282094791773999990) * f[0];
    tg := (0.145565337808999990) * g[6] + (0.140070311615000000) * g[8] + (0.086798397468799998) * g[20] +
        (0.097043558539500002) * g[22] + (0.282094791773999990) * g[0];
    y[31] += tf * g[31] + tg * f[31];
    t := f[31] * g[31];
    y[6] += (0.145565337808999990) * t;
    y[8] += (0.140070311615000000) * t;
    y[20] += (0.086798397468799998) * t;
    y[22] += (0.097043558539500002) * t;
    y[0] += (0.282094791773999990) * t;

    // [32,32]: 0,24,20,6,
    tf := (0.282094791771999980) * f[0] + (0.128376561118000000) * f[24] + (-0.021699599367299999) * f[20] + (0.097043558538800007) * f[6];
    tg := (0.282094791771999980) * g[0] + (0.128376561118000000) * g[24] + (-0.021699599367299999) * g[20] + (0.097043558538800007) * g[6];
    y[32] += tf * g[32] + tg * f[32];
    t := f[32] * g[32];
    y[0] += (0.282094791771999980) * t;
    y[24] += (0.128376561118000000) * t;
    y[20] += (-0.021699599367299999) * t;
    y[6] += (0.097043558538800007) * t;

    // [33,33]: 6,20,0,
    tf := (0.016173926423100001) * f[6] + (-0.130197596204999990) * f[20] + (0.282094791770000020) * f[0];
    tg := (0.016173926423100001) * g[6] + (-0.130197596204999990) * g[20] + (0.282094791770000020) * g[0];
    y[33] += tf * g[33] + tg * f[33];
    t := f[33] * g[33];
    y[6] += (0.016173926423100001) * t;
    y[20] += (-0.130197596204999990) * t;
    y[0] += (0.282094791770000020) * t;

    // [34,34]: 20,6,0,
    tf := (-0.130197596207000000) * f[20] + (-0.097043558542400002) * f[6] + (0.282094791766000000) * f[0];
    tg := (-0.130197596207000000) * g[20] + (-0.097043558542400002) * g[6] + (0.282094791766000000) * g[0];
    y[34] += tf * g[34] + tg * f[34];
    t := f[34] * g[34];
    y[20] += (-0.130197596207000000) * t;
    y[6] += (-0.097043558542400002) * t;
    y[0] += (0.282094791766000000) * t;

    // [35,35]: 6,0,20,
    tf := (-0.242608896358999990) * f[6] + (0.282094791761999970) * f[0] + (0.130197596198000000) * f[20];
    tg := (-0.242608896358999990) * g[6] + (0.282094791761999970) * g[0] + (0.130197596198000000) * g[20];
    y[35] += tf * g[35] + tg * f[35];
    t := f[35] * g[35];
    y[6] += (-0.242608896358999990) * t;
    y[0] += (0.282094791761999970) * t;
    y[20] += (0.130197596198000000) * t;

    // multiply count:=2527

    Result := y;
end;

//-------------------------------------------------------------------------------------
// Evaluates a directional light and returns spectral SH data.  The output
// vector is computed so that if the intensity of R/G/B is unit the resulting
// exit radiance of a point directly under the light on a diffuse object with
// an albedo of 1 would be 1.0.  This will compute 3 spectral samples, resultR
// has to be specified, while resultG and resultB are optional.

// http://msdn.microsoft.com/en-us/library/windows/desktop/bb204988.aspx
//-------------------------------------------------------------------------------------

function XMSHEvalDirectionalLight(order: size_t; dir: TFXMVECTOR; color: TFXMVECTOR; var resultR: Psingle;
    var resultG: Psingle; var resultB: Psingle): boolean;
var
    clr: TXMFLOAT3A;
    fTmp: array [0..XM_SH_MAXORDER * XM_SH_MAXORDER - 1] of single;
    fNorm: single;
    numcoeff, i: size_t;
    fRScale, fGScale, fBScale: single;
begin
    Result := False;
    if (resultR = nil) then
        Exit;

    if (order < XM_SH_MINORDER) or (order > XM_SH_MAXORDER) then
        Exit;

    XMStoreFloat3A(clr, color);

    XMSHEvalDirection(fTmp, order, dir); // evaluate the BF in this direction...

    // now compute "normalization" and scale vector for each valid spectral band
    fNorm := XM_PI / CosWtInt(order);

    numcoeff := order * order;

    fRScale := fNorm * clr.x;

    for  i := 0 to numcoeff - 1 do
    begin
        resultR[i] := fTmp[i] * fRScale;
    end;

    if (resultG <> nil) then
    begin
        fGScale := fNorm * clr.y;

        for i := 0 to numcoeff - 1 do
        begin
            resultG[i] := fTmp[i] * fGScale;
        end;
    end;

    if (resultB <> nil) then
    begin
        fBScale := fNorm * clr.z;

        for i := 0 to numcoeff - 1 do
        begin
            resultB[i] := fTmp[i] * fBScale;
        end;
    end;

    Result := True;
end;


//------------------------------------------------------------------------------------
// Evaluates a spherical light and returns spectral SH data.  There is no
// normalization of the intensity of the light like there is for directional
// lights, care has to be taken when specifiying the intensities.  This will
// compute 3 spectral samples, resultR has to be specified, while resultG and
// resultB are optional.

// http://msdn.microsoft.com/en-us/library/windows/desktop/bb205451.aspx
//-------------------------------------------------------------------------------------

function XMSHEvalSphericalLight(order: size_t; pos: TXMVECTOR; radius: single; color: TXMVECTOR;
    {var} resultR: Psingle;
    {var} resultG: Psingle;
    {var} resultB: Psingle): boolean;
var
    dir: TXMVECTOR;
    fTmpDir: array [0..XM_SH_MAXORDER * XM_SH_MAXORDER - 1] of single;  // rotation "vector"
    fTmpL0: array[0..XM_SH_MAXORDER - 1] of single;
    vd: TXMFLOAT3A;
    fDist, fConeAngle: single;
    fNewNorm, fX, fY, fZ: single;
    clr: TXMFLOAT3A;
    i, j: integer;
    cNumCoefs, cStart: size_t;
    fValUse: single;
begin
    Result := False;
    if (resultR = nil) then
        Exit;


    if (radius < 0.0) then
        Exit;

    fDist := XMVectorGetX(XMVector3Length(pos));

    // WARNING: fDist should not be < radius - otherwise light contains origin

    //const single fSinConeAngle := (fDist <= radius) ? 0.99999f : radius/fDist;

    if (fDist <= radius) then fConeAngle := (XM_PIDIV2)
    else
        fConeAngle := arcsin(radius / fDist);

    dir := XMVector3Normalize(pos);




    // Sphere at distance fDist, the cone angle is determined by looking at the
    // right triangle with one side (the hypotenuse) beind the vector from the
    // origin to the center of the sphere, another side is from the origin to
    // a point on the sphere whose normal is perpendicular to the given side (this
    // is one of the points on the cone that is defined by the projection of the sphere
    // through the origin - we want to find the angle of this cone) and the final
    // side being from the center of the sphere to the point of tagency (the two
    // sides conected to this are at a right angle by construction.)
    // From trig we know that sin(theta) := ||opposite||/||hypotenuse||, where
    // ||opposite|| := Radius, ||hypotenuse|| := fDist
    // theta is the angle of the cone that subtends the sphere from the origin


    // no default normalization is done for this case, have to be careful how
    // you represent the coefficients...

    fNewNorm := 1.0;///(fSinConeAngle*fSinConeAngle);

    ComputeCapInt(order, fConeAngle, @fTmpL0[0]);


    XMStoreFloat3A(vd, dir);

    fX := vd.x;
    fY := vd.y;
    fZ := vd.z;

    case (order) of

        2:
            sh_eval_basis_1(fX, fY, fZ, @fTmpDir[0]);


        3:
            sh_eval_basis_2(fX, fY, fZ, @fTmpDir[0]);


        4:
            sh_eval_basis_3(fX, fY, fZ, @fTmpDir[0]);


        5:
            sh_eval_basis_4(fX, fY, fZ, @fTmpDir[0]);


        6:
            sh_eval_basis_5(fX, fY, fZ, @fTmpDir[0]);


        else
        begin
            assert((order < XM_SH_MINORDER) or (order > XM_SH_MAXORDER));
            Exit;
        end;
    end;



    XMStoreFloat3A(clr, color);

    for  i := 0 to order - 1 do
    begin
        cNumCoefs := 2 * i + 1;
        cStart := i * i;
        fValUse := fTmpL0[i] * clr.x * fNewNorm * fExtraNormFac[i];
        for j := 0 to cNumCoefs - 1 do resultR[cStart + j] := fTmpDir[cStart + j] * fValUse;
    end;

    if (resultG <> nil) then
    begin
        for  i := 0 to order - 1 do
        begin
            cNumCoefs := 2 * i + 1;
            cStart := i * i;
            fValUse := fTmpL0[i] * clr.y * fNewNorm * fExtraNormFac[i];
            for j := 0 to cNumCoefs - 1 do resultG[cStart + j] := fTmpDir[cStart + j] * fValUse;
        end;
    end;

    if (resultB <> nil) then
    begin
        for  i := 0 to order - 1 do
        begin
            cNumCoefs := 2 * i + 1;
            cStart := i * i;
            fValUse := fTmpL0[i] * clr.z * fNewNorm * fExtraNormFac[i];
            for j := 0 to cNumCoefs - 1 do resultB[cStart + j] := fTmpDir[cStart + j] * fValUse;
        end;
    end;

    Result := True;
end;



//-------------------------------------------------------------------------------------
// Evaluates a light that is a cone of constant intensity and returns spectral
// SH data.  The output vector is computed so that if the intensity of R/G/B is
// unit the resulting exit radiance of a point directly under the light oriented
// in the cone direction on a diffuse object with an albedo of 1 would be 1.0.
// This will compute 3 spectral samples, resultR has to be specified, while resultG
// and resultB are optional.

// http://msdn.microsoft.com/en-us/library/windows/desktop/bb204986.aspx
//-------------------------------------------------------------------------------------

function XMSHEvalConeLight(order: size_t; dir: TFXMVECTOR; radius: single; color: TFXMVECTOR;
    {var} resultR: psingle;
    {var} resultG: Psingle;
    {var} resultB: Psingle): boolean;
var
    fTmpL0: array [0..XM_SH_MAXORDER - 1] of single;
    fTmpDir: array [0..XM_SH_MAXORDER * XM_SH_MAXORDER - 1] of single;
    clr: TXMFLOAT3A;
    i, j: integer;
    cNumCoefs, cStart: size_t;
    fConeAngle, fAngCheck, fNewNorm, fValUse: single;
    vd: TXMFLOAT3A;
    fX, fY, fZ: single;
begin
    Result := False;
    if (resultR = nil) then
        exit;

    if (radius < 0.0) or (radius > (XM_PI * 1.00001)) then
        exit;

    if (radius < 0.0001) then
    begin
        // turn it into a pure directional light...
        Result := XMSHEvalDirectionalLight(order, dir, color, resultR, resultG, resultB);
        Exit;
    end
    else
    begin

        fConeAngle := radius;
        if (fConeAngle > XM_PIDIV2) then fAngCheck := (XM_PIDIV2)
        else
            fAngCheck := fConeAngle;

        fNewNorm := 1.0 / (sin(fAngCheck) * sin(fAngCheck));

        ComputeCapInt(order, fConeAngle, fTmpL0);

        XMStoreFloat3A(vd, dir);

        fX := vd.x;
        fY := vd.y;
        fZ := vd.z;

        case (order) of

            2:
                sh_eval_basis_1(fX, fY, fZ, @fTmpDir[0]);


            3:
                sh_eval_basis_2(fX, fY, fZ, @fTmpDir[0]);


            4:
                sh_eval_basis_3(fX, fY, fZ, @fTmpDir[0]);


            5:
                sh_eval_basis_4(fX, fY, fZ, @fTmpDir[0]);


            6:
                sh_eval_basis_5(fX, fY, fZ, @fTmpDir[0]);


            else
            begin
                assert((order < XM_SH_MINORDER) or (order > XM_SH_MAXORDER));
                Exit;
            end;
        end;



        XMStoreFloat3A(clr, color);

        for  i := 0 to order - 1 do
        begin
            cNumCoefs := 2 * i + 1;
            cStart := i * i;
            fValUse := fTmpL0[i] * clr.x * fNewNorm * fExtraNormFac[i];
            for  j := 0 to cNumCoefs - 1 do
                resultR[cStart + j] := fTmpDir[cStart + j] * fValUse;
        end;

        if (resultG <> nil) then
        begin
            for  i := 0 to order - 1 do
            begin
                cNumCoefs := 2 * i + 1;
                cStart := i * i;
                fValUse := fTmpL0[i] * clr.y * fNewNorm * fExtraNormFac[i];
                for  j := 0 to cNumCoefs - 1 do
                    resultG[cStart + j] := fTmpDir[cStart + j] * fValUse;
            end;
        end;

        if (resultB <> nil) then
        begin
            for  i := 0 to order - 1 do
            begin
                cNumCoefs := 2 * i + 1;
                cStart := i * i;
                fValUse := fTmpL0[i] * clr.z * fNewNorm * fExtraNormFac[i];
                for  j := 0 to cNumCoefs - 1 do
                    resultB[cStart + j] := fTmpDir[cStart + j] * fValUse;
            end;
        end;
    end;

    Result := True;
end;


//------------------------------------------------------------------------------------
// Evaluates a light that is a linear interpolant between two colors over the
// sphere.  The interpolant is linear along the axis of the two points, not
// over the surface of the sphere (ie: if the axis was (0,0,1) it is linear in
// Z, not in the azimuthal angle.)  The resulting spherical lighting function
// is normalized so that a point on a perfectly diffuse surface with no
// shadowing and a normal pointed in the direction pDir would result in exit
// radiance with a value of 1 if the top color was white and the bottom color
// was black.  This is a very simple model where topColor represents the intensity
// of the "sky" and bottomColor represents the intensity of the "ground".

// http://msdn.microsoft.com/en-us/library/windows/desktop/bb204989.aspx
//-------------------------------------------------------------------------------------

function XMSHEvalHemisphereLight(order: size_t; dir: TFXMVECTOR; topColor: TFXMVECTOR; bottomColor: TFXMVECTOR;
    {var} resultR: Psingle;
    {var} resultG: Psingle;
    {var} resultB: Psingle): boolean;
var
    fTmpDir: array[0..XM_SH_MAXORDER * XM_SH_MAXORDER - 1] of single;  // rotation "vector"
    fTmpL0: array [0..XM_SH_MAXORDER - 1] of single;
    vd: TXMFLOAT3A;
    fX, fY, fZ: single;
    fNewNorm: single;
    clrTop: TXMFLOAT3A;
    clrBottom: TXMFLOAT3A;
    fA, fAvrg, fValUse: single;
    i, j: integer;
    cNumCoefs, cStart: size_t;

begin
    Result := False;
    if (resultR = nil) then
        Exit;

    if ((order < XM_SH_MINORDER) or (order > XM_SH_MAXORDER)) then
        Exit;

    // seperate "R/G/B colors...


    fNewNorm := 3.0 / 2.0; // normalizes things for 1 sky color, 0 ground color...


    XMStoreFloat3A(vd, dir);

    fX := vd.x;
    fY := vd.y;
    fZ := vd.z;

    sh_eval_basis_1(fX, fY, fZ, fTmpDir);


    XMStoreFloat3A(&clrTop, topColor);

    XMStoreFloat3A(&clrBottom, bottomColor);

    fA := clrTop.x;
    fAvrg := (clrTop.x + clrBottom.x) * 0.5;

    fTmpL0[0] := fAvrg * 2.0 * SHEvalHemisphereLight_fSqrtPi;
    fTmpL0[1] := (fA - fAvrg) * 2.0 * SHEvalHemisphereLight_fSqrtPi3;


    for i := 0 to 1 do
    begin

        cNumCoefs := 2 * i + 1;
        cStart := i * i;
        fValUse := fTmpL0[i] * fNewNorm * fExtraNormFac[i];
        for  j := 0 to cNumCoefs - 1 do resultR[cStart + j] := fTmpDir[cStart + j] * fValUse;
    end;

    for i := 2 to order - 1 do
    begin
        cNumCoefs := 2 * i + 1;
        cStart := i * i;
        for  j := 0 to cNumCoefs - 1 do resultR[cStart + j] := 0.0;
    end;

    if (resultG <> nil) then
    begin
        fA := clrTop.y;
        fAvrg := (clrTop.y + clrBottom.y) * 0.5;

        fTmpL0[0] := fAvrg * 2.0 * SHEvalHemisphereLight_fSqrtPi;
        fTmpL0[1] := (fA - fAvrg) * 2.0 * SHEvalHemisphereLight_fSqrtPi3;

        for i := 0 to 1 do
        begin
            cNumCoefs := 2 * i + 1;
            cStart := i * i;
            fValUse := fTmpL0[i] * fNewNorm * fExtraNormFac[i];
            for  j := 0 to cNumCoefs - 1 do resultG[cStart + j] := fTmpDir[cStart + j] * fValUse;
        end;

        for i := 2 to order - 1 do
        begin
            cNumCoefs := 2 * i + 1;
            cStart := i * i;
            for  j := 0 to cNumCoefs - 1 do resultG[cStart + j] := 0.0;
        end;
    end;

    if (resultB <> nil) then
    begin
        fA := clrTop.z;
        fAvrg := (clrTop.z + clrBottom.z) * 0.5;

        fTmpL0[0] := fAvrg * 2.0 * SHEvalHemisphereLight_fSqrtPi;
        fTmpL0[1] := (fA - fAvrg) * 2.0 * SHEvalHemisphereLight_fSqrtPi3;

        for i := 0 to 1 do
        begin

            cNumCoefs := 2 * i + 1;
            cStart := i * i;
            fValUse := fTmpL0[i] * fNewNorm * fExtraNormFac[i];
            for  j := 0 to cNumCoefs - 1 do resultB[cStart + j] := fTmpDir[cStart + j] * fValUse;
        end;

        for i := 2 to order - 1 do
        begin
            cNumCoefs := 2 * i + 1;
            cStart := i * i;
            for  j := 0 to cNumCoefs - 1 do resultB[cStart + j] := 0.0;
        end;
    end;

    Result := True;
end;




end.
