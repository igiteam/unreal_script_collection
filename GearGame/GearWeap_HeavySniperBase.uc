/**
 * Heavy Sniper Weapon
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_HeavySniperBase extends GearWeap_HeavyBase
	native(Weapon)
	abstract;

/** How much to scale the default camera shake when mounted. */
var() const protected float		FireCameraShakeScaleMounted;
/** Range of how much to scale the default firing camera shake.  Mapped to normalized accuracy values. */
var() const protected vector2d	FireCameraShakeScaleRange;


/** sound of shells colliding against ground*/
var() protected const SoundCue				ShellCollisionSound;

/** FOV (in deg) of the zoomed state of this weapon */
var() protected const config float			ZoomFOV;

/** separate fire camera shake for zoomed mode, since the regular camera shake feels enormous when zoomed */
var() protected const GearCameraShake   	FireCameraShake_Zoomed;

/** Aim error when mounted and zoomed. */
var() protected const config float ZoomedWeaponAimError;

/** Amount of damage to apply to shield holder on shield hits. */
var() protectedwrite const config float DamageToShieldHolder;

var protected const ParticleSystem TracerBeamPS;

/** additional inaccuracy when just mounted */
var config float MountedInaccuracyMax;
/** how long until the MountedInaccuracy goes away */
var config float MountedSteadyTime;
/** last time we mounted this weapon */
var float LastMountedTime;

/** Beam emitters for the targetting laser */
var	private ParticleSystemComponent		TargetingBeamEmitter;
var	private ParticleSystemComponent		LockedTargetingBeamEmitter;

/** The socker where we want the targetting laser to come out of */
var name ScopeSocketName;

/** Distance to nudge target location from surface.  Helps hide imperfect collision, deals with 90 deg surfaces, etc */
var() private float NudgeDist;

/** Audio component for looped sound */
var AudioComponent TargetingBeamLoopSound;
var AudioComponent TargetingBeamBeepLoopSound;
var AudioComponent TargetingBeamLockLoopSound;
/** lock on complete sound played only for the holder */
var SoundCue LockedOnSound;

/** How much we modify the pitch when firing unaimed */
var config Rotator UnaimedInaccuracyModifier;

/** Last time the aim location was updated */
var float LastAimLocationUpdateTime;

// Minimum amount of time between aim location updates. Used to keep from thrashing the server with rpc calls
var config float MinTimeBetweenAimLocationUpdates;

//Amount to scale rotation input while aimed
var config float AimedRotationScale;

//Whether or not the sniper rifle is 'locked on' and ready to fire
var bool bIsLockedOn;
//Whether or not the laser is on
var bool bLaserIsOn;

//Whether or not the beeping sound should be audible
var bool bShouldHearBeep;

//Unable to fire sound
var protected const SoundCue	UnableToFireSoundCue;
var float TimeBetweenUnableToFire;
var float LastTimeUnableToFire;

/** Zoomed crosshair */
var Texture2D CrosshairIconSecondary;

/** Fudged rotation adjustment when zooming to account for camera change. */
var() protected const rotator TargetingRotAdjustment;

cpptext
{
	UBOOL HitShouldStopHeavySniperBullet(FCheckResult const& Hit);
}


// simulated function float GetWeaponRating()
// {
// 	local float Rating;
//
// 	Rating = Super.GetWeaponRating();
//
// 	// AI prefers sniper at long range
// 	if ( GearAI(GetWeaponController(Instigator)) != None && GetWeaponController(Instigator).Enemy != None &&
// 		!GearAI(GetWeaponController(Instigator)).IsShortRange(GetWeaponController(Instigator).Enemy.Location) )
// 	{
// 		Rating += 0.5;
// 	}
//
// 	return Rating;
// }


simulated event PostBeginPlay()
{
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		//Make sure the emitters are deactivated and attach them to the appropriate socket
		TargetingBeamEmitter.DeActivateSystem();
		SkeletalMeshComponent(Mesh).AttachComponentToSocket( TargetingBeamEmitter, ScopeSocketName );

		LockedTargetingBeamEmitter.DeActivateSystem();
		SkeletalMeshComponent(Mesh).AttachComponentToSocket( LockedTargetingBeamEmitter, ScopeSocketName );
		TurnOffTargetingLaser();
	}
	LastTimeUnableToFire = WorldInfo.TimeSeconds-TimeBetweenUnableToFire;

	super.PostBeginPlay();
}

/** Nuke the scope when the rifle goes away */
simulated function Destroyed()
{
	Super.Destroyed();

	if (Scope != None)
	{
		Scope.Destroy();
	}
}

/**
 * State WeaponFiring
 * Fires a bullet at a time
 */
simulated state WeaponFiring
{
	simulated function TargetingModeChanged(GearPawn P)
	{
		local GearPC PC;

		TimeSinceTargeting = WorldInfo.TimeSeconds;
		if( (Instigator != none) && GearPawn(Instigator).bIsZoomed )
		{
			// we want to leave zoomed state if we stop targeting, but stay zoomed across a reload
			// (which involves leaving targeting mode for a moment).
			PC = GearPC(GetWeaponController());
			if ( PC != None )
			{
				if ( !PC.bIsTargeting && !IsReloading() )
				{
					SetZoomed(FALSE,TRUE);
				}
				else
				{
					SetOwnerNoSee(PC.bIsTargeting);
				}
			}
		}
	}

	simulated function Tick(float DeltaTime)
	{
		RecalculateLaserLocation();
		Super.Tick(DeltaTime);
	}

	simulated function BeginState(name PrevStateName)
	{
		Super.BeginState(PrevStatename);
		TurnOffTargetingLaser();
		bIsLockedOn=false;
	}


	simulated function EndState(name NextStateName)
	{
		super.EndState(NextStateName);

 		if ( NextStateName != 'Active' )
 		{
 			SetOwnerNoSee(FALSE);
 		}
	}
}


simulated function bool ShouldAutoReload()
{
	if (Instigator != None && Instigator.IsHumanControlled() && PendingFire(0))
	{
		// don't autoreload while still holding the fire button
		return FALSE;
	}
	return Super.ShouldAutoReload();
}

simulated function PlayWeaponReloading()
{
	Super.PlayWeaponReloading();
	// force the player to remain in the aiming pose after a reload
	if (GearPawn(Instigator) != None)
	{
		GearPawn(Instigator).SetWeaponAlert(8.f);
	}
}

simulated function PlayShellCaseEject()
{
	//SetTimer( 1.70, FALSE, nameof(PlayShellCaseEject_Sniper) );
}


simulated function PlayBoltEject()
{
	Super.PlayShellCaseEject();

	if( !bSuppressAudio )
	{
		Playsound( SoundCue'Weapon_Sniper.Reloads.CogSniperAmmoEjectCue', true );
	}
	SetTimer( 0.750, FALSE, nameof(PlayShellCaseLandImpact) );
}


simulated function PlayShellCaseLandImpact()
{
	if ( (WorldInfo.NetMode != NM_DedicatedServer) && !bSuppressAudio )
	{
		Instigator.PlaySound( ShellCollisionSound, true );
	}
}



simulated function PlayFireEffects(byte FireModeNum, optional vector HitLocation)
{
	TurnOffTargetingLaser();
	super.PlayFireEffects(FireModeNum, HitLocation);
}

/**
 * Overridden to modify locations
 */
simulated function PlayOwnedFireEffects(byte FireModeNum, vector HitLocation)
{
	local vector SpawnLoc;
	local rotator SpawnRot;

	// if we should spawn a tracer effect for the local player, let's do so
	if( WorldInfo.NetMode != NM_DedicatedServer &&
		ShouldSpawnTracerFX() &&
		!IsZero(HitLocation)
		)
	{
		SpawnLoc = GetMuzzleLoc() + vect(0,0,10); // move it up a little particle and socket interaction is a bit off
		if ( UseFirstPersonCamera() )
		{
			SpawnLoc -= vect(0,0,10);
		}

		// if we are on the client when we will not have correct HitLocation so we will calculate an
		// approximate one for our tracer to use.
		if (Role < ROLE_Authority && !bClientSideInstantHit)
		{
			HitLocation = SpawnLoc + vector(GetAdjustedAim(SpawnLoc)) * GetTraceRange();
		}

		SpawnRot = Rotator(HitLocation - SpawnLoc);

		SpawnTracerEffect( Instigator, SpawnLoc, SpawnRot, HitLocation, VSize(HitLocation -SpawnLoc) );
	}
}

simulated function float GetPlayerAimError()
{
	local GearPawn GP;
	GP = GearPawn(Instigator);
	if (GP != None && WorldInfo.GRI.IsMultiplayerGame() && (!GP.bIsTargeting || `TimeSince(TimeSinceTargeting) < 0.4f))
	{
		return WeaponAimError.Y;
	}
	else if (GP != None && GP.bIsZoomed)
	{
		return ZoomedWeaponAimError * 1.0 + GetAdditionalMountedInaccuracy();
	}
	else
	{
		return Super.GetPlayerAimError();
	}
}

simulated event WeaponStoppedFiring(byte FiringMode)
{
	//`log( WorldInfo.TimeSeconds @ GetFuncName() @ "FiringMode:" @ FiringMode );
	if (Instigator != None)
	{
		Instigator.WeaponStoppedFiring(Self, FALSE);
	}

	StopFireEffects(FiringMode);

	/*
	// if we're not currently reloading our weapon, play idle animation
	if( FiringMode != RELOAD_FIREMODE )
	{
	GearPawn(Instigator).PlayWeaponStanceIdle();
	}
	*/

	// turn off shell eject particle system
	if( PSC_ShellEject != None )
	{
		PSC_ShellEject.DeActivateSystem();
		SetTimer( 3.0f, FALSE, nameof(HidePSC_ShellEject) );
	}
}

simulated function float GetTargetingFOV(float BaseFOV)
{
	if (GearPawn(Instigator).bIsZoomed)
	{
		return ZoomFOV;
	}
	else
	{
		return Super.GetTargetingFOV(BaseFOV);
	}
}

simulated function Texture2D GetCrosshairIcon(GearPC PC, out float XOffset, out float YOffset)
{
	return GearPawn(Instigator).bIsZoomed ? CrosshairIconSecondary : CrosshairIcon;
}

simulated function TimeWeaponEquipping()
{
	SetZoomed(FALSE,TRUE);
	Super.TimeWeaponEquipping();
}

simulated function TimeWeaponPutDown()
{
	SetZoomed(FALSE,TRUE);
	Super.TimeWeaponPutDown();
}

simulated function SetMounted(bool bNowMounted)
{
	local GearPC PC;
	local GearPawn InstigatorWP;
	local rotator RotAdj;

	Super.SetMounted(bNowMounted);

	if (bIsMounted)
	{
		LastMountedTime = WorldInfo.TimeSeconds;
	}

	// force zoom whenever mounted
	SetZoomed(bIsMounted, true);
	if (bIsMounted)
	{
		TurnOnTargetingLaser();
	}
	else
	{
		TurnOffTargetingLaser();
		bIsLockedOn=false;
	}

	PC = GearPC(GetWeaponController());
	InstigatorWP = GearPawn(Instigator);

	if (PC != None && InstigatorWP != None)
	{
		SetZoomed(bIsMounted, true);

		// flip the yaw adjustment if player is mirrored
		RotAdj = TargetingRotAdjustment;

		if (InstigatorWP.bIsMirrored)
		{
			RotAdj.Yaw = -RotAdj.Yaw;
		}

		if (InstigatorWP.bIsZoomed)
		{
			GearWeaponPlaySoundLocal(ZoomActivatedSound,,, true);
			PC.ExtraRot += RotAdj;
		}
		else
		{
			GearWeaponPlaySoundLocal(ZoomDeactivatedSound,,, true);
			PC.ExtraRot -= RotAdj;
		}
	}
}

simulated final function float GetAdditionalMountedInaccuracy()
{
	return MountedInaccuracyMax * FMax(0.0, 1.0 - (WorldInfo.TimeSeconds - LastMountedTime) / MountedSteadyTime);
}

simulated protected function GearCameraShake GetFireViewShake()
{
	return (GearPawn(Instigator).bIsZoomed && FireCameraShake_Zoomed != None) ? FireCameraShake_Zoomed : FireCameraShake;
}

/**
 * Zoomed sniper rifle wants first person camera.
 * @returns true if Weapon would like a first person camera to be used when targeting
 */
simulated function bool UseFirstPersonCamera()
{
	return GearPawn(Instigator).bIsZoomed;
}

/**
 * Notification from pawn that it has been unpossessed.
 */
function NotifyUnpossessed()
{
	SetZoomed(FALSE,TRUE);
}




/** Overloaded to scale FireCameraShakes. */
simulated function PlayFireCameraEffects()
{
	local float NormAcc;

	// set the shake scale value.  do this before calling the super.
	NormAcc = GearInventoryManager(InvManager).Accuracy;

	if (IsMounted())
	{
		FireCameraShakeScale = FireCameraShakeScaleMounted;
	}
	else
	{
		// use normal accuracy values
		FireCameraShakeScale = Lerp(FireCameraShakeScaleRange.X, FireCameraShakeScaleRange.Y, NormAcc);
	}

	super.PlayFireCameraEffects();
}


simulated function ConsumeAmmo(byte FireModeNum)
{
	Super.ConsumeAmmo(FireModeNum);

	if (!HasAmmo(0))
	{
		TurnOffTargetingLaser();
	}
}

simulated function AmmoUpdated()
{
	Super.AmmoUpdated();

	if (!HasAmmo(0))
	{
		TurnOffTargetingLaser();
	}
}

/** Overridden to return TRUE. */
simulated function bool ShouldUseMuzzleFlashSocketForShellEjectAttach()
{
	return TRUE;
}

simulated state Active
{
	simulated function Tick(float DeltaTime)
	{
		local GearPC PC;
		local Vector ClosestPoint;
		local GearPawn_Infantry GPI;

		if( ShouldAutoReload() )
		{
			ForceReload();
		}
		RecalculateLaserLocation();
		if (bIsMounted && GearPawn(Instigator).bIsZoomed)
		{
			if (WorldInfo.TimeSeconds - LastMountedTime >= MountedSteadyTime)
			{
				if (!bIsLockedOn && Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
				{
					PlayerController(Instigator.Controller).ClientPlaySound(LockedOnSound);
				}

				bIsLockedOn = true;
				if (TargetingBeamEmitter.bIsActive)
				{
					TargetingBeamEmitter.DeActivateSystem();
					TargetingBeamEmitter.SetHidden(TRUE);
					LockedTargetingBeamEmitter.ActivateSystem();
					LockedTargetingBeamEmitter.SetHidden(FALSE);
				}

				if (bShouldHearBeep)
				{
					if (TargetingBeamBeepLoopSound != none && TargetingBeamLockLoopSound != none)
					{
						TargetingBeamBeepLoopSound.Stop();
						if (!TargetingBeamLockLoopSound.IsPlaying())
						{
							TargetingBeamLockLoopSound.Play();
						}
					}
				}
			}
			else
			{
				bIsLockedOn = false;
				if (LockedTargetingBeamEmitter.bIsActive)
				{
					LockedTargetingBeamEmitter.DeActivateSystem();
					LockedTargetingBeamEmitter.SetHidden(TRUE);
					//TargetingBeamEmitter.ActivateSystem();
					//TargetingBeamEmitter.SetHidden(FALSE);
				}
				if (bShouldHearBeep)
				{
					if (TargetingBeamBeepLoopSound != none && TargetingBeamLockLoopSound != none)
					{
						TargetingBeamLockLoopSound.Stop();
						if (!TargetingBeamBeepLoopSound.IsPlaying())
						{
							TargetingBeamBeepLoopSound.Play();
						}
					}
				}
			}
		}

		if (bShouldHearBeep)
		{
			GPI = GearPawn_Infantry(Instigator);
			if (GPI != none)
			{
				foreach WorldInfo.LocalPlayerControllers(class'GearPC',PC)
				{
					if (PC.Pawn != None)
					{
						PointDistToSegment(PC.Pawn.Location,  GPI.Location, GPI.AimLocation, ClosestPoint);
						TargetingBeamBeepLoopSound.Location = ClosestPoint;
						TargetingBeamLockLoopSound.Location = ClosestPoint;
						break;
					}
				}
			}
		}

		Super.Tick(DeltaTime);
	}

	simulated function TargetingModeChanged(GearPawn P)
	{
		local GearPC PC;

		TimeSinceTargeting = WorldInfo.TimeSeconds;
		if( (Instigator != none) && GearPawn(Instigator).bIsZoomed )
		{
			// we want to leave zoomed state if we stop targeting, but stay zoomed across a reload
			// (which involves leaving targeting mode for a moment).
			PC = GearPC(GetWeaponController());
			if ( PC != None )
			{
				if ( !PC.bIsTargeting && !IsReloading() )
				{
					SetZoomed(FALSE,TRUE);
					TurnOffTargetingLaser();
				}
				else
				{
					TurnOnTargetingLaser();
					SetOwnerNoSee(PC.bIsTargeting);
				}
			}
		}
	}

	simulated function ForceReload()
	{
		// don't make it actually force for the sniper so we can stay zoomed as long as we want
		if (ShouldAutoReload())
		{
			Super.ForceReload();
		}
	}

	//Only allow firing if completely zoomed in
	simulated function BeginFire(byte FireModeNum)
	{
		if ((bIsMounted && bIsLockedOn) || FireModeNum == RELOAD_FIREMODE)
		{
			super.BeginFire(FireModeNum);
			bIsLockedOn=false;
			TurnOffTargetingLaser();
		}
		else
		{
			//Play annoying sound
			if (WorldInfo.TimeSeconds - LastTimeUnableToFire > TimeBetweenUnableToFire)
			{
				LastTimeUnableToFire=WorldInfo.TimeSeconds;
				GearWeaponPlaySoundLocal(UnableToFireSoundCue,,, true);
			}
		}
	}

	simulated function BeginState(name PreviousStateName)
	{
		local GearPawn GP;

		super.BeginState(PreviousStateName);
		
		GP = GearPawn(Instigator);
		if (GP != None)
		{
			if (ScopeClass != None && Scope == None && GP.IsLocallyControlled() && GP.IsHumanControlled())
			{
				Scope = Spawn(ScopeClass, Self);
				SetupScopeLighting();
			}
		}

		if (bIsMounted && GearPawn(Instigator).bIsZoomed)
		{
			if (!bLaserIsOn)
			{
				TurnOnTargetingLaser();
			}
		}
	}

	simulated function EndState(name NextStateName)
	{
		super.EndState(NextStateName);

		bIsLockedOn=false;
		if ( NextStateName != 'WeaponFiring' )
		{
			SetOwnerNoSee(FALSE);
		}
	}
};


simulated state Reloading
{
	ignores ForceReload;

	simulated function BeginState(Name NextStateName)
	{
		super.BeginState(NextStateName);
		TurnOffTargetingLaser();
	}

	simulated function TargetingModeChanged(GearPawn P)
	{
		local GearPC PC;

		TimeSinceTargeting = WorldInfo.TimeSeconds;
		if( (Instigator != none) && GearPawn(Instigator).bIsZoomed )
		{
			// we want to leave zoomed state if we stop targeting, but stay zoomed across a reload
			// (which involves leaving targeting mode for a moment).
			PC = GearPC(GetWeaponController());
			if ( (PC != None) && !PC.bIsTargeting )
			{
				SetZoomed(FALSE,TRUE);
			}
		}
	}

	simulated function Tick(float DeltaTime)
	{
		RecalculateLaserLocation();
		Super.Tick(DeltaTime);
	}

	simulated function EndState(Name NextStateName)
	{
		super.EndState(NextStateName);
		//Reset the last mounted time, so you have to relock in
		LastMountedTime = WorldInfo.TimeSeconds;
		bIsLockedOn=false;
		if (bIsMounted)
		{
			TurnOnTargetingLaser();
		}
	}
}

/** Returns TRUE if gun is being mounted. Overridden from GearWeap_HeavyBase. */
simulated function bool IsBeingMounted()
{
	local GearPawn	MyGearPawn;

	MyGearPawn = GearPawn(Instigator);
	return (MyGearPawn != None) && !bIsMounted && MyGearPawn.IsDoingSpecialMove(SM_TargetHeavySniper);
}

/** Returns TRUE if gun is being unmounted. Overridden from GearWeap_HeavyBase. */
simulated function bool IsBeingUnMounted()
{
	local GearPawn	MyGearPawn;

	MyGearPawn = GearPawn(Instigator);
	return (MyGearPawn != None) && MyGearPawn.IsDoingSpecialMove(SM_UnMountHeavySniper);
}


simulated native function CollectImpacts(vector StartTrace, vector EndTrace, out array<ImpactInfo> ImpactList);

simulated function ImpactInfo CalcWeaponFire(vector StartTrace, vector EndTrace, optional out array<ImpactInfo> ImpactList, optional vector Extent)
{
	local ImpactInfo FirstImpact;
	local bool bRealHit;
	local int Idx;

	CollectImpacts(StartTrace, EndTrace, ImpactList);

	// find first hit that isn't "passthru" (e.g. a trigger)
	for (Idx=0; Idx<ImpactList.Length; ++Idx)
	{
		if (!PassThroughDamage(ImpactList[Idx].HitActor))
		{
			bRealHit = TRUE;
			FirstImpact = ImpactList[Idx];
			break;
		}
	}

	if (!bRealHit)
	{
		// no impact, do what Weapon.CalcWeaponFire does
		FirstImpact.HitLocation = EndTrace;
		FirstImpact.RayDir = Normal(EndTrace - StartTrace);
		FirstImpact.StartTrace = StartTrace;
	}

	return FirstImpact;
}

/** Hack for prototype weapon, so gun isn't upside down when mirrored. */
simulated function PerformWeaponAttachment(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
	local vector NewScale3D;

	super.PerformWeaponAttachment(MeshCpnt, SocketName);

	// Mirror weapon
	if( ShouldWeaponBeMirrored(GearPawn(Instigator)) )
	{
		NewScale3D = default.Mesh.Scale3D;
		NewScale3D.Z = -NewScale3D.Z;
		Mesh.SetScale3D( NewScale3D );
	}
}

/** Turns on the targetting laser */
simulated function TurnOnTargetingLaser()
{
	local GearPC PC;

	if (Instigator == None || bLaserIsOn || !HasAmmo(0))
	{
		return;
	}

	if (TargetingBeamLoopSound != None)
	{
		TargetingBeamLoopSound.Play();
	}
	if (TargetingBeamBeepLoopSound != none)
	{
		bShouldHearBeep = false;
		if (WorldInfo.GRI != None)
		{
			foreach WorldInfo.LocalPlayerControllers(class'GearPC',PC)
			{
				if (!WorldInfo.GRI.OnSameTeam(PC.Pawn, Instigator))
				{
					bShouldHearBeep = True;
					break;
				}
			}
		}
		if (bShouldHearBeep)
		{
			TargetingBeamBeepLoopSound.Play();
		}
	}

	TargetingBeamEmitter.SetHidden(FALSE);
	TargetingBeamEmitter.ActivateSystem();

	bLaserIsOn = true;
}

/** Turns off the targetting laser */
simulated function TurnOffTargetingLaser()
{
	if (TargetingBeamLoopSound != None)
	{
		TargetingBeamLoopSound.Stop();
	}
	if (TargetingBeamBeepLoopSound != none)
	{
		TargetingBeamBeepLoopSound.Stop();
	}
	if (TargetingBeamLockLoopSound != none)
	{
		TargetingBeamLockLoopSound.Stop();
	}

	// stop effects
	TargetingBeamEmitter.DeActivateSystem();
	TargetingBeamEmitter.SetHidden(TRUE);
	LockedTargetingBeamEmitter.DeActivateSystem();
	LockedTargetingBeamEmitter.SetHidden(TRUE);

	bLaserIsOn = false;
}

/**
 * Get Impact info on what the weapon is targeting at.
 * If a hit occurs, the function returns true and fills in Impact.
 * If no hit occurs, the function returns false and Impact is undefined.
 */
simulated function bool GetTraceImpact( out ImpactInfo Impact, out Vector NudgeLocation)
{
	local vector StartTrace, EndTrace;
	local Array<ImpactInfo>	ImpactList;
	local bool bHit;

	StartTrace	= (Instigator != None) ? Instigator.GetWeaponStartTraceLocation() : Location;
	EndTrace = StartTrace + Vector(Instigator.GetAdjustedAimFor(Self,StartTrace)) * GetTraceRange();
	Impact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);

	bHit = (Impact.HitLocation != EndTrace);
	if( bHit )
	{
		// nudge outward a little bit
		NudgeLocation = Impact.HitLocation + (Impact.HitNormal * NudgeDist);
	}

	return bHit;
}

/** Called when the aimlocation of the gearpawn_infantry holding this weapon has been updated
 *  Used by the heavy sniper to aim the targeting laser
 *  @param AimLocation - the point this weapon is aimed at
 */
simulated function AimLocationUpdated(vector AimLocation)
{
	TargetingBeamEmitter.SetVectorParameter('lock_on', AimLocation);
	LockedTargetingBeamEmitter.SetVectorParameter('lock_on', AimLocation);
	TargetingBeamLoopSound.Location = Instigator.Location;
}

/** Let the server know where you're aiming the laser
 *  @param AimLocation - the location you're aiming the laser at
 */
unreliable server function ServerUpdateAimLocation(Vector AimLocation)
{
	local GearPawn_Infantry GPI;

	GPI = GearPawn_Infantry(Instigator);
	if (GPI != none && (WorldInfo.TimeSeconds - LastAimLocationUpdateTime) >= MinTimeBetweenAimLocationUpdates)
	{
		LastAimLocationUpdateTime = WorldInfo.TimeSeconds;
		GPI.SetAimLocation(AimLocation);
	}
}

/** Function to recalculate the location the laser pointer is pointing at */
simulated function RecalculateLaserLocation()
{
	local GearPawn InstigatorGP;
	local GearPawn_Infantry GPI;
	local bool bHitSomething;
	local Vector NudgeLocation, MuzzleLoc;
	local ImpactInfo Impact;
	local Vector ScopeTarget;

	InstigatorGP = GearPawn(Instigator);
	if ( (InstigatorGP != None) && InstigatorGP.bIsTargeting )
	{
		TargetingBeamEmitter.bIgnoreHiddenActorsMembership = TRUE;
		LockedTargetingBeamEmitter.bIgnoreHiddenActorsMembership = TRUE;
	}
	else
	{
		TargetingBeamEmitter.bIgnoreHiddenActorsMembership = FALSE;
		LockedTargetingBeamEmitter.bIgnoreHiddenActorsMembership = FALSE;
	}
	//If the emitter is on....
	if (bLaserIsOn)
	{
		if (InstigatorGP != None && InstigatorGP.Controller != none)
		{
			//Trace out...
			bHitSomething = GetTraceImpact( Impact, NudgeLocation );
			//And get the point of impact
			if (bHitSomething)
			{
				ScopeTarget = Impact.HitLocation;
			}
			else
			{
				// just store the endtrace somewhere and use it here, instead of recalculating?
				MuzzleLoc = GetMuzzleLoc();
				ScopeTarget = MuzzleLoc + Vector(Instigator.GetAdjustedAimFor(Self,MuzzleLoc)) * GetTraceRange();
			}
			//Set the aim location to the point of impact, so it will be replicated
			GPI = GearPawn_Infantry(InstigatorGP);
			if (GPI != none)
			{
				GPI.SetAimLocation(ScopeTarget);
				if (Role != ROLE_Authority)
				{
					ServerUpdateAimLocation(ScopeTarget);
				}
			}
		}
	}
}

simulated function ProcessViewRotation(float DeltaTime, out rotator OutViewRot, out Rotator OutDeltaRot)
{
	local GearPC GPC;

	// Change scale if aiming
	GPC = GearPC(GetWeaponController());
	if (GPC != None && GPC.bIsTargeting)
	{
		// Scale player turning input
		OutDeltaRot *= AimedRotationScale;
	}
	super.ProcessViewRotation(DeltaTime, OutViewRot, OutDeltaRot);
}


/**
 * Force fire into the ground if the player is not zoomed
 */
simulated function Rotator GetAdjustedAim( vector StartFireLoc )
{
	local Rotator Aim;
	local GearPawn GP;

	Aim = super.GetAdjustedAim(StartFireLoc);

	GP = GearPawn(Instigator);
	if (GP != None && !GP.bIsZoomed)
	{
		Aim += UnaimedInaccuracyModifier;
	}

	return Aim;
}

/* When you drop the heavy sniper, please turn off the laser. It's very annoying */
reliable client function ClientWeaponThrown()
{
	Super.ClientWeaponThrown();
	TurnOffTargetingLaser();
}

/* Don't play impact FX on death */
simulated static function SpawnImpactFX(Pawn TheInstigator, GearWeapon Weapon, const class<GearDamageType> GearDmgType, const out ImpactInfo Impact, bool bFatalShot, bool bMeleeHit, bool bPlayExplosiveRadialDamageEffects, bool bSuppressImpactFXIn)
{
	if (!bFatalShot)
	{
		Super.SpawnImpactFX(TheInstigator, Weapon, GearDmgType, Impact, bFatalShot, bMeleeHit, bPlayExplosiveRadialDamageEffects, bSuppressImpactFXIn);
	}
}

defaultproperties
{
	WeaponStatName="HeavySniper"

	bIsSuppressive=FALSE
	bSniping=true
	bInstantHit=true
	bCanNegateMeatShield=true
	bIgnoresExecutionRules=true

	bWeaponCanBeReloaded=TRUE
	bAutoSwitchWhenOutOfAmmo=FALSE
	bSuperSteadyCamWhileTargeting=TRUE
	TargetingRotAdjustment=(Pitch=93,Yaw=65,Roll=0)

	AIRating=1.f

	// reloading weapon doesn't break targeting mode.
	bReloadingWeaponPreventsTargeting=TRUE
	bNoAnimDelayFiring=TRUE

	bAllowTracers=true
	bAlwaysSpawnTracerSmoke=true
	TracerType=WTT_Oneshot
	TracerTypeAR=WTT_Oneshot

	// easy on the autoaim, sniper is a precision weapon, esp when zoomed
	AimAssistScale=0.5f
	AimAssistScaleWhileTargeting=0.f


	InstantHitDamageTypes(0)=class'GDT_HeavySniperRifle'
	AmmoTypeClass=class'GearAmmoType_HeavySniperRifle'

	FireOffset=(X=105,Y=-2,Z=11)


	// Weapon Mesh
	Begin Object Name=WeaponMesh
	End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh

	PSC_ShellEject=PSC_WeaponShellCaseComp

	bKillDuringLevelTransition=TRUE

//	WeaponAnimType=EWAT_SniperRifle

	WeaponFireAnim="AR_Idle"
	WeaponReloadAnim="AR_Reload"
	WeaponReloadAnimFail="AR_Reload_Fail"

	BS_PawnWeaponReload={(Stance=((Slot=BS_Layer1,AnimName="ADD_EG_Reload"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_EG_Mid_Cov_Reload"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_EG_Std_Cov_Reload"))
		)}

	BS_PawnWeaponReloadFail={(Stance=((Slot=BS_Layer1,AnimName="ADD_EG_Reload_Fail"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_EG_Mid_Cov_Reload_Fail"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_EG_Std_Cov_Reload_Fail"))
		)}

	LC_EmisDefaultCOG=(R=1.0,G=3.0,B=10.0,A=1.0)
	LC_EmisDefaultLocust=(R=16.0,G=0.8,B=0.2,A=1.0)

	Recoil_Hand={(
				LocAmplitude=(X=-6,Y=0,Z=0),
				LocFrequency=(X=15,Y=0,Z=0),
				LocParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
				RotAmplitude=(X=3000,Y=0,Z=0),
				RotFrequency=(X=5,Y=0,Z=0),
				RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
				TimeDuration=0.33f
				)}

	Recoil_Spine={(
				RotAmplitude=(X=750,Y=0,Z=0),
				RotFrequency=(X=12,Y=0,Z=0),
				RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
				TimeDuration=0.67f
				)}


	RotAudioStartVelThreshold=1500.f
	RotAudioStopVelThreshold=100.f
	RotAudioVolumeVelRange=(X=5000.f,Y=15000.f)
	RotAudioVolumeRange=(X=0.1f,Y=1.f)

	NoAmmoFireSoundDelay=0.25f

	FireCameraShakeScaleRange=(X=1.f,Y=2.f)
	FireCameraShakeScaleMounted=0.5f

	WeaponID=WC_HeavySniperRifle

	Begin Object Name=ForceFeedbackWaveformShooting0
		Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.500)
	End Object

	// targeting beam emitter
	Begin Object Class=ParticleSystemComponent Name=TBParticleSystemComponent0
		bOwnerNoSee=TRUE
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	TargetingBeamEmitter=TBParticleSystemComponent0

	// targeting beam emitter
	Begin Object Class=ParticleSystemComponent Name=LTBParticleSystemComponent0
		bOwnerNoSee=TRUE
		bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	LockedTargetingBeamEmitter=LTBParticleSystemComponent0

	ScopeSocketName=Scope

	NudgeDist=30

	Begin Object Class=AudioComponent Name=TargetingBeamLoopSound0
		bUseOwnerLocation=false
	End Object
	TargetingBeamLoopSound=TargetingBeamLoopSound0
	Components.Add(TargetingBeamLoopSound0);

	Begin Object Class=AudioComponent Name=TargetingBeamBeepLoopSound0
		bUseOwnerLocation=false
	End Object
	TargetingBeamBeepLoopSound=TargetingBeamBeepLoopSound0

	Begin Object Class=AudioComponent Name=TargetingBeamLockLoopSound0
		bUseOwnerLocation=false
	End Object
	TargetingBeamLockLoopSound=TargetingBeamLockLoopSound0

	RespawnTime=60.0

	TimeBetweenUnableToFire=1.0

	bUseHeavySkelControl = FALSE
}
