/**
 * Boomshot for the Multi Turret
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_Boomshot_MultiTurret extends GearWeap_Boomshot;

/**
 * The boomshot turret must always fire from the muzzle
 * 
 * @param AimDir - what direction the player is aiming
 * 
 * @return the world space location that the firing should start from
 */
simulated event vector GetPhysicalFireStartLoc(optional vector AimDir)
{
	return GetMuzzleLoc();
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
	WeaponID=WC_MultiBoomshot
	WeaponStatName="MultiBoomshot"

	AIProjectileClass=class'GearProj_Boomshot_MultiTurret'
	WeaponProjectiles(0)=class'GearProj_Boomshot_MultiTurret'

	Begin Object Name=WeaponMesh
		bPerBoneMotionBlur=FALSE
	End Object

	FireSound=SoundCue'Weapon_MultiTurrets.BoomShot.MultiTurret_BoomShot_Enemy_Cue'
	FireSound_Player=SoundCue'Weapon_MultiTurrets.BoomShot.MultiTurret_BoomShot_Player_Cue'
	FireSound_Squad=SoundCue'Weapon_MultiTurrets.BoomShot.MultiTurret_BoomShot_Squad_Cue'

	FireCameraShake=None

	HUDDrawData			= (DisplayCount=3,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=257,UL=36,VL=8),ULPerAmmo=36)
	HUDDrawDataSuper	= (DisplayCount=3,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=257,UL=36,VL=8),ULPerAmmo=36)

	bForceProjectileSpawnFromMuzzle=TRUE
}