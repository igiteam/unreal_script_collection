/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GameplayCam_IronSights extends GearGameplayCameraMode
	native(Camera)
	config(Camera);

cpptext
{
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
}

/** returns camera mode desired FOV */
function float GetDesiredFOV( Pawn ViewedPawn )
{
	local GearWeapon			Wpn;

	Wpn = GearWeapon(ViewedPawn.Weapon);

	if (Wpn != None)
	{
		return Wpn.GetTargetingFOV(FOVAngle) + FOVAngle_ViewportAdjustments[CurrentViewportType];
	}
	else
	{
		return Super.GetDesiredFOV(ViewedPawn);
	}
}

defaultproperties
{
	ViewOffset={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}

	BlendTime=0.067f

	bDoPredictiveAvoidance=FALSE
	bInterpLocation=FALSE

	DOF_BlurKernelSize=8.f
	DOF_FocusInnerRadius=1000.f
	DOFDistanceInterpSpeed=8.f

	bAdjustDOF=TRUE
}

