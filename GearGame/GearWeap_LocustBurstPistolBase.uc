/**
 * Locust Burst pistol
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_LocustBurstPistolBase extends GearWeap_PistolBase
	abstract
	config(Weapon);

//The ready sound needs to start playing before the pistol is actually ready. This variable represents how much earlier.
var() protected const config float	ReadySoundOffset;

/** Counter for burst shots */
var protected transient	byte		BurstCount;

var protected transient	bool		bWasTargeting;

/** Audiocomponent for looping firing sound. */
var protected AudioComponent	FireLoopAC;

var StaticMeshComponent	MagazineMesh2;

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

simulated function StopFireEffects(byte FireModeNum)
{
	super.StopFireEffects(FireModeNum);

	if (FireModeNum == 0)
	{
		StopFireLoopingAudio();
	}
}

simulated protected function StopFireLoopingAudio()
{
	if (FireLoopAC != None)
	{
		FireLoopAC.FadeOut(0.1f, 0.f);
		FireLoopAC = None;
	}

	if (IsFiring() || (bSlaveWeapon && !IsInState('WeaponEquipping')))
	{
		GearWeaponPlaySoundLocal(StopFireSound, StopFireSound_Player, StopFireSound_Squad);
	}
}

simulated function bool CanReload()
{
	local GearPawn_LocustKantusBase KantusPawn;

	KantusPawn = GearPawn_LocustKantusBase(Instigator);
	// Small hack, prevent Kantus from reloading his weapon if he's throwing a grenade.
	if( KantusPawn != None && KantusPawn.IsThrowingOffHandGrenade() )
	{
		return FALSE;
	}

	return Super.CanReload();
}

simulated function PlayWeaponReloading()
{
	Super.PlayWeaponReloading();

	if (!ShouldPlaySimplePistolReload())
	{
		// so here we need to set a timer as a hack to make certain our clips are scaled to zero as there
		// is some crazy animation bug where they do not correctly get their notifies
		// so even tho the clips will not show up on the weapon at least they will not be floating in the air all crazy like
		// the failed reload is 4 seconds long.  So we wait 400 ms to make certain a tick has occurred and then if this timer
		// has not been cleared by the actual anim notify firing we will scale the magazines to zero
		SetTimer( 4.4f, FALSE, nameof(ForceScaleMagazinesToZero) );
	}
}

simulated function ForceScaleMagazinesToZero()
{
	SetWeaponAmmoBoneDisplay( FALSE, 'AmmoControlLeft' );
	SetWeaponAmmoBoneDisplay( FALSE, 'AmmoControlRight' );

//	`log( "ForceScaleMagazinesToZeroForceScaleMagazinesToZeroForceScaleMagazinesToZeroForceScaleMagazinesToZero" );
}

/** notification fired from Pawn animation when clip is released from weapon. */
simulated function Notify_AmmoRelease()
{
	local SkeletalMeshComponent	SkelMesh;
	local Vector				MagLoc;
	local Rotator				MagRot;

	if( ShouldPlaySimplePistolReload() )
	{
		return;
	}

	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Hide Ammo part on weapon mesh
	SetWeaponAmmoBoneDisplay(FALSE, 'AmmoControlLeft');

	// Spawn physics magazine instead
	SkelMesh = SkeletalMeshComponent(Mesh);
	SkelMesh.GetSocketWorldLocationAndRotation('MagazineLeft', MagLoc, MagRot);

	// Spawn physics Magazine
	SpawnPhysicsMagazine(MagLoc, MagRot);

	ClearTimer( nameof(ForceScaleMagazinesToZero) );
}

/** notification fired from Pawn animation when clip is released from weapon. */
simulated function Notify_AmmoRelease2()
{
	local SkeletalMeshComponent	SkelMesh;
	local Vector				MagLoc;
	local Rotator				MagRot;

	if( ShouldPlaySimplePistolReload() )
	{
		return;
	}

	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Hide Ammo part on weapon mesh
	SetWeaponAmmoBoneDisplay(FALSE, 'AmmoControlRight');

	// Spawn physics magazine instead
	SkelMesh = SkeletalMeshComponent(Mesh);
	SkelMesh.GetSocketWorldLocationAndRotation('MagazineRight', MagLoc, MagRot);

	// Spawn physics Magazine
	SpawnPhysicsMagazine(MagLoc, MagRot);

	ClearTimer( nameof(ForceScaleMagazinesToZero) );
}

/** notification fired from Pawn animation when player grabs another magazine. */
simulated function Notify_AmmoGrab()
{
	if( ShouldPlaySimplePistolReload() )
	{
		return;
	}

	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Attach magazine mesh to left hand
	SetPawnAmmoAttachment(TRUE,,, Rot(0,0,32768));

	// Attach magazine mesh to left hand
	SetPawnAmmoAttachment(TRUE, MagazineMesh2, 'b_MF_Weapon_L');
}

simulated function UpdateMagazineDueToMirror(GearPawn P)
{
	// If player happened to be in the middle of a weapon reload animation
	// handle case where clip was attached to left hand
	if( MagazineMesh != None && P.Mesh != None && P.Mesh.IsComponentAttached(MagazineMesh) )
	{
		SetPawnAmmoAttachment(FALSE);
		SetPawnAmmoAttachment(TRUE,,, Rot(0,0,32768));
	}
	if( MagazineMesh2 != None && P.Mesh != None && P.Mesh.IsComponentAttached(MagazineMesh2) )
	{
		SetPawnAmmoAttachment(FALSE, MagazineMesh2);
		SetPawnAmmoAttachment(TRUE, MagazineMesh2, 'b_MF_Weapon_L');
	}
}

/** notification fired from Pawn animation when player puts new magazine in weapon. */
simulated function Notify_AmmoReload()
{
	if( ShouldPlaySimplePistolReload() )
	{
		return;
	}

	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Detach magazine mesh from instigator's left
	SetPawnAmmoAttachment(FALSE);

	// Show Ammo part on weapon mesh.
	SetWeaponAmmoBoneDisplay(TRUE, 'AmmoControlLeft');
}

/** notification fired from Pawn animation when player puts new magazine in weapon. */
simulated function Notify_AmmoReload2()
{
	if( ShouldPlaySimplePistolReload() )
	{
		return;
	}

	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// Detach magazine mesh from instigator's left
	SetPawnAmmoAttachment(FALSE, MagazineMesh2);

	// Show Ammo part on weapon mesh.
	SetWeaponAmmoBoneDisplay(TRUE, 'AmmoControlRight');
}


defaultproperties
{
	WeaponStatName="Gorgon"

	AIRating=1.f

//	FireAnimRateScale=2.5

	bWeaponCanBeReloaded=TRUE

	InstantHitDamageTypes(0)=class'GDT_LocustBurstPistol'
	AmmoTypeClass=class'GearAmmoType_LocustBurstPistol'

	NoAmmoFireSoundDelay=0.25f

	// Weapon Mesh
	Begin Object Name=WeaponMesh
	End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh

	WeaponFireAnim=""
	WeaponReloadAnim="BP_Reload"
	WeaponReloadAnimFail="BP_Reload_Fail"

	// reload barrel smoke
	Begin Object Name=PSC_WeaponReloadBarrelSmokeComp
		Template=ParticleSystem'Locust_Pistol.EffectS.P_Geist_Pistol_Smoke'
	End Object
	PSC_ReloadBarrelSmoke=PSC_WeaponReloadBarrelSmokeComp

	Recoil_Hand={(
		LocAmplitude=(X=-15,Y=0,Z=0),
		LocFrequency=(X=8,Y=20,Z=15),
		LocParams=(X=ERS_Zero,Y=ERS_Random,Y=ERS_Random),
		RotAmplitude=(X=5000,Y=200,Z=0),
		RotFrequency=(X=8,Y=20,Z=8),
		RotParams=(X=ERS_Zero,Y=ERS_Random,Y=ERS_Zero),
		TimeDuration=0.17f,
	)}

	Recoil_Spine={(
		RotAmplitude=(X=800,Y=0,Z=0),
		RotFrequency=(X=13,Y=10,Z=0),
		RotParams=(X=ERS_Zero,Y=ERS_Random,Y=ERS_Zero),
		TimeDuration=0.27f,
	)}

	bInstantHit=TRUE
	bIsSuppressive=true

	NeedReloadNotifyThreshold=2

	LC_EmisDefaultCOG=(R=0.0,G=2.0,B=25.0,A=1.0)
	LC_EmisDefaultLocust=(R=15.0,G=2.0,B=0.0,A=1.0)

	WeaponID=WC_LocustBurstPistol

	BS_PawnWeaponReload={(Stance=((Slot=BS_Layer1,AnimName="ADD_Burst_Reload"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Burst_Cov_Mid_Reload"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Burst_Cov_Std_Reload"))
		)}

	BS_PawnWeaponReloadFail={(Stance=((Slot=BS_Layer1,AnimName="ADD_Burst_Reload_Fail"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Burst_Cov_Mid_Reload_Fail"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Burst_Cov_Std_Reload_Fail"))
		)}

	MuzzleFlashArchetype=GearMuzzleFlash'GearMuzzleFlashes.GearWeap_LocustBurstPistolBase_MuzFlash'

	bAllowTracers=TRUE
	TracerType=WTT_Gorgon
	TracerTypeAR=WTT_Gorgon_AR

	// CQC Long Executions
	LongExecutions(3)={(CQC_Long_KillerAnim="CTRL_BurstPistol",
						CQC_Long_KillerAnim_Loop="",
						CQC_Long_KillerAnim_End="",
						CQC_Long_VictimAnim="DBNO_BurstPistol",
						CQC_Long_VictimAnim_Loop="",
						CQC_Long_VictimAnim_End="",
						CQC_Long_bHolsterWeapon=FALSE,
						CQC_Long_VictimDeathTime=2.f,
						CQC_Long_VictimRotStartTime=0.f,
						CQC_Long_VictimRotInterpSpeed=8.f,
						CQC_Long_CameraAnims=(CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_BurstPistol_Cam01',CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_BurstPistol_Cam02',CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_BurstPistol_Cam03'),
						CQC_Long_DamageType=class'GDT_LongExecution_BurstPistol',
						CQC_Long_EffortID=GearEffort_None,
						MarkerRelOffset=(X=85.670,Y=33.657,Z=0),
						CameraLensEffect=class'Emit_CameraBlood_LongExecution_BurstPistol',
						AwardRequired="GorgonExecution")}
}
