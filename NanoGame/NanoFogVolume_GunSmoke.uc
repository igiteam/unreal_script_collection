/**
 * Spawnable gun smoke fog volume (ala GTA IV)
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoFogVolume_GunSmoke extends NanoFogVolume_Spawnable
	config(Weapon);



function PostBeginPlay()
{
	Super.PostBeginPlay();

// 	VisBlocker = new(self) AutomaticMeshComponent.Class(AutomaticMeshComponent);
// 	VisBlocker.SetScale(AutomaticMeshComponent.Scale * VisBlockerScale);
// 	VisBlocker.SetBlockRigidBody(false);
// 	VisBlocker.SetActorCollision(true, false, false);
// 	VisBlocker.SetTraceBlocking(true, false);
// 	VisBlocker.SetHidden(true);
// 	AttachComponent(VisBlocker);
}


 
defaultproperties
{
	FogVolumeArchetype=FogVolumeSphericalDensityInfo'Effects_FogVolumes.FogVolumes.FV_Spherical_GunSmoke'

	FadeInTime=2.f
	FadeOutTime=2.f

	bMovable=FALSE
	bCollideActors=TRUE
	bBlockActors=FALSE
	bCollideWorld=FALSE
	bCollideWhenPlacing=FALSE
}
