/**
 * Wretch melee weapon
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_BabyCorpserMelee extends GearWeap_Melee
	config(Weapon)
	hidedropdown;


simulated function StartFire(byte FireModeNum)
{
	if (FireModeNum == MELEE_ATTACK_FIREMODE)
	{
		Super.StartFire(FireModeNum);
	}
}

simulated function bool ShouldRefire()
{
	return (AIController != None && Super.ShouldRefire());
}


function DoMeleeDamage( Actor Target, Vector HitLocation, float DamageScale )
{
	local GearPawn P;

	P = GearPawn(Instigator);
	if( P != None )
	{
		Target.TakeDamage(AttackDamage[0] * DamageScale, GetWeaponController(), HitLocation, Normal(Target.Location-Instigator.Location) * DamageScale, class'GDT_BabyCorpser_Melee',, self);
	}
}

defaultproperties
{
	bCanThrow=FALSE
	BS_MeleeAttack.Empty()
	BS_MeleeAttack(0)=(Stance=((Slot=BS_FullBody,AnimName="Melee")))
}
