/**
* Bloodmount melee weapon
*
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class GearWeap_BloodMountMelee extends GearWeap_Melee
	config(Weapon)
	hidedropdown;

simulated function bool ShouldDrawCrosshair()
{
	return Super(GearWeapon).ShouldDrawCrosshair();
}

defaultproperties
{
	InstantHitDamageTypes(0)=class'GDT_BloodmountMelee'
	bUseTargetingCamera=true
}
