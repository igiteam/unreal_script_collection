/**
 * Player prep for the zipline
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_ZiplineStart extends GearSpecialMove;

/**
 * Switch to pistol and transition to idle in a bit
 *
 * @param bForced - was the special move forced
 *
 * @param PrevMove - the previous special move to run
 *
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearWeapon Weap;

	Super.SpecialMoveStarted(bForced, PrevMove);
		
	foreach PawnOwner.InvManager.InventoryActors(class'GearWeapon', Weap)
	{
		if (Weap.WeaponType == WT_Holster)
		{
			PawnOwner.InvManager.SetCurrentWeapon(Weap);
			break;
		}
	}

	PawnOwner.SetTimer(0.5f, FALSE, nameof(EndMove), Self);
}

/** Transition to idle */
function EndMove()
{
	PawnOwner.LocalDoSpecialMove(SM_ZiplineIdle, TRUE);
}

defaultproperties
{
	bCanFireWeapon=FALSE
	bCanSwitchWeapons=FALSE

	bDisableMovement=TRUE
	bLockPawnRotation=TRUE

	bDisallowDBNO=TRUE
}