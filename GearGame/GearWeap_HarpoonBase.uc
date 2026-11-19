/**
 * Harpoon Weapon
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_HarpoonBase extends GearWeapon
	config(Weapon)
	abstract;

/** @return the harpoon attach location */
simulated event vector GetMuzzleLoc()
{
	local Turret InstTurret;

	InstTurret = Turret(Instigator);
	if (InstTurret != None)
	{
		return InstTurret.Mesh.GetBoneLocation('Harpoon_Attach');
	}

	return Super.GetMuzzleLoc();
}

/** overridden to do nothing, so we don't get chatter every shot */
function PlayNeedsAmmoChatter() {}

defaultproperties
{
	bSkipOutOfAmmoIndicator=TRUE
}