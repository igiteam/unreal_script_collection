/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_MP7 extends NanoWeapon
	native(inherit);

/** Sound cue to play when NPC finishes firing  */
var() SoundCue  EndFireSound;
/** Sound cue to play when the player finishes firing */
var() SoundCue  EndFireSound_Player;

var bool bFireSoundIsLooping;

var transient AudioComponent FireLoop_AC;
var transient float LastPlayFireWeapon;


var transient NanoInterface_Targetable GunTarget;

// values that should prob be all moved up to nanoweaponbase but don't want to break things up there

/** AI Accuracy cone - by range */
var(AI)	config Vector2d AI_AccCone_Min;
var(AI)	config Vector2d AI_AccCone_Max;
var(AI) config float AI_RateOfFire_Scale;

var() const config float WeaponRateOfFire;

var() const config int MaxShotsThatCanBeFiredAtOnce;
var() const config int MinShotsToBeFiredAtOnce;
var transient protected int CurrShotsThatHaveBeenFiredInARow;
var transient byte DelayedFireMode;
var transient bool bDelayedBeginFire;

/** we want every other bullet to fire a tracer. **/
var transient bool bShouldSpawnTracer;

/** 
 *  This is how long the nano regen will take to start regenning after a reload. 
 *  You need something like as otherwise people can just unload bullet after bullet and never really
 *  run out of nano juice as the regen rate is fast and creates more juice than the cost of a reload.
 *  So you can shoot forever withtout this.
 **/
var config float NanoRegenDelayInSeconds;

var() transient vector2d	DesiredAim;

simulated event Rotator GetAimRotation( Rotator AimRotation )
{
	local vector HitL, HitN, CamLoc;
	local rotator CamRot;
	local NanoPawn NP;


 	if( !Instigator.IsLocallyControlled() )
 	{
 		AimRotation = NanoPawn(Instigator).GetReplicatedAim();
 	}
//	else if (!Instigator.IsHumanControlled())
//	{
//		AimRotation = Instigator.Controller.Rotation;
//	}
// 	else if( GunTarget != None )
// 	{
// 		AimRotation = Rotator(GunTarget.GetTargetedLocation()-Instigator.Location);
// 		// hard-coded offset to get the gun lined up with the shots a bit better
// 		AimRotation.Pitch -= 1024.f;
// 	}
	else
	{
		Instigator.GetActorEyesViewpoint(CamLoc,CamRot);
		//DrawDebugLine(CamLoc, (CamLoc + vector(CamRot) * 5000.f), 255, 0, 0, TRUE);

		if ((Trace(HitL,HitN,CamLoc + vector(CamRot) * 5000.f,CamLoc,TRUE,,,TRACEFLAG_Bullet) != None) && (HitL != CamLoc))
		{
			AimRotation = rotator(HitL - CamLoc);
		}
		else
		{
			AimRotation = CamRot;
		}

		//AimRotation = Instigator.Controller.Rotation;
		//DrawDebugLine(Instigator.Location, (Instigator.Location + vector(AimRotation) * 5000.f), 255, 0, 0, TRUE);
	}

	NP = NanoPawn(Instigator);

	//`log( `showvar(NP) @ `showvar(NP.HandGunAimOffset) );

	// so based off this we are going to move the gun in some direction
	if( ( NP != None ) && ( NP.HandGunAimOffset != None ) )
	{
		//`log( self @ "updating HandGunAimOffset" @ `showvar(AimRotation.Yaw) @ `showvar(NormalizeRotAxis(NP.Rotation.Yaw - AimRotation.Yaw)/16384.0f) @ `showvar(NormalizeRotAxis(AimRotation.Pitch)/16384.0f) );
		//ScriptTrace();

		NP.HandGunAimOffset.Aim.X = FInterpTo( NP.HandGunAimOffset.Aim.X, FClamp( NormalizeRotAxis(NP.Rotation.Yaw - AimRotation.Yaw)/16384.0f, -1.0f, 1.0f), 0.01, 10 );
		NP.HandGunAimOffset.Aim.Y = FInterpTo( NP.HandGunAimOffset.Aim.Y, FClamp( NormalizeRotAxis(AimRotation.Pitch)/16384.0f, -1.0f, 1.0f), 0.01, 10 );
	}




	return AimRotation;
}

/** Accessor for native functions, to save an interface cast and making the targetable interface native */
event vector GetGunTargetLocation()
{
	if( GunTarget != None )
	{
		return GunTarget.GetTargetedLocation();
	}

	return vect(0,0,0);
}

/** we are overriding this function to allow for num of shots per second type specification */
simulated function float GetFireInterval( byte FireModeNum )
{
	return 60.f / GetRateOfFire();
}


/** returns rate of fire of weapon*/
simulated function float GetRateOfFire()
{
	local float RetVal;

	RetVal = WeaponRateOfFire;

	if (Instigator != None)
	{
		if( Instigator.IsHumanControlled() )
		{
			// no rate of fire change
		}
		else
		{
			// scale for AI
			RetVal *= AI_RateOfFire_Scale;
		}
	}

	return RetVal;
}

simulated function FireAmmunition()
{
	++CurrShotsThatHaveBeenFiredInARow;
	Super.FireAmmunition();

	if (TRUE)// || `TimeSince(LastPlayFireWeapon) > 0.33f)
	{
		//'ADD_SMG_Idle_Ready_Aim_Recoil'
		NanoPawn(Instigator).PlayGunAdditiveAnim('ADD_SMG_Idle_Fire',1.f,0.001f);
		LastPlayFireWeapon = WorldInfo.TimeSeconds;
	}
}


/** return true if should spawn tracer effect for instant trace hits */
simulated function bool ShouldSpawnTracerFX()
{
	if( ( Super.ShouldSpawnTracerFX() == TRUE )
		&& ( bShouldSpawnTracer == TRUE )
		)
	{
		bShouldSpawnTracer = !bShouldSpawnTracer;
		return TRUE;
	}

	bShouldSpawnTracer = !bShouldSpawnTracer;
	return FALSE;
}


function BurstFireCooldown();

simulated state Active
{
	simulated function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		CurrShotsThatHaveBeenFiredInARow = 0;

		if (Instigator != None && Instigator.IsLocallyControlled())
		{
			//SetTimer(0.25f,FALSE,nameof(TryToPickTarget));
		}
	}

	simulated function BeginFire(byte FireModeNum)
	{
		if (!IsTimerActive(nameof(BurstFireCooldown)) || FireModeNum == RELOAD_FIREMODE)
		{
			Super.BeginFire(FireModeNum);
		}
		else
		{
			// queue up the firing
			bDelayedBeginFire = TRUE;
			DelayedFireMode = FireModeNum;
		}
	}

	function BurstFireCooldown()
	{
		if (bDelayedBeginFire)
		{
			bDelayedBeginFire = FALSE;
			BeginFire(DelayedFireMode);
		}
	}
}


/**
* Returns true if weapon can potentially be reloaded
*
* @return	true if weapon can be reloaded
*/
simulated function bool CanReload()
{
	return Super.CanReload();
}


/** Has weapon any ammo left? Regardless of firing mode and spare magazines. */
simulated function bool HasAnyAmmo()
{
	return Super.HasAnyAmmo();
}


/**
 * State Reloading
 * State the weapon is in when it is being reloaded (current magazine replaced with a new one, related animations and effects played).
 */
simulated state Reloading
{
	ignores ForceReload;

	simulated function BeginState(Name PreviousStateName)
	{
		`LogInv("PreviousStateName:" @ PreviousStateName);

		// use up some nano juice
		ReloadStartTime = WorldInfo.TimeSeconds;

		// animation is played when receiving the updated firing mode.
		SetCurrentFireMode(RELOAD_FIREMODE);
	}

	simulated function EndState(Name NextStateName)
	{
		`LogInv("NextStateName:" @ NextStateName);

		// Was reload aborted??
		if( IsTimerActive(nameof(EndOfReloadTimer)) )
		{
			// Call global version, so we're not forced to go to the Active state
			Global.AbortWeaponReload();
			ClearTimer(nameof(EndOfReloadTimer));
		}

		EndFire( RELOAD_FIREMODE );
		NanoPawn(Instigator).bWantsToShoot = FALSE;
		bDelayedBeginFire = FALSE;

		// switch back to default firing mode.
		SetCurrentFireMode( 0 );
		ClearPendingFire( 0 );

		if( CustomAnimNode != None )
		{
			CustomAnimNode.StopCustomAnim( 0.1f );
		}
	}

	/** @see Weapon::TryPutDown() */
	simulated function bool TryPutDown()
	{
		// Put the weapon down right away, and abort weapon reloading
		PutDownWeapon();
		return TRUE;
	}

	simulated function bool CanSwitchAwayFromWeapon()
	{
		return TRUE;
	}

	/** Abort weapon reload... */
	simulated function AbortWeaponReload()
	{
		Global.AbortWeaponReload();

		// leave state and go back to active without reloading weapon
		GotoState('Active');
	}

	simulated function EndOfReloadTimer()
	{
		Global.EndOfReloadTimer();

		ClearTimer(nameof(EndOfReloadTimer));

		// Reload weapon
		PerformReload();

		// we're done, leave state and go back to active
		GotoState('Active');
	}

	simulated function BeginFire(byte FireModeNum)
	{
		Global.BeginFire(FireModeNum);

		// Melee aborts weapon reloads
		if( FireModeNum == MELEE_ATTACK_FIREMODE && PendingFire(MELEE_ATTACK_FIREMODE) )
		{
			if( IsTimerActive(nameof(EndOfReloadTimer)) )
			{
				// Call global, because we don't want to go to the active state
				Global.AbortWeaponReload();
			}
			SendToFiringState(FireModeNum);
		}
	}

	simulated function bool IsFiring()
	{
		return FALSE;
	}
}

simulated function bool IsGunReadyToFire()
{
	local NanoPawn NP;
	local NanoPC   PC;
	if (Instigator.IsHumanControlled())
	{
		NP = NanoPawn(Instigator);
		if( NP != None )
		{
			if( NP.bDodging || NP.MantleState != MANTLE_None || NP.IsTimerActive('WeaponUnholstered') )
			{
				return FALSE;
			}
			PC = NanoPC(Instigator.Controller);
			if( PC != None && (PC.MainPlayerInput.bMustAimToShoot && !NP.bIsTargeting) )
			{
				return FALSE;
			}
		}
	}
	return TRUE;
}

simulated function bool ShouldRefire()
{
	local bool bGunStillWantsToFire;
	local bool bMinShotsMet;

	// if doesn't have ammo to keep on firing, then stop
	if( !HasAmmo( CurrentFireMode ) )
	{
		CurrShotsThatHaveBeenFiredInARow = 0;
		return FALSE;
	}

	// refire if owner is still willing to fire
	bGunStillWantsToFire = StillFiring( CurrentFireMode );

	bMinShotsMet = CurrShotsThatHaveBeenFiredInARow >= MinShotsToBeFiredAtOnce;

	// if gun wants to fire
	if( ( bGunStillWantsToFire == TRUE ) && ( bMinShotsMet == TRUE ) )
	{
		// then we check to see if we have hit our MaxShotsThatCanBeFiredAtOnce
		if( ( CurrShotsThatHaveBeenFiredInARow >= MinShotsToBeFiredAtOnce ) 
			&& ( CurrShotsThatHaveBeenFiredInARow >= MaxShotsThatCanBeFiredAtOnce )
			)
		{
			//`log( `showvar(MaxShotsThatCanBeFiredAtOnce) @ `showvar(CurrShotsThatHaveBeenFiredInARow) );
			CurrShotsThatHaveBeenFiredInARow = 0;
			bShouldSpawnTracer = TRUE;

			// must release trigger and refire
			EndFire( CurrentFireMode );
			NanoPawn(Instigator).bWantsToShoot = FALSE;
			GotoState('Active');

			return FALSE;
		}
	}

	return ( bGunStillWantsToFire || ( bMinShotsMet == FALSE ) ) && IsGunReadyToFire();

}

simulated function bool IsGunPointedAhead()
{
	local vector DummyLoc/*, CamLoc*/;
	local rotator MuzzleRot, AimRot;
	local NanoPawn NP;
	if (Instigator.IsHumanControlled())
	{
		NP = NanoPawn(Instigator);
		if (NP != None && (NP.bDodging || NP.MantleState != MANTLE_None))
		{
			return FALSE;
		}
		SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(MuzzleSocketName,DummyLoc,MuzzleRot);
		//Instigator.GetActorEyesViewPoint(CamLoc,AimRot);
		//`log("muzzle dot:"@vector(MuzzleRot) dot vector(Instigator.Rotation));

		// If the aim rotation is in line with where the muzzle is pointing, fire!
		if( (vector(MuzzleRot) dot vector(GetAimRotation(AimRot))) > 0.8f )
		{
			return TRUE;
		}
		// Otherwise, try to set the rotation towards where the gun wants to fire
		else
		{
			Instigator.SetDesiredRotation(AimRot, FALSE, FALSE, 1.f);
			return FALSE;
		}
		//return (vector(MuzzleRot) dot vector(CamRot)) > 0.8f;
	}
	return TRUE;
}

simulated protected function PlayFireSound()
{
	local bool bPlayerFired;

	if( bFireSoundIsLooping == TRUE )
	{
		if (FireLoop_AC == None)
		{
			// If the player is firing, we play a different sound, and disable spatialization
			bPlayerFired = (NanoPC(Instigator.Controller) != None);

			FireLoop_AC = Instigator.CreateAudioComponent( bPlayerFired ? FireSound_Player : FireSound, FALSE, TRUE );
			if (FireLoop_AC != None)
			{
				FireLoop_AC.bUseOwnerLocation = TRUE;
				FireLoop_AC.bAllowSpatialization = !bPlayerFired;
				FireLoop_AC.bAutoDestroy = TRUE;
				FireLoop_AC.Play();
			}
		}
	}
	else
	{
		NanoWeaponPlaySoundLocal( FireSound, FireSound_Player,, 1.f );
	}
}


simulated function HandleFinishedFiring()
{
	NanoWeaponPlaySoundLocal( EndFireSound, EndFireSound_Player,, 1.f );
	Super.HandleFinishedFiring();
}


//// Look to push this up as it is shared common functionality between all magazine type weapons  (where are our mixins!?)
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

	// Attach magazine mesh to left hand
	//SetPawnAmmoAttachment(TRUE);
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
	//SetPawnAmmoAttachment(FALSE);

	// Show Ammo part on weapon mesh.
	SetWeaponAmmoBoneDisplay(TRUE);
}

state Inactive
{
	simulated function BeginState(Name PrevStateName)
	{
		Super.BeginState(PrevStateName);
	}
}

simulated state WeaponFiring
{
	simulated function BeginState(Name PrevStateName)
	{
		local NanoPawn NP;
		local NanoPC PC;

		// Make sure we've tried to get a gun target when we start firing
 		if( GunTarget == None && Instigator.IsLocallyControlled() )
 		{
 			//TryToPickTarget();
 		}

		if (!IsGunReadyToFire())
		{
			EndFire(CurrentFireMode);
			GotoState('Active');
		}
		else
		{
			Super.BeginState(PrevStateName);
			NP = NanoPawn(Instigator);
			if (!NP.bIsTargeting)
			{
				NP.bIsDoingAttack = TRUE;
			
				PC = NanoPC(Instigator.Controller);
				if( PC != None )
				{
					PC.bPlayerSelectedMeleeTarget = TRUE;
				}
			}


			//`log( "Starting WeaponFiringState" );
			//ScriptTrace();

			NP.PlayRecoilAdditiveAnim('ADD_SMG_Idle_Ready_Aim_Recoil',1.f,0.1f);
			//NP.SetRecoilWeight(1.f,1.f);
		}
	}

	simulated function EndState(Name NextStateName)
	{
		local NanoPawn NP;
		local NanoPC PC;

		Super.EndState(NextStateName);

		//`log( "Ending WeaponFiringState" );

		NP = NanoPawn(Instigator);
		if (NP != None)
		{
			NP.bIsDoingAttack = FALSE;
			NP.SetRecoilWeight(0.f,0.1f);
		}

		PC = NanoPC(Instigator.Controller);
		if( PC != None )
		{
			PC.bPlayerSelectedMeleeTarget = FALSE;
		}

		if (FireLoop_AC != None)
		{
			FireLoop_AC.FadeOut(0.15f,0.f);
			FireLoop_AC = None;
		}
	}
}

// ADD_SMG_Idle_Fire
// GunAdditiveSeq, GunAdditiveBlend

simulated function TryToPickTarget(optional NanoPawn NP)
{
	local NanoPC PC;
	local vector FindLoc;
	local rotator CamRot;
	//local rotator FindRot;
	//local bool bPlayerInput;
	local NanoInterface_Targetable OldTarget;
	if (NP == None)
	{
		NP = NanoPawn(Instigator);
	}
	//`log(`location@`showvar(NP));
	if (NP != None && !NP.bIsTargeting)
	{
		PC = NanoPC(NP.Controller);
		OldTarget = GunTarget;
		GunTarget = None;

		if (PC != None)
		{
			FindLoc = NP.Location;
			//bPlayerInput = (Abs(PC.PlayerInput.RawJoyUp) > 0.2f || Abs(PC.PlayerInput.RawJoyRight) > 0.2f);
			CamRot.Yaw = PC.PlayerCamera.Rotation.Yaw;
			//FindRot = PC.GetDirFromLeftStick(CamRot,bPlayerInput); // use the camera rot


			// what we are doing now is:
			// if you can see the target pick the best one
			// if you are moving and that target goes off "view"
			//   if it is still the best target / no new target  then keep shooing it!
			//   otherwise pick a new target

			GunTarget = NanoInterface_Targetable(PC.SelectTarget_Worker(PC.GunRateTarget,2048.f,0.3f,FindLoc,CamRot)); // aim in front


			// this needs to be aim all over the place well never because you can't see what you are shooting
			if (GunTarget == None && OldTarget != None && OldTarget.IsTargetable())
			{
			//	GunTarget = NanoInterface_Targetable(PC.SelectTarget_Worker(PC.GunRateTarget,2048.f,-1.f,FindLoc,CamRot)); // aim all over the place
			}

			//`log("- found:"@`showvar(GunTarget)@`showvar(OldTarget));

			// if we have a new gun target
			if( GunTarget != None 
				&& GunTarget != OldTarget
				&& GunTarget.IsTargetable()
				)
			{
				PC.SetTargetedActor(GunTarget);
				NP.bForceAimAnim = TRUE;
			}
			// if we have the same target as before OR we have not found a new target
			// and our old target is still valid
			else if( ( ( GunTarget == OldTarget ) || ( GunTarget == None ) )
				&& OldTarget != None 
				&& OldTarget.IsTargetable()
				)
			{
				GunTarget = OldTarget;
				PC.SetTargetedActor(GunTarget);
			}
			// we didn't find a new target so set our target to none
			else 
			{
				PC.SetTargetedActor(None);
				NP.bForceAimAnim = FALSE;
			}
		}
	}
}

simulated function Rotator GetAdjustedAim( vector StartFireLoc )
{
	local rotator AimRot;
	local NanoPawn NP;
	local vector HitL, HitN, CamLoc;
	local rotator CamRot;
	NP = NanoPawn(Instigator);

	if( !NP.IsLocallyControlled() )
	{
		// For non-local pawns, get the replicated aim offset, which accounts for the client's camera position and controller rotation
		return NP.GetReplicatedAim();
	}
	// basically, here if we have Aimed at something, we are always going to hit it, until we no longer are aiming at it
	else if( ( NP.bIsTargeting || !NP.IsHumanControlled() ) && ( NP.bForceAimAnim == FALSE ) )
	{
		// Targeting pawns and AI use the standard GAA() functionality
		return Super.GetAdjustedAim(StartFireLoc);
	}
	else if (GunTarget != None)
	{
		AimRot = rotator(GunTarget.GetTargetedLocation() - StartFireLoc);
	}
	else
	{
		NP.GetActorEyesViewpoint(CamLoc,CamRot);
		if ((Trace(HitL,HitN,CamLoc + vector(CamRot) * 5000.f,CamLoc,TRUE,,,TRACEFLAG_Bullet) != None) && (HitL != CamLoc))
		{
			AimRot = rotator(HitL - CamLoc);
		}
		else
		{
			AimRot = CamRot;
		}
	}
	return AddSpread(AimRot);
}

defaultproperties
{
	WeaponUIName="MP7"

	// RELOAD
	FiringStatesArray(1)="Reloading"
	WeaponFireTypes(1)=EWFT_InstantHit	// this is not actually a firing mode, but this avoids an access None log spam
	WeaponReloadSound=SoundCue'Weapon_Pistol.Pistol.Pitsol_ReloadNPC_01_Cue'
	WeaponReloadSound_Player=SoundCue'Weapon_Pistol.Pistol.Pitsol_Reload_Stereo_01Cue'
	TracerType=WTT_LongSkinny

	WeaponReloadAnim="SMG_Reload_4th"

	// MELEE_ATTACK_FIREMODE
	FiringStatesArray(2)="MeleeAttacking"
	WeaponFireTypes(2)=EWFT_InstantHit
	InstantHitDamageTypes(2)=class'NDT_Melee'

	Begin Object Class=NanoCameraShake Name=FireCameraShake0
		OscillationDuration=0.25f
		RotOscillation={(Pitch=(Amplitude=22.f,Frequency=20.f),
						Yaw=(Amplitude=22.f,Frequency=20.f),
						Roll=(Amplitude=11.f,Frequency=10.f))}
		bOverrideTargetingDampening=TRUE
		TargetingDampening=0.5f
	End Object
	FireCameraShake=FireCameraShake0

	// muzzle flash emitter
	Begin Object Name=PSC_WeaponMuzzleMuzFlashComp
		Template=ParticleSystem'Nano_WeaponFX.GEN.Effects.P_GEN_MP5_MuzzleEffect'
	End Object
	MuzFlashEmitter=PSC_WeaponMuzzleMuzFlashComp


	// Weapon SkeletalMesh
	Begin Object Name=WeaponMeshComp
		SkeletalMesh=SkeletalMesh'REB_SMGv2.SK_REB_SMGv2'
		PhysicsAsset=PhysicsAsset'REB_SMGv2.SK_REB_SMGv2_Physics'
		AnimTreeTemplate=AnimTree'REB_SMGv2.AT_REB_SMGv2'
		AnimSets(0)=AnimSet'REB_SMGv2.AS_REB_SMGv2'
	End Object
	Mesh=WeaponMeshComp

	Begin Object Class=StaticMeshComponent Name=MagazineMesh0
		StaticMesh=StaticMesh'REB_SMGv2.Meshes.SM_REB_SMGv2_Magazine_LOD0' 
		CollideActors=FALSE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		bAcceptsStaticDecals=FALSE
		bAcceptsDynamicDecals=FALSE
	End Object
	MagazineMesh=MagazineMesh0

	FireInterval(0)=+0.150f
	Spread(0)=0.05

	bFireSoundIsLooping=TRUE

	FireSound=SoundCue'Weapon_Pistol.Pistol.Weapon_SmgLoopNPC_Cue'
	FireSound_Player=SoundCue'Weapon_Pistol.Pistol.Weapon_SMG_FireLoop_Cue'

	EndFireSound=SoundCue'Weapon_Pistol.Pistol.Weapon_SmgEndNPC_Cue'
	EndFireSound_Player=SoundCue'Weapon_Pistol.Pistol.Weapon_SmgEnd_Cue'

	MinTimeBetweenBulletWhips=0.5f
	WeaponWhipSound=SoundCue'Weapon_Shared.Bullet_Whips.Bullet_Whips_Cue'

	// shell case ejection emitter
	Begin Object Class=NanoParticleSystemComponent Name=PSC_WeaponShellCaseComp
		Template=ParticleSystem'Nano_WeaponFX.GEN.Effects.P_GEN_SpawnShellCasing'
	    bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	PSC_ShellEject=PSC_WeaponShellCaseComp

	// reload barrel smoke
	Begin Object Class=NanoParticleSystemComponent Name=PSC_WeaponReloadBarrelSmokeComp
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
		Template=ParticleSystem'COG_AssaultRifle.EffectS.P_COG_AssaultRifle_Smoke'
	End Object
	PSC_ReloadBarrelSmoke=PSC_WeaponReloadBarrelSmokeComp

	// Muzzle Flash point light
    Begin Object Name=WeaponMuzzleFlashLightComp
		bAffectCompositeShadowDirection=TRUE
		LightColor=(R=213,G=137,B=91,A=255)
		Radius=128
	End Object
    MuzzleFlashLight=WeaponMuzzleFlashLightComp
	MuzzleLightDuration=0.05f
	MuzzleLightPulseFreq=60
	MuzzleLightPulseExp=1.5

	//bInfiniteSpareAmmo=TRUE
	bShouldSpawnTracer=TRUE

	bUseMeleeHitTimer=TRUE
	MeleeImpactCompleteTime=-1.f

	//SummonEffect=ParticleSystem'Nano_FX.Effects.P_Nano_SMG_Spawn_2'
	SummonEffectSocketName="RightHand"
	SummonAnimName="HG_Draw"
	DrawWeaponAnim="HG_Draw"
	HolsterWeaponAnim="HG_Holster"
	ThrowAwayAnimName="SMG_Throw_Away"
	TimeToSummonWeapon=0.0f
	SummonCue=None
	DismissCue=SoundCue'Weapon_Pistol.Pistol.Pistol_Dismiss_Cue'
	UnholsterCue=SoundCue'Weapon_Pistol.Pistol.Pistol_Dismiss_Cue'
	
	CrosshairIcon=Texture2d'Nano_ProtoHUD_Ingame.Crosshairs.MP7'

	FireNoAmmoSound=SoundCue'Weapon_AssaultRifle.Firing.CogRifleFireEmptyCue'

	bCanDashWithWeapon=FALSE

	MI_WeaponDense=MaterialInstanceConstant'REB_SMGv2.Materials.M_SMG_Densing_INST'
	MI_WeaponGhost=MaterialInstanceConstant'REB_SMGv2.Materials.M_SMG2_Ghosting_INST' 
}
