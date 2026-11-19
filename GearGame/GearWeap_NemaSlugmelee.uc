/**
* Rock Worm melee weapon
*
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class GearWeap_NemaSlugMelee extends GearWeap_Melee
	config(Weapon)
	hidedropdown;


defaultproperties
{
	BS_MeleeAttack.Empty()
	BS_MeleeAttack(0)=(Stance=((Slot=BS_FullBody,AnimName="NS_AttackA")))
	BS_MeleeAttack(1)=(Stance=((Slot=BS_FullBody,AnimName="NS_AttackB")))
}