/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Perch extends NanoThirdPersonCameraMode
	native(Camera)
	config(Camera);

var() protected const vector TargetRelativeCameraOriginOffset_PoleBend;

cpptext
{
	/** Returns an offset, in pawn-local space, to be applied to the camera origin. */
	virtual FVector GetTargetRelativeOriginOffset(class APawn* TargetPawn);
}

defaultproperties
{
	TargetRelativeCameraOriginOffset_PoleBend=(Z=-500)

	OriginLocInterpSpeed=10
	OriginRotInterpSpeed=8
	TargetRelativeCameraOriginOffset=(X=0,Y=0,Z=0)

	FinalCamOffset=(X=0,Y=0,Z=-60)

}
