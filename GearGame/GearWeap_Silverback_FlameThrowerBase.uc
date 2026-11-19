
/**
 * GearWeap_Silverback_FlameThrowerBase
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_Silverback_FlameThrowerBase extends GearWeap_FlameThrowerBase
	abstract;

/** Allow this gun to overheat with the Silverback */
var protected transient bool		bOverheated;

/** Attach to the Silverback as soon as we spawn */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
		
	AttachToSilverback();
}

/** Instigator may not have replicated yet, repeat until he shows up */
simulated function AttachToSilverback()
{
	local GearPawn  GP;

	if (Instigator == none)
	{
		SetTimer(0.2f, FALSE, nameof(AttachToSilverback));
	}
	else
	{
		GP = GearPawn(Instigator);
		if (GP != none)
		{
			AttachWeaponTo(GP.Mesh, GetDefaultHandSocketName(GP));
		}
	}
}

/** Clients don't always properly activate the weapon, make sure the pilot light is on */
simulated protected function TurnOnFireSpray()
{
	TurnOnPilot();

	Super.TurnOnFireSpray();
}

/** Block this weapon from firing if the SilverBack has overheated */
simulated function BeginFire(byte FireModeNum)
{
	if (!bOverheated)
	{
		Super.BeginFire(FireModeNum);
	}
}

/** The Silverback has overheated, stop firing */
simulated function ForceOverheat()
{
	local float SavedMinFireDuration;
	
	bOverheated = true;

	SavedMinFireDuration = MinFireDuration;
	MinFireDuration = 0.0;
	ForceEndFire();
	MinFireDuration = SavedMinFireDuration;
}

/** Silverback has notified us that the overheat is clear */
simulated function ClearOverheat()
{
	bOverheated = false;
}

/** 
 * Give the HUD our heat bar progress 
 *
 * @return the percentage of the heat bar the UI should fill
 */
simulated function float GetCurrentBarrelHeat()
{
	return GearPawn_SilverbackArmedBase(Instigator).CurrentBarrelHeat;
}

/** 
 * Tell the HUD to draw a heat bar 
 *
 * @return true to tell the UI we need a heat bar
 */
simulated function bool IsHeatLimited()
{
	return true;
}

/** Block the inactive state so we simplify clients staying in sync with the server */
simulated state Inactive
{
	simulated function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		GotoState('WeaponEquipping');
	}
}

/** There is no equip animation for this weapon */
simulated function PlayEquipAnimation(float BlendInTime);

/** There is no holster animation for this weapon */
simulated function PlayHolsterAnimation();

defaultproperties
{
	bOnlyRelevantToOwner=FALSE
}
