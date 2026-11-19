/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearCamMod_CameraBone extends CameraModifier
	native(Camera)
	config(Camera);

/** Name of camera bone to get information from */
var()	Name		CameraBoneName;
/** Name of camera root bone to use as a basis */
var()	Name		CameraBoneRootName;
/** GearPawn associated w/ camera */
var		GearPawn		Pawn;

/** Mesh and has been initialized */
var		bool	bInitialized;
/** Mesh component to grab bone information from */
var		SkeletalMeshComponent Mesh;

/** How much extra alpha to apply if in combat (to make combat feel more intense) */
var() config float InCombatAlphaBonus;

/* Alpha to use for idling anims. */
var() config float AlphaWhenIdle;

/** Max delta translation to allow */
var() vector MaxTranslation;

/** put on pawn or PC? */
var() bool	 bDisableAmbientCameraMotion;

/** Interpolation speed for Alpha */
var() private float AlphaInterpSpeed;

var transient protected vector LastDeltaPos;
var transient protected rotator LastDeltaRot;

enum ECameraAnimOption
{
	CAO_None,
	CAO_TranslateDelta,
	CAO_TranslateRotateDelta,
	CAO_Absolute,
};
var ECameraAnimOption CameraAnimOption;

// shaky cam dampening for OXM demo.
// @fixme, post demo we should just tweak the anims to look good
var() config bool	bOXMShakyCamDampening;
var() config float	OXMShakyCamDampeningFactor;



cpptext
{
protected:
	FRotator CalcDeltaRot(FRotator CameraRootRot, FRotator CameraBoneRot, FRotator PawnRot);
	FRotator FixCamBone(FRotator R) const;
public:
	virtual void GetDebugText(TArray<FString>& Lines);
};

native final function bool Initialize();

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
	CameraBoneName=b_MF_Camera
	CameraBoneRootName=b_MF_Camera_Root
	CameraAnimOption=CAO_TranslateRotateDelta

	AlphaInterpSpeed=7.f

	AlphaInTime=0.f
	AlphaOutTime=0.f

	MaxTranslation=(X=2000.f,Y=2000.f,Z=2000.f)
}
