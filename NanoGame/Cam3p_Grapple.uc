/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Grapple extends NanoThirdPersonCameraMode
	native(Camera);

/** Offset of the camera at the max grapple velocity */
var() vector    GrapplingMaxOffset;

cpptext
{
	/**
	 * Returns location and rotation, in world space, of the camera's basis point.  The camera will rotate
	 * around this point, offsets are applied from here, etc.
	 */
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
};

function OnBecomeActive(Pawn TargetPawn, GameThirdPersonCameraMode PrevMode)
{
	Super.OnBecomeActive(TargetPawn, PrevMode);
 
	NanoCamera.SetAutoSlideAndPanInterpSpeeds(8.f, 8.f);
}

function OnBecomeInActive(Pawn TargetPawn, GameThirdPersonCameraMode NewMode)
{
	Super.OnBecomeInActive(TargetPawn, NewMode);

	TargetPawn.SetTimer(1.f, FALSE, nameof(NanoCamera.ResetAutoSlideAndPanInterpSpeeds), NanoCamera);
	TargetPawn.Controller.SetRotation(ThirdPersonCam.PlayerCamera.Rotation);
}

defaultproperties
{
	bInterpLocation=TRUE
	bInterpLocByTime=TRUE
	OriginLocInterpSpeed=10.f
	bInterpToIdealLocThenLock=TRUE

	bInterpRotation=TRUE
	bInterpRotByTime=FALSE
	OriginRotInterpSpeed=32.f

	FollowingCameraVelThreshold=10000.f

	GrapplingMaxOffset=(X=-356.f, Z=128.f)
}
