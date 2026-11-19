/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTutorial_ChangeWeapon extends GearTutorial_PCAction_Base
	config(Game);


/** Whether the update function should start checking for tutorial completion or not */
var bool bCheckForCompletion;


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Called when the tutorial gets added to the tutorial manager's list */
function OnTutorialAdded( GearTutorialManager TutMgr, SeqAct_ManageTutorials Action, bool IsKismetDriven  )
{
// 	local GearPC CurrPC;

	Super.OnTutorialAdded(TutMgr, Action, IsKismetDriven);

// 	// Hack all players to discard their weapons
// 	if (TutMgr.Outer.Pawn.Role == ROLE_Authority)
// 	{
// 		foreach TutMgr.Outer.WorldInfo.AllControllers(class'GearPC', CurrPC)
// 		{
// 			if (TutMgr.Outer.WorldInfo.Game != None)
// 			{
// 				GearGame(TutMgr.Outer.WorldInfo.Game).DiscardInventoryWithoutDelay(CurrPC.Pawn);
// 			}
// 		}
// 	}
// 
// 	if (TutMgr.Outer.Pawn != None)
// 	{
// 		// Hack this player to re-add their inventory but w/o equipping it
// 		GearPawn(TutMgr.Outer.Pawn).AddDefaultInventoryNoEquip();
// 	}

	bCheckForCompletion = true;
}

/** Called when the tutorial has become the active tutorial by the tutorial manager */
function bool TutorialActivated()
{
	TutorialMgr.Outer.DisableInput( true, true, true );
	bGameplayIsFrozen = true;
	Super.TutorialActivated();
	return true;
}

/** Called when the tutorial gets removed from the tutorial manager's list */
function OnTutorialRemoved()
{
	Super.OnTutorialRemoved();

	GearPC(Outer).bPreventWeaponSwitching = false;
}

/** Action to perform on the player when this tutorial is completed - implemented by all subclasses */
function PerformPCInputAction( bool bPressed )
{
	GearPC(Outer).MyGearPawn.UnHolsterWeapon();
	GearPlayerInput(InputHandler).HandleButtonInput_DPad(GB_DPad_Right,bPressed);
	if (bPressed)
	{
		GearPlayerInput(InputHandler).HandleButtonInput_DPad(GB_DPad_Right,!bPressed);
		GearPC(Outer).StopShowingWeaponSelector();
	}
}

/** Whether the player is already carrying the weapon or not */
function bool HasLancerEquipped()
{
	local GearPC MyGearPC;
	local GearPawn MyGearPawn;
	local GearWeapon CurrWeapon;

	MyGearPC = GearPC(Outer);
	if ( MyGearPC != None )
	{
		MyGearPawn = GearPawn(MyGearPC.Pawn);
		if ( MyGearPawn != None && !MyGearPawn.bWeaponHolstered )
		{
			CurrWeapon = MyGearPawn.MyGearWeapon;
			if ( (CurrWeapon != None) && ClassIsChildOf(CurrWeapon.Class, class'GearWeap_AssaultRifle') )
			{
				return true;
			}
		}
	}

	return false;
}

/** Determine if we should open the UI scene or not */
function bool ShouldOpenUIScene()
{
	// Don't open the scene if they already have the weapon equipped (this tutorial will be getting auto-completed)
	if ( HasLancerEquipped() )
	{
		return false;
	}

	return Super.ShouldOpenUIScene();
}

/** Called every tick so that the tutorial has a chance to update itself */
event Update()
{
	local GearWeapon CurrWeapon;

	// See if we should auto complete this tutorial because the player already has the weapon equipped
	if ( bCheckForCompletion && HasLancerEquipped() )
	{
		// Hack the Lancer so it can reload
		CurrWeapon = GearPawn(TutorialMgr.Outer.Pawn).MyGearWeapon;
		if (CurrWeapon != None)
		{
			CurrWeapon.SpareAmmoCount += CurrWeapon.WeaponMagSize * 0.75f;
			CurrWeapon.AmmoUsedCount = CurrWeapon.WeaponMagSize * 0.75f;
		}

		OnTutorialCompleted();
	}

	Super.Update();

	// Prevent the player from equipping weapons until this tutorial is ready
	if ( !bTutorialIsReadyForActivation )
	{
		GearPC(Outer).bPreventWeaponSwitching = true;
	}
	else
	{
		GearPC(Outer).bPreventWeaponSwitching = false;
	}
}

defaultproperties
{
	TutorialType=GEARTUT_ChangeWeapon
	GameButtonType=GB_DPad_Right
}
