/**
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class SpawnedTGEmitter extends TGEmitter
	native(TG)
	notplaceable;

final function HideBecauseFinished(ParticleSystemComponent FinishedComponent)
{
	HideSelf();
}

