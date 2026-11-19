/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GearTutorial_Grenades2 extends GearTutorial_Base
	config(Game);


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** Whether the player has started targetting their grenade yet */
var transient bool bStartedTargettingGrenade;

/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/**
 * Called when this tutorial's input handler is created (if this tutorial has it's own handler)
 *		This is where a tutorial can add InputButtonData mappings to the handler.
 */
function InitializeInputHandler()
{
	// Must call super first so that there is button data to set
	Super.InitializeInputHandler();

	if ( InputHandler != None )
	{
		InputHandler.SetInputButtonHandle( GB_LeftTrigger, HandleButtonInput_Targetting );
	}
}

/** Called when the tutorial gets added to the tutorial manager's list */
function OnTutorialAdded( GearTutorialManager TutMgr, SeqAct_ManageTutorials Action, bool IsKismetDriven  )
{
	Super.OnTutorialAdded( TutMgr, Action, IsKismetDriven );

	GearPC(Outer).AddGearEventDelegate( eGED_GrenadeToss, OnGrenadeToss );
}

/** Called when the tutorial gets removed from the tutorial manager's list */
function OnTutorialRemoved()
{
	Super.OnTutorialRemoved();

	GearPC(Outer).ClearGearEventDelegate( eGED_GrenadeToss, OnGrenadeToss );
}

/**
 * Opportunity for the tutorial to override the filtering system for the input object handling this tutorial's input
 *		@Param Filtered - whether this button should be filtered or not (non zero means true)
 *		@Return - whether we've handled the filtering or not
 */
function bool FilterButtonInput( Name ButtonName, bool bPressed, int ButtonIdx, out int Filtered )
{
	// If we've started targetting let the parent handle the input
	if ( bStartedTargettingGrenade )
	{
		return false;
	}

	// Have the tutorial's input handler handle this input
	if ( ButtonName == InputHandler.InputButtonDataList[GB_LeftTrigger].ButtonNameMapping )
	{
		Filtered = 0;
	}
	else
	{
		Filtered = 1;
	}

	return true;
}

/** Callback when the player targets using the grenades */
function HandleButtonInput_Targetting( bool bPressed, optional bool bDblClickMove )
{
	if ( bPressed )
	{
		bStartedTargettingGrenade = true;

		// Unfreeze the game
		ToggleFreezeGameplay( false );

		// Reset the left trigger handle and call it
		InputHandler.SetInputButtonHandle( GB_LeftTrigger, GearPlayerInput(InputHandler).HandleButtonInput_LeftTrigger );
		GearPlayerInput(InputHandler).HandleButtonInput_LeftTrigger( bPressed );
		InputHandler.ForceButtonRelease( GB_DPad_Up );

		// Change the UI scene to not show the 'press LT' part
		if ( bSceneIsOpen && SceneInstance != None)
		{
			SceneInstance.ShowButtonLabel(false);
		}
	}
}

/** Callback for when the player tosses the grenade */
function OnGrenadeToss()
{
	OnTutorialCompleted();
}

/** Called every tick so that the tutorial has a chance to update itself */
event Update()
{
	local GearInventoryManager InvManager;
	local GearPC PC;
	local GearWeapon GrenadeWeapon;
	local int CurrAmmoCount;

	if (GearPC(Outer).Role == ROLE_Authority)
	{
		foreach TutorialMgr.Outer.WorldInfo.AllControllers(class'GearPC', PC)
		{
			if (PC.MyGearPawn != None)
			{
				InvManager = GearInventoryManager(PC.MyGearPawn.InvManager);
				if (InvManager != None)
				{
					GrenadeWeapon = GearWeapon(InvManager.GetInventoryInSlot(EASlot_Belt));
					if (GrenadeWeapon != None)
					{
						CurrAmmoCount = GrenadeWeapon.SpareAmmoCount + GrenadeWeapon.WeaponMagSize - GrenadeWeapon.AmmoUsedCount;
						if (CurrAmmoCount <= 0)
						{
							// Add a grenade to the inventory
							InvManager.AddAmmoFromWeaponClass(class'GearWeap_FragGrenade', 1);
						}
					}
					else
					{
						// Create grenade inventory
						InvManager.CreateInventory(class'GearWeap_FragGrenade');
					}
				}
			}
		}
	}

	Super.Update();
}

defaultproperties
{
	TutorialType=GEARTUT_Grenades2
	InputHandlerClass=class'GearPlayerInputTutorialPC'
}
