/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Platforming extends NanoThirdPersonCameraMode
	native(Camera);
	
cpptext
{
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
	virtual void InterpolateCameraOrigin( APawn* TargetPawn, FLOAT DeltaTime, FVector& out_ActualCameraOrigin, FVector const& IdealCameraOrigin, FRotator& out_ActualCameraOriginRot, FRotator const& IdealCameraOriginRot );
};

/** Standard camera offset from pawn */
var() Vector	PlatformCameraOffset;

/** How fast the camera pitches back to level */
var() float AutoPitchLevelInterpSpeed;

/** Where to blend the pitch to while platforming */
var() int PlatformingPitchAdjustment;

defaultproperties
{
	BlendTime=0.2f

	// defaults, in case the vehicle's data doesn't work out
	ViewOffset={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}
	WorstLocOffset=(X=-150,Y=0,Z=25)

	bDirectLook=FALSE
	bLockedToViewTarget=TRUE
	bFollowTarget=TRUE
	FollowingInterpSpeed_Pitch=5.f
	FollowingInterpSpeed_Yaw=1.5f
	FollowingInterpSpeed_Roll=5.f
	FollowingCameraVelThreshold=1000.f

	bInterpLocation=TRUE
	InterpLocTime=0.25f
	bInterpLocByTime=FALSE
	bInterpToIdealLocThenLock=FALSE
	OriginLocInterpSpeed=5

	bInterpRotation=TRUE
	InterpRotTime=0.25f
	bInterpRotByTime=FALSE
	bInterpToIdealRotThenLock=FALSE
	bRotInterpSpeedConstant=TRUE

	bUseCameraBoneRotation=FALSE
	OriginRotInterpSpeed=7218

	PlatformCameraOffset=(X=-190,Y=70.f,Z=64.f)
	AutoPitchLevelInterpSpeed=2.f
	PlatformingPitchAdjustment=-2048
}
