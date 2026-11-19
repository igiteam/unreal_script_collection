
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAmmoPickup_AmmoCase extends GearPickupFactory
	config(Weapon);

var localized string DisplayName;

var() bool bInfiniteAmmo;

struct AmmoMagInfo
{
	var name AmmoName;
	var vector2D NumMags;
	/** cash cost to take this ammo in Horde - value of pickup is highest of all ammo types the player needs */
	var int HordeCost;
};
var config array<AmmoMagInfo> AmmoAmounts;

/** different HUD action indicator for pickups requiring Horde purchase */
var ActionInfo PickupActionRequiresPurchase;

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
* returns the display name of the item to be picked up
*/
simulated function String GetDisplayName()
{
	return DisplayName;
}

/** Set default ammo mesh. */
simulated function SetPickupMesh();
/** We're not using InventoryType class like PickupFactory.uc */
simulated function InitializePickup();

/**
 * bExcludeChecks - TRUE = could you have?
 *                - FALSE = you actually can
 */
simulated static function bool FindPickupAmmoTypes(Pawn P, optional out array<class<GearAmmoType> > out_AmmoTypes, optional out int HordeCost, optional bool bExcludeChecks)
{
	local GearInventoryManager InvManager;
	local GearWeapon Weap;
	local int NextCost;

	InvManager = GearInventoryManager(P.InvManager);

	if (InvManager != None)
	{
		foreach InvManager.InventoryActors(class'GearWeapon',Weap)
		{
			if ( Weap.CharacterSlot != EASlot_None
				&& (bExcludeChecks || (Weap.WeaponMaxSpareAmmo > 0 && Weap.SpareAmmoCount < Weap.WeaponMaxSpareAmmo)) &&
				GetNumMagsBasedOnAmmoType(Weap.AmmoTypeClass, NextCost).Y > 0.0 )
			{
				out_AmmoTypes[out_AmmoTypes.Length] = Weap.AmmoTypeClass;
				HordeCost = Max(HordeCost, NextCost);
			}
		}
	}
	return (out_AmmoTypes.Length > 0);
}

/**
 * See if we can do something with this weapon pickup.
 * bExcludeChecks - TRUE = could you have?
 *                - FALSE = you actually can
 */
simulated function Name FindInteractionWith(Pawn P, bool bExcludeChecks)
{
	local GearPawn GP;
	local int HordeCost;

	GP = GearPawn(P);
	// Don't allow any pickup when carrying crate or when picking something up
	if (bHidden || GP == None || GP.IsDoingSpecialMove(SM_WeaponPickup) || !FindPickupAmmoTypes(P,, HordeCost, bExcludeChecks))
	{
		return 'None';
	}
	// check for Horde cash cost
	else if (RequiresPurchase() && P.PlayerReplicationInfo != None && P.PlayerReplicationInfo.Score < HordeCost)
	{
		return 'PickupLocked';
	}
	else
	{
		return 'TakeAmmo';
	}
}

simulated function bool GetPickupAction(out ActionInfo out_PickupAction, out Name out_Interaction, Pawn P)
{
	local int HordeCost;

	if (Super.GetPickupAction(out_PickupAction, out_Interaction, P))
	{
		// use the purchase action icon if necessary
		if (RequiresPurchase())
		{
			if (CanBePickedUpBy(P))
			{
				out_PickupAction.ActionIconDatas[0] = PickupActionRequiresPurchase.ActionIconDatas[0];
			}
			FindPickupAmmoTypes(P,, HordeCost);
			out_PickupAction.TooltipText = DisplayName @ "-" @ class'GearWeaponPickupFactory'.default.CostTooltip @ HordeCost;
		}
		return true;
	}
	else
	{
		return false;
	}
}

/**
 * Give pickup to player
 */
function GiveTo(Pawn P)
{
	local array<class<GearAmmoType> > AmmoTypes;
	local GearInventoryManager InvManager;
	local GearGRI_Horde GRI;
	local int HordeCost;

	InvManager = GearInventoryManager(P.InvManager);

	if (InvManager != None && FindPickupAmmoTypes(P, AmmoTypes, HordeCost, false))
	{
		GiveAmmoTo(P);
		if (!bInfiniteAmmo)
		{
			if (WorldInfo.Game.IsA('GearGameHorde_Base'))
			{
				if (HordeCost > 0 && P.PlayerReplicationInfo != None)
				{
					// no respawn time for ammo that needs cash to purchase
					P.PlayerReplicationInfo.Score -= HordeCost;
					P.PlayerReplicationInfo.bForceNetUpdate = true;

					if (GearPC(P.Controller) != None)
					{
						GearPC(P.Controller).ClientModifyStat('CashSpent', HordeCost); 
					}

					GRI = GearGRI_Horde(WorldInfo.GRI);
					if (GRI.bCanPlaceFortifications)
					{
						GRI.UpdateFortificationGhostImages();
					}
					ClaimedBy = None;
				}
				else
				{
					SetHidden(true);
					SetTimer(45.0, false, nameof(UnHideAmmo));
				}
			}
			else
			{
				ShutDown();
			}
		}
		else
		{
			SetHidden(TRUE);
			SetTimer( 10.f,FALSE,nameof(UnHideAmmo) );
		}
	}
}

/**
 * Give the ammo to the player
 */
static function GiveAmmoTo(Pawn P)
{
	local array<class<GearAmmoType> > AmmoTypes;
	local int Idx;
	local float Amount;
	local GearInventoryManager InvManager;
	local GearPawn WP;
	local Vector2D AmmoRng;
	local bool bGaveAmmo;

	InvManager = GearInventoryManager(P.InvManager);
	WP = GearPawn(P);

	if (InvManager != None && FindPickupAmmoTypes(P, AmmoTypes,, false))
	{
		P.PlaySound(SoundCue'Weapon_AssaultRifle.Weapons.GenericAmmoPickup01Cue');
		for (Idx = 0; Idx < AmmoTypes.Length; Idx++)
		{
			AmmoRng = GetNumMagsBasedOnAmmoType(AmmoTypes[Idx]);
			if (AmmoRng.Y > 0.0)
			{
				Amount = RandRange(AmmoRng.X,AmmoRng.Y);
				if (AmmoTypes[Idx].default.bRoundAmmoBoxClips)
				{
					// round to int as some weapons don't have partial clips
					Amount = Round(Amount);
				}
				if (AmmoTypes.length == 1)
				{
					// if this is the only ammo type we can get, make sure we get something
					Amount = Max(Amount, 1.0);
				}
				if (Amount > 0.0)
				{
					// bonus ammo on casual
					if (GearPRI(WP.PlayerReplicationInfo).Difficulty == class'DifficultySettings_Casual')
					{
						Amount *= 1.2;
					}
					bGaveAmmo = InvManager.AddAmmoFromAmmoType(AmmoTypes[Idx], Amount) || bGaveAmmo;
				}
			}
		}

		if (bGaveAmmo)
		{
			// @STATS - Ammo pickup (macro expanded because its a static function)
 			if(P.WorldInfo.Game != None && GearGame(P.WorldInfo.Game).GameplayEventsWriter != None && GearGame(P.WorldInfo.Game).GameplayEventsWriter.IsSessionInProgress())
 			{
 				GearGame(P.WorldInfo.Game).GameplayEventsWriter.LogPlayerIntEvent(`PlayerStatId(AMMOCRATE_PICKUP),P.Controller,1);
 			}
		}
	}
}

function UnHideAmmo()
{
	ClaimedBy = None;
	bForceNetUpdate = TRUE;
	SetHidden(FALSE);
}

/** This will return the NumMags based on ammo type **/
simulated static function Vector2D GetNumMagsBasedOnAmmoType(class<GearAmmoType> TheAmmoType, optional out int HordeCost)
{
	local int Index;
	local vector2D ZeroVector2D;

	Index = default.AmmoAmounts.Find('AmmoName', TheAmmoType.Name);
	if (Index != INDEX_NONE)
	{
		HordeCost = default.AmmoAmounts[Index].HordeCost;
		return default.AmmoAmounts[Index].NumMags;
	}
	else
	{
		return ZeroVector2D;
	}
}

simulated function bool RequiresPurchase()
{
	return (WorldInfo.GRI != None && ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameHorde_Base'));
}

simulated event string GetDebugAbbrev()
{
	return "APCase";
}

defaultproperties
{
	bBlockActors=false

	Components.Remove(Sprite)

	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		StaticMesh=StaticMesh'AmmoPickups.Mesh.Ammopickup_Box'
		bCastDynamicShadow=FALSE
		bOwnerNoSee=TRUE
		CollideActors=FALSE
		Scale=1.0
		Translation=(Z=-20)
		LightEnvironment=PickupLightEnvironment
	End Object
	PickupMesh=StaticMeshComponent0
	Components.Add(StaticMeshComponent0)

	PickupActionRequiresPurchase={(
				FontIndex=0,
			 	ActionName=WeaponPickupIcon,
			 	ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=176,V=314,UL=35,VL=64))), // Y Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=360,V=0,UL=58,VL=55))),
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=156,V=233,UL=34,VL=56)))	),
			)}

	Begin Object NAME=CollisionCylinder
		CollisionRadius=+00100.000000
	End Object
}
