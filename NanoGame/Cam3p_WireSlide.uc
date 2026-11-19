/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_WireSlide extends Cam3p_Orbit_Base
	config(Camera);

defaultproperties
{
//	TargetRelativeCameraOriginOffset=(Z=-180)

	bInterpLocation=TRUE

	bUsePerAxisBuffer=FALSE
	bUseCameraBoneRotation=FALSE

	bInterpRotation=TRUE
	bInterpRotByTime=FALSE
	InterpRotTime=0.25f
	bInterpToIdealRotThenLock=FALSE


//	bUseCameraBoneRotation=TRUE

    OriginLocInterpSpeed=5
	OriginRotInterpSpeed=10
	TargetRelativeCameraOriginOffset=(X=0,Y=0,Z=0)

	FinalCamOffset=(X=0,Y=0,Z=-70)


	StrafeLeftAdjustment=(X=0,Y=0,Z=0)
	StrafeRightAdjustment=(X=0,Y=0,Z=0)
    StrafeOffsetScalingThreshold=0

	RunFwdAdjustment=(X=0,Y=0,Z=0)
	RunBackAdjustment=(X=-30,Y=0,Z=0)
	RunOffsetScalingThreshold=0

	BlendTime=0.25

// 	bUsePerAxisOriginLocInterp=TRUE
// 	PerAxisOriginLocInterpSpeed=(X=4,Y=15,Z=8)
// 	InterpLocPerAxisBuffer=(X=24.f,Y=48.f,Z=32.f)
// 	TimeBeforeInterpolatingToIdeal=0.f

// 	FramingPitchDelay=0.5f
// 	AutoCenterDelay=3.f

	FanOriginLocOffset=(X=-64.f,Y=0,Z=128)
	LadderOriginLocOffset=(X=-64.f,Y=0,Z=32)

	bDirectLook=FALSE
	bFollowTarget=FALSE

}
