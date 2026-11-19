/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Turbine extends NanoThirdPersonCameraMode
	config(Camera);

defaultproperties
{
	ViewOffset={(
		OffsetHigh=(X=-135,Y=0,Z=40),
		OffsetLow=(X=-125,Y=0,Z=40),
		OffsetMid=(X=-135,Y=0,Z=-20),
		)}

	WorstLocOffset=(X=-8,Y=1,Z=95)
	bValidateWorstLoc=FALSE

	bInterpLocation=TRUE
	bUsePerAxisBuffer=FALSE
	bUseCameraBoneRotation=FALSE

	bInterpRotation=TRUE
	bInterpRotByTime=FALSE
	InterpRotTime=0.25f
	bInterpToIdealRotThenLock=FALSE


	OriginLocInterpSpeed=15
	OriginRotInterpSpeed=10
	TargetRelativeCameraOriginOffset=(X=0,Y=0,Z=0)

	FinalCamOffset=(X=0,Y=100,Z=0)

//	bUseCameraBoneRotation=TRUE

	StrafeLeftAdjustment=(X=0,Y=0,Z=0)
	StrafeRightAdjustment=(X=0,Y=0,Z=0)
    StrafeOffsetScalingThreshold=0

	RunFwdAdjustment=(X=0,Y=0,Z=0)
	RunBackAdjustment=(X=-30,Y=0,Z=0)
	RunOffsetScalingThreshold=0

	BlendTime=0.25

	bDirectLook=FALSE
	bFollowTarget=FALSE


}
