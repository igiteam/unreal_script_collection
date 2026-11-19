/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTutorial_Fire extends GearTutorial_Base
	config(Game);


/** Amount of ammo at the start of this tutorial */
var transient int TotalAmmoUsed;

/** Amount of ammo in gun when started current spray of shooting */
var transient int StartAmmoCountThisSpray;

/** Whether the trigger is held down right now */
var transient bool bTriggerHeld;

/** Number of bullets that need to be shot to determine this tutorial finished */
var config int TotalAmmoUsedForCompletetion;

/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Returns the current ammo count in the gun being held */
function int GetCurrentAmmoCount()
{
	local GearWeapon CurrWeapon;
	local int CurrAmmoCount;

	CurrWeapon = GearPawn(TutorialMgr.Outer.Pawn).MyGearWeapon;
	if (CurrWeapon != None)
	{
		CurrAmmoCount = CurrWeapon.SpareAmmoCount + CurrWeapon.WeaponMagSize - CurrWeapon.AmmoUsedCount;
	}
	return CurrAmmoCount;
}

/** Called every tick so that the tutorial has a chance to update itself */
event Update()
{
	local GearPlayerInput_Base PInput;
	
	PInput = GearPlayerInput_Base(GearPC(Outer).PlayerInput);
	if (PInput != None)
	{
		if (PInput.IsButtonActive(RemapGameButton(GB_RightTrigger)))
		{
			if (!bTriggerHeld)
			{
				StartAmmoCountThisSpray = GetCurrentAmmoCount();
				bTriggerHeld = true;
			}
			else
			{
				TotalAmmoUsed += StartAmmoCountThisSpray - GetCurrentAmmoCount();
			}
		}
		else
		{
			bTriggerHeld = false;
		}
	}

	if (TotalAmmoUsed > TotalAmmoUsedForCompletetion)
	{
		OnTutorialCompleted();
	}

	Super.Update();
}

defaultproperties
{
	TutorialType=GEARTUT_Fire
}
