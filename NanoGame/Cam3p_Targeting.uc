/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Targeting extends NanoThirdPersonCameraMode
	config(Camera);

defaultproperties
{
	//TargetRelativeCameraOriginOffset=(Z=-180)

	// turn off following

	ViewOffset={(
		OffsetHigh=(X=-135,Y=0,Z=40),
		OffsetLow=(X=-125,Y=0,Z=40),
		OffsetMid=(X=-135,Y=0,Z=-20),
		)}

	WorstLocOffset=(X=-8,Y=1,Z=95)
	FinalCamOffset=(X=0,Y=35,Z=8)
	TargetRelativeCameraOriginOffset=(X=0,Y=0,Z=0)

	bDirectLook=FALSE
	bLockedToViewTarget=TRUE
	bFollowTarget=FALSE
	FollowingInterpSpeed_Pitch=5.f
	FollowingInterpSpeed_Yaw=1.5f
	FollowingInterpSpeed_Roll=5.f
	FollowingCameraVelThreshold=1000.f

	bInterpLocation=TRUE

	bInterpLocByTime=FALSE
	InterpLocTime=0.25f

	bInterpToIdealLocThenLock=FALSE


	bInterpRotation=TRUE

	bInterpRotByTime=FALSE
	InterpRotTime=0.25f

	bInterpToIdealRotThenLock=FALSE
	//	bRotInterpSpeedConstant=TRUE

	bUseCameraBoneRotation=FALSE

	OriginLocInterpSpeed=50
	OriginRotInterpSpeed=20 // this controls the "lag" from where you are aiming to where the camera is actually located
	OffsetAdjustmentInterpSpeed=1.0f


}
