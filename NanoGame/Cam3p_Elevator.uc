/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Elevator extends NanoThirdPersonCameraMode
	native(Camera)
	config(Camera);

/** How fast to blend between the offsets */
var() float     CameraOffsetBlendRate;
/** How fast to blend between rotational offsets */
var() float     CameraRotationalOffsetBlendRate;


/** Stores the last offset of the camera relative to the pawn, used for blending between camera offsets */
var transient vector LastRelativePawnOffset;

/** Stores the relative rotation we want the camera to blend to */
var transient rotator DesiredRelativeCameraRot;
/** Stores the last relative rotational offset of the camera, used for blending between camera rotational offsets */
var transient rotator LastRelativeCameraRot;

/** Whether or not the camera was in ejection mode last frame */
var transient bool  bWasInEjectionMode;
/** Distance of the ejection cam from the EjectionTarget, as a percentage of the distance between the target and the pawn */
var() float         EjectionCamDistance;
/** Z-Offset of the ejection cam after applying the EjectionCamDistanceMultipler */
var() float         EjectionCamZOffset;


cpptext
{
	/**
	 * Returns location and rotation, in world space, of the camera's basis point.  The camera will rotate
	 * around this point, offsets are applied from here, etc.
	 */
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);

	/** With the elevator, we want to interpolate the camera relative to the pawn, so make these functions take into account TargetPawn->Location */
	virtual FVector InterpolateCameraOriginLoc(APawn* TargetPawn, FRotator const& CameraTargetRot, FVector const& LastLoc, FVector const& IdealLoc, FLOAT DeltaTime);
	virtual FRotator InterpolateCameraOriginRot(class APawn* TargetPawn, FRotator const& LastRot, FRotator const& IdealRot, FLOAT DeltaTime);
};

function OnBecomeActive(Pawn TargetPawn, GameThirdPersonCameraMode PrevMode)
{
	Super.OnBecomeActive(TargetPawn, PrevMode);
 
 	// Set this to 0, so that it will be updated appropriately in the Interpolate functions
 	LastRelativePawnOffset = vect(0.f,0.f,0.f);

	bWasInEjectionMode = FALSE;
	OriginLocInterpSpeed = default.OriginLocInterpSpeed;

	NanoCamera.SetAutoSlideAndPanInterpSpeeds(4.f, 4.f);
}

function OnBecomeInActive(Pawn TargetPawn, GameThirdPersonCameraMode NewMode)
{
	Super.OnBecomeInActive(TargetPawn, NewMode);

	NanoCamera.ResetAutoSlideAndPanInterpSpeeds();
}

function float GetDesiredFOV( Pawn ViewedPawn )
{
	local NanoVehicle_ElevatorBase NE;

	NE = NanoVehicle_ElevatorBase(ViewedPawn.Base);

	if( NE != None && NE.IsOverdriving() )
	{
		return NE.OverdriveFOV;
	}
	else
	{
		return Super.GetDesiredFOV( ViewedPawn );
	}
}

defaultproperties
{
	BlendTime=0.1f
	bSlideOffsetOnCamModeChange=FALSE
	
	// defaults, in case the vehicle's data doesn't work out
	ViewOffset={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}
	WorstLocOffset=(X=0,Y=0,Z=150)

	bDirectLook=FALSE
	bLockedToViewTarget=TRUE
	bFollowTarget=FALSE

	bInterpLocation=FALSE
	bInterpLocByTime=FALSE
	bInterpToIdealLocThenLock=FALSE

	bInterpRotation=TRUE
	bInterpRotByTime=FALSE
	bInterpToIdealRotThenLock=FALSE
	
	bUseCameraBoneRotation=TRUE

	OriginLocInterpSpeed=3.f

	CameraOffsetBlendRate=2.f
	CameraRotationalOffsetBlendRate=0.75f

	EjectionCamDistance=350.f
	EjectionCamZOffset=88.f
}
