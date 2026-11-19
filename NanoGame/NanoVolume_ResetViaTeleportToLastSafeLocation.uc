/**
 * 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoVolume_ResetViaTeleportToLastSafeLocation extends NanoPhysicsVolume;



simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	Super.Touch(Other, OtherComp, HitLocation, HitNormal);

	if( NanoPawn_RebelsBase(Other) != none )
	{
		NanoPawn_RebelsBase(Other).ResetToAnchor();
	}
}



defaultproperties
{
}