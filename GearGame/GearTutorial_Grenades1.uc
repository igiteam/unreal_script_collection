/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTutorial_Grenades1 extends GearTutorial_PCAction_Base
	config(Game);


/** Whether this tutorial was automatically closed because the player already had the weapon equipped */
var bool bAutoCompleted;

/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Action to perform on the player when this tutorial is completed - implemented by all subclasses */
function PerformPCInputAction( bool bPressed )
{
	if ( !bAutoCompleted )
	{
		GearPlayerInput(InputHandler).HandleButtonInput_DPad(GB_DPad_Up,bPressed);
	}
}

/** Whether the player is already carrying the weapon or not */
function bool HasGrenadesEquipped()
{
	local GearPC MyGearPC;
	local GearPawn MyGearPawn;
	local GearWeapon CurrWeapon;

	MyGearPC = GearPC(Outer);
	if ( MyGearPC != None )
	{
		MyGearPawn = GearPawn(MyGearPC.Pawn);
		if ( MyGearPawn != None )
		{
			CurrWeapon = MyGearPawn.MyGearWeapon;
			if ( (CurrWeapon != None) && ClassIsChildOf(CurrWeapon.Class, class'GearWeap_GrenadeBase') )
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
	if ( HasGrenadesEquipped() )
	{
		return false;
	}

	return Super.ShouldOpenUIScene();
}

/** Called every tick so that the tutorial has a chance to update itself */
event Update()
{
	local GearInventoryManager InvManager;
	local GearPC PC;
	local GearWeapon GrenadeWeapon;
	local int CurrAmmoCount;

	// See if we should auto complete this tutorial because the player already has the weapon equipped
	if ( !bAutoCompleted && HasGrenadesEquipped() )
	{
		bAutoCompleted = true;
		OnTutorialCompleted();
	}

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
	TutorialType=GEARTUT_Grenades1
	GameButtonType=GB_DPad_Up
}
