/**
 * Shotgun on the multiturret, needed to pump ammo through the multiturret
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_Shotgun_MultiTurret extends GearWeap_Shotgun;

/**
 * Pipe ammo consumption through to the multiturret
 *
 * @param FireModeNum - the current fire mode
 */
simulated function ConsumeAmmo(byte FireModeNum)
{
	local Turret_MultiTurretBase MT;

	MT = Turret_MultiTurretBase(Instigator);
	if (MT != None)
	{
		MT.ConsumeAmmo(FireModeNum);
	}
}

/**
 * Whether there's ammo to fire
 *
 * @param FireModeNum - the current fire mode
 *
 * @param Amount - how much ammo we want to verify that we have
 *
 * @return TRUE if we have enough loaded ammo to satisfy the request
 */
simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
	local Turret_MultiTurretBase MT;

	MT = Turret_MultiTurretBase(Instigator);
	if (MT != None)
	{
		return MT.HasAmmo(FireModeNum, Amount);
	}

	return FALSE;
}

/**
 * Whether we should refire, based on turret's firing state
 */ 
simulated function bool ShouldRefire()
{
	local Turret_MultiTurretBase MT;

	MT = Turret_MultiTurretBase(Instigator);
	if (MT != None && !MT.ShouldRefire(self))
	{
		return false;
	}

	return Super.ShouldRefire();
}

defaultproperties
{
	WeaponID=WC_MultiGnasher
	WeaponStatName="MultiGnasher"

	Begin Object Name=WeaponMesh
		bPerBoneMotionBlur=FALSE
	End Object

	InstantHitDamageTypes[0]=class'GDT_Shotgun_MultiTurret'
}
