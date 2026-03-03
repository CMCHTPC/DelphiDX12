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
   Additional Copyright (C)

   Adapation by Norbert Sonnleitner to work with the DX12 Headers

  ************************************************************************** }

{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  Adaptation by PiloLogic Software House
  for CodeTyphon Project (https://www.pilotlogic.com/)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}

(*----------------------------------------------------------------------------*
 *  Direct3D tutorial from DirectX 9.0 SDK                                    *
 *  Delphi adaptation by Alexey Barkovoy (e-mail: directx@clootie.ru)         *
 *                                                                            *
 *  Latest version can be downloaded from:                                    *
 *     http://www.clootie.ru                                                  *
 *     http://sourceforge.net/projects/delphi-dx9sdk                          *
 *----------------------------------------------------------------------------*
 *  $Id: Textures.dpr,v 1.7 2005/06/30 19:49:00 clootie Exp $
 *----------------------------------------------------------------------------*)
//-----------------------------------------------------------------------------
// File: Textures.cpp

// Desc: Better than just lights and materials, 3D objects look much more
//       convincing when texture-mapped. Textures can be thought of as a sort
//       of wallpaper, that is shrinkwrapped to fit a texture. Textures are
//       typically loaded from image files, and D3DX provides a utility to
//       function to do this for us. Like a vertex buffer, textures have
//       Lock() and Unlock() functions to access (read or write) the image
//       data. Textures have a width, height, miplevel, and pixel format. The
//       miplevel is for "mipmapped" textures, an advanced performance-
//       enhancing feature which uses lower resolutions of the texture for
//       objects in the distance where detail is less noticeable. The pixel
//       format determines how the colors are stored in a texel. The most
//       common formats are the 16-bit R5G6B5 format (5 bits of red, 6-bits of
//       green and 5 bits of blue) and the 32-bit A8R8G8B8 format (8 bits each
//       of alpha, red, green, and blue).

//       Textures are associated with geometry through texture coordinates.
//       Each vertex has one or more sets of texture coordinates, which are
//       named tu and tv and range from 0.0 to 1.0. Texture coordinates can be
//       supplied by the geometry, or can be automatically generated using
//       Direct3D texture coordinate generation (which is an advanced feature).

// Copyright (c) Microsoft Corporation. All rights reserved.
//-----------------------------------------------------------------------------

{$APPTYPE GUI}

program Textures;

uses
  Windows,
  Messages,
  MMSystem,
  ActiveX,
  DX12.D3D9,
  DX12.D3D9Types,
  DX12.D3D9Caps,
  DX12.D3DX9Tex,
  DX12.D3DX9Math;


  //-----------------------------------------------------------------------------
  // Global variables
  //-----------------------------------------------------------------------------
var
  g_pD3D: IDirect3D9 = nil; // Used to create the D3DDevice
  g_pd3dDevice: IDirect3DDevice9 = nil; // Our rendering device
  g_pVB: IDirect3DVertexBuffer9 = nil; // Buffer to hold vertices
  g_pTexture: IDirect3DTexture9 = nil; // Our texture

  // A structure for our custom vertex type. We added a normal, and omitted the
  // color (which is provided by the material)
type
  PCustomVertex = ^TCustomVertex;

  TCustomVertex = packed record
    position: TD3DXVector3; // The position
    color: TD3DColor;    // The color
    {$IFNDEF SHOW_HOW_TO_USE_TCI}
    tu, tv: single;   // The texture coordinates
    {$ENDIF}
  end;

  PCustomVertexArray = ^TCustomVertexArray;
  TCustomVertexArray = array [0..0] of TCustomVertex;

const
  // Our custom FVF, which describes our custom vertex structure
  {$IFDEF SHOW_HOW_TO_USE_TCI}
  D3DFVF_CUSTOMVERTEX = D3DFVF_XYZ or D3DFVF_DIFFUSE;
  {$ELSE}
  D3DFVF_CUSTOMVERTEX = D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1;
  {$ENDIF}



  //-----------------------------------------------------------------------------
  // Name: InitD3D()
  // Desc: Initializes Direct3D
  //-----------------------------------------------------------------------------
  function InitD3D(hWnd: HWND): HRESULT;
  var
    d3dpp: TD3DPRESENT_PARAMETERS;
  begin
    Result := E_FAIL;

    // Create the D3D object.
    // cast the interface pointer to an interface
    g_pD3D := IDirect3D9(Direct3DCreate9(D3D_SDK_VERSION));
    if (g_pD3D = nil) then Exit;

    // Set up the structure used to create the D3DDevice. Since we are now
    // using more complex geometry, we will create a device with a zbuffer.
    FillChar(d3dpp, SizeOf(d3dpp), 0);
    d3dpp.Windowed := longbool(1);
    d3dpp.BackBufferCount:=1;
    d3dpp.SwapEffect := D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferFormat :=D3DFMT_UNKNOWN;// D3DFMT_UNKNOWN;
    d3dpp.EnableAutoDepthStencil := longbool(1);
    d3dpp.AutoDepthStencilFormat := D3DFMT_D16;

    // Create the D3DDevice
    Result := g_pD3D.CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, hWnd,  D3DCREATE_MULTITHREADED or D3DCREATE_FPU_PRESERVE or D3DCREATE_HARDWARE_VERTEXPROCESSING, @d3dpp, g_pd3dDevice);
    if FAILED(Result) then
    begin
      Result := E_FAIL;
      Exit;
    end;

    // Turn off culling
    g_pd3dDevice.SetRenderState(D3DRS_CULLMODE, Ord(D3DCULL_NONE));

    // Turn off D3D lighting
    g_pd3dDevice.SetRenderState(D3DRS_LIGHTING, 0);

    // Turn on the zbuffer
    g_pd3dDevice.SetRenderState(D3DRS_ZENABLE, 1);

    Result := S_OK;
  end;



  //-----------------------------------------------------------------------------
  // Name: InitGeometry()
  // Desc: Creates the scene geometry
  //-----------------------------------------------------------------------------
  function InitGeometry: HRESULT;
  var
    i: DWORD;
    theta: single;
    pVertices: PCustomVertexArray;
  begin
    Result := E_FAIL;

    // Use D3DX to create a texture from a file based image
    if FAILED(DX12.D3DX9Tex.D3DXCreateTextureFromFileW(g_pd3dDevice, '..\Basics\Tut05_Textures\banana.bmp', g_pTexture)) then
    begin
      // If texture is not in current folder, try parent folder
      if FAILED(DX12.D3DX9Tex.D3DXCreateTextureFromFileW(g_pd3dDevice, 'banana.bmp', g_pTexture)) then
      begin
        MessageBox(0, 'Could not find banana.bmp', 'Textures.exe', MB_OK);
        Exit;
      end;
    end;

    // Create the vertex buffer.
    if FAILED(g_pd3dDevice.CreateVertexBuffer(50 * 2 * SizeOf(TCustomVertex), 0, D3DFVF_CUSTOMVERTEX, D3DPOOL_DEFAULT, g_pVB, nil)) then Exit;

    // Fill the vertex buffer. We are setting the tu and tv texture
    // coordinates, which range from 0.0 to 1.0
    if FAILED(g_pVB.Lock(0, 0, Pointer(pVertices), 0)) then Exit;

    for i := 0 to 49 do
    begin
      theta := (2 * D3DX_PI * i) / (50 - 1);

      pVertices[2 * i + 0].position.Init(Sin(theta), -1.0, Cos(theta));
      pVertices[2 * i + 0].color := $ffffffff;
      {$IFNDEF SHOW_HOW_TO_USE_TCI}
      pVertices[2 * i + 0].tu := (i) / (50 - 1);
      pVertices[2 * i + 0].tv := 1.0;
      {$ENDIF}

      pVertices[2 * i + 1].position.Init(Sin(theta), 1.0, Cos(theta));
      pVertices[2 * i + 1].color := $ff808080;
      {$IFNDEF SHOW_HOW_TO_USE_TCI}
      pVertices[2 * i + 1].tu := (i) / (50 - 1);
      pVertices[2 * i + 1].tv := 0.0;
      {$ENDIF}
    end;
    g_pVB.Unlock;

    Result := S_OK;
  end;



  //-----------------------------------------------------------------------------
  // Name: Cleanup()
  // Desc: Releases all previously initialized objects
  //-----------------------------------------------------------------------------
  procedure Cleanup;
  begin
    if (g_pTexture <> nil) then
    {$IFDEF TMT}
    g_pTexture.Release;
      {$ELSE}
      g_pTexture := nil;
    {$ENDIF}


    if (g_pVB <> nil) then
    {$IFDEF TMT}
    g_pVB.Release;
      {$ELSE}
      g_pVB := nil;
    {$ENDIF}

    if (g_pd3dDevice <> nil) then
    {$IFDEF TMT}
    g_pd3dDevice.Release;
      {$ELSE}
      g_pd3dDevice := nil;
    {$ENDIF}

    if (g_pD3D <> nil) then
    {$IFDEF TMT}
    g_pD3D.Release;
      {$ELSE}
      g_pD3D := nil;
    {$ENDIF}
  end;



  //-----------------------------------------------------------------------------
  // Name: SetupMatrices()
  // Desc: Sets up the world, view, and projection transform matrices.
  //-----------------------------------------------------------------------------
  procedure SetupMatrices;
  var
    matWorld, matView, matProj: TD3DXMatrix;
    vEyePt, vLookatPt, vUpVec: TD3DXVECTOR3;
    x: integer;
    p: pointer;
  begin
    // Set up world matrix
    D3DXMatrixIdentity(@matWorld);
    D3DXMatrixRotationX(@matWorld, timeGetTime / 1000.0);
    g_pd3dDevice.SetTransform(D3DTS_WORLD, @matWorld);

    // Set up our view matrix. A view matrix can be defined given an eye point,
    // a point to lookat, and a direction for which way is up. Here, we set the
    // eye five units back along the z-axis and up three units, look at the
    // origin, and define "up" to be in the y-direction.
    vEyePt := D3DXVector3(0.0, 3.0, -5.0);
    x:=sizeOf(vEyePt);
    x:=sizeOf(matView);
    vLookatPt := D3DXVector3(0.0, 0.0, 0.0);
    vUpVec := D3DXVector3(0.0, 1.0, 0.0);
    p:=D3DXMatrixLookAtLH(@matView, @vEyePt, @vLookatPt, @vUpVec);
    g_pd3dDevice.SetTransform(D3DTS_VIEW, @matView);

    // For the projection matrix, we set up a perspective transform (which
    // transforms geometry from 3D view space to 2D viewport space, with
    // a perspective divide making objects smaller in the distance). To build
    // a perpsective transform, we need the field of view (1/4 pi is common),
    // the aspect ratio, and the near and far clipping planes (which define at
    // what distances geometry should be no longer be rendered).
    D3DXMatrixPerspectiveFovLH(@matProj, D3DX_PI / 4, 1.0, 1.0, 100.0);
    g_pd3dDevice.SetTransform(D3DTS_PROJECTION, @matProj);
  end;



  //-----------------------------------------------------------------------------
  // Name: Render()
  // Desc: Draws the scene
  //-----------------------------------------------------------------------------
  procedure Render;
  {$IFDEF SHOW_HOW_TO_USE_TCI}
var
  mat: TD3DXMatrixA16;
  {$ENDIF}
  begin
    // Clear the backbuffer and the zbuffer
    g_pd3dDevice.Clear(0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER,
      D3DCOLOR_XRGB(0, 0, 255), 1.0, 0);

    // Begin the scene
    if SUCCEEDED(g_pd3dDevice.BeginScene) then
    begin
      // Setup the world, view, and projection matrices
      SetupMatrices;

      // Setup our texture. Using textures introduces the texture stage states,
      // which govern how textures get blended together (in the case of multiple
      // textures) and lighting information. In this case, we are modulating
      // (blending) our texture with the diffuse color of the vertices.
      g_pd3dDevice.SetTexture(0, g_pTexture);

      // Set up the default texture states.
      g_pd3dDevice.SetTextureStageState(0, D3DTSS_COLOROP, Ord(D3DTOP_MODULATE));
      g_pd3dDevice.SetTextureStageState(0, D3DTSS_COLORARG1, Ord(D3DTA_TEXTURE));
      g_pd3dDevice.SetTextureStageState(0, D3DTSS_COLORARG2, Ord(D3DTA_DIFFUSE));
      g_pd3dDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, Ord(D3DTOP_DISABLE));

      // Set up the default sampler states.
      g_pd3dDevice.SetSamplerState(0, D3DSAMP_MINFILTER, Ord(D3DTEXF_LINEAR));
      g_pd3dDevice.SetSamplerState(0, D3DSAMP_MAGFILTER, Ord(D3DTEXF_LINEAR));
      g_pd3dDevice.SetSamplerState(0, D3DSAMP_MIPFILTER, Ord(D3DTEXF_LINEAR));
      g_pd3dDevice.SetSamplerState(0, D3DSAMP_ADDRESSU, Ord(D3DTADDRESS_CLAMP));
      g_pd3dDevice.SetSamplerState(0, D3DSAMP_ADDRESSV, Ord(D3DTADDRESS_CLAMP));

      {$IFDEF SHOW_HOW_TO_USE_TCI}
    // Note: to use D3D texture coordinate generation, use the stage state
    // D3DTSS_TEXCOORDINDEX, as shown below. In this example, we are using
    // the position of the vertex in camera space to generate texture
    // coordinates. The tex coord index (TCI) parameters are passed into a
    // texture transform, which is a 4x4 matrix which transforms the x,y,z
    // TCI coordinates into tu, tv texture coordinates.

    // In this example, the texture matrix is setup to
    // transform the texture from (-1,+1) position coordinates to (0,1)
    // texture coordinate space:
    //    tu =  0.5*x + 0.5
    //    tv = -0.5*y + 0.5
    mat._11 := 0.25; mat._12 := 0.00; mat._13 := 0.00; mat._14 := 0.00;
    mat._21 := 0.00; mat._22 :=-0.25; mat._23 := 0.00; mat._24 := 0.00;
    mat._31 := 0.00; mat._32 := 0.00; mat._33 := 1.00; mat._34 := 0.00;
    mat._41 := 0.50; mat._42 := 0.50; mat._43 := 0.00; mat._44 := 1.00;

    g_pd3dDevice.SetTransform(D3DTS_TEXTURE0, mat);
    g_pd3dDevice.SetTextureStageState(0, D3DTSS_TEXTURETRANSFORMFLAGS, D3DTTFF_COUNT2);
    g_pd3dDevice.SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, D3DTSS_TCI_CAMERASPACEPOSITION);
      {$ENDIF}

      // Render the vertex buffer contents
      g_pd3dDevice.SetStreamSource(0, g_pVB, 0, SizeOf(TCustomVertex));
      g_pd3dDevice.SetFVF(D3DFVF_CUSTOMVERTEX);
      g_pd3dDevice.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2 * 50 - 2);

      // End the scene
      g_pd3dDevice.EndScene;
    end;

    // Present the backbuffer contents to the display
    g_pd3dDevice.Present(nil, nil, 0, nil);
  end;



  //-----------------------------------------------------------------------------
  // Name: MsgProc()
  // Desc: The window's message handler
  //-----------------------------------------------------------------------------
  function MsgProc(hWnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
  begin
    case uMsg of
      WM_DESTROY:
      begin
        Cleanup;
        PostQuitMessage(0);
        Result := 0;
        Exit;
      end;
    end;

    Result := DefWindowProc(hWnd, uMsg, wParam, lParam);
  end;



  //-----------------------------------------------------------------------------
  // Name: WinMain()
  // Desc: The application's entry point
  //-----------------------------------------------------------------------------
  // INT WINAPI WinMain( HINSTANCE hInst, HINSTANCE, LPSTR, INT )
  {$IFDEF TMT}
const
  {$ELSE}
var
  {$ENDIF}
  wc: TWndClassEx = (cbSize: SizeOf(TWndClassEx);
  style: CS_CLASSDC;
  {$IFDEF FPC}
  lpfnWndProc: MsgProc;
  {$ELSE}
    lpfnWndProc: @MsgProc;
  {$ENDIF}
  cbClsExtra: 0;
  cbWndExtra: 0;
  hInstance: 0; // - filled later
  hIcon: 0;
  hCursor: 0;
  hbrBackground: 0;
  lpszMenuName: nil;
  lpszClassName: 'D3D Tutorial';
  hIconSm: 0);
var
  hWindow: HWND;
  msg: TMsg;

  {$R *.res}

begin
  // Register the window class
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
  wc.hInstance := GetModuleHandle(nil);
  RegisterClassEx(wc);

  // Create the application's window
  hWindow := CreateWindow('D3D Tutorial', 'D3D Tutorial 05: Textures', WS_OVERLAPPEDWINDOW, 100, 100, 300, 300, 0, 0, wc.hInstance, nil);

  // Initialize Direct3D
  if SUCCEEDED(InitD3D(hWindow)) then
  begin
    // Create the scene geometry
    if SUCCEEDED(InitGeometry) then
    begin
      // Show the window
      ShowWindow(hWindow, SW_SHOWDEFAULT);
      UpdateWindow(hWindow);

      // Enter the message loop
      FillChar(msg, SizeOf(msg), 0);
      while (msg.message <> WM_QUIT) do
      begin
        if PeekMessage(msg, 0, 0, 0, PM_REMOVE) then
        begin
          TranslateMessage(msg);
          DispatchMessage(msg);
        end
        else
          Render;
      end;
    end;
  end;

  UnregisterClass('D3D Tutorial', wc.hInstance);
  CoUninitialize();
end.
