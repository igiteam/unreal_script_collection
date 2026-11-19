
/**
 * Hammer of Dawn marker
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_TempestHODBase extends GearWeap_HODBase
	abstract;

/** Rate of the regen */
var config float RegenRate;


simulated state Inactive
{
	simulated function Tick(float DeltaTime)
	{
		UpdateHODBattery(DeltaTime);
		super.Tick(DeltaTime);
	}
};

simulated function Tick(float DeltaTime)
{
	UpdateHODBattery(DeltaTime);
	super.Tick(DeltaTime);
}

/** Updates the batter of the HOD */
simulated function UpdateHODBattery(float DeltaTime)
{
	if (!bTargetingBeamFiring)
	{
		if (WorldInfo.NetMode != NM_Client)
		{
			BatteryLifeSec += DeltaTime * RegenRate;
		}
	}
}

simulated function bool HasAmmo( byte FireModeNum, optional int Amount )
{
	if (bTargetingBeamFiring)
	{
		return ( (BatteryLifeSec > 0.f) || (FireModeNum == MELEE_ATTACK_FIREMODE) );
	}
	else
	{
		return (BatteryLifeSec >= default.BatteryLifeSec);
	}
}

/** Whether we are low enough on ammo to display a red bar in the HUD */
simulated function bool HasLowAmmoForRedUI()
{
	return (BatteryLifeSec < default.BatteryLifeSec && !bTargetingBeamFiring);
}

defaultproperties
{
}
