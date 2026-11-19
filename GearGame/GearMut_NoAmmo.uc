/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_NoAmmo extends GearMutator;

function bool CheckReplacement(Actor Other)
{
	local GearWeapon W;

	W = GearWeapon(Other);
	if (W != None && !W.IsA('GearVehicleWeapon') && !W.default.bInfiniteSpareAmmo)
	{
		W.WeaponMaxSpareAmmo = 0;
		W.AmmoUsedCount = W.WeaponMagSize;
	}

	return true;
}
