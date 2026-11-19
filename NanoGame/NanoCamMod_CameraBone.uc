/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoCamMod_CameraBone extends CameraModifier
	native(Camera)
	config(Camera);

/** Name of camera bone to get information from */
var()	Name		CameraBoneName;
/** Name of camera root bone to use as a basis */
var()	Name		CameraBoneRootName;
/** NanoPawn associated w/ camera */
var		NanoPawn		Pawn;

/** Mesh and has been initialized */
var		bool	bInitialized;
/** Mesh component to grab bone information from */
var		SkeletalMeshComponent Mesh;

/** Max delta translation to allow */
var() vector MaxTranslation;

/** Interpolation speed for Alpha */
var() private float AlphaInterpSpeed;

enum ECameraAnimOption
{
	CAO_None,
	CAO_TranslateDelta,
	CAO_TranslateRotateDelta,
	CAO_Absolute,
};
var ECameraAnimOption CameraAnimOption;

native final function bool Initialize();

/** Very much a hack.  Camera root rotation isn't identity in the skeleton, swap axes so it is. */
native final simulated function rotator FixCamBone(rotator R);

final function native rotator CalcDeltaRot(rotator CameraRootRot, rotator CameraBoneRot, rotator PawnRot);

native function bool ModifyCamera
(
		Camera	Camera,
		float	DeltaTime,
	out TPOV	OutPOV
);

native function float GetTargetAlpha( Camera Camera );

/** 
 * Overloaded to do our own blending over time. 
 * AlphaInTime and AlphaOutTime should be 0 for this to work as intended.
 */
native function UpdateAlpha( Camera Camera, float DeltaTime );

defaultproperties
{
	CameraBoneName="b_Camera_3rdP"
	CameraBoneRootName="b_Camera_3rdP_Root"
	CameraAnimOption=CAO_TranslateRotateDelta

	AlphaInterpSpeed=7.f

	AlphaInTime=0.f
	AlphaOutTime=0.f

	MaxTranslation=(X=2000.f,Y=2000.f,Z=2000.f)
}
