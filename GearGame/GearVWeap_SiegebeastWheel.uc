/**
 * The siegebeast charging wheel
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearVWeap_SiegebeastWheel extends GearVehicleWeapon;

/** How long to wait between wheel cranks */
var const float CrankLength;

/**
 * There's no aiming on this seat
 * 
 * @return TRUE because the aim is always correct
 */
simulated event bool IsAimCorrect()
{
	return TRUE;
}

/** Turn the wheel or leave if there's no driver */
function AITurnWheel()
{
	if( MyVehicle == None )
	{
		ClearTimer( nameof(AITurnWheel) );
	}

	if (GearAIController != None)
	{
		if (MyVehicle.Driver == None)
		{
			GearWeaponPawn(Instigator).DriverLeave(FALSE);
		}
		else
		{
			GearAIController.bWeaponCanFire = TRUE;
			StartFire(MELEE_ATTACK_FIREMODE);
		}
	}
}

/** Use FlashCount to play animations and hold the melee end til the anim is done */
simulated function MeleeAttackStarted()
{
	IncrementFlashCount();

	SetTimer(CrankLength, FALSE, nameof(EndOfMeleeAttack));
}

/**
 * Only allow firing when the siegebeast isn't fully charged
 * 
 * @param FireModeNum - how is the player trying to fire this weapon
 * 
 * @param Amount - the amount of ammo the weapon is trying to use
 * 
 * @return TRUE if the weapon can fire
 */
simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
	local Vehicle_Siegebeast_Base Siegebeast;

	Siegebeast = Vehicle_Siegebeast_Base(MyVehicle);
	if (Siegebeast != None)
	{
		return Siegebeast.bReadyToReload;
	}

	return FALSE;
}

/** Don't play any chatter */
function PlayNeedsAmmoChatter();

defaultproperties
{
	WeaponFireTypes(0)=EWFT_Custom
	CrankLength=1.5f
}