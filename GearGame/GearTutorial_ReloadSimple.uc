/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTutorial_ReloadSimple extends GearTutorial_UnlimitedAmmoBase
	config(Game);


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Called when the tutorial gets added to the tutorial manager's list */
function OnTutorialAdded( GearTutorialManager TutMgr, SeqAct_ManageTutorials Action, bool IsKismetDriven  )
{
	local GearWeapon CurrWeapon;

	Super.OnTutorialAdded( TutMgr, Action, IsKismetDriven );

	GearPC(Outer).AddGearEventDelegate( eGED_Reload, OnReload );

	// Hack the Lancer so it can reload
	CurrWeapon = GearPawn(TutorialMgr.Outer.Pawn).MyGearWeapon;
	if (CurrWeapon != None)
	{
		CurrWeapon.SpareAmmoCount += CurrWeapon.WeaponMagSize * 0.75f;
		CurrWeapon.AmmoUsedCount = CurrWeapon.WeaponMagSize * 0.75f;
	}
}

/** Called when the tutorial gets removed from the tutorial manager's list */
function OnTutorialRemoved()
{
	Super.OnTutorialRemoved();

	GearPC(Outer).ClearGearEventDelegate( eGED_Reload, OnReload );
}

/** Called when the tutorial has become the active tutorial by the tutorial manager */
function bool TutorialActivated()
{
	TutorialMgr.Outer.DisableInput( true, true, true );
	bGameplayIsFrozen = true;
	Super.TutorialActivated();
	return true;
}

/** Delegate fired when the player reloads */
function OnReload()
{
	// Mark the other reload tutorials as complete if this one was completed
	// Don't let the first one save the profile so we don't have back to back saving
	TutorialMgr.MarkTutorialComplete( GEARTUT_Reload );

	// Tutorial is done if they reloaded
	OnTutorialCompleted();
}

/** Will freeze the game and the player, but does not pause the game */
function ToggleFreezeGameplay( bool bFreeze )
{
	local GearPC MyGearPC;

	Super.ToggleFreezeGameplay( bFreeze );

	if ( bFreeze && CanFreezeGame() )
	{
		// Let's make sure we have ammo and don't have to reload after this
		MyGearPC = GearPC(Outer);
		if ( MyGearPC != None )
		{
			MyGearPC.StopFiringWeaponAfterTime(0.5f);
		}
	}
}

/** Action to perform on the player when this tutorial is completed - implemented by all subclasses */
function PerformPCInputAction( bool bPressed )
{
	GearPlayerInput(InputHandler).HandleButtonInput_RightBumper(bPressed);
}

/** Called every tick so that the tutorial has a chance to update itself */
event Update()
{
	local GearPC PC;
	PC = GearPC(Outer);
	PC.MyGearHud.LastWeaponInfoTime = GearPC(Outer).WorldInfo.TimeSeconds;
	Super.Update();
}


defaultproperties
{
	TutorialType=GEARTUT_ReloadSimple
	GameButtonType=GB_RightBumper
}
