/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMVehicleDeathPiece extends TMGib_Vehicle
	notplaceable;


var ParticleSystemComponent PSC;

/** We need to skip the TMGib_Vehicle PreBeginPlay because TMGib_Vehicle tries to ChooseGib which we don't want to do **/
simulated event PreBeginPlay()
{
	Super(Actor).PreBeginPlay();
}


