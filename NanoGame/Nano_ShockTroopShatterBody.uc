/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Nano_ShockTroopShatterBody extends FracturedSMActorSpawnable;

var SoundCue ShatterSound;

simulated event PostBeginPlay()
{
	local vector ExploOrigin;

	Super.PostBeginPlay();

	// Explosive origin is a bit behind us
	ExploOrigin = Location + (vect(-64,0,72) >> Rotation);
	BreakOffPartsInRadius(ExploOrigin, 200, 200, TRUE);

	// Play shatter sound
	PlaySound(ShatterSound, TRUE, TRUE, FALSE, Location, FALSE);
}

defaultproperties
{
	bBlockActors=FALSE

	ShatterSound=SoundCue'Gameplay_Audio.DensingImpacts.Densing_ImpactEarth_Cue'

	Begin Object Name=FracturedStaticMeshComponent0
		StaticMesh=FracturedStaticMesh'Nano_FX.Meshes.S_Nano_FX_DenseShatterMesh_FRACTURED'
		Translation=(Z=-90.0)
		BlockActors=FALSE
		BlockNonZeroExtent=FALSE
	End Object
}