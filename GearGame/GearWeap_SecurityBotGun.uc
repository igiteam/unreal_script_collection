/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GearWeap_SecurityBotGun extends GearWeapon;

/** TRUE when playing looping muzzle flash effect */
var()	bool		bPlayingMuzzleFlashEffect;


/** Looping SoundCue for ammo feeder. */
var protected const SoundCue BarrelSpinningLoopCue;
/** The AudioComponent that is used for the looping ammo loading sound **/
var protected AudioComponent BarrelSpinningLoopAC;

/** Set to true if the fire loop is playing */
var transient bool bPlayingFireLoop;

/** Looping SoundCue for firing. */
var protected const SoundCue FireLoopCue;
/** Looping SoundCue for firing. */
var protected const SoundCue FireLoopCue_Player;
/** Looping SoundCue for firing. */
var protected const SoundCue FireLoopCue_Squad;
/** The AudioComponent that is used for the looping shot sound **/
var protected AudioComponent FireLoopAC;

/** Sound to play when firing starts */
var const protected SoundCue FireStartCue;

/** final shot echo, play when firing stops.  nonlooping. */
var const protected SoundCue FireStopCue;
var const protected SoundCue FireStopCue_Player;
var const protected SoundCue FireStopCue_Squad;

/** Sound to play when firing stops due to overheating */
var protected const SoundCue FireStopCue_Overheat;

var protected const SoundCue CasingImpactCue;

/** Sound to play when ammo feed stops */
var protected const SoundCue BarrelSpinningStopCue;

/** Smoke emitter at the muzzle */
var ParticleSystemComponent		PSC_BarrelSmoke;

/** Tracks how long this weapon has been firing, in seconds. */
var protected transient float	FiringDuration;

/** Longest sustained firing burst before overheating, in seconds. */
var() protected const config float	MaxFiringTimeBeforeOverheat;

/** When gun overheats, how long you must wait until the gun begins to cool down again. */
var() protected const config float	OverheatPenaltyTime;

/** Whether the gun is overheated */
var protected transient bool		bOverheated;

/** How long it takes the barrel to cool down from fully heated, in seconds. */
var() protected const config float	CooldownTime;

/** How long it takes the barrel to cool down from fully heated while ActiveCooling(tm) is in effect, in seconds. */
var() protected const config float	CooldownTimeActiveCooling;

/** Whether active cooling is enabled */
var protected transient bool bActivelyCooling;

/** Sound loop to play while cooling */
var protected const SoundCue ActiveCoolingLoopCue;

/** Sound to play when starting active cooling */
var protected const SoundCue ActiveCoolingStartCue;

/** Sound to play when stopping active cooling */
var protected const SoundCue ActiveCoolingStopCue;

/** Reference to the active cooling sound loop */
var protected transient AudioComponent ActiveCoolingSteamAudioLoop;

replication
{
	if (Role == ROLE_Authority && bNetOwner)
		bOverheated;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	if( Instigator != None )
	{
		PerformWeaponAttachment(Instigator.Mesh);
	}
}

simulated function Vector GetMuzzleLoc()
{
	return GearPawn(Instigator).GetPhysicalFireStartLoc(FireOffset);
}


simulated event LocalActiveReloadSuccess( bool bDidSuperSweetReload );
simulated function ActiveReloadSuccess(bool bDidSuperSweetReload);
simulated function FailedActiveReload(bool bFailedActiveReload);
simulated function TimeWeaponEquipping()
{
	SetTimer( 0.0001f, FALSE, 'WeaponEquipped' );
	return;
}

simulated function PlayWeaponReloading()
{
	if( ReloadDuration > 0.f )
	{
		SetTimer( ReloadDuration, FALSE, nameof(EndOfReloadTimer) );
	}
	else
	{
		EndOfReloadTimer();
	}
}


simulated event AttachMuzzleEffectsComponents(SkeletalMeshComponent SkelMesh)
{
	local GearPawn	MeshOwner;


	MeshOwner = GearPawn(SkelMesh.Owner);
	//`log(GetFuncName()@self@SKelMesh@MeshOwner@MeshOwner.GetRightHandSocketName());
	if( MeshOwner != None )
	{
		Skelmesh.AttachComponentToSocket(PSC_BarrelSmoke, MeshOwner.GetRightHandSocketName());

		// attach muzzle flash emitter, and position to fire offset
		if( MuzzleFlash.MuzFlashEmitter != None && !SkelMesh.IsComponentAttached(MuzzleFlash.MuzFlashEmitter) )
		{
			SkelMesh.AttachComponentToSocket(MuzzleFlash.MuzFlashEmitter, MeshOwner.GetRightHandSocketName());
			HideMuzzleFlashEmitter();
		}

		// Muzzle Flash dynamic light
		if( MuzzleFlash.MuzzleFlashLight != None && !SkelMesh.IsComponentAttached(MuzzleFlash.MuzzleFlashLight) )
		{
			SkelMesh.AttachComponentToSocket(MuzzleFlash.MuzzleFlashLight, MeshOwner.GetRightHandSocketName());
		}

		// shell ejection
		if( PSC_ShellEject != None && !SkelMesh.IsComponentAttached(PSC_ShellEject) )
		{
			SkelMesh.AttachComponentToSocket(PSC_ShellEject, MeshOwner.GetRightHandSocketName());
			SkelMesh.bForceUpdateAttachmentsInTick=true;
			PSC_ShellEject.bJustAttached = true;
			HidePSC_ShellEject();
		}
	}
}


simulated function PerformWeaponAttachment(SkeletalMeshComponent MeshCpnt, optional Name BoneName)
{
	AttachMuzzleEffectsComponents(MeshCpnt);
}

simulated function DetachWeapon()
{
	local SkeletalMeshComponent	PawnMesh;

	Super.DetachWeapon();


	if( Instigator != None )
	{
		PawnMesh = Instigator.Mesh;
	}

	if( PawnMesh != None )
	{
		// shell eject particle system
		if( MuzzleFlash.MuzFlashEmitter != None && PawnMesh.IsComponentAttached(MuzzleFlash.MuzFlashEmitter) )
		{
			PawnMesh.DetachComponent(MuzzleFlash.MuzFlashEmitter);
		}

		if( MuzzleFlash.MuzzleFlashLight != None && PawnMesh.IsComponentAttached(MuzzleFlash.MuzzleFlashLight) )
		{
			PawnMesh.DetachComponent(MuzzleFlash.MuzzleFlashLight);
		}

		if( PSC_ShellEject != None && PawnMesh.IsComponentAttached(PSC_ShellEject) )
		{
			PawnMesh.DetachComponent(PSC_ShellEject);
		}
	}

	if( BarrelSpinningLoopAC != none )
	{
		BarrelSpinningLoopAC.FadeOut( 0.1f, 0.0f );
		BarrelSpinningLoopAC = None;
	}

	if( FireLoopAC != none )
	{
		bPlayingFireLoop = false;
		FireLoopAC.FadeOut( 0.1f, 0.0f );
		FireLoopAC = None;
	}
}

simulated function PlayShellCaseEject()
{
	// shell eject particle system
	if( PSC_ShellEject != None )
	{
		if (IsTimerActive( 'HidePSC_ShellEject' ))
		{
			ClearTimer( 'HidePSC_ShellEject' );
			if (PSC_ShellEject != none)
			{
				PSC_ShellEject.ActivateSystem();
				PSC_ShellEject.RewindEmitterInstances();
			}
		}

		if ( PSC_ShellEject.HiddenGame )
		{
			PSC_ShellEject.SetHidden( FALSE );
			PSC_ShellEject.ActivateSystem();
		}
	}
}


simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{

	//`log(GetFUncName()@self@Instigator);
	// Start muzzle flash effect
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		if( (Instigator != None) )
		{
			PlayShellCaseEject();

			if (Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
			{
				PlayerController(Instigator.Controller).ClientPlayForceFeedbackWaveform(WeaponFireWaveForm);
			}
		}

		// Play muzzle flash effect
		PlayMuzzleFlashEffect();
	}

	// Play fire effects for owned player
	if (WorldInfo.Netmode != NM_Client || (Instigator != None && Instigator.IsLocallyControlled()) || bDummyFireWeapon)
	{
		PlayOwnedFireEffects( FireModeNum, HitLocation );
	}

}

simulated function StartWeaponFireSoundLoop()
{
	FireLoopAC = GearWeaponPlaySoundLocalEx(FireLoopCue, FireLoopCue_Player, FireLoopCue_Squad, FireLoopAC, 0.1f);
}

simulated function EndWeaponFireSoundLoop()
{
	if( FireLoopAC != None )
	{
		FireLoopAC.FadeOut(0.2f, 0.0f);
	}
}

simulated function WeaponFired( byte FiringMode, optional vector HitLocation )
{
	//local Turret_TroikaBase Troika;
	Super.WeaponFired( FiringMode, HitLocation );

	if( !bSuppressAudio && !bPlayingFireLoop )
	{
		bPlayingFireLoop = true;
		GearWeaponPlaySoundLocal(FireStartCue,,,, 1.f);
		SetTimer(0.2, false, 'StartWeaponFireSoundLoop');
	}

	if (!PSC_BarrelSmoke.bSuppressSpawning)
	{
		PSC_BarrelSmoke.DeactivateSystem();
	}

	ClearTimer(nameof(ReallyStoppedFiring));
}

simulated function EndFiringSounds()
{
	// stop any firing or spinning up sounds
	if( bPlayingFireLoop )
	{
		bPlayingFireLoop = false;
		SetTimer(0.2, false, 'EndWeaponFireSoundLoop');

		/** last shot echo/tail off */
		GearWeaponPlaySoundLocal(FireStopCue, FireStopCue_Player, FireStopCue_Squad,, 1.f);
		GearWeaponPlaySoundLocal(CasingImpactCue);
	}
	GearWeaponPlaySoundLocal(BarrelSpinningStopCue);

}



simulated function ReallyStoppedFiring()
{
	EndFiringSounds();
	PSC_BarrelSmoke.ActivateSystem(TRUE);
}
simulated function WeaponStoppedFiring(byte FiringMode)
{
	Super.WeaponStoppedFiring(FiringMode);
	SetTimer(0.1f,FALSE,nameof(ReallyStoppedFiring));
}

/**
 * Whether the gun is heat limited or not
 *
 * @return TRUE to show we are heat limited
 */
simulated function bool IsHeatLimited()
{
	return TRUE;
}

/** Clear the overheat */
simulated protected function OverheatPenaltyExpired()
{
	bOverheated = FALSE;
}

/**
 * End active cooling if we started firing
 *
 * @param FiringMode - the new firing mode
 *
 * @param bViaReplication - if this change was generated by replication
 */
simulated function FireModeUpdated(byte FiringMode, bool bViaReplication)
{
	if (FiringMode == 0)
	{
		EndActiveCooling();
	}

	super.FireModeUpdated(FiringMode, bViaReplication);
}

/**
 * Update barrel heat
 *
 * @param DeltaTime - the length of the last frame
 */
simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	// keep track of firing duration and barrel heat
	if (IsFiring())
	{
		FiringDuration += DeltaTime;
		CurrentBarrelHeat += DeltaTime / MaxFiringTimeBeforeOverheat;
		CurrentBarrelHeat = FMin(CurrentBarrelHeat, 1.f);

		if (Instigator.IsLocallyControlled())
		{
			if ( (CurrentBarrelHeat >= 1.f) && !bOverheated )
			{
				// overheated!  stop firing and don't allow a restart for some time
				Overheated();
			}
		}
	}
	else
	{
		FiringDuration = 0.f;
		if (bActivelyCooling)
		{
			CurrentBarrelHeat -= DeltaTime / CooldownTimeActiveCooling;

			if (Instigator.IsLocallyControlled())
			{
				if (CurrentBarrelHeat <= 0.f)
				{
					EndActiveCooling();
				}
			}
		}
		else if (CooldownTime > 0.f)
		{
			CurrentBarrelHeat -= DeltaTime / CooldownTime;
		}
		CurrentBarrelHeat = FMax(CurrentBarrelHeat, 0.f);
	}
}

/**
 * Handle no reloading
 *
 * @param FireModeNum - the current fire mode
 */
simulated function ConsumeAmmo(byte FireModeNum)
{
	local int SpareAmmoUsed;

	Super.ConsumeAmmo(FireModeNum);

	// since we don't have a normal clip, draw directly from spare ammo until it is used up
	if (bInfiniteSpareAmmo)
	{
		AmmoUsedCount = 0;
	}
	else if (SpareAmmoCount > 0)
	{
		SpareAmmoUsed = Min(SpareAmmoCount, AmmoUsedCount);
		AmmoUsedCount -= SpareAmmoUsed;
		SpareAmmoCount -= SpareAmmoUsed;
	}
}

/**
 * Overridden to disallow firing while overheated.
 *
 * @param FireModeNum - the current fire mode
 */
simulated function BeginFire(byte FireModeNum)
{
	if (!bOverheated)
	{
		Super.BeginFire(FireModeNum);
	}
}

/**
 * Tell the server to toggle active cooling
 *
 * @param bActive - whether to enable or disable active cooling
 */
reliable server function ServerToggleActiveCooling(bool bActive)
{
	if (bActive != bActivelyCooling)
	{
		if (!bActive)
		{
			EndActiveCooling();
		}
		else
		{
			BeginActiveCooling();
		}
	}
}

/** Play the overheat sound, stop firing, and set the timer to expire the overheat */
simulated function Overheated()
{
	bOverheated = TRUE;
	WeaponPlaySound(FireStopCue_Overheat);
	StopFire(0);
	if (Role == ROLE_Authority)
	{
		SetTimer( OverheatPenaltyTime,, nameof(OverheatPenaltyExpired) );
		GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_GatlingOverheated, Instigator, None, 0.35f);
	}
	else
	if (Role < ROLE_Authority)
	{
		ServerOverheated();
	}
}

/** Let the server know that we overheated */
reliable server function ServerOverheated()
{
	Overheated();
}

/** Start active cooling */
simulated function BeginActiveCooling()
{
	bActivelyCooling = TRUE;
	ServerToggleActiveCooling(TRUE);

	ActiveCoolingSteamAudioLoop = GearWeaponPlaySoundLocalEx(ActiveCoolingLoopCue,,, ActiveCoolingSteamAudioLoop, 0.3f);
	WeaponPlaySound(ActiveCoolingStartCue);
}

/** Stop active cooling */
simulated function EndActiveCooling()
{
	if (bActivelyCooling)
	{
		// turn off hiss sound
		if (ActiveCoolingSteamAudioLoop != None)
		{
			ActiveCoolingSteamAudioLoop.FadeOut(0.3f, 0.f);
			ActiveCoolingSteamAudioLoop = None;

			WeaponPlaySound(ActiveCoolingStopCue);
		}

		// done
		bActivelyCooling = FALSE;
		ServerToggleActiveCooling(FALSE);
	}
}

simulated state Active
{
	/**
	 * Check for active cooling activation
	 *
	 * @param DeltaTime - the length of the last frame
	 */
	simulated function Tick(float DeltaTime)
	{
		local GearPlayerInput GPI;
		local bool bR1Pressed;

		// poll input directly, for more robustness with with respect to when the
		// R1 button goes up/down

		GPI = GetControllingPlayerInput();
		bR1Pressed = (GPI != None && GPI.IsButtonActive(GB_RightBumper)) || (GearAIController != None && GearAIController.bPerformActiveCooling);
		if (bActivelyCooling && !bR1Pressed)
		{
			EndActiveCooling();
		}
		else if (!bActivelyCooling && bR1Pressed && CurrentBarrelHeat > 0.0)
		{
			BeginActiveCooling();
		}

		Global.Tick(DeltaTime);
	}

	/**
	 * Make sure active cooling is disabled
	 *
	 * @param NextStateName - the state we're transitioning to next
	 */
	simulated function EndState(Name NextStateName)
	{
		//`log(WorldInfo.TimeSeconds@GetFuncName()@GetStateName()@`showvar(NextStateName));
		Super.EndState(NextStateName);

		EndActiveCooling();
	}
}

/** Reload if we get more ammo */
simulated function AmmoUpdated()
{
	local int AmmoReloaded;

	AmmoReloaded = Min(Min(SpareAmmoCount, WeaponMagSize), AmmoUsedCount);
	AmmoUsedCount -= AmmoReloaded;
	SpareAmmoCount -= AmmoReloaded;
}

defaultproperties
{
	// no reloading in the new "overheat" weapon concept
	bWeaponCanBeReloaded=FALSE

	// reloading weapon doesn't break targeting mode.
	bReloadingWeaponPreventsTargeting=FALSE

	AmmoTypeClass=class'GearAmmoType_AssaultRifle'

	BS_MeleeAttack.Empty()

	FireOffset=(X=32,Y=0,Z=0)

	// shell case ejection emitter
	Begin Object Name=PSC_WeaponShellCaseComp
		Template=ParticleSystem'COG_AssaultRifle.Effects.P_GOG_AssaultRifle_Shells'
		Translation=(X=16,Z=6)
	End Object
	PSC_ShellEject=PSC_WeaponShellCaseComp


	WeaponIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=222,V=100,UL=143,VL=46)
	AnnexWeaponIcon=(U=0,V=305,UL=128,VL=34)
	CrosshairIcon=Texture2D'Warfare_HUD.HUD.HUD_Xhair_COG_Assault'

	bInstantHit=true

	TracerType=WTT_Lancer
	TracerTypeAR=WTT_Lancer
	WeaponID=WC_SecurityBotGun

	bAllowTracers=TRUE

	InstantHitDamageTypes(0)=class'GDT_SecurityBotGun'
}
