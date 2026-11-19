/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Camera mode for when player is in a vehicle.
 */
class GameplayCam_Reaver extends GearGameplayCameraMode
	config(Camera);

defaultproperties
{
	BlendTime=0.13f

	// defaults, in case the vehicle's data doesn't work out
	ViewOffset={(
		OffsetHigh=(X=-800,Y=0,Z=200),
		OffsetLow=(X=-500,Y=0,Z=200),
		OffsetMid=(X=-800,Y=0,Z=200),
	)}

	bSmoothViewOffsetPitchChanges=true
	TargetRelativeCameraOriginOffset=(X=0,Y=0,Z=0)

	bDirectLook=FALSE
	bLockedToViewTarget=TRUE
	bFollowTarget=FALSE
	FollowingInterpSpeed_Pitch=5.f
	FollowingInterpSpeed_Yaw=1.5f
	FollowingInterpSpeed_Roll=5.f
	FollowingCameraVelThreshold=1000.f
	bInterpLocation=FALSE
	bInterpRotation=FALSE

	bDoPredictiveAvoidance=FALSE
	bValidateWorstLoc=FALSE
}
