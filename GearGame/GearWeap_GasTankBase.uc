/**
 * Gas Tank "Weapon"
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_GasTankBase extends GearWeapon
	abstract;

var config int Health;

/** Defines the explosion. */
var GearExplosion			ExplosionTemplate;

simulated function PlayFireEffects(byte FireModeNum, optional vector HitLocation)
{
}

simulated function PlayFireCameraEffects()
{
}

simulated state Active
{
	//If we are not actively in the process of picking up the tank, we MUST put it on our back. No holding onto it!
	simulated function Tick(float DeltaTime)
	{
		local Actor Pickup;
		local GearPawn GP;
		local class<GearWeapon> PickupClass;

		GP = GearPawn(Instigator);
		if (GP != none)
		{
			if (!GP.IsDoingSpecialMove(SM_WeaponPickup) && GSM_Pickup(GP.SpecialMoves[GP.SpecialMove]) != None)
			{
				Pickup = GSM_Pickup(GP.SpecialMoves[GP.SpecialMove]).PickupActor;
				if (GearWeaponPickupFactory(Pickup) != None)
				{
					PickupClass = GearWeaponPickupFactory(Pickup).WeaponPickupClass;
				}
				else if (GearDroppedPickup(Pickup) != None)
				{
					PickupClass = class<GearWeapon>(GearDroppedPickup(Pickup).InventoryClass);
				}
			}

			if (Class != PickupClass)
			{
				GearInventoryManager(InvManager).AutoSwitchWeapon();
			}
		}
	}

	simulated function ForceReload()
	{
	}

	//Never allow firing :P
	simulated function BeginFire(byte FireModeNum)
	{
	}
};

/* Stuff to do when the weapon is first acquired */
function GivenTo(Pawn NewOwner, optional bool bDoNotActivate)
{
	local GearPawn GP;

	Super.GivenTo(NewOwner,bDoNotActivate);

	GP = GearPawn(NewOwner);
	if (GP != none)
	{
		GP.EquippedGasTank = self;
		GP.EquippedGasTankHealth = Health;
		GP.bHasGasTank = true;
	}
}

/**
 * Dummy! This weapon has no muzzle.
 */
simulated event vector GetMuzzleLoc()
{
	return vect(0,0,0);
}

function Explode()
{
	local GearExplosionActorReplicated ExplosionActor;

	// spawn explosion
	ExplosionActor = Spawn(class'GearExplosionActorReplicated', Instigator,, Instigator.Location, rot(16384,0,0));
	ExplosionActor.InstigatorController = Instigator.Controller;  // will have be replicated out
	ExplosionTemplate.InitFromContentTemplate();
	ExplosionTemplate.Damage = 5000;
	ExplosionTemplate.DamageRadius = 500;
	ExplosionTemplate.DamageFalloffExponent = 1.0f;

	ExplosionActor.Explode(ExplosionTemplate);
}

defaultproperties
{
	bIsSuppressive=FALSE
	bSniping=false
	bInstantHit=true
	bCanNegateMeatShield=false
	bIgnoresExecutionRules=false

	bWeaponCanBeReloaded=false
	bAutoSwitchWhenOutOfAmmo=FALSE

	// Weapon Mesh
	Begin Object Name=WeaponMesh
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockRigidBody=TRUE
		RBChannel=RBCC_Default
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,EffectPhysics=TRUE,GameplayPhysics=TRUE,Pawn=FALSE)
	End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh
	bKillDuringLevelTransition=TRUE


	LC_EmisDefaultCOG=(R=1.0,G=3.0,B=10.0,A=1.0)
	LC_EmisDefaultLocust=(R=16.0,G=0.8,B=0.2,A=1.0)

	AIRating=-1000.0f

	WeaponID=WC_GasTank
}

