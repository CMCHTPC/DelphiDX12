{ **************************************************************************
    FreePascal/Delphi DirectX 12 Header Files

    Copyright (C) 2013-2025 Norbert Sonnleitner

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
************************************************************************** }

{ **************************************************************************
   Additional Copyright (C) for this modul:

   Copyright (C) Microsoft Corporation.  All Rights Reserved.
   Content:    D3DX simple shapes

   This unit consists of the following header files
   File name: d3dx9shapes.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.D3DX9Shapes;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3D9,
    DX12.D3DX9Core,
    DX12.D3DX9Mesh;

    {$Z4}

const
    D3DX9_DLL = 'D3DX9_43.dll';


    ///////////////////////////////////////////////////////////////////////////
    // Functions:
    ///////////////////////////////////////////////////////////////////////////
    //-------------------------------------------------------------------------
    // D3DXCreatePolygon:
    // ------------------
    // Creates a mesh containing an n-sided polygon.  The polygon is centered
    // at the origin.

    // Parameters:

    //  pDevice     The D3D device with which the mesh is going to be used.
    //  Length      Length of each side.
    //  Sides       Number of sides the polygon has.  (Must be >= 3)
    //  ppMesh      The mesh object which will be created
    //  ppAdjacency Returns a buffer containing adjacency info.  Can be NULL.
    //-------------------------------------------------------------------------



function D3DXCreatePolygon(pDevice: IDirect3DDevice9; Length: single; Sides: UINT; out ppMesh: ID3DXMESH; out ppAdjacency: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;



//-------------------------------------------------------------------------
// D3DXCreateBox:
// --------------
// Creates a mesh containing an axis-aligned box.  The box is centered at
// the origin.

// Parameters:

//  pDevice     The D3D device with which the mesh is going to be used.
//  Width       Width of box (along X-axis)
//  Height      Height of box (along Y-axis)
//  Depth       Depth of box (along Z-axis)
//  ppMesh      The mesh object which will be created
//  ppAdjacency Returns a buffer containing adjacency info.  Can be NULL.
//-------------------------------------------------------------------------
function D3DXCreateBox(pDevice: IDirect3DDevice9; Width: single; Height: single; Depth: single; out ppMesh: ID3DXMesh; out ppAdjacency: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;



//-------------------------------------------------------------------------
// D3DXCreateCylinder:
// -------------------
// Creates a mesh containing a cylinder.  The generated cylinder is
// centered at the origin, and its axis is aligned with the Z-axis.

// Parameters:

//  pDevice     The D3D device with which the mesh is going to be used.
//  Radius1     Radius at -Z end (should be >= 0.0f)
//  Radius2     Radius at +Z end (should be >= 0.0f)
//  Length      Length of cylinder (along Z-axis)
//  Slices      Number of slices about the main axis
//  Stacks      Number of stacks along the main axis
//  ppMesh      The mesh object which will be created
//  ppAdjacency Returns a buffer containing adjacency info.  Can be NULL.
//-------------------------------------------------------------------------
function D3DXCreateCylinder(pDevice: IDirect3DDevice9; Radius1: single; Radius2: single; Length: single; Slices: UINT; Stacks: UINT; out ppMesh: ID3DXMesh; out ppAdjacency: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;



//-------------------------------------------------------------------------
// D3DXCreateSphere:
// -----------------
// Creates a mesh containing a sphere.  The sphere is centered at the
// origin.

// Parameters:

//  pDevice     The D3D device with which the mesh is going to be used.
//  Radius      Radius of the sphere (should be >= 0.0f)
//  Slices      Number of slices about the main axis
//  Stacks      Number of stacks along the main axis
//  ppMesh      The mesh object which will be created
//  ppAdjacency Returns a buffer containing adjacency info.  Can be NULL.
//-------------------------------------------------------------------------
function D3DXCreateSphere(pDevice: IDirect3DDevice9; Radius: single; Slices: UINT; Stacks: UINT; out ppMesh: ID3DXMesh; out ppAdjacency: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;



//-------------------------------------------------------------------------
// D3DXCreateTorus:
// ----------------
// Creates a mesh containing a torus.  The generated torus is centered at
// the origin, and its axis is aligned with the Z-axis.

// Parameters:

//  pDevice     The D3D device with which the mesh is going to be used.
//  InnerRadius Inner radius of the torus (should be >= 0.0f)
//  OuterRadius Outer radius of the torue (should be >= 0.0f)
//  Sides       Number of sides in a cross-section (must be >= 3)
//  Rings       Number of rings making up the torus (must be >= 3)
//  ppMesh      The mesh object which will be created
//  ppAdjacency Returns a buffer containing adjacency info.  Can be NULL.
//-------------------------------------------------------------------------
function D3DXCreateTorus(pDevice: IDirect3DDevice9; InnerRadius: single; OuterRadius: single; Sides: UINT; Rings: UINT; out ppMesh: ID3DXMesh; out ppAdjacency: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;



//-------------------------------------------------------------------------
// D3DXCreateTeapot:
// -----------------
// Creates a mesh containing a teapot.

// Parameters:

//  pDevice     The D3D device with which the mesh is going to be used.
//  ppMesh      The mesh object which will be created
//  ppAdjacency Returns a buffer containing adjacency info.  Can be NULL.
//-------------------------------------------------------------------------
function D3DXCreateTeapot(pDevice: IDirect3DDevice9; out ppMesh: ID3DXMesh; out ppAdjacency: ID3DXBuffer): HRESULT; stdcall; external D3DX9_DLL;



//-------------------------------------------------------------------------
// D3DXCreateText:
// ---------------
// Creates a mesh containing the specified text using the font associated
// with the device context.

// Parameters:

//  pDevice       The D3D device with which the mesh is going to be used.
//  hDC           Device context, with desired font selected
//  pText         Text to generate
//  Deviation     Maximum chordal deviation from true font outlines
//  Extrusion     Amount to extrude text in -Z direction
//  ppMesh        The mesh object which will be created
//  pGlyphMetrics Address of buffer to receive glyph metric data (or NULL)
//-------------------------------------------------------------------------
function D3DXCreateTextA(pDevice: IDirect3DDevice9; hDC: HDC; pText: LPCSTR; Deviation: single; Extrusion: single; out ppMesh: ID3DXMesh;
    out ppAdjacency: ID3DXBuffer; pGlyphMetrics: LPGLYPHMETRICSFLOAT): HRESULT; stdcall; external D3DX9_DLL;


function D3DXCreateTextW(pDevice: IDirect3DDevice9; hDC: HDC; pText: LPCWSTR; Deviation: single; Extrusion: single; out ppMesh: ID3DXMesh;
    out ppAdjacency: ID3DXBuffer; pGlyphMetrics: LPGLYPHMETRICSFLOAT): HRESULT; stdcall; external D3DX9_DLL;




implementation

end.
