/**
 * COG AR-15 Assault Rifle
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_AssaultRifle extends GearWeapon;

/** FOV (in deg) of the zoomed state of this weapon */
var() protected const float ZoomFOV;

var transient bool bStartedRipping;

var ForceFeedbackWaveForm RippingWaveForm;

/** AudioComponents to play sounds on */
var AudioComponent AC_IdleLoop;

var AudioComponent AC_RipLoop;
var SoundCue ChainSawRipLoopSound;

var	AudioComponent AC_SlashLoop;
var SoundCue ChainSawSlashLoopSound;

var SoundCue SpecialMeleeAttackIdleLoopSound;
var SoundCue SpecialMeleeAttackStopSound;
var SoundCue SpecialMeleeAttackSputterSound;


/** Temporarily disable blood FX for this attack? */
var transient bool bDisableChainsawBloodFX;

/** chainsaw-specific friction params */
var() config vector2d	SpecialMeleeAttackFrictionMultiplierRange;
var() config float		SpecialMeleeAttackPeakFrictionRadiusScale;
var() config float		SpecialMeleeAttackPeakFrictionHeightScale;


/** Whether or not this weapon should spawn a decal.  Perf improvement when the AI doesn't always spawn a decal.  Especially as most of them are behind you or on the cover in front of you **/
var bool bShouldSpawnDecal;

/** Audiocomponent for looping firing sound. */
var protected AudioComponent	FireLoopAC;

/** TRUE when playing looping muzzle flash effect */
var()	bool		bPlayingMuzzleFlashEffect;


/** The ChainSaw MaterialInstaneConstant**/
var MaterialInstanceConstant ChainSawMIC;


/** Effect to play when the chainsaw attack impacts the mob **/
var ParticleSystemComponent ChainSawImpactEffect;
var ParticleSystem ChainSawImpactEffect_FromForward;
var ParticleSystem ChainSawImpactEffect_FromBehind;
var ParticleSystem ChainSawImpactEffect_Lambent;
var ParticleSystem ChainSawImpactEffect_Former;
/** Whether or not this Chainsaw is sawing from behind **/
var bool bAttackFromBehind;

/** The PS to play when extreme content is off **/
var ParticleSystem ChainSawImpactEffect_NoGore;

var ParticleSystemComponent ChainSawSmokeEffect;

/** ChainSaw sounds */
var bool bPlayingSlashSound;
var SoundCue ChainsawSlashStartSound;
var SoundCue ChainsawSlashStopSound;


/** Chainsaw sputter sound.  We need our own audio component so that the sound is not played in the world and we hear it spatializing as we run **/
var	AudioComponent AC_SputterSound;

/** Chainsaw revving! **/
var bool bRevTapping;
var bool bRevHolding;
var bool bRevReady;

/** Muzzle smoke effect drop rate, in effects per seconds. */
var() private float			MuzzleSmokeRate;

var() protected const config float CameraFOVWhileChainsawing;

/** How much recoil should the gun reduce at full accuracy */
var protected config float FullAccurateRecoilPct;

/** How much aim error should the gun reduce when there's no heat */
var protected config float FullAccurateAimErrorPct;

/** Crosshair dot */
var protected const Texture2D CrosshairDot;

/** Active reload variants on the normal FireSound cues */
var	protected const SoundCue FireSoundAR;
var	protected const SoundCue FireSoundAR_Squad;
var	protected const SoundCue FireSoundAR_Player;



/**
 * Raise the aim error when heated up
 *
 * @return the modified aim error
 */
simulated function float GetPlayerAimError()
{
	return Super.GetPlayerAimError() * FMin(1.0f, FMax(CrosshairExpansionFiringTime / CrosshairExpansionTime, GearInventoryManager(InvManager).Accuracy) + FullAccurateAimErrorPct);
}

/**
 * Raise the recoil when heated up
 *
 * @return the modified recoil
 */
simulated function int GetWeaponRecoil()
{
	//`log(`showvar(FMax(CrosshairExpansionFiringTime / CrosshairExpansionTime, GearInventoryManager(InvManager).Accuracy)));

	return Super.GetWeaponRecoil() * FMin(1.0f, FMax(CrosshairExpansionFiringTime / CrosshairExpansionTime, GearInventoryManager(InvManager).Accuracy) + FullAccurateRecoilPct);
}

simulated event PostBeginPlay()
{
	// The muzzle flash hasn't been instanced yet, so make sure to access the archetype object as the default
	SkeletalMeshComponent(Mesh).AttachComponentToSocket(ChainSawImpactEffect, MuzzleFlashArchetype.MuzzleSocketName);
	SkeletalMeshComponent(Mesh).AttachComponentToSocket(ChainSawSmokeEffect, MuzzleFlashArchetype.MuzzleSocketName);

	ChainSawMIC = new(outer) class'MaterialInstanceConstant';
	ChainSawMIC.SetParent( Material'COG_AssaultRifle.BlurringBlades' );
	Mesh.SetMaterial( 1, ChainSawMIC );

	Super.PostBeginPlay();
}

simulated function Destroyed()
{
	if ( FireLoopAC != None )
	{
		FireLoopAC.FadeOut(0.2f,0.f);
		FireLoopAC = None;
	}

	// Shut down slash looping sound
	if( AC_SlashLoop != None )
	{
		AC_SlashLoop.FadeOut(0.2f, 0.f);
		AC_SlashLoop = None;
	}

	// Shut down rip looping sound
	if( AC_RipLoop != None )
	{
		AC_RipLoop.FadeOut(0.2f, 0.f);
		AC_RipLoop = None;
	}

	if( AC_SputterSound != None )
	{
		AC_SputterSound.FadeOut(0.2f, 0.f);
		AC_SputterSound = None;
	}

	Super.Destroyed();
}

simulated function PlayShellCaseEject()
{
	local GearPawn	GP;
	local Rotator	NewRot;

	// shell eject particle system
	if( (PSC_ShellEject != None) && (WorldInfo.NetMode != NM_DedicatedServer) )
	{
		GP = GearPawn(Instigator);

		// If pawn is mirrored, then mirror shell ejection Y axis as well
		if( GP != None )
		{
			// we need to manually flip the meshes on the emitters so they are not backwards
			if( GP.bIsMirrored )
			{
				PSC_ShellEject.SetVectorParameter( 'MeshOrientation', vect(1,1,1) );
			}
			else
			{
				PSC_ShellEject.SetVectorParameter( 'MeshOrientation', vect(0,0,0) );
			}

			// LAURENT: forced offsets, because Component.default.Property doesn't work ATM.
			if( GP.bIsMirrored )
			{
				NewRot.Yaw = 16384;
			}
			else
			{
				NewRot.Yaw = -16384;
			}

			if( PSC_ShellEject.Rotation != NewRot )
			{
				PSC_ShellEject.SetRotation(NewRot);
			}
		}

		if (IsTimerActive( 'HidePSC_ShellEject' ))
		{
			ClearTimer( 'HidePSC_ShellEject' );
			if (PSC_ShellEject != none)
			{
				PSC_ShellEject.ActivateSystem();
				PSC_ShellEject.RewindEmitterInstances();
			}
		}

		if (PSC_ShellEject.HiddenGame == TRUE)
		{
			PSC_ShellEject.SetHidden( FALSE );
			PSC_ShellEject.ActivateSystem();
		}
	}
}

simulated function FireModeUpdated(byte FiringMode, bool bViaReplication)
{
	if (GearPawn(Instigator) == None || !GearPawn(Instigator).bWantChainsawBash)
	{
		if (FiringMode == MELEE_ATTACK_FIREMODE)
		{
			StartBlade();
		}
		else if (PreviousFiringMode == MELEE_ATTACK_FIREMODE)
		{
			StopBlade();
		}
	}

	super.FireModeUpdated(FiringMode, bViaReplication);
}

simulated function float PlayMeleeAttackAnimation(GearPawn P)
{
	if (P.bWantChainsawBash)
	{
		return Super.PlayMeleeAttackAnimation(P);
	}
}

/** called by the client to indicate it wants to do the chainsaw melee bash instead of the chainsaw hold */
reliable server final function ServerSetChainsawBash(bool bNewWantChainsawBash)
{
	local GearPawn GP;

	GP = GearPawn(Instigator);
	if (GP != None)
	{
		GP.bWantChainsawBash = bNewWantChainsawBash;
	}
}

simulated function SendToFiringState(byte FireModeNum)
{
	if (FireModeNum == MELEE_ATTACK_FIREMODE)
	{
		// revert to default melee attack state when doing the chainsaw bash
		FiringStatesArray[FireModeNum] = (GearPawn(Instigator) != None && GearPawn(Instigator).bWantChainsawBash) ? 'MeleeAttacking' : default.FiringStatesArray[FireModeNum];
	}

	Super.SendToFiringState(FireModeNum);
}

simulated state ChainsawMeleeAttacking extends MeleeAttacking
{
	simulated function BeginState(Name PreviousStateName)
	{
		SetCurrentFireMode(MELEE_ATTACK_FIREMODE);

		DoChainsawSpecialMove();
	}

	/** attempts to do the chainsaw hold move, delaying the melee attack if it's not possible right now */
	simulated function DoChainsawSpecialMove(INT bShouldSkipIntro=0)
	{
		local GearPawn GP;

		GP = GearPawn(Instigator);
		if (GP != None)
		{
			if (GP.CanDoSpecialMove(SM_ChainsawHold))
			{
				MeleeAttackStarted();

				GP.DoSpecialMove(SM_ChainsawHold,,,bShouldSkipIntro);
				SetTimer(0.5f, false, nameof(EnableRev));

				if (Role == ROLE_Authority && !bSlaveWeapon)
				{
					// Alert AI about chainsaw sound and set timer for continuation of sound
					Instigator.MakeNoise(1.f, 'MeleeAttack');
					SetTimer(0.5f, true, nameof(SpecialMeleeAttackMakeNoiseTimer));
				}

				// if server or locally owned client
				if (GetWeaponController() != None)
				{
					// Set up chainsaw-specific friction params
					FrictionMultiplierRange = SpecialMeleeAttackFrictionMultiplierRange;
					PeakFrictionRadiusScale = SpecialMeleeAttackPeakFrictionRadiusScale;
					PeakFrictionHeightScale = SpecialMeleeAttackPeakFrictionHeightScale;
				}
			}
			else
			{
				// if we can't do the move yet, try again later
				SetTimer(0.03, false, nameof(DoChainsawSpecialMove));
			}
		}
	}

	simulated function EndState( Name NextStateName )
	{
		local GearPawn GP;
		//`log(self@GetStateName()@GetFuncName());

		// if server or locally owned client
		GP = GearPawn(Instigator);
		if (GetWeaponController() != None)
		{
			// Set up chainsaw-specific friction params
			FrictionMultiplierRange = default.FrictionMultiplierRange;
			PeakFrictionRadiusScale = default.PeakFrictionRadiusScale;
			PeakFrictionHeightScale = default.PeakFrictionHeightScale;
			// cancel out the hold special move
			if (GP != None)
			{
				GP.EndSpecialMove(SM_ChainsawHold);
			}
		}

		// stop the fx
		if (GP != None && !GP.IsDoingSpecialMove(SM_ChainsawAttack_Object) && !GP.IsDoingSpecialMove(SM_ChainsawAttack_Object_NoCamera))
		{
			//`log(`showvar(GP.SpecialMove));
			ChainSawImpactEffect.DeActivateSystem();
			StopBloodTrails( GearPawn(Instigator) );
		}

		// Prevent stale rev taps
		bRevTapping = FALSE;

		ClearTimer('SpecialMeleeAttackMakeNoiseTimer');

		Super.EndState( NextStateName );
	}

	simulated function bool HandleButtonPress( coerce Name ButtonName )
	{
		if( ButtonName == 'R2' )
		{
			// just rev
			bRevTapping = TRUE;
			return TRUE;
		}
		else
		{
			return Global.HandleButtonPress(ButtonName);
		}
	}

	simulated function Tick( float DeltaTime )
	{
		local GearPC PC;
		local GearPawn GP;

		Super.Tick( DeltaTime );

		GP = GearPawn(Instigator);
		PC = GearPC(GetWeaponController());
		if( PC != None && PC.IsLocalPlayerController() )
		{
			if (bRevTapping && bRevReady && GP != None && GP.IsDoingSpecialMove(SM_ChainsawHold))
			{
				bRevTapping = FALSE;
				bRevReady = FALSE;
				SetTimer( 0.85f,FALSE,nameof(EnableRev) );
				WeaponPlaySound(SoundCue'Weapon_AssaultRifle.Melee.ChainsawRevMediumCue');
				if (bSlaveWeapon)
				{
					ServerDoChainsawRev();
				}
			}
		}

		// Pawn should always be doing a special move in that state.
		// Catch when we keep holding the melee button after a successful chainsaw. We should get back in the hold special move.
		if( !GP.IsDoingASpecialMove() )
		{
			DoChainsawSpecialMove(1);   // resume and skip hold intro
		}
    }

	// When melee button is released, we go back to the active state.
	// There is code in GearPawn::Tick() to prevent the button from being released if we're in the middle of an attack
	simulated function EndFire(byte FireModeNum)
	{
		Super.EndFire(FireModeNum);

		if (FireModeNum == CurrentFireMode)
		{
			GotoState('Active');
		}
	}
}

unreliable server function ServerDoChainsawRev()
{
	WeaponPlaySound(SoundCue'Weapon_AssaultRifle.Melee.ChainsawRevMediumCue');
}

simulated function EnableRev()
{
	bRevReady = TRUE;
}

/** @see AGearWeapon::PlayFireEffects */
simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{
	super.PlayFireEffects( FireModeNum, HitLocation );

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		// Play looping weapon fire animation
		if( !IsPlayingAnim(WeaponFireAnim, TRUE) )
		{
			PlayWeaponAnim(WeaponFireAnim, 1.f, 0.f, 0.f, TRUE);
		}
	}
}

simulated function PlayMuzzleFlashEffect()
{
	if( !bPlayingMuzzleFlashEffect && !bSuppressMuzzleFlash && IsMuzzleFlashRelevant() )
	{
		bPlayingMuzzleFlashEffect = TRUE;

		// activate muzzle flash particle system
		if( MuzzleFlash.MuzFlashEmitter != None )
		{
			ClearTimer( 'HideMuzzleFlashEmitter' );
			MuzzleFlash.MuzFlashEmitter.SetHidden( FALSE );
			MuzzleFlash.MuzFlashEmitter.ActivateSystem();
		}

		if( MuzzleFlash.MuzzleFlashLight != None && !GearGRI(WorldInfo.GRI).ShouldDisableEffectsDueToFramerate(Instigator) )
		{
			MuzzleFlash.MuzzleFlashLight.SetEnabled(TRUE);
		}
	}
}

simulated function WeaponStoppedFiring( byte FiringMode )
{
	super.WeaponStoppedFiring( FiringMode );

	// Stop playing weapon animation.
	FreezeWeaponAnim();

	if( bPlayingMuzzleFlashEffect )
	{
		bPlayingMuzzleFlashEffect = FALSE;

		// deactivate muzzle flash particle system
		if( MuzzleFlash.MuzFlashEmitter != None )
		{
			MuzzleFlash.MuzFlashEmitter.DeActivateSystem();
			SetTimer( 0.1f, FALSE, nameof(HideMuzzleFlashEmitter) );
		}

		// turn off muzzle flash light
		if( MuzzleFlash.MuzzleFlashLight != None )
		{
			MuzzleFlash.MuzzleFlashLight.SetEnabled(FALSE);
		}
	}
}


simulated function MeleeImpactNotify(GearAnimNotify_MeleeImpact Notify)
{
	local GearPawn GP;

	GP = GearPawn(Instigator);
	if (GP != None && GP.bWantChainsawBash)
	{
		Super.MeleeImpactNotify(Notify);
	}
	else if (Notify.bImpactStart)
	{
		if (!bStartedRipping)
		{
			//`log(WorldInfo.TimeSeconds@`location@`showvar(ChainsawImpactEffect.Template)@`showvar(Notify.bImpactStart));
			if (GP != None && (GP.IsDoingSpecialMove(SM_ChainsawAttack) || GP.IsDoingSpecialMove(SM_ChainsawAttack_Object) || GP.IsDoingSpecialMove(SM_ChainsawAttack_Object_NoCamera)))
			{
				// start the ripping fx/sounds
				StartRipping();
				bStartedRipping = TRUE;
			}
		}
	}
	else
	{
		if (bStartedRipping)
		{
			//`log(WorldInfo.TimeSeconds@`location@`showvar(ChainsawImpactEffect.Template)@`showvar(Notify.bImpactStart));
			// locally stop the fx
			StopRipping();

			// forward to the special move so it can kill the victim, etc
			if (GP != None && GP.IsDoingSpecialMove(SM_ChainsawAttack))
			{
				GSM_ChainsawAttack(GP.SpecialMoves[SM_ChainsawAttack]).ChainsawAnimNotify();
			}
			else if (GP != None && (GP.IsDoingSpecialMove(SM_ChainsawAttack_Object) || GP.IsDoingSpecialMove(SM_ChainsawAttack_Object_NoCamera)))
			{
				GSM_ChainsawAttack_Object(GP.SpecialMoves[SM_ChainsawAttack_Object]).ChainsawAnimNotify();
			}
			bStartedRipping = FALSE;
		}
		else
		{
			SetTimer(0.5f,FALSE,nameof(StopSlashing));
		}
	}
}

function StartAttackObject(bool bSkipBlood, ParticleSystem OverrideFX)
{
	StartSlashing(bSkipBlood,OverrideFX);
	if (Role == ROLE_Authority && !Instigator.IsLocallyControlled())
	{
		ClientStartAttackObject(bSkipBlood,OverrideFX);
	}
}

reliable client function ClientStartAttackObject(bool bSkipBlood, ParticleSystem OverrideFX)
{
	StartSlashing(bSkipBlood,OverrideFX);
}

/** Starts the slashing sound (from an attack), and sets a timer to trigger the looping cue. */
simulated function StartSlashing(optional bool bSkipBlood, optional ParticleSystem OverrideFX)
{
	bDisableChainsawBloodFX = bSkipBlood;
	// always set this even if none - normal chainsaws will choose from the _FromForward/_FromBehind
	ChainsawImpactEffect.SetTemplate(OverrideFX);
	// Play looping sound
	WeaponPlaySound(ChainsawSlashStartSound);
	SetTimer( ChainsawSlashStartSound.GetCueDuration(), FALSE, nameof(StartSlashLoop) );
}

/** Starts the looping slash audio. */
simulated function StartSlashLoop()
{
	if( AC_SlashLoop == None )
	{
		AC_SlashLoop = GearWeaponPlaySoundLocalEx(ChainSawSlashLoopSound,,, AC_SlashLoop, 0.1f);
	}
}

/** Stops the loop and plays the outro sound cue */
simulated function StopSlashing()
{
	if( AC_SlashLoop != None )
	{
		AC_SlashLoop.FadeOut(0.2f,0.f);
		AC_SlashLoop = None;
	}

	ClearTimer(nameof(StartSlashLoop));
	ClearTimer(nameof(StopSlashing));

	// kick off the slash stop sound
	WeaponPlaySound(ChainsawSlashStopSound);

	// reset the blood flag since it's a one-time usePawnOwner.TargetedGDO == None
	bDisableChainsawBloodFX = default.bDisableChainsawBloodFX;
}

/** Starts the ripping sound/fx (once an attack connects, called from anim notify) */
simulated function StartRipping()
{
	local GearPawn GP;
	local SoundCue RipLoop;
	local GearPC PCOwner;
	local GearPC PCFollower;

	GP = GearPawn(Instigator);
	PCOwner = GearPC(GP.Controller);
	if( AC_RipLoop == None )
	{
		if ( (GP != None) && (GP.TargetedGDO != None) )
		{
			RipLoop = GP.TargetedGDO.ChainSawRipSound;
		}
		if ( GP != None && (GP.IsDoingSpecialMove(SM_ChainsawAttack_Object) || GP.IsDoingSpecialMove(SM_ChainsawAttack_Object_NoCamera)))
		{
			RipLoop = GSM_ChainsawAttack_Object(GP.SpecialMoves[GP.SpecialMove]).ChainsawTrigger.ChainSawRipSound;
		}
		if (RipLoop == None)
		{
			RipLoop = ChainSawRipLoopSound;
		}
		AC_RipLoop = GearWeaponPlaySoundLocalEx(RipLoop,,, AC_RipLoop, 0.2f);
		if (PCOwner != None && PCOwner.IsLocalPlayerController())
		{
			PCOwner.ClientPlayForceFeedbackWaveform(RippingWaveForm);
		}

		if (GP.IsDoingSpecialMove(SM_ChainsawAttack))
		{
			PCFollower = GearPC(GSM_ChainSawAttack(GP.SpecialMoves[GP.SpecialMove]).Follower.Controller);
			if (PCFollower != None && PCFollower.IsLocalPlayerController())
			{
				PCFollower.ClientPlayForceFeedbackWaveform(RippingWaveForm);
			}
		}
	}

	//@note - if this flag is set then we've most likely set an override template already (@see StartSlashing), so don't break it!
	if (!bDisableChainsawBloodFX)
	{
		if (WorldInfo.GRI.ShouldShowGore())
		{
			if (GP != None && GP.InteractionPawn != None && GearPawnFX_Former(GP.InteractionPawn.GearPawnFX) != None)
			{
				ChainSawImpactEffect.SetTemplate(ChainSawImpactEffect_Former);
			}
			else if (GP != None && GP.InteractionPawn != None && GearPawnFX_Lambent(GP.InteractionPawn.GearPawnFX) != None)
			{
				ChainSawImpactEffect.SetTemplate(ChainSawImpactEffect_Lambent);
			}
			else if (!bAttackFromBehind)
			{
				ChainSawImpactEffect.SetTemplate(ChainSawImpactEffect_FromForward);
			}
			else
			{
				ChainSawImpactEffect.SetTemplate(ChainSawImpactEffect_FromBehind);
			}
			if (GP != None)
			{
				if (GP.InteractionPawn != None)
				{
					GP.InteractionPawn.StartBloodTrail('SpawnABloodTrail_ChainsawSpray_Ground', 0.05);
					GP.InteractionPawn.StartBloodTrail('SpawnABloodTrail_ChainsawSpray_Wall');
				}
				else
				{
					GP.StartBloodTrail('SpawnABloodTrail_ChainsawSpray_Ground', 0.05);
					GP.StartBloodTrail('SpawnABloodTrail_ChainsawSpray_Wall');
				}
			}
		}
		else
		{
			ChainSawImpactEffect.SetTemplate( ChainSawImpactEffect_NoGore );
		}
	}
	// if we have a template then show the FX
	if (ChainsawImpactEffect.Template != None)
	{
		ChainSawImpactEffect.SetHidden( FALSE );
		ChainSawImpactEffect.ActivateSystem();
	}
}

/** Stops the ripping loop sound, and hides blood */
simulated function StopRipping()
{
	local GearPawn GP;
	local GearPC PCOwner;
	local GearPC PCFollower;

	if( AC_RipLoop != None )
	{
		AC_RipLoop.FadeOut(0.2f,0.f);
		AC_RipLoop = None;
	}

	PCOwner = GearPC(GetWeaponController());
	if (PCOwner != None && PCOwner.IsLocalPlayerController())
	{
		PCOwner.ClientStopForceFeedbackWaveform(RippingWaveForm);
	}

	GP = GearPawn(Instigator);
	if (GP != None && GP.IsDoingSpecialMove(SM_ChainsawAttack))
	{
		PCFollower = GearPC(GSM_ChainSawAttack(GP.SpecialMoves[GP.SpecialMove]).Follower.Controller);
		if (PCFollower != None && PCFollower.IsLocalPlayerController())
		{
			PCFollower.ClientStopForceFeedbackWaveform(RippingWaveForm);
		}
	}

	ChainSawImpactEffect.DeActivateSystem();
	// Stop the slash altogether (only if it's started, ignore if we got interrupted)
	if( AC_SlashLoop != None || IsTimerActive('StartSlashLoop') )
	{
		SetTimer( 0.5f, FALSE, nameof(StopSlashing) );
	}

	StopBloodTrails( GearPawn(Instigator) );
}

simulated function StopBloodTrails( GearPawn TheOwner )
{
	if( TheOwner != none )
	{
		TheOwner.StopBloodTrail( 'SpawnABloodTrail_ChainsawSpray_Ground' );
		TheOwner.StopBloodTrail( 'SpawnABloodTrail_ChainsawSpray_Wall' );
	}
}

/* Start Idle chainsaw sound **/
simulated function StartIdleSound()
{
	// Play Idle looping sound
	if( AC_IdleLoop == None )
	{
		AC_IdleLoop = GearWeaponPlaySoundLocalEx(SpecialMeleeAttackIdleLoopSound,,, AC_IdleLoop, 0.3f);
	}
}

/** Starts the blade spinning */
simulated function StartBlade()
{
	ClearTimer('HalfStopBlade');
	ClearTimer('FullStopBlade');
	// don't go 1.0, the aliasing causing it to look go backward - in Xbox
	ChainSawMIC.SetScalarParameterValue( 'BladeSpeed', 0.7f);

	// delay idle sound coming in
	SetTimer(0.5f, FALSE, 'StartIdleSound');

	// start the smoke
	ClearTimer( 'HideSmokeEffect' );
	ChainSawSmokeEffect.SetHidden( FALSE );
	ChainSawSmokeEffect.ActivateSystem();
}

/** Stops the blade spinning */
simulated function StopBlade()
{
	ChainSawMIC.SetScalarParameterValue( 'BladeSpeed', 0.7f);
	SetTimer( 1.0f, false, nameof(HalfStopBlade) );
	SetTimer( 2.0f, FALSE, nameof(FullStopBlade) );

	ClearTimer('StartIdleSound');
	// Shut down idle looping sound
	if( AC_IdleLoop != None )
	{
		AC_IdleLoop.FadeOut(0.2f, 0.f);
		AC_IdleLoop = None;
	}
	// clear the smoke
	ChainSawSmokeEffect.DeActivateSystem();
	SetTimer( 2.0f, FALSE, nameof(HideSmokeEffect) );
}

simulated function HalfStopBlade()
{
	ChainSawMIC.SetScalarParameterValue( 'BladeSpeed', 0.25f);
}
simulated function FullStopBlade()
{
	ChainSawMIC.SetScalarParameterValue( 'BladeSpeed', 0.0f);
}

simulated function HideSmokeEffect()
{
	ChainSawSmokeEffect.SetHidden( TRUE );
}

reliable client function ClientForceEndMelee()
{
	EndFire(MELEE_ATTACK_FIREMODE);
}

simulated function StartFire(byte FireModeNum)
{
	local Actor Target;
	local GearPawn GP;

	// don't bother firing if the enemy is really far away
	if (GearAIController != None && FireModeNum == 0)
	{
		Target = (GearAIController.FireTarget != None) ? GearAIController.FireTarget : GearAIController.Enemy;
		if (Target != None && VSize(Target.Location - GearAIController.Pawn.Location) > Range_Long * 1.5)
		{
			return;
		}
	}

	// disallow melee if chainsaw is interrupted
	if (FireModeNum == MELEE_ATTACK_FIREMODE)
	{
		GP = GearPawn(Instigator);
		if (GP != None)
		{
			// decide if we should do the bash attack instead based on what is nearby
			GP.bWantChainsawBash = ShouldChainsawBash();
			if (Role < ROLE_Authority)
			{
				ServerSetChainsawBash(GP.bWantChainsawBash);
			}
		}
	}

	Super.StartFire(FireModeNum);
}

/** Check if the regular melee attack should be used instead of starting the chainsaw */
simulated function bool ShouldChainsawBash()
{
	local Actor A;
	local GearPawn GP, OtherGP;

	GP = GearPawn(Instigator);

	foreach GP.VisibleCollidingActors(class'Actor', A, MeleeAttackRange)
	{
		OtherGP = GearPawn(A);
		if (OtherGP != None)
		{
			if (OtherGP.IsGameplayRelevant() && !WorldInfo.GRI.OnSameTeam(OtherGP, GP))
			{
				if (vector(GP.Rotation) dot Normal(OtherGP.Location - GP.Location) >= 0)
				{
					if (OtherGP.IsDBNO())
					{
						return true;
					}

					// Revert to regular melee if a pawn doesn't accept special melees at this time
					if (!OtherGP.CanBeSpecialMeleeAttacked(GP))
					{
						return true;
					}
				}

				if (GearAIController != None && OtherGP.IsHumanControlled())
				{
					// Casual players don't want to be chainsaw'd by the AI
					if (!GearPRI(OtherGP.PlayerReplicationInfo).Difficulty.default.bHumanCOGCanBeExecuted)
					{
						return true;
					}

					// Horde and campaign players don't want to be chainsaw'd without having the AI rev the saw first
					if ( (!WorldInfo.GRI.IsMultiplayerGame() || WorldInfo.GRI.IsCoopMultiplayerGame()) &&
						GearAIController.FindCommandOfClass(class'AICmd_Base_Melee') == None )
					{
						return true;
					}
				}

				// AI needs to bash formers instead of trying to chainsaw because they get hit by former too fast, which stops the chainsaw chargeup
				// They'll loop forever trying to hit formers and just get smacked to death (ohnoes!)
				if( GearAIController != None && GearPawn_LambentHumanBase(OtherGP) != None )
				{
					return TRUE;
				}
			}
		}
		else if (GearFortification(A) != None && !WorldInfo.GRI.OnSameTeam(A, GP))
		{
			return true;
		}
	}

 	return false;
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

	// Attach magazine mesh to left hand
	SetPawnAmmoAttachment(TRUE);
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

/**
 * Event called when melee attack begins.
 * This means when weapon is entering melee attacking state on local player and server.
 * When Pawn.FiringMode == MELEE_ATTACK_FIREMODE is replicated on remote clients.
 */
simulated function MeleeAttackStarted()
{
	if (GearPawn(Instigator).bWantChainsawBash)
	{
		bUseMeleeHitTimer = true;
		Super.MeleeAttackStarted();
	}
	else
	{
		bUseMeleeHitTimer = false;
		// Forward event to pawn owner
		GearPawn(Instigator).MeleeAttackStarted(self);
	}
}

/**
 * Play Melee Attack
 * This function plays the melee attack animation
 * and sets a timer to call EndOfMeleeAttack(), which will trigger this end of the move
 * (and state transition).
 */
simulated function PlayMeleeAttack()
{
	local GearPawn P;

	P = GearPawn(Instigator);
	if (P.bWantChainsawBash)
	{
		bSuppressMeleeAttackCameraBoneAnim = TRUE;

		Super.PlayMeleeAttack();
	}
	else
	{
		bSuppressMeleeAttackCameraBoneAnim = FALSE;

		Super.PlayMeleeAttack();

		P.SoundGroup.PlayEffort(P, GearEffort_ChainSawAttackEffort, true);

		WeaponPlaySound(SoundCue'Weapon_AssaultRifle.Melee.ChainsawSlashStart01Cue');
	}
}

simulated function SpecialMeleeAttackMakeNoiseTimer()
{
	// sometimes you can get your gun into a state where it is stuck in MeleeAttacking with no owner
	if( Instigator == None )
	{
		ClearTimer('SpecialMeleeAttackMakeNoiseTimer');
	}
	else
	{
		Instigator.MakeNoise( 0.75f, 'SpecialMeleeAttackMakeNoiseTimer' );
	}
}

/*
 * For AI controlled weapons we only spawn 1/2 decals.  For Human players we spawn 1/1 decals
 *
 * This will spawn a PhysicalMaterial based effect.	 It looks up the PhysicalMaterial
 * tree until it finds a valid effect to Spawn.	 If it does not find one then
 * it defaults the effect coded in to the .uc file for that specific weapon
 * @param TheInstigator - Pawn that fired the weapon (none from dummy fire)
 * @param Weapon - Reference to weapon (dummy fire has a weapon but no instigator, so Instigator.Weapon is not possible)
 * @param GearDmgType - damage type reference for effects
 * @param Impact - information about the impact
 * @param PhysMaterial - physical material properties for the impact
 */
simulated static function SpawnImpactDecal( Pawn TheInstigator, GearWeapon Weapon, const class<GearDamageType> GearDmgType, const out ImpactInfo Impact, PhysicalMaterial PhysMaterial )
{
	local GearWeap_AssaultRifle AR;

	// always spawn a decal for the local player
	if( TheInstigator != None && TheInstigator.IsHumanControlled() && TheInstigator.IsLocallyControlled() )
	{
		Super.SpawnImpactDecal( TheInstigator, Weapon, GearDmgType, Impact, PhysMaterial );
	}
	// 50% of the time spawn a decal for others
	else
	{
		AR = GearWeap_AssaultRifle(Weapon);
		if( AR == None || AR.bShouldSpawnDecal )
		{
			Super.SpawnImpactDecal( TheInstigator, Weapon, GearDmgType, Impact, PhysMaterial );
		}

		if (AR != None)
		{
			AR.bShouldSpawnDecal = !AR.bShouldSpawnDecal;
		}
	}
}

function float GetAIMeleeAttackRange()
{
	// override to the distance that GSM_ChainsawHold checks for targets
	return 95.0; // 64.0 sphere check, but it uses overlap so add in smallest cylinder radius
}

simulated function SetActiveReloadEffectsActive(bool bActive)
{
	super.SetActiveReloadEffectsActive(bActive);

	if (FireLoopAC != None)
	{
		if (bActiveReloadVisualEffectsActive)
		{
			// ensure playing AR sound
			if ( (FireLoopAC.SoundCue != FireSoundAR_Player) && (FireLoopAC.SoundCue != FireSoundAR_Squad) && (FireLoopAC.SoundCue != FireSoundAR) )
			{
				// stop current
				FireLoopAC.FadeOut(0.25f, 0.f);
				FireLoopAC.bAutoDestroy = true;
				FireLoopAC = None;

				// start new
				PlayFireSound();
			}
		}
		else
		{
			// ensure not playing AR sound
			if ( (FireLoopAC.SoundCue == FireSoundAR_Player) || (FireLoopAC.SoundCue == FireSoundAR_Squad) || (FireLoopAC.SoundCue == FireSoundAR) )
			{
				// stop current
				FireLoopAC.FadeOut(0.25f, 0.f);
				FireLoopAC.bAutoDestroy = true;
				FireLoopAC = None;

				// start new
				PlayFireSound();
			}
		}
	}

}

simulated protected function PlayFireSound()
{
	if (FireLoopAC == None || !FireLoopAC.IsPlaying())
	{
		// start loop
		if (bActiveReloadVisualEffectsActive)
		{
			FireLoopAC = GearWeaponPlaySoundLocalEx(FireSoundAR, FireSoundAR_Player, FireSoundAR_Squad, FireLoopAC);
		}
		else
		{
			FireLoopAC = GearWeaponPlaySoundLocalEx(FireSound, FireSound_Player, FireSound_Squad, FireLoopAC);
		}
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

/**
 * Stop the looping fire sound
 *
 * @param FireModeNum - the current fire mode
 */
simulated function StopFireEffects(byte FireModeNum)
{
	super.StopFireEffects(FireModeNum);

	if (FireModeNum == 0)
	{
		StopFireLoopingAudio();
	}
}

/** Stop the fire loop and play the stop fire sound */
simulated protected function StopFireLoopingAudio()
{
	if (FireLoopAC != None)
	{
		FireLoopAC.FadeOut(0.1f, 0.f);
		FireLoopAC = None;
		
		if (IsFiring() || (bSlaveWeapon && !IsInState('WeaponEquipping')))
		{
			GearWeaponPlaySoundLocal(StopFireSound, StopFireSound_Player, StopFireSound_Squad);
		}
	}
}

simulated function float GetAdjustedFOV(float BaseFOV)
{
	if ( (CurrentFireMode == MELEE_ATTACK_FIREMODE) )
	{
		return CameraFOVWhileChainsawing;
	}

	return BaseFOV;
}

simulated event PostDemoRewind()
{
	Super.PostDemoRewind();

	// force muzzle flash to restart if we're still firing
	bPlayingMuzzleFlashEffect = false;
}

/** Weapons get a crack at handling controls */
simulated function bool HandleButtonPress( coerce Name ButtonName )
{
	local GearPC PC;
	local GearPawn InstigatorGP;

	if( super.HandleButtonPress( ButtonName ) == FALSE )
	{
		if( bCanDoIronSights && InputCanZoom(ButtonName) )
		{
			PC = GearPC(GetWeaponController());
			InstigatorGP = GearPawn(Instigator);

			//@todo should be able to click on R3 and zoom in target instantly
			if ( (PC != None) && (InstigatorGP != None) && (PC.bIsTargeting || InstigatorGP.IsDeployingShield()) )
			{
				SetZoomed(!GearPawn(Instigator).bIsZoomed);

// 				if( GearPawn(Instigator).bIsZoomed == TRUE )
// 				{
// 					GearWeaponPlaySoundLocal(ZoomActivatedSound,, TRUE);
// 				}
// 				else
// 				{
// 					GearWeaponPlaySoundLocal(ZoomDeactivatedSound,, TRUE);
// 				}

				return TRUE;
			}
		}
	}

	return FALSE;
}

/**
 * Returns FOV, in deg, of this weapon when it is in targeting mode.
 */
simulated function float GetTargetingFOV( float BaseFOV )
{
	if( bCanDoIronSights && GearPawn(Instigator).bIsZoomed == TRUE )
	{
		return ZoomFOV;
	}
	else
	{
		return Super.GetTargetingFOV( BaseFOV );
	}
}

/**
 * Draw the center dot
 *
 * @param HUD - the HUD to draw on
 */
simulated function DrawAdditionalCrosshair(GearHUD_Base HUD)
{
	local float XL, YL;
	local float Alpha;

	if (CrosshairDot != None)
	{
		XL = CrosshairDot.GetSurfaceWidth();
		YL = CrosshairDot.GetSurfaceHeight();

		Alpha = 1.0f - FMax(3.0f * GearInventoryManager(InvManager).Accuracy, 0.5f * CrosshairExpansionFiringTime / CrosshairExpansionTime);

		HUD.Canvas.SetDrawColor(HUD.Canvas.DrawColor.R, HUD.Canvas.DrawColor.G, HUD.Canvas.DrawColor.B, Max(0, Alpha * 255));
		HUD.Canvas.SetPos(0.5f * (HUD.Canvas.ClipX - XL), 0.5f * (HUD.Canvas.ClipY - YL));
		HUD.Canvas.DrawTile(CrosshairDot, XL, YL, 0, 0, XL, YL);
	}
}

defaultproperties
{
	WeaponStatName="Lancer"
	bWeaponCanBeReloaded=TRUE

	FiringStatesArray(MELEE_ATTACK_FIREMODE)=ChainsawMeleeAttacking

	InstantHitDamageTypes(0)=class'GDT_AssaultRifle'

	AmmoTypeClass=class'GearAmmoType_AssaultRifle'

	MeleeAttackCameraBoneAnims(0)=(AnimName="Camera_Melee_Saw_A",CollisionTestVector=(X=68.f,Y=149.f,Z=78.f))
	MeleeAttackCameraBoneAnims(1)=(AnimName="Camera_Melee_Saw_B",CollisionTestVector=(X=-36.f,Y=97.f,Z=129.f))
	MeleeAttackCameraBoneAnims(2)=(AnimName="Camera_Melee_Saw_C",CollisionTestVector=(X=68.f,Y=-162.f,Z=74.f))
	MeleeAttackCameraBoneAnims(3)=(AnimName="Camera_Melee_Saw_D",CollisionTestVector=(X=-14.f,Y=-111.f,Z=95.f))

	SpecialMeleeAttackIdleLoopSound=SoundCue'Weapon_AssaultRifle.Melee.ChainsawLoopIdle01Cue'
	SpecialMeleeAttackStopSound=SoundCue'Weapon_AssaultRifle.Melee.ChainsawStop01Cue'
	SpecialMeleeAttackSputterSound=SoundCue'Weapon_AssaultRifle.Melee.ChainsawStallCue'

	ChainsawSlashStartSound=SoundCue'Weapon_AssaultRifle.Melee.ChainsawSlashStart01Cue'
	ChainSawSlashLoopSound=SoundCue'Weapon_AssaultRifle.Melee.ChainsawSlashLoop01Cue'
	ChainsawSlashStopSound=SoundCue'Weapon_AssaultRifle.Melee.ChainsawSlashStop01Cue'

	ChainSawRipLoopSound=SoundCue'Weapon_AssaultRifle.Melee.ChainsawRipFleshCue'

	FireSound=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireLoopEnemyCue'			// looping
	FireSound_Squad=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireLoopSquadCue' 		// looping
	FireSound_Player=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireLoopPlayerCue'	// looping
	StopFireSound=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireStopEnemyCue'
	StopFireSound_Squad=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireStopSquadCue'
	StopFireSound_Player=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireStopPlayerCue'
	FireSoundAR=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireLoopEnemyActiveCue'
	FireSoundAR_Player=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireLoopPlayerActiveCue'
	FireSoundAR_Squad=SoundCue'Weapon_AssaultRifle.CogAssault.CogARifleFireLoopSquadActiveCue'

	FireNoAmmoSound=SoundCue'Weapon_AssaultRifle.Firing.CogRifleFireEmptyCue'
	NoAmmoFireSoundDelay=0.25f

	WeaponReloadSound=None

	BulletWhipArchetype=GearBulletWhip'GearSoundGroupArchetypes.BulletWhips.AssaultRifle'

	WeaponEquipSound=SoundCue'Weapon_AssaultRifle.Actions.CogRiflePickupCue'
	WeaponDeEquipSound=SoundCue'Weapon_AssaultRifle.Actions.CogRifleLowerCue'

	PickupSound=SoundCue'Weapon_AssaultRifle.Actions.CogRiflePickupCue'
	WeaponDropSound=SoundCue'Weapon_AssaultRifle.Actions.CogRifleDropCue'

	AIRating=1.f

	// Weapon Animation
	WeaponFireAnim="AR_Fire"
	WeaponReloadAnim="AR_Reload"
	WeaponReloadAnimFail="AR_Reload_Fumble"

	// Weapon Mesh
	Begin Object Name=WeaponMesh
		SkeletalMesh=SkeletalMesh'COG_AssaultRifle.Mesh.COGAssaultRifle'
		PhysicsAsset=PhysicsAsset'COG_AssaultRifle.Mesh.COGAssaultRifle_Physics'
		AnimTreeTemplate=AnimTree'COG_AssaultRifle.AT_COG_AssaultRifle'
		AnimSets(0)=AnimSet'COG_AssaultRifle.Animations.COG_AssaultRifle'
	End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh

	FireOffset=(X=61,Y=-0.5,Z=7.25)

	MuzzleSmokeRate=5.f

	// shell case ejection emitter
	Begin Object Name=PSC_WeaponShellCaseComp
	    Template=ParticleSystem'COG_AssaultRifle.Effects.P_GOG_AssaultRifle_Shells'
		Translation=(X=16,Z=6)
	End Object
	PSC_ShellEject=PSC_WeaponShellCaseComp

	// reload barrel smoke
	Begin Object Name=PSC_WeaponReloadBarrelSmokeComp
		Template=ParticleSystem'COG_AssaultRifle.EffectS.P_COG_AssaultRifle_Smoke'
	End Object
	PSC_ReloadBarrelSmoke=PSC_WeaponReloadBarrelSmokeComp

	Begin Object Class=ParticleSystemComponent Name=ChainSawImpactEffect0
	    bAutoActivate=FALSE
		TickGroup=TG_PostUpdateWork
	End Object
	ChainSawImpactEffect=ChainSawImpactEffect0

	ChainSawImpactEffect_FromForward=ParticleSystem'Effects_Gameplay.Blood.P_ChainSaw_Blood_01'
	ChainSawImpactEffect_FromBehind=ParticleSystem'Effects_Gameplay.Blood.P_ChainSaw_Blood_Reverse_01'
	ChainSawImpactEffect_NoGore=ParticleSystem'Effects_Gameplay.Chainsaw.P_Chainsaw_Sparks_NoGore'
	ChainSawImpactEffect_Lambent=ParticleSystem'Effects_Gameplay.Blood_Lambent.P_ChainSaw_Blood_Lambent_01'
	ChainSawImpactEffect_Former=ParticleSystem'Effects_Gameplay.Blood_Lambent.P_ChainSaw_Blood_DarkDrones'

	Begin Object Class=ParticleSystemComponent Name=ChainSawSmokeEffect0
	    bAutoActivate=FALSE
		Template=ParticleSystem'COG_AssaultRifle.Effects.P_COG_AssaultRifle_ChainSaw_Smoke'
		TickGroup=TG_PostUpdateWork
	End Object
	ChainSawSmokeEffect=ChainSawSmokeEffect0

	Begin Object Class=StaticMeshComponent Name=MagazineMesh0
		StaticMesh=StaticMesh'COG_AssaultRifle.Assault_Rifle_Magazine'
		CollideActors=FALSE
		BlockActors=FALSE
		BlockZeroExtent=FALSE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		bAcceptsStaticDecals=FALSE
		bAcceptsDynamicDecals=FALSE
	End Object
	MagazineMesh=MagazineMesh0

	bCanDisplayReloadTutorial=TRUE
	WeaponIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=222,V=100,UL=143,VL=46)
	AnnexWeaponIcon=(U=0,V=305,UL=128,VL=34)

	bCrosshairExpanding=TRUE
	CrosshairIcon=Texture2D'Warfare_HUD.HUD.HUD_Xhair_COG_Lancer'

	bInstantHit=true

	TracerType=WTT_Lancer
	TracerTypeAR=WTT_Lancer_AR

	NeedReloadNotifyThreshold=5

	LC_EmisDefaultCOG=(R=2.0,G=4.0,B=8.0,A=1.0)
	LC_EmisDefaultLocust=(R=60.0,G=1.0,B=0.1,A=1.0)

	Recoil_Hand={(
		TimeDuration=0.2f,
		RotAmplitude=(X=1000,Y=150,Z=0),
		RotFrequency=(X=10,Y=10,Z=0),
		RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
		LocAmplitude=(X=-8,Y=0,Z=0),
		LocFrequency=(X=10,Y=0,Z=0),
		LocParams=(X=ERS_Zero,Y=ERS_Zero,Z=ERS_Random)
	)}

	Recoil_Spine={(
		TimeDuration=0.2f,
		RotAmplitude=(X=500,Y=150,Z=0),
		RotFrequency=(X=10,Y=10,Z=0),
		RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero)
		)}

	Begin Object Class=GearCameraShake Name=FireCameraShake0
		OscillationDuration=0.25f
		RotOscillation={(Pitch=(Amplitude=45.f,Frequency=80.f),
						Yaw=(Amplitude=22.5f,Frequency=50.f),
						Roll=(Amplitude=11.25f,Frequency=20.f))}
	End Object
	FireCameraShake=FireCameraShake0
	FireCameraShakeScale=1.25f

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformRipping1
		Samples(0)=(LeftAmplitude=80,RightAmplitude=80,LeftFunction=WF_Noise,RightFunction=WF_Noise,Duration=5.000)
		bIsLooping=TRUE
	End Object
	RippingWaveForm=ForceFeedbackWaveformRipping1

	WeaponID=WC_Lancer

	bUseMeleeHitTimer=FALSE

	MeleeTraceExtent=(X=32,Y=32,Z=32)
	MeleeImpactSound=SoundCue'Weapon_AssaultRifle.Reloads.CogRifleHitCue'

	bShouldSpawnDecal=TRUE

	bAllowTracers=TRUE
	bCanParryMelee=false

	bSupportsBarrelHeat=TRUE
	BarrelHeatInterpSpeed=6.f
	BarrelHeatPerShot=0.3f
	BarrelHeatCooldownTime=1.25f
	MaxBarrelHeat=2.f
	BarrelHeatMaterialParameterName="AssaultRifle_Heat"

	bCanDoIronSights=false		// enable with "ironsights" console command
	IronSightsCameraOffset=(x=15,z=-18.9)
	IronSightsCameraRotOffset=(Pitch=0)
	ZoomFOV=30.f

	MuzzleFlashArchetype=GearMuzzleFlash'GearMuzzleFlashes.GearWeap_AssaultRifle_MuzFlash'

	// CQC Long Executions
	LongExecutions(3)={(CQC_Long_KillerAnim="CTRL_Lancer",
						CQC_Long_KillerAnim_Loop="",
						CQC_Long_KillerAnim_End="",
						CQC_Long_VictimAnim="DBNO_Lancer",
						CQC_Long_VictimAnim_Loop="",
						CQC_Long_VictimAnim_End="",
						CQC_Long_bHolsterWeapon=FALSE,
						CQC_Long_VictimDeathTime=5.0f,
						CQC_Long_VictimRotStartTime=0.0f,
						CQC_Long_VictimRotInterpSpeed=8.f,
						CQC_Long_CameraAnims=(CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Lancer_Cam01', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Lancer_Cam02', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_Lancer_Cam03'),
						// I just keep digger damagetype since it's same. If you'd like to customize, please create new one and change
						CQC_Long_DamageType=class'GDT_LongExecution_Lancer',
						CQC_Long_EffortID=GearEffort_ChainSawAttackEffort,
						MarkerRelOffset=(X=84.570,Y=27.190,Z=0),
						AwardRequired="LancerExecution",
						bDisableDeathScreams=TRUE,
						CameraLensEffect=class'Emit_CameraBlood_LongExecution_Lancer')}

	bDrawAdditionalCrosshairIfAimingAtFriendly=TRUE
	CrosshairDot=Texture2D'Warfare_HUD.HUD_Xhair_COG_Lancer_Dot'

	// These are the player's bling skin options
	WeaponSkins(0)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_Gold'
	WeaponSkins(1)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_CHROME'
	WeaponSkins(2)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_OMEN'
	WeaponSkins(3)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_TRIBALMASKED'
	WeaponSkins(4)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_CAMO'
	WeaponSkins(5)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_DIGITAL'
	WeaponSkins(6)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_PINK'
	WeaponSkins(7)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_GARISH'
	WeaponSkins(8)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_BLOOD'
	WeaponSkins(9)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_CRACKLE'
	WeaponSkins(10)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_FLOWER'
	WeaponSkins(11)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_PAISLEY'
	WeaponSkins(12)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_TRIBAL'
	WeaponSkins(13)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_URBAN'
	WeaponSkins(14)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Lancer.COG_WeaponShader_Lancer_XBOX'
}
