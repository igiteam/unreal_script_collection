/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Camera mode for when player is in a vehicle.
 */
class GameplayCam_MountedHeavyWeapon extends GearGameplayCameraMode
	native(Camera)
	config(Camera);


/** Returns View relative offsets */
simulated native function GetBaseViewOffsets(Pawn ViewedPawn, ECameraViewportTypes ViewportConfig, float DeltaTime, out Vector out_Low, out Vector out_Mid, out Vector out_High);

defaultproperties
{
	BlendTime=0.13f						// tighter feel
	//bDoPredictiveAvoidance=FALSE		// turrets should be placed in the clear by LDs
	bValidateWorstLoc=FALSE
	OriginLocInterpSpeed=500

	// defaults, in case the turret's data doesn't work out
	ViewOffset={(
		OffsetHigh=(X=-100,Y=0,Z=15),
		OffsetLow=(X=-100,Y=0,Z=80),
		OffsetMid=(X=-100,Y=0,Z=30),
		)}
}
