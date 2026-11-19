/**
 * Spawnable smoke grenade fog volume.
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class TGFogVolume_SmokeGrenade extends TGFogVolume_Spawnable
	config(TGWeapon)
	native(TGWeapon);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function PostBeginPlay()
{
	Super.PostBeginPlay();

	VisBlocker = new(self) AutomaticMeshComponent.Class(AutomaticMeshComponent);
	VisBlocker.SetScale(AutomaticMeshComponent.Scale * VisBlockerScale);
	VisBlocker.SetBlockRigidBody(false);
	VisBlocker.SetActorCollision(true, false, false);
	VisBlocker.SetTraceBlocking(true, false);
	VisBlocker.SetHidden(true);
	AttachComponent(VisBlocker);
}



