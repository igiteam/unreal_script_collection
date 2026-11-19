/** 
 * Semi-persistent bits of fire stuck to the world.  Deposited by flamethrower, etc.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class BerserkerEffectsDamageActor extends Actor
	config(Pawn);


/** Reference to the berserker who dropped this damage actor */
var GearPawn_LocustBerserkerLambentBase BerserkerPawn;

/** Whether the berserker was laying down fog when this actor was created */
var bool bShouldDealFogDamage;

/** Whether the berserker was laying down imulsion trails when this actor was created */
var bool bShouldDealImulsionDamage;


/** Called when the berserker drops this damage actor so we can keep a reference back to the berserker */
simulated function InitializeDamageActor(GearPawn_LocustBerserkerLambentBase BerserkerGP, bool bDoFogDamage, bool bDoTrailDamage)
{
	BerserkerPawn = BerserkerGP;
	if (BerserkerPawn != None)
	{
		bShouldDealFogDamage = bDoFogDamage;
		bShouldDealImulsionDamage = bDoTrailDamage;
	}
}

/** Overloaded to tell the berserker to deal damage to someone */
simulated function Tick(float DeltaTime)
{
	local GearPawn GP;

	Super.Tick(DeltaTime);

	// Make sure only host does this (though only host should have spawned this)
	if (Role == ROLE_Authority && BerserkerPawn != None)
	{
		// Find all GearPawns and tell the berserker that damage should be dealt
		ForEach TouchingActors(class'GearPawn', GP)
		{
			BerserkerPawn.ActorIsInDamageActor(GP, self);
		}
	}
}

/** Overloaded so we can clean up the berserker who is referencing this actor */
event Destroyed()
{
	if (BerserkerPawn != None)
	{
		BerserkerPawn.DroppedDamageActorsList.RemoveItem(self);
	}

	Super.Destroyed();
}

defaultproperties
{
 	LifeSpan=15.0f
	RemoteRole=ROLE_SimulatedProxy

	bCollideActors=true
	Begin Object Class=CylinderComponent Name=CollisionCylinder0
		CollisionRadius=+055.000000
		CollisionHeight=+0100.00000
		CollideActors=TRUE
	End Object
	CollisionComponent=CollisionCylinder0
	Components.Add(CollisionCylinder0)
}

