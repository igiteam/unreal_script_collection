/**
 * Pacifier Bot Minigun Weapon
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Pacifier_Minigun extends NanoWeap_Pacifier_Base;

/** Amount of time to spin up before firing */
var config	float	WarmupTime;

var protected transient AudioComponent AC_FireLoop;
var protected SoundCue StopFireCue;
var protected SoundCue SpinUpCue;


simulated state WeaponFiring
{
	simulated event BeginState( Name PreviousStateName )
	{
		PlaySound( SpinUpCue );
		SetTimer( WarmupTime, FALSE, nameof(WarmupTimeExpired) );
	}

	simulated function WarmupTimeExpired()
	{
		if( ShouldRefire() )
		{
			// Fire the first
			FireAmmunition();
			TimeWeaponFiring( CurrentFireMode );
		}
		else
		{
			HandleFinishedFiring();
		}
	}
	
	simulated event EndState( Name NextStateName )
	{
		ClearTimer( nameof(WarmupTimeExpired) );
		Super.EndState( NextStateName );
	}
}

simulated protected function PlayFireSound()
{
	if( AC_FireLoop == None )
	{
		AC_FireLoop = new(self) class'AudioComponent';
		AttachComponent( AC_FireLoop );
		AC_FireLoop.bStopWhenOwnerDestroyed = TRUE;
		AC_FireLoop.SoundCue = FireSound;
	}
	if( !AC_FireLoop.IsPlaying() )
	{
		AC_FireLoop.FadeIn( 0.25f, 1.0f );
	}
}

simulated protected function StopFireSound()
{
	AC_FireLoop.Stop();
	NanoWeaponPlaySoundLocal( StopFireCue, StopFireCue,, 1.f );
}

simulated function StopFireEffects(byte FireModeNum)
{
	Super.StopFireEffects(FireModeNum);

	StopFireSound();
}

defaultproperties
{
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_InstantHit
	Spread(0)=0.05f
	WeaponProjectiles(0)=none
	InstantHitDamageTypes(0)=class'NDT_MP7'
	InstantHitDamage(0)=0.0f
	InstantHitMomentum(0)=0.0f
	FireInterval(0)=+0.1f


	// muzzle flash emitter
	Begin Object Name=PSC_WeaponMuzzleMuzFlashComp
		Template=ParticleSystem'Nano_WeaponFX.GEN.Effects.P_GEN_MP5_MuzzleEffect'
		Scale3D=(X=10.f,Y=10.f,Z=10.f)
	End Object
	MuzFlashEmitter=PSC_WeaponMuzzleMuzFlashComp

	FireSound=SoundCue'Vehicle_PacBot.PacBot.PacBot_Chaingun_FireLoop_Cue'
	StopFireCue=SoundCue'Vehicle_PacBot.PacBot.PacBot_Chaingun_Stop_Cue'
	SpinUpCue=SoundCue'Vehicle_PacBot.PacBot.PacBot_Chaingun_Windup_Cue'
}