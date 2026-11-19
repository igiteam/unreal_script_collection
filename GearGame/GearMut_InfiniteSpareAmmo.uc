/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_InfiniteSpareAmmo extends GearMutator;

function bool CheckReplacement(Actor Other)
{
	if (Other.IsA('GearWeapon'))
	{
		GearWeapon(Other).SetInfiniteSpareAmmo();
	}

	return true;
}
