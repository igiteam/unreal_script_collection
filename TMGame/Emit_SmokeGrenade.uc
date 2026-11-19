/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class Emit_SmokeGrenade extends Emitter
	config(TGWeapon)
	notplaceable;

var protected const SoundCue				SmokeSpewStartCue;
var protected const SoundCue				SmokeSpewFinishCue;
var protected const SoundCue				SmokeSpewLoopCue;
var protected transient AudioComponent      SmokeSpewLoopAC;

var() protected const class<TGFogVolume_SmokeGrenade>		FogVolumeClass;
var protected transient TGFogVolume_SmokeGrenade			FogVolume;

var() protected const bool		bDoCoughChecks;
/** Radius around emitter that causes coughing. */
var() protected const float		CoughRadius;
/** Defines how often to look for folks who should be coughing. */
var() protected const vector2d	CoughCheckInterval;

/** Controller of pawn that threw grenade - incase pawn dies before/during smoke/damage */
var transient Controller  InstigatorController;

/** Variables for determining how this emitter was triggered */
var bool bTriggeredByMartyr;
var bool bTriggeredBySticky;

/**
 * Ignore doing any damage for this pawn
 * (used for having a player who was tagged avoid the extra damage
 */
var Pawn IgnoringDamagePawn;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		FogVolume = Spawn(FogVolumeClass,,,, rot(0,0,0));
		TurnOnSmokeSpewSound();
	}

	// do first cough check right away
	if ( bDoCoughChecks && (WorldInfo.NetMode != NM_Client) )
	{
		DoCoughCheck();
	}

	SetTimer(0.5f,FALSE,nameof(CheckPerformance));
}

simulated function CheckPerformance()
{
	if (WorldInfo.bDropDetail)
	{
		;
		TurnOffSmokeEmitter();
	}
	else
	{
		SetTimer(0.5f,FALSE,nameof(CheckPerformance));
	}
}

/** Sets duration of smoke emission.  Does not include any fadeout/dissipation time. */
simulated function SetEmissionDuration(float Duration)
{
	SetTimer( Duration, FALSE, nameof(TurnOffSmokeEmitter) );
}

simulated protected function TurnOffSmokeEmitter()
{
	// turn off emitter, let particles dissipate
	ParticleSystemComponent.DeactivateSystem();

	// turn off sound
	TurnOffSmokeSpewSound();

	// start fogvolume fadeout
	FogVolume.NotifyEmitterFinished();

	ClearTimer('DoCoughCheck');
}

/** Server-only, Speakline will replicate cough lines. */
function DoCoughCheck()
{
	local TGPawn GP;
	local float NextCoughCheckDelay;

	//DrawDebugSphere(Location, InkDamageRadius, 10, 255, 255, 255, FALSE);
	// Note: not doing VisibleCollidingActors, since we don't care the origin of the damage
	foreach CollidingActors(class'TGPawn', GP, CoughRadius, Location)
	{
		// effectively doubles the delay, but prevents everyone from coughing at once.
		if (FRand() > 0.5f)
		{
			//GP.SoundGroup.PlayEffort(GP, GearEffort_InSmokeCough);
		}
	}

	NextCoughCheckDelay = RandRange(CoughCheckInterval.X, CoughCheckInterval.Y);
	SetTimer( NextCoughCheckDelay, FALSE, nameof(DoCoughCheck) );
}


simulated protected function TurnOnSmokeSpewSound()
{
	SmokeSpewLoopAC = CreateAudioComponent( SmokeSpewLoopCue, TRUE, TRUE );
	if (SmokeSpewLoopAC != None)
	{
		SmokeSpewLoopAC.bAutoDestroy = TRUE;
		SmokeSpewLoopAC.Location = Location;
		SmokeSpewLoopAC.FadeIn( 0.3f, 1.0f );
	}

	if (SmokeSpewStartCue != None)
	{
		PlaySound(SmokeSpewStartCue, TRUE);
	}
}

simulated protected function TurnOffSmokeSpewSound()
{
	if (SmokeSpewLoopAC != None)
	{
		SmokeSpewLoopAC.FadeOut( 1.0f, 0.0f );
	}

	if (SmokeSpewFinishCue != None)
	{
		PlaySound(SmokeSpewFinishCue, TRUE);
	}
}

simulated function OnParticleSystemFinished(ParticleSystemComponent FinishedComponent)
{
	// ignored for smoke/ink
}

