/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_CannonTurret extends NanoWeapon;

// values that should prob be all moved up to nanoweaponbase but don't want to break things up there

/** AI Accuracy cone - by range */

var protected transient NanoTurret_Cannon MyTurret;

simulated event PostBeginPlay()
{
	MyTurret = NanoTurret_Cannon(Instigator);
	if (MyTurret != None)
	{
		// turret's mesh is also the weapon's mesh
		Mesh = MyTurret.Mesh;
		AttachMuzzleEffectsComponents(MyTurret.Mesh);
	}

	super.PostBeginPlay();
}

simulated function Rotator GetAimRotation( Rotator AimRotation )
{
	local vector HitL, HitN, CamLoc;
	local rotator CamRot;

	if( !Instigator.IsLocallyControlled() )
	{
		AimRotation = NanoPawn(Instigator).GetReplicatedAim();
	}
	else if (!Instigator.IsHumanControlled() || (NanoPawn(Instigator) != None && NanoPawn(Instigator).bIsTargeting))
	{
		AimRotation = Instigator.Controller.Rotation;
	}
	else
	{
		Instigator.GetActorEyesViewpoint(CamLoc,CamRot);
		if ((Trace(HitL,HitN,CamLoc + vector(CamRot) * 5000.f,CamLoc,TRUE,,,TRACEFLAG_Bullet) != None) && (HitL != CamLoc))
		{
			AimRotation = rotator(HitL - CamLoc);
		}
		else
		{
			AimRotation = CamRot;
		}
	}

	return AimRotation;
}

// /** Accessor for native functions, to save an interface cast and making the targetable interface native */
// event vector GetGunTargetLocation()
// {
// 	if( GunTarget != None )
// 	{
// 		return GunTarget.GetTargetedLocation();
// 	}
// 
// 	return vect(0,0,0);
// }

/** we are overriding this function to allow for num of shots per second type specificiation */
// simulated function float GetFireInterval( byte FireModeNum )
// {
// 	return 60.f / GetRateOfFire();
// }
// 
// 
// /** returns rate of fire of weapon*/
// simulated function float GetRateOfFire()
// {
// 	local float RetVal;
// 
// 	RetVal = WeaponRateOfFire;
// 
// 	if (Instigator != None)
// 	{
// 		if( Instigator.IsHumanControlled() )
// 		{
// 			// no rate of fire change
// 		}
// 		else
// 		{
// 			// scale for AI
// 			RetVal *= AI_RateOfFire_Scale;
// 		}
// 	}
// 
// 	return RetVal;
// }
// 
// simulated function FireAmmunition()
// {
// 	Super.FireAmmunition();
// 
// 	if (TRUE)// || `TimeSince(LastPlayFireWeapon) > 0.33f)
// 	{
// 		//'ADD_SMG_Idle_Ready_Aim_Recoil'
// 		NanoPawn(Instigator).PlayGunAdditiveAnim('ADD_SMG_Idle_Fire',1.f,0.001f);
// //		LastPlayFireWeapon = WorldInfo.TimeSeconds;
// 	}
// }


// 
// simulated state Active
// {
// 	simulated function BeginState(Name PreviousStateName)
// 	{
// 		Super.BeginState(PreviousStateName);
// 		if (Instigator != None && Instigator.IsLocallyControlled())
// 		{
// 			SetTimer(0.25f,FALSE,nameof(TryToPickTarget));
// 		}
// 	}

// 	simulated function BeginFire(byte FireModeNum)
// 	{
// 		if (!IsTimerActive(nameof(BurstFireCooldown)) || FireModeNum == RELOAD_FIREMODE)
// 		{
// 			Super.BeginFire(FireModeNum);
// 		}
// 		else
// 		{
// 			// queue up the firing
// 			bDelayedBeginFire = TRUE;
// 			DelayedFireMode = FireModeNum;
// 		}
// 	}

//}


/**
* Returns true if weapon can potentially be reloaded
*
* @return	true if weapon can be reloaded
*/
// simulated function bool CanReload()
// {
// 	return Super.CanReload() && (NanoPawn(Instigator).HasEnoughNanoPower( NanoAmountForReload, FALSE ) || !Instigator.IsHumanControlled() );
// }


// /** Has weapon any ammo left? Regardless of firing mode and spare magazines. */
// simulated function bool HasAnyAmmo()
// {
// 	return Super.HasAnyAmmo() && (NanoPawn(Instigator).HasEnoughNanoPower( NanoAmountForReload, FALSE ) || !Instigator.IsHumanControlled() );
// }


// simulated function bool IsGunReadyToFire()
// {
// 	local NanoPawn NP;
// 	if (Instigator.IsHumanControlled())
// 	{
// 		NP = NanoPawn(Instigator);
// 		if (NP != None && (NP.bDodging || NP.MantleState != MANTLE_None || NP.IsTimerActive('WeaponUnholstered') || !IsGunPointedAhead()))
// 		{
// 			return FALSE;
// 		}
// 	}
// 	return TRUE;
// }

// simulated function bool ShouldRefire()
// {
// 	return Super.ShouldRefire() && IsGunReadyToFire();
// }
// 
// simulated function bool IsGunPointedAhead()
// {
// 	local vector DummyLoc/*, CamLoc*/;
// 	local rotator MuzzleRot, AimRot;
// 	local NanoPawn NP;
// 	if (Instigator.IsHumanControlled())
// 	{
// 		NP = NanoPawn(Instigator);
// 		if (NP != None && (NP.bDodging || NP.MantleState != MANTLE_None))
// 		{
// 			return FALSE;
// 		}
// 		SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(MuzzleSocketName,DummyLoc,MuzzleRot);
// 		//Instigator.GetActorEyesViewPoint(CamLoc,AimRot);
// 		//`log("muzzle dot:"@vector(MuzzleRot) dot vector(Instigator.Rotation));
// 
// 		// If the aim rotation is in line with where the muzzle is pointing, fire!
// 		if( (vector(MuzzleRot) dot vector(GetAimRotation(AimRot))) > 0.8f )
// 		{
// 			return TRUE;
// 		}
// 		// Otherwise, try to set the rotation towards where the gun wants to fire
// 		else
// 		{
// 			Instigator.SetDesiredRotation(AimRot, FALSE, FALSE, 1.f);
// 			return FALSE;
// 		}
// 		//return (vector(MuzzleRot) dot vector(CamRot)) > 0.8f;
// 	}
// 	return TRUE;
// }

// simulated protected function PlayFireSound()
// {
// 	local bool bPlayerFired;
// 
// 	if (FireLoop_AC == None)
// 	{
// 		// If the player is firing, we play a different sound, and disable spatialization
// 		bPlayerFired = (NanoPC(Instigator.Controller) != None);
// 
// 		FireLoop_AC = Instigator.CreateAudioComponent( bPlayerFired ? FireSound_Player : FireSound, FALSE, TRUE );
// 		if (FireLoop_AC != None)
// 		{
// 			FireLoop_AC.bUseOwnerLocation = TRUE;
// 			FireLoop_AC.bAllowSpatialization = !bPlayerFired;
// 			FireLoop_AC.bAutoDestroy = TRUE;
// 			FireLoop_AC.Play();
// 		}
// 	}
// }

// simulated function HandleFinishedFiring()
// {
// 	NanoWeaponPlaySoundLocal( EndFireSound, EndFireSound_Player,, 1.f );
// 	Super.HandleFinishedFiring();
// }


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

simulated function rotator AddSpread(rotator BaseAim)
{
	return super(Weapon).AddSpread(BaseAim);
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
// 	/** @see GearWeapon::ShouldRefire() */
// 	simulated function bool ShouldRefire()
// 	{
// 		// For Players: in single fire mode, it is not possible to refire. You have to release and re-press fire to shot every time
// 		if( Instigator != None && Instigator.IsHumanControlled() )
// 		{
// 			EndFire( CurrentFireMode );
// 			Instigator.Controller.bFire = 0;
// 
// 			return FALSE;
// 		}
// 
// 		return Global.ShouldRefire();
// 	}

// 	simulated function BeginState(Name PrevStateName)
// 	{
// 		local NanoPawn NP;
// 		local NanoPC PC;
// 
// 		// Make sure we've tried to get a gun target when we start firing
//  		if( GunTarget == None && Instigator.IsLocallyControlled() )
//  		{
//  			TryToPickTarget();
//  		}
// 
// 		if (!IsGunReadyToFire())
// 		{
// 			EndFire(CurrentFireMode);
// 			GotoState('Active');
// 		}
// 		else
// 		{
// 			Super.BeginState(PrevStateName);
// 			NP = NanoPawn(Instigator);
// 			if (!NP.bIsTargeting)
// 			{
// 				NP.bIsDoingAttack = TRUE;
// 			
// 				PC = NanoPC(Instigator.Controller);
// 				if( PC != None )
// 				{
// 					PC.bPlayerSelectedMeleeTarget = TRUE;
// 				}
// 			}
// 
// 
// 			NP.PlayRecoilAdditiveAnim('ADD_SMG_Idle_Ready_Aim_Recoil',1.f,0.1f);
// 			//NP.SetRecoilWeight(1.f,1.f);
// 		}
// 	}
// 
// 	simulated function EndState(Name NextStateName)
// 	{
// 		local NanoPawn NP;
// 		local NanoPC PC;
// 
// 		Super.EndState(NextStateName);
// 
// 		NP = NanoPawn(Instigator);
// 		if (NP != None)
// 		{
// 			NP.bIsDoingAttack = FALSE;
// 			NP.SetRecoilWeight(0.f,0.1f);
// 		}
// 
// 		PC = NanoPC(Instigator.Controller);
// 		if( PC != None )
// 		{
// 			PC.bPlayerSelectedMeleeTarget = FALSE;
// 		}
// 	}
 }
 
//   ADD_SMG_Idle_Fire
//   GunAdditiveSeq, GunAdditiveBlend
//   
//   simulated function TryToPickTarget(optional NanoPawn NP)
//   {
//   	local NanoPC PC;
//   	local vector FindLoc;
//   	local rotator FindRot, CamRot;
//   	local bool bPlayerInput;
//   	local NanoInterface_Targetable OldTarget;
//   	if (NP == None)
//   	{
//   		NP = NanoPawn(Instigator);
//   	}
//   	//`log(`location@`showvar(NP));
//   	if (NP != None && !NP.bIsTargeting)
//   	{
//   		PC = NanoPC(NP.Controller);
//   		OldTarget = GunTarget;
//   		GunTarget = None;
//   		if (PC != None)
//   		{
//   			FindLoc = NP.Location;
//   			bPlayerInput = (Abs(PC.PlayerInput.RawJoyUp) > 0.2f || Abs(PC.PlayerInput.RawJoyRight) > 0.2f);
//   			CamRot.Yaw = PC.PlayerCamera.Rotation.Yaw;
//   			FindRot = PC.GetDirFromLeftStick(CamRot,bPlayerInput);
//   			GunTarget = NanoInterface_Targetable(PC.SelectTarget_Worker(PC.GunRateTarget,2048.f,0.3f,FindLoc,FindRot));
//   			if (GunTarget == None && OldTarget != None && OldTarget.IsTargetable())
//   			{
//   				GunTarget = NanoInterface_Targetable(PC.SelectTarget_Worker(PC.GunRateTarget,2048.f,-1.f,FindLoc,FindRot));
//   			}
//   			if (GunTarget != None && GunTarget != OldTarget)
//   			{
//   				PC.SetTargetedActor(GunTarget);
//   				NP.bForceAimAnim = TRUE;
//   			}
//   			//`log("- found:"@`showvar(GunTarget)@`showvar(OldTarget));
//   			if (GunTarget == None && OldTarget != None && OldTarget.IsTargetable())
//   			{
//   				GunTarget = OldTarget;
//   			}
//   			else
//   			{
//   				PC.SetTargetedActor(None);
//   				NP.bForceAimAnim = FALSE;
//   			}
//   		}
//   	}
// }
// 
// 
// simulated function Rotator GetAdjustedAim( vector StartFireLoc )
// {
// 	local rotator AimRot;
// 	local NanoPawn NP;
// 	local vector HitL, HitN, CamLoc;
// 	local rotator CamRot;
// 	NP = NanoPawn(Instigator);
// 
// 	if( !NP.IsLocallyControlled() )
// 	{
// 		// For non-local pawns, get the replicated aim offset, which accounts for the client's camera position and controller rotation
// 		return NP.GetReplicatedAim();
// 	}
// 	else if ( NP.bIsTargeting || !NP.IsHumanControlled() )
// 	{
// 		// Targeting pawns and AI use the standard GAA() functionality
// 		return Super.GetAdjustedAim(StartFireLoc);
// 	}
// 	else if (GunTarget != None)
// 	{
// 		AimRot = rotator(GunTarget.GetTargetedLocation() - StartFireLoc);
// 	}
// 	else
// 	{
// 		NP.GetActorEyesViewpoint(CamLoc,CamRot);
// 		if ((Trace(HitL,HitN,CamLoc + vector(CamRot) * 5000.f,CamLoc,TRUE,,,TRACEFLAG_Bullet) != None) && (HitL != CamLoc))
// 		{
// 			AimRot = rotator(HitL - CamLoc);
// 		}
// 		else
// 		{
// 			AimRot = CamRot;
// 		}
// 	}
// 	return AddSpread(AimRot);
// }


defaultproperties
{
	WeaponUIName="SENTRY TURRET"

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponProjectiles(0)=class'NanoProj_CannonTurret'
	
	// muzzle flash emitter
	Begin Object Name=PSC_WeaponMuzzleMuzFlashComp
		Template=ParticleSystem'Nano_WeaponFX.GEN.Effects.P_GEN_MP5_MuzzleEffect'
	End Object
	MuzFlashEmitter=PSC_WeaponMuzzleMuzFlashComp

	// Muzzle Flash point light
	Begin Object Name=WeaponMuzzleFlashLightComp
	    bEnabled=FALSE
		Brightness=10
		Radius=128
		LightColor=(R=213,G=137,B=91,A=255)
		bAffectCompositeShadowDirection=TRUE
	End Object
    MuzzleFlashLight=WeaponMuzzleFlashLightComp
	MuzzleLightDuration=0.05f
	MuzzleLightPulseFreq=60
	MuzzleLightPulseExp=1.5
	MuzzleSocketName="Muzzle_L"

	FireInterval(0)=+0.050f
	Spread(0)=0.15

	FireSound=SoundCue'Weapon_Pistol.Pistol.Pistol_FireEnemy_Cue'
	FireSound_Player=SoundCue'Weapon_Pistol.Pistol.Pistol_FirePlayer_Cue'

	MinTimeBetweenBulletWhips=0.5f
	WeaponWhipSound=SoundCue'Weapon_Shared.Bullet_Whips.Bullet_Whips_Cue'

	// shell case ejection emitter
	Begin Object Class=NanoParticleSystemComponent Name=PSC_WeaponShellCaseComp
		Template=ParticleSystem'Nano_WeaponFX.GEN.Effects.P_GEN_SpawnShellCasing'
	    bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	PSC_ShellEject=PSC_WeaponShellCaseComp


	bInfiniteSpareAmmo=TRUE

	bUseMeleeHitTimer=TRUE
	MeleeImpactCompleteTime=-1.f

	CrosshairIcon=Texture2d'Nano_ProtoHUD_Ingame.Crosshairs.MP7'

	bCanDashWithWeapon=FALSE
}
