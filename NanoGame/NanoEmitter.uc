/**
 * Nano Emitter subclass
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoEmitter extends Emitter
	native;

// this should be promoted to GameFramework.


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
	ParticleSystemComponent.DeActivateSystem(); // if we are hiding this we want to deactivate also
	SetBase( None );
	SetHidden( TRUE );
	SetTickIsDisabled(true);
	ClearTimer(nameof(HideSelf));
}


/** This is used as way for being able to call SetTimer() to deactivate the psc **/
simulated function DeactivateSelf()
{
	ParticleSystemComponent.DeActivateSystem(); // if we are hiding this we want to deactivate also
	SetBase( None );
	ClearTimer(nameof(DeactivateSelf));
}



defaultproperties
{
	bDestroyOnSystemFinish=true
	bNetInitialRotation=true
	bNoDelete=false
}
