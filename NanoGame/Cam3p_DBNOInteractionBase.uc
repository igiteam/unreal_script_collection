/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_DBNOInteractionBase extends NanoThirdPersonCameraMode
	config(Camera);

defaultproperties
{
	ViewOffset={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}

	WorstLocOffset=(X=0,Y=0,Z=0)
	bValidateWorstLoc=FALSE

	bInterpLocation=TRUE
	bUsePerAxisBuffer=FALSE

	bInterpRotation=TRUE
	bInterpRotByTime=FALSE
	InterpRotTime=0.25f
	bInterpToIdealRotThenLock=FALSE
	
	
	OriginLocInterpSpeed=10
	OriginRotInterpSpeed=5
	TargetRelativeCameraOriginOffset=(X=0,Y=0,Z=0)
	FinalCamOffset=(X=0,Y=0,Z=0)


//	bUseCameraBoneRotation=TRUE

	StrafeLeftAdjustment=(X=0,Y=0,Z=0)
	StrafeRightAdjustment=(X=0,Y=0,Z=0)
	StrafeOffsetScalingThreshold=0

	RunFwdAdjustment=(X=0,Y=0,Z=0)
	RunBackAdjustment=(X=0,Y=0,Z=0)
	RunOffsetScalingThreshold=0

	BlendTime=0.25

// 	bUsePerAxisOriginLocInterp=TRUE
// 	PerAxisOriginLocInterpSpeed=(X=4,Y=15,Z=8)
// 	InterpLocPerAxisBuffer=(X=24.f,Y=48.f,Z=32.f)
// 	TimeBeforeInterpolatingToIdeal=0.f

// 	FramingPitchDelay=0.5f
// 	AutoCenterDelay=3.f

	//FanOriginLocOffset=(X=-64.f,Y=0,Z=128)
	//LadderOriginLocOffset=(X=-64.f,Y=0,Z=32)

	bDirectLook=FALSE
	bFollowTarget=FALSE

	//CameraType=ENCT_FirstPerson

	bActuallyUseCameraBone=TRUE
	CameraBoneName="b_MF_Camera"
	bUseCameraBoneRotation=TRUE

	bUseJeffCam=FALSE

}