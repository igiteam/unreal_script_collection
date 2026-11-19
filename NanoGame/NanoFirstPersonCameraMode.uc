/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoFirstPersonCameraMode extends NanoThirdPersonCameraMode
	config(Camera)
	native(Camera);

/** Called when Camera mode becomes active */
function OnBecomeActive(Pawn TargetPawn, GameThirdPersonCameraMode PrevMode)
{
	Super.OnBecomeActive( TargetPawn, PrevMode );
	bSkipCameraCollision = default.bSkipCameraCollision;
}

/** Called when interp by time is complete */
event OnInterpLocByTimeComplete()
{
	// Once interp has completed and camera has locked into position
	if( bInterpToIdealLocThenLock )
	{
		// Skip collision checks
		bSkipCameraCollision = TRUE;
	}
}

defaultproperties
{
	CameraType=ENCT_FirstPerson

	CameraBoneName="b_Camera"
	TransitionBoneName="b_Camera_Trans_3rd_to_1st"

	bValidateWorstLoc=FALSE
	
	InterpLocTime=0.25f
	bInterpLocByTime=TRUE
	bInterpToIdealLocThenLock=TRUE

	bInterpRotation=TRUE
	InterpRotTime=0.25f
	bInterpRotByTime=TRUE
	bInterpToIdealRotThenLock=TRUE

	bUseCameraBoneRotation=FALSE
	OriginRotInterpSpeed=20
}