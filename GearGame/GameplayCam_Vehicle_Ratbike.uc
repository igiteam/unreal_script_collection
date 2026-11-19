/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Camera mode for when player is in a vehicle.
 */
class GameplayCam_Vehicle_Ratbike extends GameplayCam_Vehicle																  
	// deprecated, remove me
	native(Camera)
	config(Camera);

/** Returns View relative offsets */
simulated native function GetBaseViewOffsets(Pawn ViewedPawn, ECameraViewportTypes ViewportConfig, float DeltaTime, out Vector out_Low, out Vector out_Mid, out Vector out_High);

/**
* Returns location and rotation, in world space, of the camera's basis point.  The camera will rotate
* around this point, offsets are applied from here, etc.
*/
simulated native function GetCameraOrigin(Pawn TargetPawn, out vector OriginLoc, out rotator OriginRot);

defaultproperties
{
	BlendTime=0.1
	bSkipCameraCollision=TRUE
	bUsePerAxisOriginLocInterp=TRUE;
	PerAxisOriginLocInterpSpeed=(X=15,Y=2,Z=5)
	bInterpLocation=TRUE
	//bInterpRotation=TRUE
}
