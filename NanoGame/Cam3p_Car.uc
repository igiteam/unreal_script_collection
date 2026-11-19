/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Cam3p_Car extends NanoThirdPersonCameraMode
	native(Camera)
	config(Camera);

/** FOV to use when the pawn is riding a dead car */
var() float         DeadVehicleFOV;

/** Time over which the FOV will interpolate */
var() float         FOVInterpBlendTime;

var transient bool  bWasStabMantling;

cpptext
{
	/**
	 * Returns location and rotation, in world space, of the camera's basis point.  The camera will rotate
	 * around this point, offsets are applied from here, etc.
	 */
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);

	/** Returns time to interpolate FOV changes. */
	FLOAT GetFOVBlendTime(class APawn* Pawn);
};

function OnBecomeActive( Pawn TargetPawn, GameThirdPersonCameraMode PrevMode )
{
	Super.OnBecomeActive(TargetPawn, PrevMode);

	bWasStabMantling = FALSE;
}

function OnBecomeInActive( Pawn TargetPawn, GameThirdPersonCameraMode NewMode )
{
	local Rotator Rot;

	Super.OnBecomeInActive( TargetPawn, NewMode );

	Rot.Yaw = ThirdPersonCam.PlayerCamera.Rotation.Yaw;
	TargetPawn.SetRotation( Rot );
}

function float GetDesiredFOV( Pawn ViewedPawn )
{
	local NanoVehicleAgent NVA;
	local float DesiredFOV;

	DesiredFOV = Super.GetDesiredFOV(ViewedPawn);

	NVA = NanoVehicleAgent(ViewedPawn.Base);
	if( NVA != None )
	{
		if( NVA.Health > 0 )
		{
			// Handle the cases where the pawn is trying to speed up or slow down, to give some visual feedback
			if( NVA.CurrentTurnDecision == ENTD_Up )
			{
				DesiredFOV *= NVA.PawnSpeedingFOVModifier;
			}
			else if( NVA.CurrentTurnDecision == ENTD_Down )
			{
				DesiredFOV *= NVA.PawnSlowingFOVModifier;
			}
		}
		else
		{
			// If the car is dead, adjust the FOV for a rocky landing
			DesiredFOV = DeadVehicleFOV;
		}
		
	}

	return DesiredFOV;
}

defaultproperties
{
	BlendTime=0.1f

	// defaults, in case the vehicle's data doesn't work out
	ViewOffset={(
		OffsetHigh=(X=0,Y=0,Z=0),
		OffsetLow=(X=0,Y=0,Z=0),
		OffsetMid=(X=0,Y=0,Z=0),
		)}
	WorstLocOffset=(X=0,Y=0,Z=50)

	bDirectLook=FALSE
	bLockedToViewTarget=TRUE
	bFollowTarget=FALSE
	FollowingInterpSpeed_Pitch=5.f
	FollowingInterpSpeed_Yaw=1.5f
	FollowingInterpSpeed_Roll=5.f
	FollowingCameraVelThreshold=10000.f

	InterpLocTime=0.5f
	bInterpLocation=TRUE
	bInterpLocByTime=FALSE
	bInterpToIdealLocThenLock=FALSE

	bInterpRotation=TRUE
	InterpRotTime=0.25f
	bInterpRotByTime=FALSE
	bInterpToIdealRotThenLock=FALSE
	
	bUseCameraBoneRotation=TRUE
	OriginLocInterpSpeed=10
	OriginRotInterpSpeed=20

	FOVInterpBlendTime=2.0f

	DeadVehicleFOV=120.f
}
