/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_NoAmmoPickups extends GearMutator;

function bool CheckReplacement(Actor Other)
{
	return !Other.IsA('GearAmmoPickup_AmmoCase') && !Other.IsA('GearAmmoPickup_AmmoLocker');
}
