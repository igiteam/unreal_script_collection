/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SpawnedNanoEmitter extends NanoEmitter
	native
	notplaceable;


// this should be promoted to GameFramework. 

final function HideBecauseFinished(ParticleSystemComponent FinishedComponent)
{
	HideSelf();
}

defaultproperties
{
	Begin Object Name=ParticleSystemComponent0
		SecondsBeforeInactive=1.0f
	End Object

	Components.Remove(ArrowComponent0)
	Components.Remove(Sprite)

	LifeSpan=30.0f // safety net for any spawned emitters (caller can override if they know their effect will be last infi time or longer than 30
}
