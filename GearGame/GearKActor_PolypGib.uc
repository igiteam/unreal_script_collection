/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearKActor_PolypGib extends GearKActorSpawnableEffect
	notplaceable;

/** Should this gib stick upon collision */
var bool bStickOnCollision;

event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
				const out CollisionImpactData RigidCollisionData, int ContactIndex )
{
	if( bStickOnCollision && 
		( OtherComponent == None || 
		  ( OtherComponent.IsA('StaticMeshComponent') && 
		    !OtherComponent.Owner.IsA('GearKActorSpawnableEffect') &&
		    OtherComponent.Owner.Physics != PHYS_RigidBody ) ) )
	{
		SetRotation(Rotator(Velocity));
		Velocity = vect(0,0,0);
		StaticMeshComponent.PutRigidBodyToSleep();
		SetCollision(false, false);
		SetPhysics(PHYS_None);

		SetHardAttach(true);
		if( OtherComponent != None && OtherComponent.Owner != None )
		{
			SetBase(OtherComponent.Owner);
		}
		else
		{
			SetBase(WorldInfo);
		}
	}
	else
	{
		Super.RigidBodyCollision(HitComponent, OtherComponent, RigidCollisionData, ContactIndex);
	}
}

defaultproperties
{
	Begin Object Name=StaticMeshComponent0
		Scale=0.575f
		bNotifyRigidBodyCollision=true
		ScriptRigidBodyCollisionThreshold=100.f
		RBChannel=RBCC_DeadPawn
		RBCollideWithChannels=(Default=TRUE,GameplayPhysics=TRUE,Pawn=TRUE,DeadPawn=TRUE,EffectPhysics=TRUE,FracturedMeshPart=TRUE,SoftBody=TRUE)
	End Object

	bCollideComplex=true
	bCollideActors=true
	bCollideWorld=true

	bUpdateSimulatedPosition=false
	bReplicateMovement=false
	bNeedsRBStateReplication=false

	GravityScale=2.5f
}
