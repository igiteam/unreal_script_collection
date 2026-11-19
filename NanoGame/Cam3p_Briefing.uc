/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Briefing extends NanoThirdPersonCameraMode
	config(Camera);

/** Returns FOV that this camera mode desires. */
function float GetDesiredFOV( Pawn ViewedPawn )
{
	return 45.f;
}

defaultproperties
{
	ViewOffset={(
		OffsetHigh=(X=0,Y=-32,Z=32),
		OffsetLow=(X=0,Y=-32,Z=32),
		OffsetMid=(X=0,Y=-32,Z=32),
		)}

	InterpLocTime=0.5f
	bInterpLocByTime=TRUE
	bInterpToIdealLocThenLock=FALSE

	bInterpRotation=TRUE
	InterpRotTime=0.0f
	bInterpRotByTime=TRUE
	bInterpToIdealRotThenLock=FALSE

	bUseCameraBoneRotation=TRUE

	BlendTime=0.25f
}