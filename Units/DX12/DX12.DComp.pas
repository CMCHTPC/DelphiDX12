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

   Copyright (c) Microsoft Corporation.  All rights reserved.

   This unit consists of the following header files
   File name:  dcomp.h
   Header version: 10.0.26100.6584

  ************************************************************************** }

unit DX12.DComp;

{$mode ObjFPC}{$H+}

interface

uses
    Windows, Classes, SysUtils,
    DX12.D3DCommon,
    DX12.DXGI,
    DX12.DXGIFormat,
    DX12.DXGIType,
    DX12.DXGICommon,
    DX12.DXGI1_2,
    DX12.D2DBaseTypes,
    DX12.D3D9Types, // for D3DMATRIX
    DX12.DCommon,// for D2D_MATRIX_3X2_F
    DX12.D2D1,
    DX12.D2D1Effects,
    DX12.D2D1_1,  // for D2D1_COMPOSITE_MODE
    DX12.DCompTypes, // for CompositionSurfaceType
    DX12.DCompAnimation; // for IDirectCompositionAnimation interface

    {$Z4}

const
    Dcomp_dll = 'Dcomp.dll';


    IID_IDCompositionDevice: TGUID = '{C37EA93A-E7AA-450D-B16F-9746CB0407F3}';
    IID_IDCompositionTarget: TGUID = '{eacdd04c-117e-4e17-88f4-d1b12b0e3d89}';

    IID_IDCompositionVisual: TGUID = '{4d93059d-097b-4651-9a60-f0f25116e2f3}';
    IID_IDCompositionEffect: TGUID = '{EC81B08F-BFCB-4e8d-B193-A915587999E8}';
    IID_IDCompositionTransform3D: TGUID = '{71185722-246B-41f2-AAD1-0443F7F4BFC2}';

    IID_IDCompositionTransform: TGUID = '{FD55FAA7-37E0-4c20-95D2-9BE45BC33F55}';
    IID_IDCompositionTranslateTransform: TGUID = '{06791122-C6F0-417d-8323-269E987F5954}';
    IID_IDCompositionScaleTransform: TGUID = '{71FDE914-40EF-45ef-BD51-68B037C339F9}';
    IID_IDCompositionRotateTransform: TGUID = '{641ED83C-AE96-46c5-90DC-32774CC5C6D5}';
    IID_IDCompositionSkewTransform: TGUID = '{E57AA735-DCDB-4c72-9C61-0591F58889EE}';
    IID_IDCompositionMatrixTransform: TGUID = '{16CDFF07-C503-419c-83F2-0965C7AF1FA6}';
    IID_IDCompositionEffectGroup: TGUID = '{A7929A74-E6B2-4bd6-8B95-4040119CA34D}';
    IID_IDCompositionTranslateTransform3D: TGUID = '{91636D4B-9BA1-4532-AAF7-E3344994D788}';
    IID_IDCompositionScaleTransform3D: TGUID = '{2A9E9EAD-364B-4b15-A7C4-A1997F78B389}';
    IID_IDCompositionRotateTransform3D: TGUID = '{D8F5B23F-D429-4a91-B55A-D2F45FD75B18}';

    IID_IDCompositionMatrixTransform3D: TGUID = '{4B3363F0-643B-41b7-B6E0-CCF22D34467C}';
    IID_IDCompositionClip: TGUID = '{64AC3703-9D3F-45ec-A109-7CAC0E7A13A7}';
    IID_IDCompositionRectangleClip: TGUID = '{9842AD7D-D9CF-4908-AED7-48B51DA5E7C2}';
    IID_IDCompositionSurface: TGUID = '{BB8A4953-2C99-4F5A-96F5-4819027FA3AC}';
    IID_IDCompositionVirtualSurface: TGUID = '{AE471C51-5F53-4A24-8D3E-D0C39C30B3F0}';

    IID_IDCompositionDevice2: TGUID = '{75F6468D-1B8E-447C-9BC6-75FEA80B5B25}';
    IID_IDCompositionDesktopDevice: TGUID = '{5F4633FE-1E08-4CB8-8C75-CE24333F5602}';

    IID_IDCompositionDeviceDebug: TGUID = '{A1A3C64A-224F-4A81-9773-4F03A89D3C6C}';
    IID_IDCompositionSurfaceFactory: TGUID = '{E334BC12-3937-4E02-85EB-FCF4EB30D2C8}';

    IID_IDCompositionVisual2: TGUID = '{E8DE1639-4331-4B26-BC5F-6A321D347A85}';
    IID_IDCompositionVisualDebug: TGUID = '{FED2B808-5EB4-43A0-AEA3-35F65280F91B}';
    IID_IDCompositionVisual3: TGUID = '{2775F462-B6C1-4015-B0BE-B3E7D6A4976D}';
    IID_IDCompositionDevice3: TGUID = '{0987CB06-F916-48BF-8D35-CE7641781BD9}';


    IID_IDCompositionFilterEffect: TGUID = '{30C421D5-8CB2-4E9F-B133-37BE270D4AC2}';

    IID_IDCompositionGaussianBlurEffect: TGUID = '{45D4D0B7-1BD4-454E-8894-2BFA68443033}';
    IID_IDCompositionBrightnessEffect: TGUID = '{6027496E-CB3A-49AB-934F-D798DA4F7DA6}';
    IID_IDCompositionColorMatrixEffect: TGUID = '{C1170A22-3CE2-4966-90D4-55408BFC84C4}';

    IID_IDCompositionShadowEffect: TGUID = '{4AD18AC0-CFD2-4C2F-BB62-96E54FDB6879}';
    IID_IDCompositionHueRotationEffect: TGUID = '{6DB9F920-0770-4781-B0C6-381912F9D167}';
    IID_IDCompositionSaturationEffect: TGUID = '{A08DEBDA-3258-4FA4-9F16-9174D3FE93B1}';
    IID_IDCompositionTurbulenceEffect: TGUID = '{A6A55BDA-C09C-49F3-9193-A41922C89715}';
    IID_IDCompositionLinearTransferEffect: TGUID = '{4305EE5B-C4A0-4C88-9385-67124E017683}';
    IID_IDCompositionTableTransferEffect: TGUID = '{9B7E82E2-69C5-4EB4-A5F5-A7033F5132CD}';
    IID_IDCompositionCompositeEffect: TGUID = '{576616C0-A231-494D-A38D-00FD5EC4DB46}';
    IID_IDCompositionBlendEffect: TGUID = '{33ECDC0A-578A-4A11-9C14-0CB90517F9C5}';
    IID_IDCompositionArithmeticCompositeEffect: TGUID = '{3B67DFA8-E3DD-4E61-B640-46C2F3D739DC}';
    IID_IDCompositionAffineTransform2DEffect: TGUID = '{0B74B9E8-CDD6-492F-BBBC-5ED32157026D}';
    IID_IDCompositionDelegatedInkTrail: TGUID = '{C2448E9B-547D-4057-8CF5-8144EDE1C2DA}';
    IID_IDCompositionInkTrailDevice: TGUID = '{DF0C7CEC-CDEB-4D4A-B91C-721BF22F4E6C}';
    IID_IDCompositionTexture: TGUID = '{929BB1AA-725F-433B-ABD7-273075A835F2}';
    IID_IDCompositionDevice4: TGUID = '{85FC5CCA-2DA6-494C-86B6-4A775C049B8A}';
    IID_IDCompositionDynamicTexture: TGUID = '{A1DE1D3F-6405-447F-8E95-1383A34B0277}';
    IID_IDCompositionDevice5: TGUID = '{2C6BEBFE-A603-472F-AF34-D2443356E61B}';


type

    REFIID = ^TGUID;


    IDCompositionAffineTransform2DEffect = interface;
    PIDCompositionAffineTransform2DEffect = ^IDCompositionAffineTransform2DEffect;


    IDCompositionArithmeticCompositeEffect = interface;
    PIDCompositionArithmeticCompositeEffect = ^IDCompositionArithmeticCompositeEffect;


    IDCompositionBlendEffect = interface;
    PIDCompositionBlendEffect = ^IDCompositionBlendEffect;


    IDCompositionBrightnessEffect = interface;
    PIDCompositionBrightnessEffect = ^IDCompositionBrightnessEffect;

    IDCompositionClip = interface;
    PIDCompositionClip = ^IDCompositionClip;


    IDCompositionColorMatrixEffect = interface;
    PIDCompositionColorMatrixEffect = ^IDCompositionColorMatrixEffect;


    IDCompositionCompositeEffect = interface;
    PIDCompositionCompositeEffect = ^IDCompositionCompositeEffect;


    IDCompositionDevice = interface;
    PIDCompositionDevice = ^IDCompositionDevice;


    IDCompositionEffect = interface;
    PIDCompositionEffect = ^IDCompositionEffect;


    IDCompositionEffectGroup = interface;
    PIDCompositionEffectGroup = ^IDCompositionEffectGroup;


    IDCompositionFilterEffect = interface;
    PIDCompositionFilterEffect = ^IDCompositionFilterEffect;


    IDCompositionGaussianBlurEffect = interface;
    PIDCompositionGaussianBlurEffect = ^IDCompositionGaussianBlurEffect;

    IDCompositionHueRotationEffect = interface;
    PIDCompositionHueRotationEffect = ^IDCompositionHueRotationEffect;

    IDCompositionLinearTransferEffect = interface;
    PIDCompositionLinearTransferEffect = ^IDCompositionLinearTransferEffect;

    IDCompositionMatrixTransform = interface;
    PIDCompositionMatrixTransform = ^IDCompositionMatrixTransform;


    IDCompositionMatrixTransform3D = interface;
    PIDCompositionMatrixTransform3D = ^IDCompositionMatrixTransform3D;


    IDCompositionRectangleClip = interface;
    PIDCompositionRectangleClip = ^IDCompositionRectangleClip;


    IDCompositionRotateTransform = interface;
    PIDCompositionRotateTransform = ^IDCompositionRotateTransform;


    IDCompositionRotateTransform3D = interface;
    PIDCompositionRotateTransform3D = ^IDCompositionRotateTransform3D;


    IDCompositionSaturationEffect = interface;
    PIDCompositionSaturationEffect = ^IDCompositionSaturationEffect;


    IDCompositionScaleTransform = interface;
    PIDCompositionScaleTransform = ^IDCompositionScaleTransform;


    IDCompositionScaleTransform3D = interface;
    PIDCompositionScaleTransform3D = ^IDCompositionScaleTransform3D;


    IDCompositionShadowEffect = interface;
    PIDCompositionShadowEffect = ^IDCompositionShadowEffect;


    IDCompositionSkewTransform = interface;
    PIDCompositionSkewTransform = ^IDCompositionSkewTransform;


    IDCompositionSurface = interface;
    PIDCompositionSurface = ^IDCompositionSurface;


    IDCompositionTableTransferEffect = interface;
    PIDCompositionTableTransferEffect = ^IDCompositionTableTransferEffect;


    IDCompositionTarget = interface;
    PIDCompositionTarget = ^IDCompositionTarget;


    IDCompositionTransform = interface;
    PIDCompositionTransform = ^IDCompositionTransform;


    IDCompositionTransform3D = interface;
    PIDCompositionTransform3D = ^IDCompositionTransform3D;


    IDCompositionTranslateTransform = interface;
    PIDCompositionTranslateTransform = ^IDCompositionTranslateTransform;

    IDCompositionTranslateTransform3D = interface;
    PIDCompositionTranslateTransform3D = ^IDCompositionTranslateTransform3D;

    IDCompositionTurbulenceEffect = interface;
    PIDCompositionTurbulenceEffect = ^IDCompositionTurbulenceEffect;

    IDCompositionVirtualSurface = interface;
    PIDCompositionVirtualSurface = ^IDCompositionVirtualSurface;


    IDCompositionVisual = interface;
    PIDCompositionVisual = ^IDCompositionVisual;


    IDCompositionDesktopDevice = interface;
    PIDCompositionDesktopDevice = ^IDCompositionDesktopDevice;


    IDCompositionDevice2 = interface;
    PIDCompositionDevice2 = ^IDCompositionDevice2;


    IDCompositionDeviceDebug = interface;
    PIDCompositionDeviceDebug = ^IDCompositionDeviceDebug;


    IDCompositionSurfaceFactory = interface;
    PIDCompositionSurfaceFactory = ^IDCompositionSurfaceFactory;


    IDCompositionVisual2 = interface;
    PIDCompositionVisual2 = ^IDCompositionVisual2;


    IDCompositionVisualDebug = interface;
    PIDCompositionVisualDebug = ^IDCompositionVisualDebug;


    IDCompositionDevice3 = interface;
    PIDCompositionDevice3 = ^IDCompositionDevice3;


    IDCompositionVisual3 = interface;
    PIDCompositionVisual3 = ^IDCompositionVisual3;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionDevice

    //  Synopsis:
    //      Serves as the root factory for all other DirectComposition objects and
    //      controls transactional composition.

    //------------------------------------------------------------------------------

    IDCompositionDevice = interface(IUnknown)
        ['{C37EA93A-E7AA-450D-B16F-9746CB0407F3}']
        // Commits all DirectComposition commands pending on this device.
        function Commit(): HRESULT; stdcall;

        // Waits for the last Commit to be processed by the composition engine
        function WaitForCommitCompletion(): HRESULT; stdcall;

        // Gets timing information about the composition engine.
        function GetFrameStatistics(
        {_Out_ } statistics: PDCOMPOSITION_FRAME_STATISTICS): HRESULT; stdcall;

        // Creates a composition target bound to a window represented by an HWND.
        function CreateTargetForHwnd(
        {_In_ } hwnd: HWND; topmost: boolean;
        {_Outptr_ }  out target: IDCompositionTarget): HRESULT; stdcall;

        // Creates a new visual object.
        function CreateVisual(
        {_Outptr_ }  out visual: IDCompositionVisual): HRESULT; stdcall;

        // Creates a DirectComposition surface object
        function CreateSurface(
        {_In_ } Width: UINT;
        {_In_ } Height: UINT;
        {_In_ } pixelFormat: TDXGI_FORMAT;
        {_In_ } alphaMode: TDXGI_ALPHA_MODE;
        {_Outptr_ }  out surface: IDCompositionSurface): HRESULT; stdcall;

        // Creates a DirectComposition virtual surface object
        function CreateVirtualSurface(
        {_In_ } initialWidth: UINT;
        {_In_ } initialHeight: UINT;
        {_In_ } pixelFormat: TDXGI_FORMAT;
        {_In_ } alphaMode: TDXGI_ALPHA_MODE;
        {_Outptr_ }  out virtualSurface: IDCompositionVirtualSurface): HRESULT; stdcall;

        // Creates a surface wrapper around a pre-existing surface that can be associated with one or more visuals for composition.
        function CreateSurfaceFromHandle(
        {_In_ } handle: HANDLE;
        {_Outptr_ }  out surface: IUnknown): HRESULT; stdcall;

        // Creates a wrapper object that represents the rasterization of a layered window and which can be associated with a visual for composition.
        function CreateSurfaceFromHwnd(
        {_In_ } hwnd: HWND;
        {_Outptr_ }  out surface: IUnknown): HRESULT; stdcall;

        // Creates a 2D translation transform object.
        function CreateTranslateTransform(
        {_Outptr_ }  out translateTransform: IDCompositionTranslateTransform): HRESULT; stdcall;

        // Creates a 2D scale transform object.
        function CreateScaleTransform(
        {_Outptr_ }  out scaleTransform: IDCompositionScaleTransform): HRESULT; stdcall;

        // Creates a 2D rotation transform object.
        function CreateRotateTransform(
        {_Outptr_ }  out rotateTransform: IDCompositionRotateTransform): HRESULT; stdcall;

        // Creates a 2D skew transform object.
        function CreateSkewTransform(
        {_Outptr_ }  out skewTransform: IDCompositionSkewTransform): HRESULT; stdcall;

        // Creates a 2D 3x2 matrix transform object.
        function CreateMatrixTransform(
        {_Outptr_ }  out matrixTransform: IDCompositionMatrixTransform): HRESULT; stdcall;

        // Creates a 2D transform object that holds an array of 2D transform objects.
        function CreateTransformGroup(
        {_In_reads_(elements) } transforms: PIDCompositionTransform; elements: UINT;
        {_Outptr_ }  out transformGroup: IDCompositionTransform): HRESULT; stdcall;

        // Creates a 3D translation transform object.
        function CreateTranslateTransform3D(
        {_Outptr_ }  out translateTransform3D: IDCompositionTranslateTransform3D): HRESULT; stdcall;

        // Creates a 3D scale transform object.
        function CreateScaleTransform3D(
        {_Outptr_ }  out scaleTransform3D: IDCompositionScaleTransform3D): HRESULT; stdcall;

        // Creates a 3D rotation transform object.
        function CreateRotateTransform3D(
        {_Outptr_ }  out rotateTransform3D: IDCompositionRotateTransform3D): HRESULT; stdcall;

        // Creates a 3D 4x4 matrix transform object.
        function CreateMatrixTransform3D(
        {_Outptr_ }  out matrixTransform3D: IDCompositionMatrixTransform3D): HRESULT; stdcall;

        // Creates a 3D transform object that holds an array of 3D transform objects.
        function CreateTransform3DGroup(
        {_In_reads_(elements) } transforms3D: PIDCompositionTransform3D; elements: UINT;
        {_Outptr_ }  out transform3DGroup: IDCompositionTransform3D): HRESULT; stdcall;

        // Creates an effect group
        function CreateEffectGroup(
        {_Outptr_ }  out effectGroup: IDCompositionEffectGroup): HRESULT; stdcall;

        // Creates a clip object that can be used to clip the contents of a visual subtree.
        function CreateRectangleClip(
        {_Outptr_ }  out clip: IDCompositionRectangleClip): HRESULT; stdcall;

        // Creates an animation object
        function CreateAnimation(
        {_Outptr_ }  out animation: IDCompositionAnimation): HRESULT; stdcall;

        // Returns the states of the app's DX device and DWM's dx devices
        function CheckDeviceState(
        {_Out_ } pfValid: Pboolean): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionTarget

    //  Synopsis:
    //      An IDCompositionTarget interface represents a binding between a
    //      DirectComposition visual tree and a destination on top of which the
    //      visual tree should be composed.

    //------------------------------------------------------------------------------

    IDCompositionTarget = interface(IUnknown)
        ['{eacdd04c-117e-4e17-88f4-d1b12b0e3d89}']
        // Sets the root visual
        function SetRoot(
        {_In_opt_ } visual: IDCompositionVisual): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionVisual

    //  Synopsis:
    //      An IDCompositionVisual interface represents a visual that participates in
    //      a visual tree.

    //------------------------------------------------------------------------------

    IDCompositionVisual = interface(IUnknown)
        ['{4d93059d-097b-4651-9a60-f0f25116e2f3}']

        // Animates the value of the OffsetX property.
        function SetOffsetX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of OffsetX property
        function SetOffsetX(offsetX: single): HRESULT; stdcall;

        // Animates the value of the OffsetY property.
        function SetOffsetY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of OffsetY property
        function SetOffsetY(offsetY: single): HRESULT; stdcall;

        // Sets the matrix that modifies the coordinate system of this visual.
        function SetTransform(matrix: TD2D_MATRIX_3X2_F): HRESULT; stdcall;

        // Sets the transformation object that modifies the coordinate system of this visual.
        function SetTransform(
        {_In_opt_ } transform: IDCompositionTransform): HRESULT; stdcall;

        // Sets the visual that should act as this visual's parent for the
        // purpose of establishing a base coordinate system.
        function SetTransformParent(
        {_In_opt_ } visual: IDCompositionVisual): HRESULT; stdcall;

        // Sets the effect object that is applied during the rendering of this visual
        function SetEffect(
        {_In_opt_ } effect: IDCompositionEffect): HRESULT; stdcall;

        // Sets the mode to use when interpolating pixels from bitmaps drawn not
        // exactly at scale and axis-aligned.
        function SetBitmapInterpolationMode(
        {_In_ } interpolationMode: TDCOMPOSITION_BITMAP_INTERPOLATION_MODE): HRESULT; stdcall;

        // Sets the mode to use when drawing the edge of bitmaps that are not
        // exactly axis-aligned and at precise pixel boundaries.
        function SetBorderMode(
        {_In_ } borderMode: TDCOMPOSITION_BORDER_MODE): HRESULT; stdcall;

        // Sets the clip object that restricts the rendering of this visual to a D2D rectangle.
        function SetClip(rect: TD2D_RECT_F): HRESULT; stdcall;

        // Sets the clip object that restricts the rendering of this visual to a rectangle.
        function SetClip(
        {_In_opt_ } clip: IDCompositionClip): HRESULT; stdcall;

        // Associates a bitmap with a visual
        function SetContent(
        {_In_opt_ } content: IUnknown): HRESULT; stdcall;

        // Adds a visual to the children list of another visual.
        function AddVisual(
        {_In_ } visual: IDCompositionVisual; insertAbove: boolean;
        {_In_opt_ } referenceVisual: IDCompositionVisual): HRESULT; stdcall;

        // Removes a visual from the children list of another visual.
        function RemoveVisual(
        {_In_ } visual: IDCompositionVisual): HRESULT; stdcall;

        // Removes all visuals from the children list of another visual.
        function RemoveAllVisuals(): HRESULT; stdcall;

        // Sets the mode to use when composing the bitmap against the render target.
        function SetCompositeMode(
        {_In_ } compositeMode: TDCOMPOSITION_COMPOSITE_MODE): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionEffect

    //  Synopsis:
    //      An IDCompositionEffect interface represents an effect

    //------------------------------------------------------------------------------

    IDCompositionEffect = interface(IUnknown)
        ['{EC81B08F-BFCB-4e8d-B193-A915587999E8}']
    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionTransform3D

    //  Synopsis:
    //      An IDCompositionTransform3D interface represents a 3D transformation.

    //------------------------------------------------------------------------------

    IDCompositionTransform3D = interface(IDCompositionEffect)
        ['{71185722-246B-41f2-AAD1-0443F7F4BFC2}']
    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionTransform

    //  Synopsis:
    //      An IDCompositionTransform interface represents a 2D transformation that
    //      can be used to modify the coordinate space of a visual subtree.

    //------------------------------------------------------------------------------

    IDCompositionTransform = interface(IDCompositionTransform3D)
        ['{FD55FAA7-37E0-4c20-95D2-9BE45BC33F55}']
    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionTranslateTransform

    //  Synopsis:
    //      An IDCompositionTranslateTransform interface represents a 2D transformation
    //      that affects only the offset of a visual along the x and y axes.

    //------------------------------------------------------------------------------

    IDCompositionTranslateTransform = interface(IDCompositionTransform)
        ['{06791122-C6F0-417d-8323-269E987F5954}']
        // Animates the value of the OffsetX property.
        function SetOffsetX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the OffsetX property.
        function SetOffsetX(offsetX: single): HRESULT; stdcall;



        // Animates the value of the OffsetY property.
        function SetOffsetY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the OffsetY property.
        function SetOffsetY(offsetY: single): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionScaleTransform

    //  Synopsis:
    //      An IDCompositionScaleTransform interface represents a 2D transformation that
    //      affects the scale of a visual along the x and y axes. The coordinate system
    //      is scaled from the specified center point.

    //------------------------------------------------------------------------------

    IDCompositionScaleTransform = interface(IDCompositionTransform)
        ['{71FDE914-40EF-45ef-BD51-68B037C339F9}']
        // Animates the value of the ScaleX property.
        function SetScaleX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the ScaleX property.
        function SetScaleX(scaleX: single): HRESULT; stdcall;



        // Animates the value of the ScaleY property.
        function SetScaleY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the ScaleY property.
        function SetScaleY(scaleY: single): HRESULT; stdcall;



        // Animates the value of the CenterX property.
        function SetCenterX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the CenterX property.
        function SetCenterX(centerX: single): HRESULT; stdcall;



        // Animates the value of the CenterY property.
        function SetCenterY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the CenterY property.
        function SetCenterY(centerY: single): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionRotateTransform

    //  Synopsis:
    //      An IDCompositionRotateTransform interface represents a 2D transformation
    //      that affects the rotation of a visual along the z axis. The coordinate system
    //      is rotated around the specified center point.

    //------------------------------------------------------------------------------

    IDCompositionRotateTransform = interface(IDCompositionTransform)
        ['{641ED83C-AE96-46c5-90DC-32774CC5C6D5}']


        // Animates the value of the Angle property.
        function SetAngle(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the Angle property.
        function SetAngle(angle: single): HRESULT; stdcall;

        // Animates the value of the CenterX property.
        function SetCenterX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the CenterX property.
        function SetCenterX(centerX: single): HRESULT; stdcall;

        // Animates the value of the CenterY property.
        function SetCenterY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the CenterY property.
        function SetCenterY(centerY: single): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionSkewTransform

    //  Synopsis:
    //      An IDCompositionSkewTransform interface represents a 2D transformation that
    //      affects the skew of a visual along the x and y axes. The coordinate system
    //      is skewed around the specified center point.

    //------------------------------------------------------------------------------

    IDCompositionSkewTransform = interface(IDCompositionTransform)
        ['{E57AA735-DCDB-4c72-9C61-0591F58889EE}']


        // Animates the value of the AngleX property.
        function SetAngleX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the AngleX property.
        function SetAngleX(angleX: single): HRESULT; stdcall;



        // Animates the value of the AngleY property.
        function SetAngleY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the AngleY property.
        function SetAngleY(angleY: single): HRESULT; stdcall;



        // Animates the value of the CenterX property.
        function SetCenterX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the CenterX property.
        function SetCenterX(centerX: single): HRESULT; stdcall;



        // Animates the value of the CenterY property.
        function SetCenterY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the CenterY property.
        function SetCenterY(centerY: single): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionMatrixTransform

    //  Synopsis:
    //      An IDCompositionMatrixTransform interface represents an arbitrary affine
    //      2D transformation defined by a 3x2 matrix.

    //------------------------------------------------------------------------------

    IDCompositionMatrixTransform = interface(IDCompositionTransform)
        ['{16CDFF07-C503-419c-83F2-0965C7AF1FA6}']
        // Changes all values of the matrix of this transform.
        function SetMatrix(matrix: TD2D_MATRIX_3X2_F): HRESULT; stdcall;

        // Changes a single element of the matrix of this transform.
        function SetMatrixElement(
        {_In_ } row: int32;
        {_In_ } column: int32;
        {_In_ } Value: single): HRESULT; stdcall;

        // Animates a single element of the matrix of this transform.
        function SetMatrixElement(
        {_In_ } row: int32;
        {_In_ } column: int32;
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionEffectGroup

    //  Synopsis:
    //      An IDCompositionEffectGroup holds effects, inluding 3D transforms that can
    //      be applied to a visual.

    //------------------------------------------------------------------------------

    IDCompositionEffectGroup = interface(IDCompositionEffect)
        ['{A7929A74-E6B2-4bd6-8B95-4040119CA34D}']


        // Animates the opacity property
        function SetOpacity(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the opacity property.
        function SetOpacity(opacity: single): HRESULT; stdcall;

        // Sets the 3D transform
        function SetTransform3D(
        {_In_opt_ } transform3D: IDCompositionTransform3D): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionTranslateTransform3D

    //  Synopsis:
    //      An IDCompositionTranslateTransform3D interface represents a 3D transformation
    //      that affects the offset of a visual along the x,y and z axes.

    //------------------------------------------------------------------------------

    IDCompositionTranslateTransform3D = interface(IDCompositionTransform3D)
        ['{91636D4B-9BA1-4532-AAF7-E3344994D788}']
        // Animates the value of the OffsetX property.
        function SetOffsetX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the OffsetX property.
        function SetOffsetX(offsetX: single): HRESULT; stdcall;

        // Animates the value of the OffsetY property.
        function SetOffsetY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the OffsetY property.
        function SetOffsetY(offsetY: single): HRESULT; stdcall;

        // Animates the value of the OffsetZ property.
        function SetOffsetZ(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the OffsetZ property.
        function SetOffsetZ(offsetZ: single): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionScaleTransform3D

    //  Synopsis:
    //      An IDCompositionScaleTransform3D interface represents a 3D transformation that
    //      affects the scale of a visual along the x, y and z axes. The coordinate system
    //      is scaled from the specified center point.

    //------------------------------------------------------------------------------

    IDCompositionScaleTransform3D = interface(IDCompositionTransform3D)
        ['{2A9E9EAD-364B-4b15-A7C4-A1997F78B389}']


        // Animates the value of the ScaleX property.
        function SetScaleX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the ScaleX property.
        function SetScaleX(scaleX: single): HRESULT; stdcall;



        // Animates the value of the ScaleY property.
        function SetScaleY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the ScaleY property.
        function SetScaleY(scaleY: single): HRESULT; stdcall;



        // Animates the value of the ScaleZ property.
        function SetScaleZ(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the ScaleZ property.
        function SetScaleZ(scaleZ: single): HRESULT; stdcall;



        // Animates the value of the CenterX property.
        function SetCenterX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the CenterX property.
        function SetCenterX(centerX: single): HRESULT; stdcall;



        // Animates the value of the CenterY property.
        function SetCenterY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the CenterY property.
        function SetCenterY(centerY: single): HRESULT; stdcall;



        // Animates the value of the CenterZ property.
        function SetCenterZ(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;


         // Changes the value of the CenterZ property.
        function SetCenterZ(centerZ: single): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionRotateTransform3D

    //  Synopsis:
    //      An IDCompositionRotateTransform3D interface represents a 3D transformation
    //      that affects the rotation of a visual along the specified axis at the
    //      specified center point.

    //------------------------------------------------------------------------------

    IDCompositionRotateTransform3D = interface(IDCompositionTransform3D)
        ['{D8F5B23F-D429-4a91-B55A-D2F45FD75B18}']


        // Animates the value of the Angle property.
        function SetAngle(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the Angle property.
        function SetAngle(angle: single): HRESULT; stdcall;



        // Animates the value of the AxisX property.
        function SetAxisX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the AxisX property.
        function SetAxisX(axisX: single): HRESULT; stdcall;



        // Animates the value of the AxisY property.
        function SetAxisY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the AxisY property.
        function SetAxisY(axisY: single): HRESULT; stdcall;

        // Animates the value of the AxisZ property.
        function SetAxisZ(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the AxisZ property.
        function SetAxisZ(axisZ: single): HRESULT; stdcall;

        // Animates the value of the CenterX property.
        function SetCenterX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the CenterX property.
        function SetCenterX(centerX: single): HRESULT; stdcall;



        // Animates the value of the CenterY property.
        function SetCenterY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the CenterY property.
        function SetCenterY(centerY: single): HRESULT; stdcall;



        // Animates the value of the CenterZ property.
        function SetCenterZ(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the CenterZ property.
        function SetCenterZ(centerZ: single): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionMatrixTransform3D

    //  Synopsis:
    //      An IDCompositionMatrixTransform3D interface represents an arbitrary
    //      3D transformation defined by a 4x4 matrix.

    //------------------------------------------------------------------------------

    IDCompositionMatrixTransform3D = interface(IDCompositionTransform3D)
        ['{4B3363F0-643B-41b7-B6E0-CCF22D34467C}']
        // Changes all values of the matrix of this transform.
        function SetMatrix(matrix: TD3DMATRIX): HRESULT; stdcall;

        // Changes a single element of the matrix of this transform.
        function SetMatrixElement(
        {_In_ } row: int32;
        {_In_ } column: int32;
        {_In_ } Value: single): HRESULT; stdcall;

        // Animates a single element of the matrix of this transform.
        function SetMatrixElement(
        {_In_ } row: int32;
        {_In_ } column: int32;
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionClip

    //  Synopsis:
    //      An IDCompositionClip interface represents a rectangle that restricts the
    //      rasterization of a visual subtree.

    //------------------------------------------------------------------------------

    IDCompositionClip = interface(IUnknown)
        ['{64AC3703-9D3F-45ec-A109-7CAC0E7A13A7}']
    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionRectangleClip

    //  Synopsis:
    //      An IDCompositionRectangleClip interface represents a rectangle that restricts
    //      the rasterization of a visual subtree.

    //------------------------------------------------------------------------------

    IDCompositionRectangleClip = interface(IDCompositionClip)
        ['{9842AD7D-D9CF-4908-AED7-48B51DA5E7C2}']


        // Animates the value of the Left property.
        function SetLeft(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the Left property.
        function SetLeft(left: single): HRESULT; stdcall;



        // Animates the value of the Top property.
        function SetTop(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the Top property.
        function SetTop(top: single): HRESULT; stdcall;



        // Animates the value of the Right property.
        function SetRight(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the Right property.
        function SetRight(right: single): HRESULT; stdcall;



        // Animates the value of the Bottom property.
        function SetBottom(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the Bottom property.
        function SetBottom(bottom: single): HRESULT; stdcall;



        // Animates the value of the x radius of the ellipse that rounds the
        // top-left corner of the clip.
        function SetTopLeftRadiusX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the x radius of the ellipse that rounds the
        // top-left corner of the clip.
        function SetTopLeftRadiusX(radius: single): HRESULT; stdcall;



        // Animates the value of the y radius of the ellipse that rounds the
        // top-left corner of the clip.
        function SetTopLeftRadiusY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the y radius of the ellipse that rounds the
        // top-left corner of the clip.
        function SetTopLeftRadiusY(radius: single): HRESULT; stdcall;



        // Animates the value of the x radius of the ellipse that rounds the
        // top-right corner of the clip.
        function SetTopRightRadiusX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the x radius of the ellipse that rounds the
        // top-right corner of the clip.
        function SetTopRightRadiusX(radius: single): HRESULT; stdcall;



        // Animates the value of the y radius of the ellipse that rounds the
        // top-right corner of the clip.
        function SetTopRightRadiusY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the y radius of the ellipse that rounds the
        // top-right corner of the clip.
        function SetTopRightRadiusY(radius: single): HRESULT; stdcall;



        // Animates the value of the x radius of the ellipse that rounds the
        // bottom-left corner of the clip.
        function SetBottomLeftRadiusX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the x radius of the ellipse that rounds the
        // bottom-left corner of the clip.
        function SetBottomLeftRadiusX(radius: single): HRESULT; stdcall;



        // Animates the value of the y radius of the ellipse that rounds the
        // bottom-left corner of the clip.
        function SetBottomLeftRadiusY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the y radius of the ellipse that rounds the
        // bottom-left corner of the clip.
        function SetBottomLeftRadiusY(radius: single): HRESULT; stdcall;



        // Animates the value of the x radius of the ellipse that rounds the
        // bottom-right corner of the clip.
        function SetBottomRightRadiusX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the x radius of the ellipse that rounds the
        // bottom-right corner of the clip.
        function SetBottomRightRadiusX(radius: single): HRESULT; stdcall;

        // Animates the value of the y radius of the ellipse that rounds the
        // bottom-right corner of the clip.
        function SetBottomRightRadiusY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of the y radius of the ellipse that rounds the
        // bottom-right corner of the clip.
        function SetBottomRightRadiusY(radius: single): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionSurface

    //  Synopsis:
    //      An IDCompositionSurface interface represents a wrapper around a DirectX
    //      object, or a sub-rectangle of one of those objects.

    //------------------------------------------------------------------------------

    IDCompositionSurface = interface(IUnknown)
        ['{BB8A4953-2C99-4F5A-96F5-4819027FA3AC}']
        function BeginDraw(
        {_In_opt_ } updateRect: PRECT;
        {_In_ } iid: REFIID;
        {_Outptr_ }  out updateObject;
        {_Out_ } updateOffset: PPOINT): HRESULT; stdcall;

        function EndDraw(): HRESULT; stdcall;

        function SuspendDraw(): HRESULT; stdcall;

        function ResumeDraw(): HRESULT; stdcall;

        function Scroll(
        {_In_opt_ } scrollRect: PRECT;
        {_In_opt_ } clipRect: PRECT;
        {_In_ } offsetX: int32;
        {_In_ } offsetY: int32): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionVirtualSurface

    //  Synopsis:
    //      An IDCompositionVirtualSurface interface represents a sparsely
    //      allocated surface.

    //------------------------------------------------------------------------------

    IDCompositionVirtualSurface = interface(IDCompositionSurface)
        ['{AE471C51-5F53-4A24-8D3E-D0C39C30B3F0}']
        function Resize(
        {_In_ } Width: UINT;
        {_In_ } Height: UINT): HRESULT; stdcall;

        function Trim(
        {_In_reads_opt_(count) } rectangles: PRECT;
        {_In_ } Count: UINT): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionDevice2

    //  Synopsis:
    //      Serves as the root factory for all other DirectComposition2 objects and
    //      controls transactional composition.

    //------------------------------------------------------------------------------

    IDCompositionDevice2 = interface(IUnknown)
        ['{75F6468D-1B8E-447C-9BC6-75FEA80B5B25}']
        // Commits all DirectComposition commands pending on this device.
        function Commit(): HRESULT; stdcall;

        // Waits for the last Commit to be processed by the composition engine
        function WaitForCommitCompletion(): HRESULT; stdcall;

        // Gets timing information about the composition engine.
        function GetFrameStatistics(
        {_Out_ } statistics: PDCOMPOSITION_FRAME_STATISTICS): HRESULT; stdcall;

        // Creates a new visual object.
        function CreateVisual(
        {_Outptr_ }  out visual: IDCompositionVisual2): HRESULT; stdcall;

        // Creates a factory for surface objects
        function CreateSurfaceFactory(
        {_In_ } renderingDevice: IUnknown;
        {_Outptr_ }  out surfaceFactory: IDCompositionSurfaceFactory): HRESULT; stdcall;

        // Creates a DirectComposition surface object
        function CreateSurface(
        {_In_ } Width: UINT;
        {_In_ } Height: UINT;
        {_In_ } pixelFormat: TDXGI_FORMAT;
        {_In_ } alphaMode: TDXGI_ALPHA_MODE;
        {_Outptr_ }  out surface: IDCompositionSurface): HRESULT; stdcall;

        // Creates a DirectComposition virtual surface object
        function CreateVirtualSurface(
        {_In_ } initialWidth: UINT;
        {_In_ } initialHeight: UINT;
        {_In_ } pixelFormat: TDXGI_FORMAT;
        {_In_ } alphaMode: TDXGI_ALPHA_MODE;
        {_Outptr_ }  out virtualSurface: IDCompositionVirtualSurface): HRESULT; stdcall;

        // Creates a 2D translation transform object.
        function CreateTranslateTransform(
        {_Outptr_ }  out translateTransform: IDCompositionTranslateTransform): HRESULT; stdcall;

        // Creates a 2D scale transform object.
        function CreateScaleTransform(
        {_Outptr_ }  out scaleTransform: IDCompositionScaleTransform): HRESULT; stdcall;

        // Creates a 2D rotation transform object.
        function CreateRotateTransform(
        {_Outptr_ }  out rotateTransform: IDCompositionRotateTransform): HRESULT; stdcall;

        // Creates a 2D skew transform object.
        function CreateSkewTransform(
        {_Outptr_ }  out skewTransform: IDCompositionSkewTransform): HRESULT; stdcall;

        // Creates a 2D 3x2 matrix transform object.
        function CreateMatrixTransform(
        {_Outptr_ }  out matrixTransform: IDCompositionMatrixTransform): HRESULT; stdcall;

        // Creates a 2D transform object that holds an array of 2D transform objects.
        function CreateTransformGroup(
        {_In_reads_(elements) } transforms: PIDCompositionTransform; elements: UINT;
        {_Outptr_ }  out transformGroup: IDCompositionTransform): HRESULT; stdcall;

        // Creates a 3D translation transform object.
        function CreateTranslateTransform3D(
        {_Outptr_ }  out translateTransform3D: IDCompositionTranslateTransform3D): HRESULT; stdcall;

        // Creates a 3D scale transform object.
        function CreateScaleTransform3D(
        {_Outptr_ }  out scaleTransform3D: IDCompositionScaleTransform3D): HRESULT; stdcall;

        // Creates a 3D rotation transform object.
        function CreateRotateTransform3D(
        {_Outptr_ }  out rotateTransform3D: IDCompositionRotateTransform3D): HRESULT; stdcall;

        // Creates a 3D 4x4 matrix transform object.
        function CreateMatrixTransform3D(
        {_Outptr_ }  out matrixTransform3D: IDCompositionMatrixTransform3D): HRESULT; stdcall;

        // Creates a 3D transform object that holds an array of 3D transform objects.
        function CreateTransform3DGroup(
        {_In_reads_(elements) } transforms3D: PIDCompositionTransform3D; elements: UINT;
        {_Outptr_ }  out transform3DGroup: IDCompositionTransform3D): HRESULT; stdcall;

        // Creates an effect group
        function CreateEffectGroup(
        {_Outptr_ }  out effectGroup: IDCompositionEffectGroup): HRESULT; stdcall;

        // Creates a clip object that can be used to clip the contents of a visual subtree.
        function CreateRectangleClip(
        {_Outptr_ }  out clip: IDCompositionRectangleClip): HRESULT; stdcall;

        // Creates an animation object
        function CreateAnimation(
        {_Outptr_ }  out animation: IDCompositionAnimation): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionDesktopDevice

    //  Synopsis:
    //      Serves as the root factory for all other desktop DirectComposition
    //      objects.

    //------------------------------------------------------------------------------

    IDCompositionDesktopDevice = interface(IDCompositionDevice2)
        ['{5F4633FE-1E08-4CB8-8C75-CE24333F5602}']
        function CreateTargetForHwnd(
        {_In_ } hwnd: HWND; topmost: boolean;
        {_Outptr_ }  out target: IDCompositionTarget): HRESULT; stdcall;

        // Creates a surface wrapper around a pre-existing surface that can be associated with one or more visuals for composition.
        function CreateSurfaceFromHandle(
        {_In_ } handle: HANDLE;
        {_Outptr_ }  out surface: IUnknown): HRESULT; stdcall;

        // Creates a wrapper object that represents the rasterization of a layered window and which can be associated with a visual for composition.
        function CreateSurfaceFromHwnd(
        {_In_ } hwnd: HWND;
        {_Outptr_ }  out surface: IUnknown): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionDeviceDebug

    //  Synopsis:
    //      IDCompositionDeviceDebug serves as a debug interface

    //------------------------------------------------------------------------------

    IDCompositionDeviceDebug = interface(IUnknown)
        ['{A1A3C64A-224F-4A81-9773-4F03A89D3C6C}']
        // Enables debug counters
        function EnableDebugCounters(): HRESULT; stdcall;

        // Disables debug counters
        function DisableDebugCounters(): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionSurfaceFactory

    //  Synopsis:
    //      An IDCompositionSurfaceFactory interface represents an object that can
    //      create surfaces suitable for composition.

    //------------------------------------------------------------------------------

    IDCompositionSurfaceFactory = interface(IUnknown)
        ['{E334BC12-3937-4E02-85EB-FCF4EB30D2C8}']
        // Creates a DirectComposition surface object
        function CreateSurface(
        {_In_ } Width: UINT;
        {_In_ } Height: UINT;
        {_In_ } pixelFormat: TDXGI_FORMAT;
        {_In_ } alphaMode: TDXGI_ALPHA_MODE;
        {_Outptr_ }  out surface: IDCompositionSurface): HRESULT; stdcall;

        // Creates a DirectComposition virtual surface object
        function CreateVirtualSurface(
        {_In_ } initialWidth: UINT;
        {_In_ } initialHeight: UINT;
        {_In_ } pixelFormat: TDXGI_FORMAT;
        {_In_ } alphaMode: TDXGI_ALPHA_MODE;
        {_Outptr_ }  out virtualSurface: IDCompositionVirtualSurface): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionVisual2

    //  Synopsis:
    //      An IDCompositionVisual2 interface represents a visual that participates in
    //      a visual tree.

    //------------------------------------------------------------------------------

    IDCompositionVisual2 = interface(IDCompositionVisual)
        ['{E8DE1639-4331-4B26-BC5F-6A321D347A85}']
        // Changes the interpretation of the opacity property of an effect group
        // associated with this visual
        function SetOpacityMode(
        {_In_ } mode: TDCOMPOSITION_OPACITY_MODE): HRESULT; stdcall;

        // Sets back face visibility
        function SetBackFaceVisibility(
        {_In_ } visibility: TDCOMPOSITION_BACKFACE_VISIBILITY): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionVisualDebug

    //  Synopsis:
    //      An IDCompositionVisualDebug interface represents a debug visual

    //------------------------------------------------------------------------------

    IDCompositionVisualDebug = interface(IDCompositionVisual2)
        ['{FED2B808-5EB4-43A0-AEA3-35F65280F91B}']
        // Enable heat map
        function EnableHeatMap(
        {_In_ } color: TD2D1_COLOR_F): HRESULT; stdcall;

        // Disable heat map
        function DisableHeatMap(): HRESULT; stdcall;

        // Enable redraw regions
        function EnableRedrawRegions(): HRESULT; stdcall;

        // Disable redraw regions
        function DisableRedrawRegions(): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionVisual3

    //  Synopsis:
    //      An IDCompositionVisual3 interface represents a visual that participates in
    //      a visual tree.

    //------------------------------------------------------------------------------

    IDCompositionVisual3 = interface(IDCompositionVisualDebug)
        ['{2775F462-B6C1-4015-B0BE-B3E7D6A4976D}']
        // Sets depth mode property associated with this visual
        function SetDepthMode(
        {_In_ } mode: TDCOMPOSITION_DEPTH_MODE): HRESULT; stdcall;

        // Animates the value of the OffsetZ property.
        function SetOffsetZ(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the value of OffsetZ property.
        function SetOffsetZ(offsetZ: single): HRESULT; stdcall;

        // Animates the value of the Opacity property.
        function SetOpacity(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

         // Changes the value of the Opacity property.
        function SetOpacity(opacity: single): HRESULT; stdcall;

        // Sets the matrix that modifies the coordinate system of this visual.
        function SetTransform(matrix: TD2D_MATRIX_4X4_F): HRESULT; stdcall;

        // Sets the transformation object that modifies the coordinate system of this visual.
        function SetTransform(
        {_In_opt_ } transform: IDCompositionTransform3D): HRESULT; stdcall;

        // Changes the value of the Visible property
        function SetVisible(Visible: boolean): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionDevice3

    //  Synopsis:
    //      Serves as the root factory for all other DirectComposition3 objects and
    //      controls transactional composition.

    //------------------------------------------------------------------------------

    IDCompositionDevice3 = interface(IDCompositionDevice2)
        ['{0987CB06-F916-48BF-8D35-CE7641781BD9}']
        // Effect creation calls, each creates an interface around a D2D1Effect
        function CreateGaussianBlurEffect(
        {_Outptr_ }  out gaussianBlurEffect: IDCompositionGaussianBlurEffect): HRESULT; stdcall;

        function CreateBrightnessEffect(
        {_Outptr_ }  out brightnessEffect: IDCompositionBrightnessEffect): HRESULT; stdcall;

        function CreateColorMatrixEffect(
        {_Outptr_ }  out colorMatrixEffect: IDCompositionColorMatrixEffect): HRESULT; stdcall;

        function CreateShadowEffect(
        {_Outptr_ }  out shadowEffect: IDCompositionShadowEffect): HRESULT; stdcall;

        function CreateHueRotationEffect(
        {_Outptr_ }  out hueRotationEffect: IDCompositionHueRotationEffect): HRESULT; stdcall;

        function CreateSaturationEffect(
        {_Outptr_ }  out saturationEffect: IDCompositionSaturationEffect): HRESULT; stdcall;

        function CreateTurbulenceEffect(
        {_Outptr_ }  out turbulenceEffect: IDCompositionTurbulenceEffect): HRESULT; stdcall;

        function CreateLinearTransferEffect(
        {_Outptr_ }  out linearTransferEffect: IDCompositionLinearTransferEffect): HRESULT; stdcall;

        function CreateTableTransferEffect(
        {_Outptr_ }  out tableTransferEffect: IDCompositionTableTransferEffect): HRESULT; stdcall;

        function CreateCompositeEffect(
        {_Outptr_ }  out compositeEffect: IDCompositionCompositeEffect): HRESULT; stdcall;

        function CreateBlendEffect(
        {_Outptr_ }  out blendEffect: IDCompositionBlendEffect): HRESULT; stdcall;

        function CreateArithmeticCompositeEffect(
        {_Outptr_ }  out arithmeticCompositeEffect: IDCompositionArithmeticCompositeEffect): HRESULT; stdcall;

        function CreateAffineTransform2DEffect(
        {_Outptr_ }  out affineTransform2dEffect: IDCompositionAffineTransform2DEffect): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionFilterEffect

    //  Synopsis:
    //      An IDCompositionFilterEffect interface represents a filter effect

    //------------------------------------------------------------------------------

    IDCompositionFilterEffect = interface(IDCompositionEffect)
        ['{30C421D5-8CB2-4E9F-B133-37BE270D4AC2}']
        // Sets the input at the given index to the filterEffect (NULL will use source visual, unless flagged otherwise)
        function SetInput(
        {_In_ } index: UINT;
        {_In_opt_ } input: IUnknown;
        {_In_ } flags: UINT): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionGaussianBlurEffect

    //  Synopsis:
    //      An IDCompositionGaussianBlurEffect interface represents a gaussian blur filter effect

    //------------------------------------------------------------------------------

    IDCompositionGaussianBlurEffect = interface(IDCompositionFilterEffect)
        ['{45D4D0B7-1BD4-454E-8894-2BFA68443033}']
        // Changes the amount of blur to be applied.

        function SetStandardDeviation(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

                function SetStandardDeviation(
        {_In_ } amount: single): HRESULT; stdcall;


        // Changes border mode (see D2D1_GAUSSIANBLUR)
        function SetBorderMode(
        {_In_ } mode: TD2D1_BORDER_MODE): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionBrightnessEffect

    //  Synopsis:
    //      An IDCompositionBrightnessEffect interface represents a brightness filter effect

    //------------------------------------------------------------------------------

    IDCompositionBrightnessEffect = interface(IDCompositionFilterEffect)
        ['{6027496E-CB3A-49AB-934F-D798DA4F7DA6}']
        // Changes the value of white point property.
        function SetWhitePoint(
        {_In_ } whitePoint: TD2D1_VECTOR_2F): HRESULT; stdcall;

        // Changes the value of black point property
        function SetBlackPoint(
        {_In_ } blackPoint: TD2D1_VECTOR_2F): HRESULT; stdcall;

        // Changes the X value of the white point property.
        function SetWhitePointX(
        {_In_ } whitePointX: single): HRESULT; stdcall;

        function SetWhitePointX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the Y value of the white point property.
        function SetWhitePointY(
        {_In_ } whitePointY: single): HRESULT; stdcall;

        function SetWhitePointY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the X value of the black point property.
        function SetBlackPointX(
        {_In_ } blackPointX: single): HRESULT; stdcall;

        function SetBlackPointX(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the Y value of the black point property.
        function SetBlackPointY(
        {_In_ } blackPointY: single): HRESULT; stdcall;

        function SetBlackPointY(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionColorMatrixEffect

    //  Synopsis:
    //      An IDCompositionColorMatrixEffect interface represents a color matrix filter effect

    //------------------------------------------------------------------------------

    IDCompositionColorMatrixEffect = interface(IDCompositionFilterEffect)
        ['{C1170A22-3CE2-4966-90D4-55408BFC84C4}']
        // Changes all values of the matrix for a color transform
        function SetMatrix(
        {_In_ } matrix: TD2D1_MATRIX_5X4_F): HRESULT; stdcall;

        // Changes a single element of the matrix of this color transform.
        function SetMatrixElement(
        {_In_ } row: int32;
        {_In_ } column: int32;
        {_In_ } Value: single): HRESULT; stdcall;

        // Animates a single element of the matrix of this color transform.
        function SetMatrixElement(
        {_In_ } row: int32;
        {_In_ } column: int32;
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes the alpha mode
        function SetAlphaMode(
        {_In_ } mode: TD2D1_COLORMATRIX_ALPHA_MODE): HRESULT; stdcall;

        // Sets the clamp output property
        function SetClampOutput(
        {_In_ } clamp: boolean): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionShadowEffect

    //  Synopsis:
    //      An IDCompositionShadowEffect interface represents a shadow filter effect

    //------------------------------------------------------------------------------

    IDCompositionShadowEffect = interface(IDCompositionFilterEffect)
        ['{4AD18AC0-CFD2-4C2F-BB62-96E54FDB6879}']
        // Changes the amount of blur to be applied.
        function SetStandardDeviation(
        {_In_ } amount: single): HRESULT; stdcall;

        function SetStandardDeviation(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        // Changes shadow color
        function SetColor(
        {_In_ } color: TD2D1_VECTOR_4F): HRESULT; stdcall;

        function SetRed(
        {_In_ } amount: single): HRESULT; stdcall;

        function SetRed(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetGreen(
        {_In_ } amount: single): HRESULT; stdcall;

        function SetGreen(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetBlue(
        {_In_ } amount: single): HRESULT; stdcall;

        function SetBlue(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetAlpha(
        {_In_ } amount: single): HRESULT; stdcall;

        function SetAlpha(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionHueRotationEffect

    //  Synopsis:
    //      An IDCompositionHueRotationEffect interface represents a hue rotation filter effect

    //------------------------------------------------------------------------------

    IDCompositionHueRotationEffect = interface(IDCompositionFilterEffect)
        ['{6DB9F920-0770-4781-B0C6-381912F9D167}']
        // Changes the angle of rotation
        function SetAngle(
        {_In_ } amountDegrees: single): HRESULT; stdcall;

        function SetAngle(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionSaturationEffect

    //  Synopsis:
    //      An IDCompositionSaturationEffect interface represents a saturation filter effect

    //------------------------------------------------------------------------------

    IDCompositionSaturationEffect = interface(IDCompositionFilterEffect)
        ['{A08DEBDA-3258-4FA4-9F16-9174D3FE93B1}']
        // Changes the amount of saturation to be applied.
        function SetSaturation(
        {_In_ } ratio: single): HRESULT; stdcall;

        function SetSaturation(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionTurbulenceEffect

    //  Synopsis:
    //      An IDCompositionTurbulenceEffect interface represents a turbulence filter effect

    //------------------------------------------------------------------------------

    IDCompositionTurbulenceEffect = interface(IDCompositionFilterEffect)
        ['{A6A55BDA-C09C-49F3-9193-A41922C89715}']
        // Changes the starting offset of the turbulence
        function SetOffset(
        {_In_ } offset: TD2D1_VECTOR_2F): HRESULT; stdcall;

        // Changes the base frequency of the turbulence
        function SetBaseFrequency(
        {_In_ } frequency: TD2D1_VECTOR_2F): HRESULT; stdcall;

        // Changes the output size of the turbulence
        function SetSize(
        {_In_ } size: TD2D1_VECTOR_2F): HRESULT; stdcall;

        // Sets the number of octaves
        function SetNumOctaves(
        {_In_ } numOctaves: UINT): HRESULT; stdcall;

        // Set the random number seed
        function SetSeed(
        {_In_ } seed: UINT): HRESULT; stdcall;

        // Set the noise mode
        function SetNoise(
        {_In_ } noise: TD2D1_TURBULENCE_NOISE): HRESULT; stdcall;

        // Set stitchable
        function SetStitchable(
        {_In_ } stitchable: boolean): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionLinearTransferEffect

    //  Synopsis:
    //      An IDCompositionLinearTransferEffect interface represents a linear transfer filter effect

    //------------------------------------------------------------------------------

    IDCompositionLinearTransferEffect = interface(IDCompositionFilterEffect)
        ['{4305EE5B-C4A0-4C88-9385-67124E017683}']
        function SetRedYIntercept(
        {_In_ } redYIntercept: single): HRESULT; stdcall;

        function SetRedYIntercept(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetRedSlope(
        {_In_ } redSlope: single): HRESULT; stdcall;

        function SetRedSlope(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetRedDisable(
        {_In_ } redDisable: boolean): HRESULT; stdcall;

        function SetGreenYIntercept(
        {_In_ } greenYIntercept: single): HRESULT; stdcall;

        function SetGreenYIntercept(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetGreenSlope(
        {_In_ } greenSlope: single): HRESULT; stdcall;

        function SetGreenSlope(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetGreenDisable(
        {_In_ } greenDisable: boolean): HRESULT; stdcall;

        function SetBlueYIntercept(
        {_In_ } blueYIntercept: single): HRESULT; stdcall;

        function SetBlueYIntercept(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetBlueSlope(
        {_In_ } blueSlope: single): HRESULT; stdcall;

        function SetBlueSlope(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetBlueDisable(
        {_In_ } blueDisable: boolean): HRESULT; stdcall;

        function SetAlphaYIntercept(
        {_In_ } alphaYIntercept: single): HRESULT; stdcall;

        function SetAlphaYIntercept(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetAlphaSlope(
        {_In_ } alphaSlope: single): HRESULT; stdcall;

        function SetAlphaSlope(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetAlphaDisable(
        {_In_ } alphaDisable: boolean): HRESULT; stdcall;

        function SetClampOutput(
        {_In_ } clampOutput: boolean): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionTableTransferEffect

    //  Synopsis:
    //      An IDCompositionTableTransferEffect interface represents a Table transfer filter effect

    //------------------------------------------------------------------------------

    IDCompositionTableTransferEffect = interface(IDCompositionFilterEffect)
        ['{9B7E82E2-69C5-4EB4-A5F5-A7033F5132CD}']
        function SetRedTable(
        {_In_count_(count) } tableValues: Psingle;
        {_In_ } Count: UINT): HRESULT; stdcall;

        function SetGreenTable(
        {_In_count_(count) } tableValues: Psingle;
        {_In_ } Count: UINT): HRESULT; stdcall;

        function SetBlueTable(
        {_In_count_(count) } tableValues: Psingle;
        {_In_ } Count: UINT): HRESULT; stdcall;

        function SetAlphaTable(
        {_In_count_(count) } tableValues: Psingle;
        {_In_ } Count: UINT): HRESULT; stdcall;

        function SetRedDisable(
        {_In_ } redDisable: boolean): HRESULT; stdcall;

        function SetGreenDisable(
        {_In_ } greenDisable: boolean): HRESULT; stdcall;

        function SetBlueDisable(
        {_In_ } blueDisable: boolean): HRESULT; stdcall;

        function SetAlphaDisable(
        {_In_ } alphaDisable: boolean): HRESULT; stdcall;

        function SetClampOutput(
        {_In_ } clampOutput: boolean): HRESULT; stdcall;

        // Note:  To set individual values, the table must have already been initialized
        //        with a buffer of values of the appropriate size, or these calls will fail
        function SetRedTableValue(
        {_In_ } index: UINT;
        {_In_ } Value: single): HRESULT; stdcall;

        function SetRedTableValue(
        {_In_ } index: UINT;
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetGreenTableValue(
        {_In_ } index: UINT;
        {_In_ } Value: single): HRESULT; stdcall;

        function SetGreenTableValue(
        {_In_ } index: UINT;
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetBlueTableValue(
        {_In_ } index: UINT;
        {_In_ } Value: single): HRESULT; stdcall;

        function SetBlueTableValue(
        {_In_ } index: UINT;
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetAlphaTableValue(
        {_In_ } index: UINT;
        {_In_ } Value: single): HRESULT; stdcall;

        function SetAlphaTableValue(
        {_In_ } index: UINT;
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionCompositeEffect

    //  Synopsis:
    //      An IDCompositionCompositeEffect interface represents a composite filter effect

    //------------------------------------------------------------------------------

    IDCompositionCompositeEffect = interface(IDCompositionFilterEffect)
        ['{576616C0-A231-494D-A38D-00FD5EC4DB46}']
        // Changes the composite mode.
        function SetMode(
        {_In_ } mode: TD2D1_COMPOSITE_MODE): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionBlendEffect

    //  Synopsis:
    //      An IDCompositionBlendEffect interface represents a blend filter effect

    //------------------------------------------------------------------------------

    IDCompositionBlendEffect = interface(IDCompositionFilterEffect)
        ['{33ECDC0A-578A-4A11-9C14-0CB90517F9C5}']
        function SetMode(
        {_In_ } mode: TD2D1_BLEND_MODE): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionArithmeticCompositeEffect

    //  Synopsis:
    //      An IDCompositionArithmeticCompositeEffect interface represents an arithmetic composite filter effect

    //------------------------------------------------------------------------------

    IDCompositionArithmeticCompositeEffect = interface(IDCompositionFilterEffect)
        ['{3B67DFA8-E3DD-4E61-B640-46C2F3D739DC}']
        function SetCoefficients(
        {_In_ } coefficients: TD2D1_VECTOR_4F): HRESULT; stdcall;

        function SetClampOutput(
        {_In_ } clampoutput: boolean): HRESULT; stdcall;

        function SetCoefficient1(
        {_In_ } Coeffcient1: single): HRESULT; stdcall;

        function SetCoefficient1(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetCoefficient2(
        {_In_ } Coefficient2: single): HRESULT; stdcall;

        function SetCoefficient2(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetCoefficient3(
        {_In_ } Coefficient3: single): HRESULT; stdcall;

        function SetCoefficient3(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetCoefficient4(
        {_In_ } Coefficient4: single): HRESULT; stdcall;

        function SetCoefficient4(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionAffineTransform2DEffect

    //  Synopsis:
    //      An IDCompositionAffineTransform2DEffect interface represents a affine transform 2D filter effect

    //------------------------------------------------------------------------------
    IDCompositionAffineTransform2DEffect = interface(IDCompositionFilterEffect)
        ['{0B74B9E8-CDD6-492F-BBBC-5ED32157026D}']
        function SetInterpolationMode(
        {_In_ } interpolationMode: TD2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE): HRESULT; stdcall;

        function SetBorderMode(
        {_In_ } borderMode: TD2D1_BORDER_MODE): HRESULT; stdcall;

        function SetTransformMatrix(
        {_In_ } transformMatrix: TD2D1_MATRIX_3X2_F): HRESULT; stdcall;

        function SetTransformMatrixElement(
        {_In_ } row: int32;
        {_In_ } column: int32;
        {_In_ } Value: single): HRESULT; stdcall;

        function SetTransformMatrixElement(
        {_In_ } row: int32;
        {_In_ } column: int32;
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

        function SetSharpness(
        {_In_ } sharpness: single): HRESULT; stdcall;

        function SetSharpness(
        {_In_ } animation: IDCompositionAnimation): HRESULT; stdcall;

    end;


    TDCompositionInkTrailPoint = record
        x: single;
        y: single;
        radius: single;
    end;
    PDCompositionInkTrailPoint = ^TDCompositionInkTrailPoint;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionDelegatedInkTrail

    //  Synopsis:
    //      An IDCompositionDelegatedInkTrail interface represents low latency ink
    //      that the system renders on behalf of the app.

    //------------------------------------------------------------------------------

    IDCompositionDelegatedInkTrail = interface(IUnknown)
        ['{C2448E9B-547D-4057-8CF5-8144EDE1C2DA}']
        // Returns a generation id to be used when removing points later
        function AddTrailPoints(
        {_In_reads_(inkPointsCount) } inkPoints: PDCompositionInkTrailPoint; inkPointsCount: UINT;
        {_Out_ } generationId: PUINT): HRESULT; stdcall;

        // Returns a generation id to be used when removing points later
        function AddTrailPointsWithPrediction(
        {_In_reads_(inkPointsCount) } inkPoints: PDCompositionInkTrailPoint; inkPointsCount: UINT;
        {_In_reads_(predictedInkPointsCount) } predictedInkPoints: PDCompositionInkTrailPoint; predictedInkPointsCount: UINT;
        {_Out_ } generationId: PUINT): HRESULT; stdcall;

        function RemoveTrailPoints(generationId: UINT): HRESULT; stdcall;

        function StartNewTrail(color: TD2D1_COLOR_F): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionInkTrailDevice

    //  Synopsis:
    //      An IDCompositionInkTrailDevice interface is the factory for
    //      creating DelegatedInkTrail objects

    //------------------------------------------------------------------------------

    IDCompositionInkTrailDevice = interface(IUnknown)
        ['{DF0C7CEC-CDEB-4D4A-B91C-721BF22F4E6C}']
        function CreateDelegatedInkTrail(
        {_Out_ }  out inkTrail: IDCompositionDelegatedInkTrail): HRESULT; stdcall;

        function CreateDelegatedInkTrailForSwapChain(
        {_In_ } swapChain: IUnknown;
        {_Out_ }  out inkTrail: IDCompositionDelegatedInkTrail): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionTexture

    //  Synopsis:
    //      An interface representing a raw D3D texture that can be bound to a
    //      dcomp visual as content.

    //------------------------------------------------------------------------------
    IDCompositionTexture = interface(IUnknown)
        ['{929BB1AA-725F-433B-ABD7-273075A835F2}']
        function SetSourceRect(
        {_In_ } sourceRect: TD2D_RECT_U): HRESULT; stdcall;

        function SetColorSpace(
        {_In_ } colorSpace: TDXGI_COLOR_SPACE_TYPE): HRESULT; stdcall;

        function SetAlphaMode(
        {_In_ } alphaMode: TDXGI_ALPHA_MODE): HRESULT; stdcall;

        function GetAvailableFence(
        {_Out_ } fenceValue: PUINT64;
        {_In_ } iid: REFIID;
        {_Outptr_result_maybenull_ }  out availableFence): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionDevice4

    //  Synopsis:
    //      Serves as the root factory for composition textures.

    //------------------------------------------------------------------------------

    IDCompositionDevice4 = interface(IDCompositionDevice3)
        ['{85FC5CCA-2DA6-494C-86B6-4A775C049B8A}']
        // Determine whether or not the backing D3D device Supports composition textures
        function CheckCompositionTextureSupport(
        {_In_ } renderingDevice: IUnknown;
        {_Out_ } supportsCompositionTextures: Pboolean): HRESULT; stdcall;

        // Call to create a composition texture referencing the passed D3D texture
        function CreateCompositionTexture(
        {_In_ } d3dTexture: IUnknown;
        {_Outptr_result_maybenull_ }  out compositionTexture: IDCompositionTexture): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionDynamicTexture

    //  Synopsis:
    //      An interface representing a dynamically changing texture that can be
    //      bound to a dcomp visual as content.

    //------------------------------------------------------------------------------

    IDCompositionDynamicTexture = interface(IUnknown)
        ['{A1DE1D3F-6405-447F-8E95-1383A34B0277}']
        // Set current texture, assuming that every pixel has changed.
        function SetTexture(
        {_In_ } pTexture: IDCompositionTexture): HRESULT; stdcall;

        // Set current texture, assuming that only pixels inside the provided rects have changed.

        // DWM will use the provided rects to optimize the redrawing of the texture on the screen,
        // but it can't check the correctness of the provided rects, so the caller is responsible for
        // including every pixel that changed in at least one rect. There are no guarantees about
        // what will be redrawn outside of the provided dirty rects. It means that DWM may choose to draw
        // any set of additional pixels outside of provided dirty rects if it needs to.

        // If provided with an empty array or empty rects, this method will treat the texture as identical
        // to the previous one so that DWM may choose not to redraw it.
        function SetTexture(
        {_In_ } pTexture: IDCompositionTexture;
        {_In_count_(rectCount) } pRects: PD2D_RECT_L;
        {_In_ } rectCount: size_t): HRESULT; stdcall;

    end;


    //+-----------------------------------------------------------------------------

    //  Interface:
    //      IDCompositionDevice5

    //  Synopsis:
    //      Servers as the root factory for composition dynamic textures

    //------------------------------------------------------------------------------

    IDCompositionDevice5 = interface(IDCompositionDevice4)
        ['{2C6BEBFE-A603-472F-AF34-D2443356E61B}']
        function CreateDynamicTexture(
        {_Outptr_ }  out compositionDynamicTexture: IDCompositionDynamicTexture): HRESULT; stdcall;

    end;

    //+-----------------------------------------------------------------------------

    //  Function:
    //      DCompositionCreateDevice

    //  Synopsis:
    //      Creates a new DirectComposition device object, which can be used to create
    //      other DirectComposition objects.

//------------------------------------------------------------------------------
function DCompositionCreateDevice(
    {_In_opt_ } dxgiDevice: IDXGIDevice;
    {_In_ } iid: REFIID;
    {_Outptr_ }  out dcompositionDevice): HRESULT; stdcall; external Dcomp_dll;


//+-----------------------------------------------------------------------------

//  Function:
//      DCompositionCreateDevice2

//  Synopsis:
//      Creates a new DirectComposition device object, which can be used to create
//      other DirectComposition objects.

//------------------------------------------------------------------------------
function DCompositionCreateDevice2(
    {_In_opt_ } renderingDevice: IUnknown;
    {_In_ } iid: REFIID;
    {_Outptr_ }  out dcompositionDevice): HRESULT; stdcall; external Dcomp_dll;


//+-----------------------------------------------------------------------------

//  Function:
//      DCompositionCreateDevice3

//  Synopsis:
//      Creates a new DirectComposition device object, which can be used to create
//      other DirectComposition objects.

//------------------------------------------------------------------------------
function DCompositionCreateDevice3(
    {_In_opt_ } renderingDevice: IUnknown;
    {_In_ } iid: REFIID;
    {_Outptr_ }  out dcompositionDevice): HRESULT; stdcall; external Dcomp_dll;


//+-----------------------------------------------------------------------------

//  Function:
//      DCompositionCreateSurfaceHandle

//  Synopsis:
//      Creates a new composition surface object, which can be bound to a
//      DirectX swap chain or swap buffer or to a GDI bitmap and associated
//      with a visual.

//------------------------------------------------------------------------------
function DCompositionCreateSurfaceHandle(
    {_In_ } desiredAccess: DWORD;
    {_In_opt_ } securityAttributes: PSECURITY_ATTRIBUTES;
    {_Out_ } surfaceHandle: PHANDLE): HRESULT; stdcall; external Dcomp_dll;


//+-----------------------------------------------------------------------------

//  Function:
//      DCompositionAttachMouseWheelToHwnd

//  Synopsis:
//      Creates an Interaction/InputSink to route mouse wheel messages to the
//      given HWND. After calling this API, the device owning the visual must
//      be committed.

//------------------------------------------------------------------------------
function DCompositionAttachMouseWheelToHwnd(
    {_In_ } visual: IDCompositionVisual;
    {_In_ } hwnd: HWND;
    {_In_ } enable: boolean): HRESULT; stdcall; external Dcomp_dll;


//+-----------------------------------------------------------------------------

//  Function:
//      DCompositionAttachMouseDragToHwnd

//  Synopsis:
//      Creates an Interaction/InputSink to route mouse button down and any
//      subsequent move and up events to the given HWND. There is no move
//      thresholding; when enabled, all events including and following the down
//      are unconditionally redirected to the specified window. After calling this
//      API, the device owning the visual must be committed.

//------------------------------------------------------------------------------
function DCompositionAttachMouseDragToHwnd(
    {_In_ } visual: IDCompositionVisual;
    {_In_ } hwnd: HWND;
    {_In_ } enable: boolean): HRESULT; stdcall; external Dcomp_dll;


//+-----------------------------------------------------------------------------

//  Function:
//      DCompositionGetCurrentFrameId

//  Synopsis:
//      Returns the frameId of the most recently started composition frame.

//------------------------------------------------------------------------------
function DCompositionGetFrameId(
    {_In_ } frameIdType: TCOMPOSITION_FRAME_ID_TYPE;
    {_Out_ } frameId: PCOMPOSITION_FRAME_ID): HRESULT; stdcall; external Dcomp_dll;


//+-----------------------------------------------------------------------------

//  Function:
//      DCompositionGetStatistics

//  Synopsis:
//      Returns statistics for the requested frame, as well as an optional list
//      of all target ids that existed at that time.

//------------------------------------------------------------------------------
function DCompositionGetStatistics(
    {_In_ } frameId: TCOMPOSITION_FRAME_ID;
    {_Out_ } frameStats: PCOMPOSITION_FRAME_STATS;
    {_In_ } targetIdCount: UINT;
    {_Out_writes_opt_(targetCount) } targetIds: PCOMPOSITION_TARGET_ID;
    {_Out_opt_ } actualTargetIdCount: PUINT): HRESULT; stdcall; external Dcomp_dll;


//+-----------------------------------------------------------------------------

//  Function:
//      DCompositionGetCompositorStatistics

//  Synopsis:
//      Returns compositor target statistics for the requested frame.

//------------------------------------------------------------------------------
function DCompositionGetTargetStatistics(
    {_In_ } frameId: TCOMPOSITION_FRAME_ID;
    {_In_ } targetId: PCOMPOSITION_TARGET_ID;
    {_Out_ } targetStats: PCOMPOSITION_TARGET_STATS): HRESULT; stdcall; external Dcomp_dll;


//+-----------------------------------------------------------------------------

//  Function:
//      DCompositionBoostCompositorClock

//  Synopsis:
//      Requests compositor to temporarily increase framerate.

//------------------------------------------------------------------------------
function DCompositionBoostCompositorClock(
    {_In_ } enable: boolean): HRESULT; stdcall; external Dcomp_dll;


//+-----------------------------------------------------------------------------

//  Function:
//      DCompositionWaitForCompositorClock

//  Synopsis:
//      Waits for a compositor clock tick, other events, or a timeout.

//------------------------------------------------------------------------------
function DCompositionWaitForCompositorClock(
    {_In_range_(0, DCOMPOSITION_MAX_WAITFORCOMPOSITORCLOCK_OBJECTS) } Count: UINT;
    {_In_reads_opt_(count) } handles: PHANDLE;
    {_In_ } timeoutInMs: DWORD): DWORD; stdcall; external Dcomp_dll;


implementation

end.
