/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_Death extends GameplayCam_Default
	config(Camera)
	native(Camera);

var() protected const float FocusPointInterpSpeedDecaySpeed;
var protected transient float FocusPointInterpSpeed;

cpptext
{
	/**
	* Returns location and rotation, in world space, of the camera's basis point.  The camera will rotate
	* around this point, offsets are applied from here, etc.
	*/
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
};

function OnBecomeActive(Pawn TargetPawn, GameThirdPersonCameraMode PrevMode)
{
	Super.OnBecomeActive(TargetPAwn, PrevMode);

	// reset this back to default, and we'll decay it over time
	FocusPointInterpSpeed = default.FocusPointInterpSpeed;
}


simulated function bool SetFocusPoint(Pawn ViewedPawn)
{
	local GearPawn GP;
	local vector2d InterpSpeedRange;
	GP = GearPawn(ViewedPawn);
  	if ( GP != None )
  	{
		FocusPointInterpSpeed = FInterpTo(FocusPointInterpSpeed, 0.01f, GP.WorldInfo.DeltaSeconds, FocusPointInterpSpeedDecaySpeed);

		InterpSpeedRange.X = FocusPointInterpSpeed;
		InterpSpeedRange.Y = FocusPointInterpSpeed;

 		// note that death-cam POIs take priority over others
 		GameplayCam.SetFocusOnLoc( GP.GetDeathCamLookatPos(), InterpSpeedRange, vect2d(12,12), , TRUE, TRUE, TRUE );

		return TRUE;
  	}

	return FALSE;
}

/**
* Returns the "worst case" camera location for this camera mode.
* This is the position that the camera ray is shot from, so it should be
* a guaranteed safe place to put the camera.
*/
simulated event vector GetCameraWorstCaseLoc(Pawn TargetPawn, TViewTarget CurrentViewTarget)
{
	local GearPawn GP;
	local vector Loc;

	GP = GearPawn(TargetPawn);
	if (GP != None)
	{
		Loc = GP.Mesh.GetBoneLocation(GP.PelvisBoneName);
	}

	if (IsZero(Loc))
	{
		Loc = GP.Location;
	}

	Loc.Z += WorstLocOffset.Z;

	return Loc;
}

defaultproperties
{
	ViewOffset={(
		OffsetHigh=(X=-100,Y=0,Z=25),
		OffsetLow=(X=-60,Y=0,Z=100),
		OffsetMid=(X=-220,Y=0,Z=100),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=-40),
		OffsetLow=(X=0,Y=0,Z=-40),
		OffsetMid=(X=0,Y=0,Z=-40),
		)}
	ViewOffset_ViewportAdjustments(CVT_16to9_VertSplit)={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_Full)={(
		OffsetHigh=(X=20,Y=0,Z=15),
		OffsetLow=(X=20,Y=0,Z=15),
		OffsetMid=(X=20,Y=0,Z=15),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_HorizSplit)={(
		OffsetHigh=(X=0,Y=0,Z=-40),
		OffsetLow=(X=0,Y=0,Z=-40),
		OffsetMid=(X=0,Y=0,Z=-40),
		)}
	ViewOffset_ViewportAdjustments(CVT_4to3_VertSplit)={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}

	BlendTime=0.5f

	bDoPredictiveAvoidance=FALSE
	bValidateWorstLoc=true

	WorstLocOffset=(X=0,Y=0,Z=140)

	OriginLocInterpSpeed=3
	OriginRotInterpSpeed=1
	FocusPointInterpSpeedDecaySpeed=0.75f
	FocusPointInterpSpeed=5.f
}
