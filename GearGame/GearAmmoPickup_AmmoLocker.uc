
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAmmoPickup_AmmoLocker extends GearPickupFactory
		config(Weapon);
/** Infinite ammo locker for SP */

//The name to display
var localized string DisplayName;

//The types of ammo the locker will refill
var config array<name> AmmoTypes;

/** Set default ammo mesh. */
simulated function SetPickupMesh();
/** We're not using InventoryType class like PickupFactory.uc */
simulated function InitializePickup();

/**
* returns the display name of the item to be picked up
*/
simulated function String GetDisplayName()
{
	return DisplayName;
}

/** Bypass PickupFactory implementation. We do not have InventoryType set. */
simulated event SetInitialState()
{
	if (Role == ROLE_Authority && WorldInfo.GRI.IsMultiplayerGame() && !WorldInfo.Game.IsA('GearGameHorde_Base'))
	{
		GotoState('Disabled');
	}
	else
	{
		Super(Actor).SetInitialState();
	}
}

/**
 * Give pickup to player
 */
function GiveTo(Pawn P)
{
	local GearInventoryManager InvManager;
	local GearWeapon Weap;
	local bool bGaveAmmo;

	InvManager = GearInventoryManager(P.InvManager);

	if (InvManager != None)
	{
		P.PlaySound(SoundCue'Weapon_AssaultRifle.Weapons.GenericAmmoPickup01Cue');
		foreach InvManager.InventoryActors(class'GearWeapon',Weap)
		{
			if ( Weap.CharacterSlot != EASlot_None && AmmoTypes.Find(Weap.AmmoTypeClass.Name) != INDEX_NONE)
			{
				bGaveAmmo = InvManager.AddAmmoFromWeaponClass(Weap.class, Weap.WeaponMaxSpareAmmo) || bGaveAmmo;
			}
		}

		if (bGaveAmmo)
		{
			// @STATS - Record ammo pickup
			`RecordPlayerIntStat(AMMOCRATE_PICKUP, P.Controller, 1);
		}
	}
	SetTimer( 1.f,FALSE,nameof(UnHideAmmo) );
}

/** So it can be picked up again */
function UnHideAmmo()
{
	ClaimedBy = None;
	bForceNetUpdate = TRUE;
}

/** Determine whether or not the locker can be picked up by a specific pawn
 *	@param Pawn The pawn to check for pickupability
 *	@return Whether or not the pawn can pick it up
 */
simulated function bool CanPickup(Pawn P)
{
	local GearInventoryManager InvManager;
	local GearWeapon Weap;
	local bool bCanPickup;

	bCanPickup = false;

	InvManager = GearInventoryManager(P.InvManager);

	if (InvManager != None)
	{
		foreach InvManager.InventoryActors(class'GearWeapon',Weap)
		{
			if ( Weap.CharacterSlot != EASlot_None
				&&  Weap.WeaponMaxSpareAmmo > 0 && Weap.SpareAmmoCount < Weap.WeaponMaxSpareAmmo && AmmoTypes.Find(Weap.AmmoTypeClass.Name) != INDEX_NONE )
			{
				bCanPickup = true;
				break;
			}
		}
	}
	return bCanPickup;
}

/**
 * See if we can do something with this weapon pickup.
 * bExcludeChecks - TRUE = could you have?
 *                - FALSE = you actually can
 */
simulated function Name FindInteractionWith(Pawn P, bool bExcludeChecks)
{
	local GearPawn GP;
	GP = GearPawn(P);

	// Don't allow any pickup when carrying crate or when picking something up
	if (bHidden || GP == None || GP.IsDoingSpecialMove(SM_WeaponPickup) || (!bExcludeChecks && !CanPickup(P)))
	{
		return 'None';
	}
	return 'TakeAmmo';
}

/** Get the debug abbreviation */
simulated event string GetDebugAbbrev()
{
	return "APLocker";
}

defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		StaticMesh=StaticMesh'AmmoPickups.Mesh.Ammopickup_Permanent'
		bCastDynamicShadow=FALSE
		bOwnerNoSee=TRUE
		CollideActors=FALSE
		Scale=1.0
		Translation=(Z=-20)
		LightingChannels=(BSP=TRUE,Dynamic=FALSE,Static=TRUE,CompositeDynamic=TRUE)
		LightEnvironment=PickupLightEnvironment
	End Object
	bBlockActors=true
	Components.Remove(Sprite)
	PickupMesh=StaticMeshComponent0
	Components.Add(StaticMeshComponent0)

	Begin Object Class=CylinderComponent Name=AuxCollisionCylinder0
		CollisionRadius=+00035.000000
		CollisionHeight=+00060.000000
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=true
	End Object
	Components.Add(AuxCollisionCylinder0)

}
