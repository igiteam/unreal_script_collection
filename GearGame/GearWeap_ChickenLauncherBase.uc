/**
 * Chicken Launcher
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_ChickenLauncherBase extends GearWeapon
	abstract
	config(Weapon);

/**
 * If we are shooting an successful ActiveReload projectile then use the default number of
 * bomblets (i.e. 6)  else we will spawn only 3.
 **/
simulated function Projectile ProjectileFire()
{
	local GearProj_ChickenBase PB;
	local GearPawn WP;

	PB = GearProj_ChickenBase(Super.ProjectileFire());
	if ( WorldInfo.NetMode == NM_Client )
	{
		return None;
	}

	WP = GearPawn(Instigator);

	// if not active reloaded then halve the number of bomblets
	if( (WP != None) && WP.bActiveReloadBonusActive )
	{
		PB.SetDrawScale(2.0f);
		PB.ExplosionTemplate.ExplosionEmitterScale *= 1.5f;
		PB.NumBombletsToSpawn = PB.NumBombletsToSpawnActiveReload;
		PB.Mesh.SetMaterial(0, PB.MegaChickenSkin);
	}

	return PB;
}


// Base Weapon version of this function just casts Animations to an AnimNodeSequence, but here it is
// an AnimTree, so we can have controls. So we dig into the tree and grab the only child.
simulated function AnimNodeSequence GetWeaponAnimNodeSeq()
{
	local SkeletalMeshComponent SkelMesh;
	local AnimNodeSequence AnimSeq;

	SkelMesh = SkeletalMeshComponent(Mesh);
	if ( SkelMesh!=none && SkelMesh.Animations!=none )
	{
		AnimSeq = AnimNodeSequence(AnimTree(SkelMesh.Animations).Children[0].Anim);
	}

	return AnimSeq;
}


/** notification fired from Pawn animation when clip is released from weapon. */
simulated function Notify_AmmoRelease()
{
	local SkeletalMeshComponent	SkelMesh;
	local Vector				MagLoc;
	local Rotator				MagRot;

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
	// Skip on dedicated servers, below is just cosmetic
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	// aborted, ignore
	if ( CurrentFireMode != RELOAD_FIREMODE )
	{
		return;
	}

	// Attach magazine mesh to left hand
	SetPawnAmmoAttachment(TRUE);
}

simulated function GearKActorSpawnableEffect SpawnPhysicsMagazine(Vector SpawnLoc, Rotator SpawnRot)
{
	return None;
}


/** notification fired from Pawn animation when player puts new magazine in weapon. */
simulated function Notify_AmmoReload()
{
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

function class<Projectile> GetProjectileClass()
{
	return WeaponProjectiles[0];
}

function OverrideAIAimRotation(out rotator DesiredAimRot, vector StartFireLoc, vector AimLoc)
{
	local class<GearProjectile> ProjClass;
	local class<GearProj_ChickenBase> ChickenProjClass;
	local vector TossVelocity;
	local float ProjSpeed;

	// GravityScale * 0.5 because SuggestTossVelocity() assumes we are using PHYS_Falling, which has double gravity
	// but we actually are using PHYS_Projectile with Acceleration manually set to the desired gravity
	ProjClass = class<GearProjectile>(GetProjectileClass());
	ChickenProjClass = class<GearProj_ChickenBase>(ProjClass);
	ProjSpeed = (ChickenProjClass != None) ? ChickenProjClass.default.RocketLaunchSpeed : ProjClass.default.Speed;
	Instigator.SuggestTossVelocity(TossVelocity, AimLoc, StartFireLoc, ProjSpeed,, 0.2,,, Instigator.PhysicsVolume.GetGravityZ() * ProjClass.default.GravityScale * 0.5);

	DesiredAimRot.Pitch = rotator(TossVelocity).Pitch;
}

function int GetBurstsToFire()
{
	return 1;
}


simulated function float GetWeaponRating()
{
	local float Rating;
	local GearAI AI;

	Rating = Super.GetWeaponRating();

	// avoid trying to shoot flying enemies with it as the splash won't do much in that case
	AI = GearAI(GetWeaponController());
	if (AI != None && AI.Enemy != None && AI.Enemy.Physics == PHYS_Flying)
	{
		Rating -= 0.75;
	}

	return Rating;
}

defaultproperties
{
	WeaponStatName="Boomshot"

	AIRating=1.5
	bWeaponCanBeReloaded=TRUE
	bAutoSwitchWhenOutOfAmmo=FALSE
	bIsSuppressive=false
	bRecommendSplashDamage=true

	WeaponFireAnim="AR_Fire_Boomshot"
	WeaponReloadAnim="AR_Reload"
	WeaponReloadAnimFail="AR_Reload_Fail"

	BS_PawnWeaponReload={(Stance=((Slot=BS_Layer1,AnimName="ADD_Boomshot_Reload"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Boomshot_Cov_Mid_Reload"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Boomshot_Cov_Std_Reload"))
		)}

	BS_PawnWeaponReloadFail={(Stance=((Slot=BS_Layer1,AnimName="ADD_Boomshot_Reload_Fail"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_Boomshot_Cov_Mid_Reload_Fail"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_Boomshot_Cov_Std_Reload_Fail"))
		)}

	// Weapon Mesh Transform
	Begin Object Name=WeaponMesh
	End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh

	FireOffset=(X=68,Y=0,Z=9)

	LC_EmisDefaultCOG=(R=0.5,G=3.0,B=20.0,A=1.0)
	LC_EmisDefaultLocust=(R=30.0,G=5.0,B=3.0,A=1.0)

	Recoil_Hand={(
				LocAmplitude=(X=-8,Y=2,Z=-4),
				LocFrequency=(X=15,Y=10,Z=10),
				LocParams=(X=ERS_Zero,Y=ERS_Zero,Z=ERS_Zero),
				RotAmplitude=(X=3000,Y=300,Z=0),
				RotFrequency=(X=10,Y=10,Z=0),
				RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
				TimeDuration=0.67f
				)}

	Recoil_Spine={(
				RotAmplitude=(X=2500,Y=200,Z=0),
				RotFrequency=(X=10,Y=10,Z=0),
				RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
				TimeDuration=0.67f
				)}


	WeaponID=WC_Boomshot
	bCanNegateMeatShield=true
	bIgnoresExecutionRules=true
	bLeadTarget=true
}
