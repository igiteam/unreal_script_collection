/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Fan extends Cam3p_Platforming;
	
function OnBecomeInActive( Pawn TargetPawn, GameThirdPersonCameraMode NewMode )
{
	local Rotator Rot;

	Super.OnBecomeInActive( TargetPawn, NewMode );

	Rot.Yaw = ThirdPersonCam.PlayerCamera.Rotation.Yaw;
	TargetPawn.SetRotation( Rot );
}

defaultproperties
{
	bInterpLocation=TRUE
	InterpLocTime=0.5f
	bInterpLocByTime=TRUE
	bInterpToIdealLocThenLock=TRUE

	OriginLocInterpSpeed=3.f
	PlatformCameraOffset=(X=-768.f,Y=92.f,Z=0.f)
	AutoPitchLevelInterpSpeed=2.f
	PlatformingPitchAdjustment=8192
}
