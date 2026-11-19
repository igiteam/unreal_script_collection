/**
 * This class must be used for our Fan Volumes so we can modify it later
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoVolume_Fan extends NanoPhysicsVolume
	native;


/** We need this as the volume sometimes needs data from the fan :-\ **/
var transient NanoFanBase FanBelongTo;

cpptext
{
	virtual FVector GetZoneVelocityForActor( AActor* TheActor );
}



simulated function SetStaticMeshCollisionVolume( StaticMeshComponent InSMC )
{
	CollisionComponent = InSMC;
	AttachComponent( CollisionComponent );
}



defaultproperties
{
	Components.Remove(BrushComponent0)
	CollisionComponent=none
	BrushComponent=none

	bStatic=FALSE
	bNoDelete=FALSE

	bAffectsNormal=FALSE

	bAffectsDusted=TRUE
	DustVelocityScale=1.0f

	bAffectsDensed=FALSE
	DenseVelocityScale=0.0f

	// Add zone velocity for cloth simulation...doesn't affect actors due to GetZoneVelocityForActor() being overridden
	ZoneVelocity=(Z=50.f)

	Priority=999999 // this needs to be higher than anything else.  Otherwise when someone puts a giant volume around the world for setting terminal velocity or something like that it will get precedence based on the order over the Touching List
}