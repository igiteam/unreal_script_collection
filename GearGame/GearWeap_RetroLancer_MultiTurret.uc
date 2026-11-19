/**
 * Retro lancer on the multiturret, needed to pump ammo through the multiturret
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_RetroLancer_MultiTurret extends GearWeap_RetroLancer;

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

defaultproperties
{
	WeaponID=WC_MultiRetro
	WeaponStatName="MultiRetro"

	FireSound=None
	FireSound_Player=None
	FireSound_Squad=None

	StopFireSound=None
	StopFireSound_Player=None
	StopFireSound_Squad=None

	Begin Object Name=WeaponMesh
		bPerBoneMotionBlur=FALSE
	End Object

	TracerType=WTT_MultiTurret_RetroLancer
	TracerTypeAR=WTT_MultiTurret_RetroLancer

	InstantHitDamageTypes[0]=class'GDT_RetroLancer_MultiTurret'

	bIsScopeWeapon=FALSE
}
