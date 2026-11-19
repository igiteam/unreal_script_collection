/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAmmoCrate extends DynamicSMActor_Spawnable
	config(Weapon);

var()   config  int CrateAmmoCount;

// When touched by an actor.
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local NanoPawn NP;

	// If touched by a player pawn, let him pick this up.
	NP = NanoPawn(Other);
	if( (CrateAmmoCount > 0) && (NP != None) && NP.IsHumanControlled() )
	{
		//`log("PICKUP"@WeaponClass@"GIVING"@AmmoAmount@"TO"@NP);

		NP.Controller.PlaySound(SoundCue'Weapon_AssaultRifle.Weapons.GenericWeaponPickup03Cue');
		NP.GetPRI().GiveMaxAmmoForUnlockedWeapons(NP);
		Destroy(); // destroy this pickup once picked up!
	}
}


defaultproperties
{
	Begin Object Name=StaticMeshComponent0
	    StaticMesh=StaticMesh'FORGE_Ammo.Meshes.SM_AmmoCrate_Large_01'
		Scale=1.5
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockRigidBody=FALSE
	End Object

	bCollideActors=TRUE
	bBlockActors=FALSE
}