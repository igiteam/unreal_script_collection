/**
 * Lancer on the multiturret, needed to pump ammo through the multiturret
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_AssaultRifle_MultiTurret extends GearWeap_AssaultRifle;

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
	WeaponID=WC_MultiLancer
	WeaponStatName="MultiLancer"

	FireSound=None
	FireSound_Player=None
	FireSound_Squad=None

	StopFireSound=None
	StopFireSound_Player=None
	StopFireSound_Squad=None

	Begin Object Name=WeaponMesh
		bPerBoneMotionBlur=FALSE
	End Object

	TracerType=WTT_MultiTurret_Lancer
	TracerTypeAR=WTT_MultiTurret_Lancer

	NoAmmoFireSoundDelay=0
	InstantHitDamageTypes[0]=class'GDT_AssaultRifle_MultiTurret'

	bIsScopeWeapon=FALSE
}
