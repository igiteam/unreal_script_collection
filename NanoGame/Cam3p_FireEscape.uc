/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_FireEscape extends NanoThirdPersonCameraMode
	native(Camera);

/** Camera offset when going up */
var()   Vector  GoingUpOffset;
var()   rotator GoingUpRotOffset;

/** Camera offset when hanging out at a floor */
var()   Vector  StationaryOffset;
var()   rotator StationaryRotOffset;

/** Camera offset when going down */
var()   Vector  GoingDownOffset;
var()   rotator GoingDownRotOffset;

/** Interpolation speeds when blending to and away from the stationary position */
var()   float   BlendFromStationarySpeed, BlendToStationarySpeed;

/** Speed in the Z direction of the pawn's velocity to have the maximum FOV */
var()   float   SpeedForMaxFOV;

/** The FOV to blend to when at the above speed */
var()   float   MaxSpeedFOV;

cpptext
{
	/**
	 * Returns location and rotation, in world space, of the camera's basis point.  The camera will rotate
	 * around this point, offsets are applied from here, etc.
	 */
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
};

function float GetDesiredFOV( Pawn ViewedPawn )
{
	return Lerp( 85.f, MaxSpeedFOV, FClamp(ViewedPawn.Velocity.Z / SpeedForMaxFOV, 0.f, 1.f) );
}

defaultproperties
{
	bSkipCameraCollision=TRUE

	bLockedToViewTarget=TRUE
	bFollowTarget=FALSE
	FollowingInterpSpeed_Pitch=5.f
	FollowingInterpSpeed_Yaw=1.5f
	FollowingInterpSpeed_Roll=5.f
	FollowingCameraVelThreshold=5000.f

	bInterpLocation=TRUE
	OriginLocInterpSpeed=4.f

	bInterpRotation=TRUE
	OriginRotInterpSpeed=6.f

	BlendFromStationarySpeed=7.f
	BlendToStationarySpeed=2.25f

	SpeedForMaxFOV=200.f
	MaxSpeedFOV=70.f

	GoingUpOffset=(X=-350,Z=-250)
	GoingUpRotOffset=(Pitch=3500)

	StationaryOffset=(X=-250,Z=-128)
	StationaryRotOffset=(Pitch=0)

	GoingDownOffset=(X=-150,Z=150)
	GoingDownRotOffset=(Pitch=-3500)
}
