/**
 * Wretch melee weapon
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_TickerMelee extends GearWeap_Melee
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

defaultproperties
{
	bCanThrow=FALSE
	BS_MeleeAttack.Empty()
	InstantHitDamageTypes(0)=class'GDT_TickerMelee'
	//BS_MeleeAttack(0)=(Stance=((Slot=BS_FullBody,AnimName="Swipe")))
}
