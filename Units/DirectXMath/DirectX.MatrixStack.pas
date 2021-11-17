//-------------------------------------------------------------------------------------
// DirectXMatrixStack.h -- DirectXMath C++ Matrix Stack

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// http://go.microsoft.com/fwlink/?LinkID:=615560
//-------------------------------------------------------------------------------------

unit DirectX.MatrixStack;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows,
    DirectX.Math;

type

    PXMMATRIX = ^TXMMATRIX;

    { TMatrixStack }

    TMatrixStack = class(TObject)
    private
        m_stack: array of TXMMATRIX;
        m_stackSize: size_t;
        m_current: size_t;
    private
        procedure Allocate(newSize: size_t);
    public
        constructor Create(startSize: size_t = 16);
        destructor Destroy; override;
        function Size(): size_t;
    public
        function Top(): TXMMATRIX;
        function GetTop(): PXMMATRIX;
        procedure Pop();  // decrement stack pointer
        procedure Push(); // increment stack pointer
        procedure LoadIdentity();
        procedure LoadMatrix(matrix: TXMMATRIX);
        procedure MultiplyMatrix(matrix: TXMMATRIX);
        procedure MultiplyMatrixLocal(matrix: TXMMATRIX);
        procedure RotateX(angle: single);
        procedure RotateXLocal(angle: single);
        procedure RotateY(angle: single);
        procedure RotateYLocal(angle: single);
        procedure RotateZ(angle: single);
        procedure RotateZLocal(angle: single);
        procedure RotateAxis(axis: TXMVECTOR; angle: single);
        procedure RotateAxisLocal(axis: TXMVECTOR; angle: single);
        procedure RotateRollPitchYaw(pitch, yaw, roll: single);
        procedure RotateRollPitchYawLocal(pitch, yaw, roll: single);
        procedure RotateByQuaternion(quat: TXMVECTOR);
        procedure RotateByQuaternionLocal(quat: TXMVECTOR);
        procedure Scale(x, y, z: single);
        procedure ScaleLocal(x, y, z: single);
        procedure Translate(x, y, z: single);
        procedure TranslateLocal(x, y, z: single);
    end;

implementation

{ TMatrixStack }

procedure TMatrixStack.Allocate(newSize: size_t);
begin
    SetLength(m_stack, newSize);
    m_stackSize := newSize;
end;



constructor TMatrixStack.Create(startSize: size_t);
begin
    m_stackSize := 0;
    m_current := 0;
    m_stack := nil;

    assert(startSize > 0);
    Allocate(startSize);
    LoadIdentity();
end;



destructor TMatrixStack.Destroy;
begin
    SetLength(m_stack, 0);
    inherited Destroy;
end;



function TMatrixStack.Size(): size_t;
begin
    Result := (m_current + 1);
end;



function TMatrixStack.Top(): TXMMATRIX;
begin
    Result := m_stack[m_current];
end;



function TMatrixStack.GetTop(): PXMMATRIX;
begin
    Result := @m_stack[m_current];
end;

// decrement stack pointer

procedure TMatrixStack.Pop();
begin
    if (m_current > 0) then
        Dec(m_current);
end;


// increment stack pointer
procedure TMatrixStack.Push();
begin
    Inc(m_current);
    if (m_current >= m_stackSize) then
    begin
        Allocate(m_stackSize * 2);
    end;

    // Replicate the original top of the matrix stack.
    m_stack[m_current] := m_stack[m_current - 1];
end;

// Loads identity into the top of the matrix stack.

procedure TMatrixStack.LoadIdentity();
begin
    m_stack[m_current] := XMMatrixIdentity();
end;



// Load a matrix into the top of the matrix stack.

procedure TMatrixStack.LoadMatrix(matrix: TXMMATRIX);
begin
    m_stack[m_current] := matrix;
end;


// Multiply a matrix by the top of the stack, store result in top.
procedure TMatrixStack.MultiplyMatrix(matrix: TXMMATRIX);
begin
    m_stack[m_current] := XMMatrixMultiply(m_stack[m_current], matrix);
end;


// Pre-multiplies a matrix by the top of the stack, store result in top.
procedure TMatrixStack.MultiplyMatrixLocal(matrix: TXMMATRIX);
begin
    m_stack[m_current] := XMMatrixMultiply(matrix, m_stack[m_current]);
end;


// Add a rotation about X to stack top.
procedure TMatrixStack.RotateX(angle: single);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixRotationX(angle);
    m_stack[m_current] := XMMatrixMultiply(m_stack[m_current], mat);
end;



procedure TMatrixStack.RotateXLocal(angle: single);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixRotationX(angle);
    m_stack[m_current] := XMMatrixMultiply(mat, m_stack[m_current]);
end;


// Add a rotation about Y to stack top.
procedure TMatrixStack.RotateY(angle: single);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixRotationY(angle);
    m_stack[m_current] := XMMatrixMultiply(m_stack[m_current], mat);
end;



procedure TMatrixStack.RotateYLocal(angle: single);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixRotationY(angle);
    m_stack[m_current] := XMMatrixMultiply(mat, m_stack[m_current]);
end;


// Add a rotation about Z to stack top.
procedure TMatrixStack.RotateZ(angle: single);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixRotationZ(angle);
    m_stack[m_current] := XMMatrixMultiply(m_stack[m_current], mat);
end;



procedure TMatrixStack.RotateZLocal(angle: single);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixRotationZ(angle);
    m_stack[m_current] := XMMatrixMultiply(mat, m_stack[m_current]);
end;


// Add a rotation around an axis to stack top.
procedure TMatrixStack.RotateAxis(axis: TXMVECTOR; angle: single);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixRotationAxis(axis, angle);
    m_stack[m_current] := XMMatrixMultiply(m_stack[m_current], mat);
end;



procedure TMatrixStack.RotateAxisLocal(axis: TXMVECTOR; angle: single);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixRotationAxis(axis, angle);
    m_stack[m_current] := XMMatrixMultiply(mat, m_stack[m_current]);
end;


// Add a rotation by roll/pitch/yaw to the stack top.
procedure TMatrixStack.RotateRollPitchYaw(pitch, yaw, roll: single);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixRotationRollPitchYaw(pitch, yaw, roll);
    m_stack[m_current] := XMMatrixMultiply(m_stack[m_current], mat);
end;



procedure TMatrixStack.RotateRollPitchYawLocal(pitch, yaw, roll: single);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixRotationRollPitchYaw(pitch, yaw, roll);
    m_stack[m_current] := XMMatrixMultiply(mat, m_stack[m_current]);
end;


// Add a rotation by a quaternion stack top.
procedure TMatrixStack.RotateByQuaternion(quat: TXMVECTOR);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixRotationQuaternion(quat);
    m_stack[m_current] := XMMatrixMultiply(m_stack[m_current], mat);
end;



procedure TMatrixStack.RotateByQuaternionLocal(quat: TXMVECTOR);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixRotationQuaternion(quat);
    m_stack[m_current] := XMMatrixMultiply(mat, m_stack[m_current]);
end;


// Add a scale to the stack top.
procedure TMatrixStack.Scale(x, y, z: single);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixScaling(x, y, z);
    m_stack[m_current] := XMMatrixMultiply(m_stack[m_current], mat);
end;



procedure TMatrixStack.ScaleLocal(x, y, z: single);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixScaling(x, y, z);
    m_stack[m_current] := XMMatrixMultiply(mat, m_stack[m_current]);
end;


// Add a translation to the stack top.
procedure TMatrixStack.Translate(x, y, z: single);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixTranslation(x, y, z);
    m_stack[m_current] := XMMatrixMultiply(m_stack[m_current], mat);
end;



procedure TMatrixStack.TranslateLocal(x, y, z: single);
var
    mat: TXMMATRIX;
begin
    mat := XMMatrixTranslation(x, y, z);
    m_stack[m_current] := XMMatrixMultiply(mat, m_stack[m_current]);
end;

end.
