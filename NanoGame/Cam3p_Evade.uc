/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Evade extends NanoThirdPersonCameraMode
	config(Camera);

defaultproperties
{
	ViewOffset={(
		OffsetHigh=(X=0,Y=-55,Z=0),
		OffsetLow=(X=0,Y=-55,Z=0),
		OffsetMid=(X=0,Y=-55,Z=0),
		)}

	FinalCamOffset=(X=0,Y=20,Z=0)
	TargetRelativeCameraOriginOffset=(X=0,Y=0,Z=0)

	InterpLocTime=1.f
	bInterpLocByTime=FALSE
	bInterpToIdealLocThenLock=FALSE

	bUsePerAxisOriginLocInterp=TRUE
	PerAxisOriginLocInterpSpeed=(X=0,Y=0,Z=0)
	InterpLocPerAxisBuffer=(X=16.f,Y=48.f,Z=32.f)

	bInterpRotation=TRUE
	InterpRotTime=0.8f
	bInterpRotByTime=FALSE
	bInterpToIdealRotThenLock=FALSE


	OriginLocInterpSpeed=0
	OriginRotInterpSpeed=2
	OffsetAdjustmentInterpSpeed=1


	bUseCameraBoneRotation=TRUE

	BlendTime=0.25f

}