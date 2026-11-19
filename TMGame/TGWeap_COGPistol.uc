/**
 * COG MX-8 "Snub" Pistol
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class TGWeap_COGPistol extends TGWeap_PistolBase;

/** range of multiplier for MP AI firing speed to simulate the slowdown from having to press the button for each shot */
var config vector2D MPAI_RateOfFire_Scale;

simulated function float GetRateOfFire()
{
	local float Result;

	Result = Super.GetRateOfFire();
	if (TGAI_TDM(TGAIController) != None)
	{
		Result *= RandRange(MPAI_RateOfFire_Scale.X, MPAI_RateOfFire_Scale.Y);
	}
	return Result;
}

/**
 * State WeaponFiring
 * Fires a bullet at a time
 */

simulated state WeaponFiring
{
	/** @see TGWeapon::ShouldRefire() */
	simulated function bool ShouldRefire()
	{
		// For Players: in single fire mode, it is not possible to refire. You have to release and re-press fire to shot every time
		if( Instigator != None && Instigator.IsHumanControlled() )
		{
			EndFire( CurrentFireMode );
			Instigator.Controller.bFire = 0;

			return FALSE;
		}

		return Global.ShouldRefire();
	}

	simulated function EndState( Name NextStateName )
	{
		// do not clear flash location. Because rate of fire is too small, and weapon is release to refire. replication sometimes fail to happen.
		//ClearFlashCount();
		DelayedWeaponStoppedFiring();
		ClearTimer('RefireCheckTimer');
	}
}


/**
 * ROF is very high, so on low frame rates, server can't send FlashLocation fast enough, it is reset to 0 when weapon stops firing.
 * Same problem can happen on clients who receive the packets in the same tick. Weapon will be fired and stopped at the same time.
 * So we just replicate the shot, and stop the weapon in GetFireInterval(FireModeNum) for remote clients.
 * ClearFlashCount() is not called at all to avoid resetting the location.
 */

simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{
	if( FireModeNum == 0 && bSlaveWeapon )
	{
		SetTimer( GetFireInterval(FireModeNum), false, nameof(DelayedWeaponStoppedFiring) );
	}

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		// decrease animation play rate. ROF is fast, don't make anim ridiculously fast as well.
		PlayWeaponAnimByDuration(WeaponFireAnim, GetFireInterval(FireModeNum)/FireAnimRateScale);
	}

	super.PlayFireEffects(FireModeNum, HitLocation);
}

simulated function DelayedWeaponStoppedFiring()
{
	WeaponStoppedFiring( Instigator.FiringMode );
	//Instigator.WeaponStoppedFiring( bSlaveWeapon );
}


simulated function PlayWeaponReloading()
{
	ClearTimer('DelayedWeaponStoppedFiring');
	super.PlayWeaponReloading();
}

simulated function EjectClip()
{
//	WeaponPlaySound(SoundCue'Weapon_Pistol.Reloads.CogPistolClipEjectCue');
}
simulated function CockOpen()
{
//	WeaponPlaySound(SoundCue'Weapon_Pistol.Reloads.CogPistolCockOpenCue');
}
simulated function CockClose()
{
//	WeaponPlaySound(SoundCue'Weapon_Pistol.Reloads.CogPistolCockCloseCue');
}

simulated function InsertClip()
{
//	WeaponPlaySound(SoundCue'Weapon_Pistol.Reloads.CogPistolClipReloadInsertCue');
}

simulated function Jammed()
{
//	WeaponPlaySound(SoundCue'Weapon_Pistol.Actions.CogPistolDropCue');
}

simulated function HandSlam()
{
	WeaponPlaySound(SoundCue'Weapon_AssaultRifle.Reloads.CogRifleJammedHandCue');
}
simulated function ClipImpact()
{
//	WeaponPlaySound(SoundCue'Weapon_Pistol.Reloads.CogPistolClipEjectImpactCue');
}

/*
simulated function LinearColor GetWeaponEmisColor_COG()
{
	return WorldInfo.TMs_COGWeapons.COGPistol;
}

simulated function LinearColor GetWeaponEmisColor_Locust()
{
	return WorldInfo.TMs_LocustWeapons.COGPistol;
}
*/


// Base Weapon version of this function just casts Animations to an AnimNodeSequence, but here it is
// an AnimTree, so we can have controls. So we dig into the tree and grab the only child.
simulated function AnimNodeSequence GetWeaponAnimNodeSeq()
{
	local SkeletalMeshComponent SkelMesh;
	local AnimNodeSequence AnimSeq;

	SkelMesh = SkeletalMeshComponent(Mesh);
	AnimSeq = AnimNodeSequence(AnimTree(SkelMesh.Animations).Children[0].Anim);
	return AnimSeq;
}


/** notification fired from Pawn animation when clip is released from weapon. */
simulated function Notify_AmmoRelease()
{
	local SkeletalMeshComponent	SkelMesh;
	local Vector				MagLoc;
	local Rotator				MagRot;

	//`log( self @ 'Notify_AmmoRelease' );

	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Hide Ammo part on weapon mesh
	SetWeaponAmmoBoneDisplay( FALSE );

	// Spawn physics magazine instead
	SkelMesh = SkeletalMeshComponent(Mesh);
	SkelMesh.GetSocketWorldLocationAndRotation('Magazine', MagLoc, MagRot);

	// Spawn physics Magazine
	SpawnPhysicsMagazine(MagLoc, MagRot);
}


/** notification fired from Pawn animation when player grabs another magazine. */
simulated function Notify_AmmoGrab()
{
	//`log( self @ 'Notify_AmmoGrab' );

	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Attach magazine mesh to left hand
	SetPawnAmmoAttachment(TRUE);
}

/** notification fired from Pawn animation when player puts new magazine in weapon. */
simulated function Notify_AmmoReload()
{
	//`log( self @ 'Notify_AmmoReload' );

	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Detach magazine mesh from instigator's left
	SetPawnAmmoAttachment(FALSE);

	// Show Ammo part on weapon mesh.
	SetWeaponAmmoBoneDisplay(TRUE);
}

