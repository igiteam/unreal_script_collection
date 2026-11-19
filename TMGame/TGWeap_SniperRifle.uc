class TGWeap_SniperRifle extends TGWeapon;

/** sound of shells colliding against ground*/
var() protected const SoundCue				ShellCollisionSound;

/** FOV (in deg) of the zoomed state of this weapon */
var() protected const config float			ZoomFOV;

/** separate fire camera shake for zoomed mode, since the regular camera shake feels enormous when zoomed */
var() protected config ScreenShakeStruct	FireCameraShake_Zoomed;

/** Zoom in / out sounds **/
var protected const SoundCue				ZoomActivatedSound;
var protected const SoundCue				ZoomDeActivatedSound;

var float TimeSinceTargeting;

/**
 * adjustment applied to player rot to offset differences in camera loc.  goal is for
 * zoomed and unzoomed to aim at same place.  note that a constant offset isn't perfect
 * since offset should scale with target range, but this is easy and it helps.
 */
var() const rotator TargetingRotAdjustment;

simulated function float GetWeaponRating()
{
	local float Rating;

	Rating = Super.GetWeaponRating();

	// AI prefers sniper at long range
	if ( TGAI(Instigator.Controller) != None && Instigator.Controller.Enemy != None &&
		!TGAI(Instigator.Controller).IsShortRange(Instigator.Controller.Enemy.Location) )
	{
		Rating += 0.5;
	}

	return Rating;
}

simulated state MeleeAttacking
{
	simulated function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);
		SetZoomed(FALSE,TRUE);
	}
}

simulated function TargetingModeChanged(TGPawn P)
{
	TimeSinceTargeting = WorldInfo.TimeSeconds;
}
/**
 * State WeaponFiring
 * Fires a bullet at a time
 */
simulated state WeaponFiring
{
	simulated function TargetingModeChanged(TGPawn P)
	{
		local TGPC PC;

		TimeSinceTargeting = WorldInfo.TimeSeconds;
		if( (Instigator != none) && TGPawn(Instigator).bIsZoomed )
		{
			// we want to leave zoomed state if we stop targeting, but stay zoomed across a reload
			// (which involves leaving targeting mode for a moment).
			PC = TGPC(Instigator.Controller);
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
	if (TGPawn(Instigator) != None)
	{
		TGPawn(Instigator).SetWeaponAlert(8.f);
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
	local Emitter	TrailEmitter;
	local Vector	SpawnLoc;
	local Rotator	SpawnRot;

	SpawnLoc = GetMuzzleLoc() + vect(0,0,10); // move it up a little particle and socket interaction is a bit off

	if ( UseFirstPersonCamera() )
	{
		SpawnLoc -= vect(0,0,10);
	}

	// if we are on the client when we will not have correct HitLocation so we will calculate an
	// approximate one for our tracer to use.
	if( Role < ROLE_Authority )
	{
		HitLocation = SpawnLoc + vector(GetAdjustedAim(SpawnLoc)) * GetTraceRange();
	}

	SpawnRot = Rotator(HitLocation - SpawnLoc);

	TrailEmitter = GetImpactEmitter( ParticleSystem'COG_SniperRifle.Effects.P_COG_SniperRifle_Beam', SpawnLoc, SpawnRot );
	TrailEmitter.ParticleSystemComponent.SetFloatParameter('BeamLength', VSize(HitLocation - SpawnLoc));
	TrailEmitter.ParticleSystemComponent.ActivateSystem();

	super.PlayFireEffects(FireModeNum, HitLocation);
}

simulated function float GetPlayerAimError()
{
	local TGPawn GP;
	GP = TGPawn(Instigator);
	if (GP != None && WorldInfo.GRI.IsMultiplayerGame() && (!GP.bIsTargeting || TimeSince(TimeSinceTargeting) < 0.4f))
	{
		return WeaponAimError.Y;
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
		Instigator.WeaponStoppedFiring(self, FALSE);
	}

	StopFireEffects(FiringMode);

	/*
	// if we're not currently reloading our weapon, play idle animation
	if( FiringMode != RELOAD_FIREMODE )
	{
	TGPawn(Instigator).PlayWeaponStanceIdle();
	}
	*/

	// turn off shell eject particle system
	if( PSC_ShellEject != None )
	{
		PSC_ShellEject.DeActivateSystem();
		SetTimer( 3.0f, FALSE, nameof(HidePSC_ShellEject) );
	}
}


simulated function PlayMuzzleFlashEffect()
{
	// do not play the muzzle flash effect if you are zoomed and the local player
	if (Instigator == None || !Instigator.IsLocallyControlled() || !TGPawn(Instigator).bIsZoomed)
	{
		Super.PlayMuzzleFlashEffect();
	}
}


/**
 * Returns FOV, in deg, of this weapon when it is in targeting mode.
 */
simulated function float GetTargetingFOV(float BaseFOV)
{
	if (TGPawn(Instigator).bIsZoomed)
	{
		return ZoomFOV;
	}
	else
	{
		return Super.GetTargetingFOV(BaseFOV);
	}
}

/** Returns the value to scale the cross hair by */
simulated function float GetCrossHairScale()
{
	if( TGPawn(Instigator).bIsZoomed )
	{
		return 1.0f; // we have a new sniper reticle
	}
	else
	{
		return 0.7f;
	}
}

//simulated function Texture2D GetCrosshairIcon(TGPC PC, out float YOffset)
//{
//	return TGPawn(Instigator).bIsZoomed ? CrosshairIconSecondary : CrosshairIcon;
//}

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


/** Weapons get a crack at handling controls */
simulated function bool HandleButtonPress( coerce Name ButtonName )
{
	local TGPC		PC;
	local TGPawn	InstigatorWP;
	local rotator	RotAdj;

	if( !Super.HandleButtonPress(ButtonName) )
	{
		if ( InputCanZoom(ButtonName) )
		{
			PC = TGPC(Instigator.Controller);
			InstigatorWP = TGPawn(Instigator);

			//@todo should be able to click on R3 and zoom in target instantly
			if ( (PC != None) && (InstigatorWP != None) && PC.bIsTargeting && ( IsInState( 'MeleeAttacking' ) == FALSE ) )
			{
				SetZoomed(!TGPawn(Instigator).bIsZoomed, TRUE);

				// flip the yaw adjustment if player is mirrored
				RotAdj = TargetingRotAdjustment;

				if (InstigatorWP.bIsMirrored)
				{
					RotAdj.Yaw = -RotAdj.Yaw;
				}

				//if( TGPawn(Instigator).bIsZoomed )
				//{
				//	TGWeaponPlaySoundLocal(ZoomActivatedSound,, TRUE);
				//	PC.ExtraRot += RotAdj;
				//}
				//else
				//{
				//	TGWeaponPlaySoundLocal(ZoomDeactivatedSound,, TRUE);
				//	PC.ExtraRot -= RotAdj;
				//}

				return TRUE;
			}
		}
	}

	return FALSE;
}

//simulated function ScreenShakeStruct GetFireViewShake()
//{
//	return (TGPawn(Instigator).bIsZoomed ? FireCameraShake_Zoomed : FireCameraShake);
//}
//
/**
 * Zoomed sniper rifle wants first person camera.
 * @returns true if Weapon would like a first person camera to be used when targeting
 */
simulated function bool UseFirstPersonCamera()
{
	return TGPawn(Instigator).bIsZoomed;
}

/**
 * Notification from pawn that it has been unpossessed.
 */
function NotifyUnpossessed()
{
	SetZoomed(FALSE,TRUE);
}

simulated state Active
{
	simulated function Tick(float DeltaTime)
	{
		if( ShouldAutoReload() )
		{
			ForceReload();
		}

		Super.Tick(DeltaTime);
	}

	simulated function TargetingModeChanged(TGPawn P)
	{
		local TGPC PC;

		TimeSinceTargeting = WorldInfo.TimeSeconds;
		if( (Instigator != none) && TGPawn(Instigator).bIsZoomed )
		{
			// we want to leave zoomed state if we stop targeting, but stay zoomed across a reload
			// (which involves leaving targeting mode for a moment).
			PC = TGPC(Instigator.Controller);
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

	simulated function ForceReload()
	{
		// don't make it actually force for the sniper so we can stay zoomed as long as we want
		if (ShouldAutoReload())
		{
			Super.ForceReload();
		}
	}

	simulated function BeginState(name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		SetOwnerNoSee(TGPawn(Instigator).bIsZoomed);
	}

	simulated function EndState(name NextStateName)
	{
		super.EndState(NextStateName);

		if ( NextStateName != 'WeaponFiring' )
		{
			SetOwnerNoSee(FALSE);
		}
	}
}

simulated state Reloading
{
	ignores ForceReload;

	simulated function TargetingModeChanged(TGPawn P)
	{
		local TGPC PC;

		TimeSinceTargeting = WorldInfo.TimeSeconds;
		if( (Instigator != none) && TGPawn(Instigator).bIsZoomed )
		{
			// we want to leave zoomed state if we stop targeting, but stay zoomed across a reload
			// (which involves leaving targeting mode for a moment).
			PC = TGPC(Instigator.Controller);
			if ( (PC != None) && !PC.bIsTargeting )
			{
				SetZoomed(FALSE,TRUE);
			}
		}
	}
}

/*
simulated function LinearColor GetWeaponEmisColor_COG()
{
	return WorldInfo.Gears_COGWeapons.SniperRifle;
}

simulated function LinearColor GetWeaponEmisColor_Locust()
{
	return WorldInfo.Gears_LocustWeapons.SniperRifle;
}
*/

simulated function bool ShouldUseMuzzleFlashSocketForShellEjectAttach()
{
	return TRUE;
}

