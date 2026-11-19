/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_SentryTurret extends NanoWeapon
	native(inherit);

var transient NanoInterface_Targetable GunTarget;

// values that should prob be all moved up to nanoweaponbase but don't want to break things up there

/** AI Accuracy cone - by range */

var protected transient NanoSentryTurretBase MyTurret;


//// START  Muzzle Flash and firing flip flopping)

/** whether to use right (or left turret)**/
var transient bool bUseTurretRight;


/** Muzzle Flash particle system */
var()	editinline	ParticleSystemComponent		MuzFlashEmitter_Right;

/** Affects how we turn it on/off. */
var()				bool						bMuzFlashEmitterIsLooping_Right;

/** Muzzle socket name, to attach effects on */
var()	Name					MuzzleSocketName_Right;
/** Muzzle flash staticmesh, attached to weapon mesh */
var()	MeshComponent			MuzzleFlashMesh_Right;
/** dynamic light */
var()	PointLightComponent		MuzzleFlashLight_Right;

var()				transient float		MuzzleLightPulseTime_Right;

//// END  Muzzle Flash and firing flip flopping)


simulated event PostBeginPlay()
{
	MyTurret = NanoSentryTurretBase(Instigator);
	if (MyTurret != None)
	{
		// turret's mesh is also the weapon's mesh
		Mesh = MyTurret.Mesh;
		AttachMuzzleEffectsComponents(MyTurret.Mesh);
		AttachMuzzleEffectsComponents_Right(MyTurret.Mesh);
	}

	super.PostBeginPlay();
}


// NOTE: this is the function that will flip the muzzle location
simulated function InstantFire()
{
	bUseTurretRight = !bUseTurretRight;

	Super.InstantFire();
}



simulated function PlayMuzzleFlashEffect()
{
	if( bUseTurretRight == TRUE )
	{
		PlayMuzzleFlashEffect_Right();
	}
	else
	{
		Super.PlayMuzzleFlashEffect();
	}
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
	else if( GunTarget != None )
	{
		AimRotation = Rotator(GunTarget.GetTargetedLocation()-Instigator.Location);
		// hard-coded offset to get the gun lined up with the shots a bit better
		AimRotation.Pitch -= 1024.f;
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

/** Accessor for native functions, to save an interface cast and making the targetable interface native */
event vector GetGunTargetLocation()
{
	if( GunTarget != None )
	{
		return GunTarget.GetTargetedLocation();
	}

	return vect(0,0,0);
}


simulated native function GetMuzzleLocAndRot(out vector Loc, out rotator Rot);




/** we are overriding this function to allow for num of shots per second type specification */
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

 





 /** Sets up effects components that are attached to the weapon mesh. */
 simulated event AttachMuzzleEffectsComponents_Right(SkeletalMeshComponent SkelMesh)
 {
	 //	`log( self@GetFuncName()@SkelMesh@MuzFlashEmitter_Right@MuzzleSocketName_Right );

	 // we allowed attachment on dedicated servers, but we don't need stuff after this
	 if( WorldInfo.NetMode == NM_DedicatedServer )
	 {
		 return;
	 }

	 // Attach muzzle flash related effects
	 if( SkelMesh != None && MuzzleSocketName_Right != '' )
	 {
		 // if we are pending kill then don't attach things
		 if( SkelMesh.IsPendingKill() )
		 {
			 //ScriptTrace();
			 return;
		 }

		 if (Owner != None)
		 {
			 // 			SetMaterialBasedOnTeam( SkelMesh, GearPawn(Owner) != none ? GearPawn(Owner).GetMPWeaponColorBasedOnClass() : Owner.GetTeamNum() );
			 // 			MIC_WeaponSkin.SetScalarParameterValue( 'Weap_SpecMult', 1.0f );
			 // 			MIC_WeaponSkin.SetScalarParameterValue( 'Weap_DroppedGlow', 0.0f );
			 // 			MIC_WeaponSkin.SetScalarParameterValue( 'Weap_DropGlowAlpha', 0.0f );
		 }

		 // Muzzle Flash Mesh
		 if( MuzzleFlashMesh_Right != None && !SkelMesh.IsComponentAttached(MuzzleFlashMesh_Right) )
		 {
			 SkelMesh.AttachComponentToSocket(MuzzleFlashMesh_Right, MuzzleSocketName_Right);
		 }

		 // attach muzzle flash emitter, and position to fire offset
		 if( MuzFlashEmitter_Right != None && !SkelMesh.IsComponentAttached(MuzFlashEmitter_Right) )
		 {
			 SkelMesh.AttachComponentToSocket(MuzFlashEmitter_Right, MuzzleSocketName_Right);
			 HideMuzzleFlashEmitter();
		 }

		 // Muzzle Flash dynamic light
		 if( MuzzleFlashLight_Right != None && !SkelMesh.IsComponentAttached(MuzzleFlashLight_Right) )
		 {
			 MuzzleFlashLight_Right.SetTranslation(MuzzleLightOffsetFromCannon);
			 SkelMesh.AttachComponentToSocket(MuzzleFlashLight_Right, MuzzleSocketName_Right);
		 }

		 // attach after fire particle system
		 if( PSC_ReloadBarrelSmoke != None && !SkelMesh.IsComponentAttached(PSC_ReloadBarrelSmoke) )
		 {
			 SkelMesh.AttachComponentToSocket(PSC_ReloadBarrelSmoke, MuzzleSocketName_Right);
			 HidePSC_ReloadBarrelSmoke();
		 }
	 }
 }


 /**
 * Start muzzle flash effect
 * Network: Local Player and Clients
 */
 simulated function PlayMuzzleFlashEffect_Right()
 {
	 local vector		SpawnLoc;

	 //	`log( self@GetFuncName()@bSuppressMuzzleFlash@IsMuzzleFlashRelevant()@MuzFlashEmitter_Right);

	 // Play muzzle flash effects only if they are relevant
	 if( !bSuppressMuzzleFlash && IsMuzzleFlashRelevant() )
	 {
		 // turn on muzzle flash mesh
		 //`log("playing muzzle flash"@MuzzleFlashMesh_Right@MuzFlashEmitter_Right@MuzzleFlashLight_Right);
		 if( MuzzleFlashMesh_Right != None )
		 {
			 MuzzleFlashMesh_Right.SetHidden(FALSE);

			 // Randomize muzzle flash mesh size
			 RandomizeMuzzleFlash(MuzzleFlashMesh_Right);
		 }

		 // activate muzzle flash particle system
		 if( MuzFlashEmitter_Right != None )
		 {
			 ClearTimer( nameof(HideMuzzleFlashEmitter) );
			 MuzFlashEmitter_Right.SetHidden( FALSE );

			 if (bMuzFlashEmitterIsLooping_Right)
			 {
				 MuzFlashEmitter_Right.SetLODLevel(NanoGRI(WorldInfo.GRI).GetLODLevelToUse(MuzFlashEmitter_Right.Template, GetMuzzleLoc()));
				 MuzFlashEmitter_Right.SetActive(TRUE);
			 }
			 else
			 {
				 MuzFlashEmitter_Right.SetLODLevel(NanoGRI(WorldInfo.GRI).GetLODLevelToUse(MuzFlashEmitter_Right.Template, GetMuzzleLoc()));
				 MuzFlashEmitter_Right.ActivateSystem();
			 }
		 }

		 if( MuzzleFlashLight_Right != None
			 && !NanoGRI(WorldInfo.GRI).ShouldDisableEffectsDueToFramerate(Instigator)
			 && (!bLoopMuzzleFlashLight || !MuzzleFlashLight_Right.bEnabled)
			 )
		 {
			 //MuzzleFlashLight_Right.CastDynamicShadows = bDynamicMuzzleFlashes;
			 MuzzleFlashLight_Right.SetEnabled(TRUE);

			 // Reset Pulse time to zero, so we start at the beginning.
			 MuzzleLightPulseTime_Right = 0.f;
		 }

		 // maybe spawn lingering muzzle smoke
		 if( (MuzSmokeParticleSystem != None)
			 && !NanoGRI(WorldInfo.GRI).ShouldDisableEffectsDueToFramerate(Instigator)
			 )
		 {
			 SpawnLoc = GetMuzzleLoc();
			 WorldInfo.MyEmitterPool.SpawnEmitter(MuzSmokeParticleSystem, SpawnLoc, rot(0,0,0));
		 }

		 SetTimer( MuzzleLightDuration, FALSE, nameof(StopMuzzleFlashEffect_Right) );		 
	 }
 }




 /**
 * Stop muzzle flash effect
 * Network: Local Player and Clients
 */
 simulated function StopMuzzleFlashEffect_Right()
 {
	 //	`log( self@GetFuncName() );

	 // turn off muzzle flash mesh
	 if( MuzzleFlashMesh_Right != None )
	 {
		 MuzzleFlashMesh_Right.SetHidden( TRUE );
	 }

	 if( MuzFlashEmitter_Right != None )
	 {
		 MuzFlashEmitter_Right.SetActive(FALSE);
		 SetTimer( TimeToHideMuzzleFlashPS, FALSE, nameof(HideMuzzleFlashEmitter_Right) );
	 }

	 // turn off muzzle flash light only if it's non looping
	 // Looping ones are turned off when the weapon stops firing
	 // Used by rapid fire weapons
	 if( !bLoopMuzzleFlashLight && MuzzleFlashLight_Right != None )
	 {
		 MuzzleFlashLight_Right.SetEnabled( FALSE );
	 }
 }

 simulated function HideMuzzleFlashEmitter_Right()
 {
	 MuzFlashEmitter_Right.SetHidden( TRUE );
 }





defaultproperties
{
	WeaponUIName="SENTRY TURRET"

	WeaponFireTypes(0)=EWFT_InstantHit
	InstantHitDamageTypes(0)=class'NDT_SentryTurret'

	// muzzle flash emitter
	Begin Object Name=PSC_WeaponMuzzleMuzFlashComp
		Template=ParticleSystem'Nano_WeaponFX.GEN.Effects.P_GEN_MP5_MuzzleEffect'
	End Object
	MuzFlashEmitter=PSC_WeaponMuzzleMuzFlashComp

	// muzzle flash emitter
	Begin Object Class=NanoParticleSystemComponent Name=PSC_WeaponMuzzleMuzFlashComp1
	    Template=ParticleSystem'Nano_WeaponFX.GEN.Effects.P_GEN_MP5_MuzzleEffect'
	End Object
	MuzFlashEmitter_Right=PSC_WeaponMuzzleMuzFlashComp1


	// Muzzle Flash point light
	Begin Object Name=WeaponMuzzleFlashLightComp
	    bEnabled=FALSE
		Brightness=20
		Radius=256
		LightColor=(R=213,G=137,B=91,A=255)
		bAffectCompositeShadowDirection=TRUE
	End Object
    MuzzleFlashLight=WeaponMuzzleFlashLightComp

	Begin Object Class=PointLightComponent Name=WeaponMuzzleFlashLightComp1
	    bEnabled=FALSE
		Brightness=20
		Radius=256
		LightColor=(R=213,G=137,B=91,A=255)
		bAffectCompositeShadowDirection=TRUE
	End Object
	MuzzleFlashLight_Right=WeaponMuzzleFlashLightComp1

	MuzzleLightDuration=0.05f
	MuzzleLightPulseFreq=60
	MuzzleLightPulseExp=1.5



	MuzzleSocketName="Muzzle_L"
	MuzzleSocketName_Right="Muzzle_R"

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

	bUseMeleeHitTimer=TRUE // errr why is a gun using this?
	MeleeImpactCompleteTime=-1.f

	CrosshairIcon=Texture2d'Nano_ProtoHUD_Ingame.Crosshairs.MP7'

	bCanDashWithWeapon=FALSE
}
