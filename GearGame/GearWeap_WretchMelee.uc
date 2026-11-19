/**
 * Wretch melee weapon
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_WretchMelee extends GearWeap_Melee
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
	local int ModeIdx;

	P = GearPawn(Instigator);
	if( P != None )
	{
		ModeIdx = P.SpecialMove - GSM_PounceAttack;
		Target.TakeDamage( AttackDamage[ModeIdx] * DamageScale, GetWeaponController(), HitLocation, Normal(Target.Location-Instigator.Location) * DamageScale, class'GDT_Wretch_Melee',, self );
		GearPawn_LocustWretchBase(Instigator).PlaySwipeAttackHitSound();

		//`log( "Wretch Damage" $ AttackDamage[ModeIdx] );
	}
}

defaultproperties
{
	bCanThrow=FALSE
	BS_MeleeAttack.Empty()
	BS_MeleeAttack(0)=(Stance=((Slot=BS_FullBody,AnimName="Swipe")))
}
