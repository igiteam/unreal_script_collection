/**
 * GearVWeap_RocketCannon
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearVWeap_ReaverMinigunBase extends GearVehicleWeapon
	abstract
	config(Weapon);

/** How long it takes the barrel to cool down from fully heated, in seconds. */
var() protected const config float	CooldownTime;
/** How long it takes the barrel to cool down from fully heated while ActiveCooling(tm) is in effect, in seconds. */
var() protected const config float	CooldownTimeActiveCooling;

var protected transient bool bActivelyCooling;
var protected const SoundCue ActiveCoolingLoopCue;
var protected const SoundCue ActiveCoolingStartCue;
var protected const SoundCue ActiveCoolingStopCue;
var protected transient AudioComponent	ActiveCoolingSteamAudioLoop;

var config float MaxFiringTimeBeforeOverheat, OverheatPenaltyTime;
var bool bOverheated;

var float TracerAdvance;

simulated function bool IsHeatLimited()
{
	return TRUE;
}

/**
 * Generate the tracer effect for the weapon
 *
 * @param bIsActiveReload - whether this is an active reload shot or not
 * @param bIsLocalPlayer - whether this is a local player or not
 * @param SpawnLocation - tracer originates here
 * @param SpawnRotation - tracer orientation
 * @param TargetLoc - where the tracer is ending up
 * @param InInstigator - optional actor that triggered this
 *
 * @return the projectile that is the tracer
 */
simulated static function GearProj_BulletTracer GetTracer(bool bIsActiveReload, bool bIsLocalPlayer, vector SpawnLocation, rotator SpawnRotation, vector TargetLoc,optional Actor InInstigator)
{
	local WorldInfo WI;
	local GearProj_BulletTracer NewTracer;

	WI = class'Engine'.static.GetCurrentWorldInfo();
	NewTracer = GearEmitterPool(WI.MyEmitterPool).SpawnTracer(default.TracerType, SpawnLocation + (InInstigator.Velocity * default.TracerAdvance), SpawnRotation, TargetLoc,bIsLocalPlayer);
	NewTracer.bAllowTracersMovingFromTarget = true;

	return NewTracer;
}

simulated state Active
{
	/** Override BeginFire so we can stop it from firing if unpossessed */
	simulated function BeginFire(byte FireModeNum)
	{
		if ( (Instigator.Controller != None || bDummyFireWeapon) && !bOverheated )
		{
			Super.BeginFire(FireModeNum);
		}
	}

	simulated function Tick(float DeltaTime)
	{
		local GearPC GPC;
		local GearPlayerInput GPI;
		local bool bR1Pressed;

		// poll input directly, for more robustness with with respect to when the
		// R1 button goes up/down

		GPC = (Instigator != None) ? GearPC(Instigator.Controller) : None;
		GPI = (GPC != None) ? GearPlayerInput(GPC.PlayerInput) : None;

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
}

simulated function BeginActiveCooling()
{
	bActivelyCooling = TRUE;

	// adjust to the AC spindown rate
//	CurrentBarrelRotAccel = CurrentBarrelRotRate / SpinDownTime_ActiveCooling;

	ActiveCoolingSteamAudioLoop = GearWeaponPlaySoundLocalEx(ActiveCoolingLoopCue,,, ActiveCoolingSteamAudioLoop, 0.3f);
	WeaponPlaySound(ActiveCoolingStartCue);
}

simulated protected function OverheatPenaltyExpired()
{
	bOverheated = FALSE;
}

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
	}
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
	// keep track of firing duration and barrel heat
	if (IsFiring())
	{
		CurrentBarrelHeat += DeltaTime / MaxFiringTimeBeforeOverheat;
		CurrentBarrelHeat = FMin(CurrentBarrelHeat, 1.f);

		if ( (CurrentBarrelHeat >= 1.f) && !bOverheated )
		{
			// overheated!  stop firing and don't allow a restart for some time
			bOverheated = TRUE;
			SetTimer( OverheatPenaltyTime,, nameof(OverheatPenaltyExpired) );
			//WeaponPlaySound(FireStopCue_Overheat);
			StopFire(0);

			if (WorldInfo.Game != None)
			{
				GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_GatlingOverheated, Instigator, None, 0.35f);
			}
		}
	}
	else
	{
		if (bActivelyCooling)
		{
			CurrentBarrelHeat -= DeltaTime / CooldownTimeActiveCooling;

			if (CurrentBarrelHeat <= 0.f)
			{
				EndActiveCooling();
			}
		}
		else
		{
			CurrentBarrelHeat -= DeltaTime / CooldownTime;
		}
		CurrentBarrelHeat = FMax(CurrentBarrelHeat, 0.f);
	}
}

simulated function PlayShellCaseEject()
{
}


simulated function PlayMuzzleFlashEffect()
{
}

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
	return true;
}

simulated function float GetWeaponDistanceForEnemyTrace()
{
	return 30000.0f;
}

defaultproperties
{
	bWeaponCanBeReloaded=true
	bIsSuppressive=true
	bInfiniteSpareAmmo=true

	bAllowTracers=TRUE
	bSuppressTracers=FALSE
	TracerType=WTT_Reaver
	TracerTypeAR=WTT_Reaver

	WeaponFireTypes(0)=EWFT_InstantHit
	InstantHitDamageTypes(0)=class'GDT_ReaverMinigun'
	InstantHitDamage(0)=50
	InstantHitMomentum(0)=1
	bInstantHit=true

	bIgnoreDifficultyDamageScale=TRUE

	FireOffset=(X=68,Y=0,Z=9)

	//LC_EmisDefaultCOG=(R=0.5,G=3.0,B=20.0,A=1.0)
	//LC_EmisDefaultLocust=(R=3.0,G=3.0,B=3.0,A=1.0)

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.600)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	WeaponID=WC_Troika

	MaxFinalAimAdjustment=0.25

	bOverrideDistanceForEnemyTrace=TRUE

	TracerAdvance=0.033
}
