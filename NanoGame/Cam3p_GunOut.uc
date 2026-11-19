/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_GunOut extends NanoThirdPersonCameraMode
	config(Camera);

defaultproperties
{
	BlendTime=0.2f

	ViewOffset={(
		OffsetHigh=(X=-225,Y=30,Z=40),
		OffsetLow=(X=-225,Y=30,Z=40),
		OffsetMid=(X=-225,Y=30,Z=-20),
		)}

	WorstLocOffset=(X=0,Y=0,Z=95)
	FinalCamOffset=(X=0,Y=40,Z=0)
	TargetRelativeCameraOriginOffset=(X=0,Y=0,Z=0)

	bDirectLook=FALSE
	bLockedToViewTarget=TRUE
	bFollowTarget=FALSE
	FollowingInterpSpeed_Pitch=5.f
	FollowingInterpSpeed_Yaw=1.5f
	FollowingInterpSpeed_Roll=5.f
	FollowingCameraVelThreshold=1000.f

	bInterpLocation=TRUE
	InterpLocTime=0.25f
	bInterpLocByTime=FALSE
	bInterpToIdealLocThenLock=FALSE


	bInterpRotation=TRUE
	InterpRotTime=0.25f
	bInterpRotByTime=FALSE
	bInterpToIdealRotThenLock=FALSE
	//	bRotInterpSpeedConstant=TRUE

	bUseCameraBoneRotation=FALSE

	OriginLocInterpSpeed=40
	OriginRotInterpSpeed=5
	OffsetAdjustmentInterpSpeed=1.0f

}
