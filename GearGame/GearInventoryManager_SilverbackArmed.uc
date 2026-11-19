
/**
 * GearInventoryManager_SilverbackArmed
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearInventoryManager_SilverbackArmed extends GearInventoryManager;

/** Save references to the weapons so that the Silverback can access them */
var GearWeapon PrimaryWeapon, AltFireWeapon;

/** We don't want the AI trying to switch weapons while in the silverback */
simulated function float GetWeaponRatingFor( Weapon W )
{
	return 0.0f;
}

simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
	local GearPawn MyGearPawn;

	if( !Super.AddInventory(NewItem, bDoNotActivate) )
	{
		return FALSE;
	}

	MyGearPawn = GearPawn(Instigator);
	if( MyGearPawn != none )
	{
		if( NewItem.Class == MyGearPawn.DefaultInventory[0] )
		{
			PrimaryWeapon = GearWeapon(NewItem);
		}

		if( NewItem.Class == MyGearPawn.DefaultInventory[1] )
		{
			SetAltWeapon(GearWeapon(NewItem));
			//`log(GetFuncName() @ "found AltFireWeapon" @ AltFireWeapon);
		}
	}

	// In order for relevancy checks to succeed, the weapons should have the Silverback as a base.
	NewItem.SetBase(MyGearPawn);

	return TRUE;
}

simulated function SetAltWeapon(GearWeapon NewWeapon)
{
	if (NewWeapon == none)
		return;

	AltFireWeapon = NewWeapon;
	AltFireWeapon.Activate();
}

/** Refresh the AltFireWeapon if original happened to be a slave that have been destroyed */
simulated function GearWeapon GetAltFireWeapon()
{
	if (AltFireWeapon == none)
	{
		SetAltWeapon(GearPawn_SilverbackArmedBase(Instigator).AltWeapon);
	}

	return AltFireWeapon;
}

defaultproperties
{
}
