/**
 * Gear Emitter subclass
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearEmitter extends Emitter
	native;

/** Sound to play when spawned */
var()	SoundCue		Sound;
/** Particle System to use */
var()	ParticleSystem	ParticleSystem;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		if (ParticleSystem != None)
		{
			SetTemplate( ParticleSystem, bDestroyOnSystemFinish );
		}

		if( Sound != None )
		{
			PlaySound( Sound );
		}
	}
}

/** This is mostly used by the Object pool system **/
simulated function HideSelf()
{
	ParticleSystemComponent.KillParticlesForced(); // if we are hiding this we want to deactivate also
	SetBase( None );
	SetHidden( TRUE );
	SetTickIsDisabled(true);
	ClearTimer(nameof(HideSelf));
}


defaultproperties
{
	Begin Object Name=ParticleSystemComponent0
		SecondsBeforeInactive=0.0
	End Object
	bDestroyOnSystemFinish=true
	bNetInitialRotation=true
	bNoDelete=false
}
