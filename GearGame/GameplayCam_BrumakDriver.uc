/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Camera mode for when player is in a brumak.
 */
class GameplayCam_BrumakDriver extends GearGameplayCameraMode
	native(Camera)
	config(Camera);

cpptext
{
	virtual void GetCameraOrigin(class APawn* TargetPawn, FVector& OriginLoc, FRotator& OriginRot);
};

/** returns View relative offsets */
simulated native function GetBaseViewOffsets(Pawn ViewedPawn, ECameraViewportTypes ViewportConfig, float DeltaTime, out Vector out_Low, out Vector out_Mid, out Vector out_High);

simulated event vector GetCameraWorstCaseLoc(Pawn TargetPawn, TViewTarget CurrentViewTarget)
{
	local GearPawn_LocustBrumakBase Brumak;
	local Vector  SocketLoc;
	local Rotator SocketRot;

	Brumak = GearPawn_LocustBrumakBase(TargetPawn);
	if( Brumak == None )
	{
		Brumak = GearPawn_LocustBrumakBase(TargetPawn.Base);
	}

	if( Brumak != None )
	{
		Brumak.Mesh.GetSocketWorldLocationAndRotation( Brumak.DriverSocket, SocketLoc, SocketRot );
		return SocketLoc + (WorstLocOffset >> Brumak.Rotation);
	}
	else
	{
		return super.GetCameraWorstCaseLoc( TargetPawn, CurrentViewTarget);
	}
}

/** Returns true if mode should be using direct-look mode, false otherwise */
simulated native function bool UseDirectLookMode(Pawn CameraTarget);

/** Returns true if mode should lock camera to view target, false otherwise */
simulated native function bool LockedToViewTarget(Pawn CameraTarget);

simulated native function bool ShouldFollowTarget(Pawn CameraTarget, out float PitchInterpSpeed, out float YawInterpSpeed, out float RollInterpSpeed);

defaultproperties
{
	BlendTime=0.2f

	// defaults, in case the vehicle's data doesn't work out
	// low, right view.  by right arm
// 	ViewOffset={(
// 		OffsetHigh=(X=-300,Y=350,Z=225),
// 		OffsetLow=(X=-500,Y=350,Z=-100),
// 		OffsetMid=(X=-300,Y=350,Z=-100),
// 	)}

	// approx gears2 view
	ViewOffset={(
		OffsetHigh=(X=-250,Y=275,Z=300),
		OffsetLow=(X=-250,Y=275,Z=100),
		OffsetMid=(X=-250,Y=275,Z=100),
	)}
 
// 	// rough head view.  origin at head bone
// 	ViewOffset={(
// 		OffsetHigh=(X=100,Y=0,Z=-300),
// 		OffsetLow=(X=-100,Y=0,Z=-240),
// 		OffsetMid=(X=-100,Y=0,Z=-240),
// 	)}


	WorstLocOffset=(X=0,Y=0,Z=150)


	bDirectLook=FALSE
	bLockedToViewTarget=TRUE
	bFollowTarget=FALSE
	FollowingInterpSpeed_Pitch=5.f
	FollowingInterpSpeed_Yaw=1.5f
	FollowingInterpSpeed_Roll=5.f
	FollowingCameraVelThreshold=1000.f
}
