/**
 * Hammerburst on the multiturret, needed to pump ammo through the multiturret
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_LocustAssaultRifle_MultiTurret extends GearWeap_LocustAssaultRifle;

/** Save a reference to the fire loop */
var AudioComponent FireLoopAC;

/** Handle the fire loop */
simulated protected function PlayFireSound()
{
	if (FireLoopAC == None || !FireLoopAC.IsPlaying())
	{
		// start loop
		FireLoopAC = GearWeaponPlaySoundLocalEx(FireSound, FireSound_Player, FireSound_Squad, FireLoopAC);
		if (FireLoopAC != None)
		{
			FireLoopAC.bStopWhenOwnerDestroyed = TRUE;
		}
	}

	// Maybe alert AI of the noise
	if (WorldInfo.Netmode != NM_Client && Instigator != None)
	{
		Instigator.MakeNoise(1.f, 'PlayFireSound');
	}
}

/**
 * Stop the looping fire sound
 * 
 * @param FireModeNum - the current fire mode
 */
simulated function StopFireEffects(byte FireModeNum)
{
	super.StopFireEffects(FireModeNum);

	if (FireModeNum == 0)
	{
		StopFireLoopingAudio();
	}
}

/** Stop the fire loop and play the stop fire sound */
simulated protected function StopFireLoopingAudio()
{
	if (FireLoopAC != None)
	{
		FireLoopAC.FadeOut(0.1f, 0.f);
		FireLoopAC = None;
		
		if (IsFiring() || (bSlaveWeapon && !IsInState('WeaponEquipping')))
		{
			GearWeaponPlaySoundLocal(StopFireSound, StopFireSound_Player, StopFireSound_Squad);
		}
	}
}

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
	WeaponID=WC_MultiHammerburst
	WeaponStatName="MultiHammerburst"

	FireSound=None
	FireSound_Player=None
	FireSound_Squad=None

	Begin Object Name=WeaponMesh
		bPerBoneMotionBlur=FALSE
	End Object

	TracerType=WTT_MultiTurret_Hammerburst
	TracerTypeAR=WTT_MultiTurret_Hammerburst

	InstantHitDamageTypes[0]=class'GDT_LocustAssaultRifle_MultiTurret'

	bIsScopeWeapon=FALSE
}
