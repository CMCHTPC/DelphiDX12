//-------------------------------------------------------------------------------------
// Stereo3DMatrixHelper.h -- SIMD C++ Math helper for Stereo 3D matrices

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
//-------------------------------------------------------------------------------------
unit DirectX.Stereo3DMatrixHelper;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

interface

uses
    Classes, SysUtils, Windows,
    DirectX.Math;

type
    // Enumeration for stereo channels (left and right).
    TSTEREO_CHANNEL = (
        STEREO_CHANNEL_LEFT = 0,
        STEREO_CHANNEL_RIGHT
        );

    // Enumeration for stereo mode (normal or inverted).
    TSTEREO_MODE = (
        STEREO_MODE_NORMAL = 0,
        STEREO_MODE_INVERTED
        );

    //------------------------------------------------------------------------------

    // Stereo calibration settings

    // * Viewer distance to the display
    // * Physical display size
    // * Render resolution

    // The stereo separation factor indicates how much separation is between the left and right
    // eyes.  0 is no separation, 1 is full separation. It defaults to 1.0.

    // The debug stereo exaggeration factor indicates how much to increase the interocular spacing and
    // maximum acuity angle from comfortable defaults.  For retail builds, this value should always
    // be 1.0, but during development, on small screens, this value can be raised to up to 2.0 in
    // order to exaggerate the 3D effect.  Values over 1.0 may cause discomfort on normal sized
    // displays. It defaults to 1.0.

    TSTEREO_PARAMETERS = record
        fViewerDistanceInches: single;
        fDisplaySizeInches: single;
        fPixelResolutionWidth: single;
        fPixelResolutionHeight: single;
        fStereoSeparationFactor: single;
        fStereoExaggerationFactor: single;
    end;
    PSTEREO_PARAMETERS = ^TSTEREO_PARAMETERS;

procedure StereoCreateDefaultParameters(var stereoParameters: TSTEREO_PARAMETERS);

function StereoProjectionFovLH(const pStereoParameters: PSTEREO_PARAMETERS; Channel: TSTEREO_CHANNEL;
    FovAngleY, AspectRatio, NearZ, FarZ: single; StereoMode: TSTEREO_MODE = STEREO_MODE_NORMAL): TXMMATRIX;

function StereoProjectionFovRH(const pStereoParameters: PSTEREO_PARAMETERS; Channel: TSTEREO_CHANNEL;
    FovAngleY, AspectRatio, NearZ, FarZ: single; StereoMode: TSTEREO_MODE = STEREO_MODE_NORMAL): TXMMATRIX;

implementation

uses
    Math;



function StereoProjectionHelper
    (const stereoParameters: PSTEREO_PARAMETERS; var fVirtualProjection, zNearWidth, zNearHeight: single;
    FovAngleY, AspectRatio, NearZ: single): boolean;
const
    fMaxStereoDistance: single = 780; // inches (should be between 10 and 20m)
    fMaxVisualAcuityAngle: single = 1.6 * (XM_PI / 180.0);  // radians
    fInterocularDistance: single = 1.25; // inches
var
    ComfortableResult: boolean;
    fDisplayHeight, fDisplayWidth, fHalfInterocular, fHalfPixelWidth, fHalfMaximumAcuityAngle: single;
    fMaxSeparationAcuityAngle, fMaxSeparationDistance, fRefinedMaxStereoDistance, fFovHalfAngle: single;
    fRefinedMaxSeparationAcuityAngle, fPhysicalZNearDistance, fNearZSeparation: single;
begin
    // note that most people have difficulty fusing images into 3D
    // if the separation equals even just the human average. by
    // reducing the separation (interocular distance) by 1/2, we
    // guarantee a larger subset of people will see full 3D
    // the conservative setting should always be used. the only problem
    // with the conservative setting is that the 3D effect will be less
    // impressive on smaller screens (which makes sense, since your eye
    // cannot be tricked as easily based on the smaller fov). to simulate
    // the effect of a larger screen, use the liberal settings (debug only)
    // Conservative Settings: * max acuity angle: 0.8f degrees * interoc distance: 1.25 inches
    // Liberal Settings: * max acuity angle: 1.6f degrees * interoc distance: 2.5 inches
    // maximum visual accuity angle allowed is 3.2 degrees for
    // a physical scene, and 1.6 degrees for a virtual one.
    // thus we cannot allow an object to appear any closer to
    // the viewer than 1.6 degrees (divided by two for most
    // half-angle calculations)


    fDisplayHeight := stereoParameters.fDisplaySizeInches / sqrt(AspectRatio * AspectRatio + 1.0);
    fDisplayWidth := fDisplayHeight * AspectRatio;
    fHalfInterocular := 0.5 * fInterocularDistance * stereoParameters.fStereoExaggerationFactor;
    fHalfPixelWidth := fDisplayWidth / stereoParameters.fPixelResolutionWidth * 0.5;
    fHalfMaximumAcuityAngle := fMaxVisualAcuityAngle * 0.5 * stereoParameters.fStereoExaggerationFactor;
    // single fHalfWidth := fDisplayWidth * 0.5;

    fMaxSeparationAcuityAngle := arctan(fHalfInterocular / fMaxStereoDistance);
    fMaxSeparationDistance := fHalfPixelWidth / tan(fMaxSeparationAcuityAngle);
    fRefinedMaxStereoDistance := fMaxStereoDistance - fMaxSeparationDistance;
    fFovHalfAngle := FovAngleY / 2.0;

    ComfortableResult := True;
    if (fRefinedMaxStereoDistance < 0.0) or (fMaxSeparationDistance > 0.1 * fMaxStereoDistance) then
    begin
        // Pixel resolution is too low to offer a comfortable stereo experience
        ComfortableResult := False;
    end;


    fRefinedMaxSeparationAcuityAngle := arctan(fHalfInterocular / (fRefinedMaxStereoDistance));
    fPhysicalZNearDistance := fHalfInterocular / tan(fHalfMaximumAcuityAngle);
    // single fScalingFactor := fHalfMaximumAcuityAngle / atanf(fHalfInterocular / stereoParameters.fViewerDistanceInches);

    fNearZSeparation := tan(fRefinedMaxSeparationAcuityAngle) * (fRefinedMaxStereoDistance - fPhysicalZNearDistance);
    // single fNearZSeparation2 := fHalfInterocular * (fRefinedMaxStereoDistance - fPhysicalZNearDistance) / fRefinedMaxStereoDistance;

    zNearHeight := cos(fFovHalfAngle) / sin(fFovHalfAngle);
    zNearWidth := zNearHeight / AspectRatio;
    fVirtualProjection := (fNearZSeparation * NearZ * zNearWidth * 4.0) / (2.0 * NearZ);

    Result := ComfortableResult;
end;



procedure StereoCreateDefaultParameters(var stereoParameters: TSTEREO_PARAMETERS);
begin
    // Default assumption is 1920x1200 resolution, a 22" LCD monitor, and a 2' viewing distance
    stereoParameters.fViewerDistanceInches := 24.0;
    stereoParameters.fPixelResolutionWidth := 1920.0;
    stereoParameters.fPixelResolutionHeight := 1200.0;
    stereoParameters.fDisplaySizeInches := 22.0;

    stereoParameters.fStereoSeparationFactor := 1.0;
    stereoParameters.fStereoExaggerationFactor := 1.0;
end;



function StereoProjectionFovLH(const pStereoParameters: PSTEREO_PARAMETERS; Channel: TSTEREO_CHANNEL;
    FovAngleY, AspectRatio, NearZ, FarZ: single; StereoMode: TSTEREO_MODE): TXMMATRIX;
var
    DefaultParameters: TSTEREO_PARAMETERS;
    fVirtualProjection, zNearWidth, zNearHeight: single;
    fInvertedAngle: single;
    proj, patchedProjection: TXMMATRIX;
    trans, rots: TXMMATRIX;
begin
    {$IFDEF UseAssert}
    assert((Channel = STEREO_CHANNEL_LEFT) OR (Channel = STEREO_CHANNEL_RIGHT));
    assert((StereoMode = STEREO_MODE_NORMAL) OR (StereoMode = STEREO_MODE_INVERTED));
    assert(not XMScalarNearEqual(FovAngleY, 0.0, 0.00001 * 2.0));
    assert(not XMScalarNearEqual(AspectRatio, 0.0, 0.00001));
    assert(not XMScalarNearEqual(FarZ, NearZ, 0.00001));
    {$ENDIF}

    ZeroMemory(@DefaultParameters, SizeOf(TSTEREO_PARAMETERS));
    if (pStereoParameters = nil) then
    begin
        StereoCreateDefaultParameters(DefaultParameters);
        pStereoParameters^ := DefaultParameters;
    end;

    {$IFDEF UseAssert}
    assert((pStereoParameters.fStereoSeparationFactor >= 0.0) AND( pStereoParameters.fStereoSeparationFactor <= 1.0));
    assert((pStereoParameters.fStereoExaggerationFactor >= 1.0) AND(pStereoParameters.fStereoExaggerationFactor <= 2.0));
    {$ENDIF}

    fVirtualProjection := 0.0;
    zNearWidth := 0.0;
    zNearHeight := 0.0;
    StereoProjectionHelper(pStereoParameters, fVirtualProjection, zNearWidth, zNearHeight, FovAngleY, AspectRatio, NearZ);

    fVirtualProjection := fVirtualProjection * pStereoParameters.fStereoSeparationFactor; // incorporate developer defined bias


    // By applying a translation, we are forcing our cameras to be parallel


    fInvertedAngle := arctan(fVirtualProjection / (2.0 * NearZ));

    proj := XMMatrixPerspectiveFovLH(FovAngleY, AspectRatio, NearZ, FarZ);

    if (Channel = STEREO_CHANNEL_LEFT) then
    begin
        if (StereoMode > STEREO_MODE_NORMAL) then
        begin
            rots := XMMatrixRotationY(fInvertedAngle);
            trans := XMMatrixTranslation(-fVirtualProjection, 0, 0);
            patchedProjection := XMMatrixMultiply(XMMatrixMultiply(rots, trans), proj);
        end
        else
        begin
            trans := XMMatrixTranslation(-fVirtualProjection, 0, 0);
            patchedProjection := XMMatrixMultiply(trans, proj);
        end;
    end
    else
    begin
        if (StereoMode > STEREO_MODE_NORMAL) then
        begin
            rots := XMMatrixRotationY(-fInvertedAngle);
            trans := XMMatrixTranslation(fVirtualProjection, 0, 0);
            patchedProjection := XMMatrixMultiply(XMMatrixMultiply(rots, trans), proj);
        end
        else
        begin
            trans := XMMatrixTranslation(fVirtualProjection, 0, 0);
            patchedProjection := XMMatrixMultiply(trans, proj);
        end;
    end;

    Result := patchedProjection;
end;



function StereoProjectionFovRH(const pStereoParameters: PSTEREO_PARAMETERS; Channel: TSTEREO_CHANNEL;
    FovAngleY, AspectRatio, NearZ, FarZ: single; StereoMode: TSTEREO_MODE): TXMMATRIX;
var
    DefaultParameters: TSTEREO_PARAMETERS;
    fVirtualProjection, zNearWidth, zNearHeight: single;
    fInvertedAngle: single;
    proj, patchedProjection: TXMMATRIX;
    trans, rots: TXMMATRIX;
begin
    {$IFDEF UseAssert}
    assert((Channel == STEREO_CHANNEL_LEFT OR Channel) = (STEREO_CHANNEL_RIGHT));
    assert((StereoMode = STEREO_MODE_NORMAL) OR (StereoMode = STEREO_MODE_INVERTED));
    assert(not XMScalarNearEqual(FovAngleY, 0.0, 0.00001 * 2.0));
    assert(not XMScalarNearEqual(AspectRatio, 0.0, 0.00001));
    assert(not XMScalarNearEqual(FarZ, NearZ, 0.00001));
    {$ENDIF}

    ZeroMemory(@DefaultParameters, SizeOf(TSTEREO_PARAMETERS));
    if (pStereoParameters = nil) then
    begin
        StereoCreateDefaultParameters(DefaultParameters);
        pStereoParameters^ := DefaultParameters;
    end;

    {$IFDEF UseAssert}
    assert((pStereoParameters.fStereoSeparationFactor >= 0.0) and ( pStereoParameters.fStereoSeparationFactor <= 1.0));
    assert((pStereoParameters.fStereoExaggerationFactor >= 1.0 ) and ( pStereoParameters.fStereoExaggerationFactor <= 2.0));
    {$ENDIF}

    fVirtualProjection := 0.0;
    zNearWidth := 0.0;
    zNearHeight := 0.0;

    StereoProjectionHelper(pStereoParameters, fVirtualProjection, zNearWidth, zNearHeight, FovAngleY, AspectRatio, NearZ);

    fVirtualProjection := fVirtualProjection * pStereoParameters.fStereoSeparationFactor; // incorporate developer defined bias

    // By applying a translation, we are forcing our cameras to be parallel

    fInvertedAngle := arctan(fVirtualProjection / (2.0 * NearZ));

    proj := XMMatrixPerspectiveFovRH(FovAngleY, AspectRatio, NearZ, FarZ);


    // By applying a translation, we are forcing our cameras to be parallel

    if (Channel = STEREO_CHANNEL_LEFT) then
    begin
        if (StereoMode > STEREO_MODE_NORMAL) then
        begin
            rots := XMMatrixRotationY(fInvertedAngle);
            trans := XMMatrixTranslation(-fVirtualProjection, 0, 0);
            patchedProjection := XMMatrixMultiply(XMMatrixMultiply(rots, trans), proj);
        end
        else
        begin
            trans := XMMatrixTranslation(-fVirtualProjection, 0, 0);
            patchedProjection := XMMatrixMultiply(trans, proj);
        end;
    end
    else
    begin
        if (StereoMode > STEREO_MODE_NORMAL) then
        begin
            rots := XMMatrixRotationY(-fInvertedAngle);
            trans := XMMatrixTranslation(fVirtualProjection, 0, 0);
            patchedProjection := XMMatrixMultiply(XMMatrixMultiply(rots, trans), proj);
        end
        else
        begin
            trans := XMMatrixTranslation(fVirtualProjection, 0, 0);
            patchedProjection := XMMatrixMultiply(trans, proj);
        end;
    end;

    Result := patchedProjection;
end;

end.
