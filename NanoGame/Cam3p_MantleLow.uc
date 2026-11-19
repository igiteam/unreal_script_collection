/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_MantleLow extends NanoThirdPersonCameraMode
	config(Camera)
	native(Camera);

cpptext
{
	FVector GetViewOffset(class APawn* ViewedPawn, FLOAT DeltaTime, const FVector& ViewOrigin, const FRotator& ViewRotation);
}

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

	bUsePerAxisOriginLocInterp=FALSE
	PerAxisOriginLocInterpSpeed=(X=4,Y=15,Z=15)
	InterpLocPerAxisBuffer=(X=16.f,Y=48.f,Z=32.f)

	bInterpRotation=TRUE
	InterpRotTime=0.8f
	bInterpRotByTime=FALSE
	bInterpToIdealRotThenLock=FALSE


	OriginLocInterpSpeed=20
	OriginRotInterpSpeed=2
	OffsetAdjustmentInterpSpeed=1


	bUseCameraBoneRotation=TRUE

	BlendTime=0.25f

}