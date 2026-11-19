/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_MustActiveReload extends GearMutator;

function bool CheckReplacement(Actor Other)
{
	local GearWeapon Weap;

	Weap = GearWeapon(Other);
	if (Weap != None)
	{
		// it only affects humans so just globally apply it
		Weap.bMustActiveReload = true;
	}
	return true;
}
