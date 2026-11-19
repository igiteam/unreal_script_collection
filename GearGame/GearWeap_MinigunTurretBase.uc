/**
 * Minigun turret base class
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_MinigunTurretBase extends GearWeap_TroikaBase
	config(Weapon)
	abstract;

/** How long the weapon has been firing. */
var protected transient float StartedFiringTime;

/**
 * Record the time we started firing
 * 
 * @param FiringMode - the current firing mode
 * 
 * @param HitLocation - where the last shot hit
 */
simulated function WeaponFired(byte FiringMode, optional vector HitLocation)
{
	if (FireLoopAC == None)
	{
		// just started firing, audio hasn't kicked in yet
		StartedFiringTime = WorldInfo.TimeSeconds;
	}
	super.WeaponFired(FiringMode, HitLocation);
}

/**
 * Play the reloading particles if we've been firing for 2 seconds
 * 
 * @param FiringMode - the current firing mode
 */
simulated function WeaponStoppedFiring(byte FiringMode)
{
	super.WeaponStoppedFiring(FiringMode);

	if ( (WorldInfo.TimeSeconds - StartedFiringTime) > 2.f )
	{
		PSC_Reloading.ActivateSystem(TRUE);
	}
}
