/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoForceField_OrbitalAttractorBox extends NxGenericForceFieldBox;



defaultproperties
{
	// for spawnability
	bNoDelete=FALSE

	// we only want to collide with EffectPhysics which are what the Orbitals are
	CollideWithChannels={(
                Default=FALSE,
                Pawn=FALSE,
                Vehicle=FALSE,
                Water=FALSE,
                GameplayPhysics=FALSE,
                EffectPhysics=TRUE,
                Untitled1=FALSE,
                Untitled2=FALSE,
                Untitled3=FALSE,
                FluidDrain=FALSE,
                Cloth=FALSE,
                SoftBody=FALSE
                )}

     FalloffLinear=(X=10.0,Y=10.0,Z=5.0);
     BoxExtent=(X=128.0f,Y=128.0f,Z=128.0f)

	PositionMultiplierX=(X=1.0,Y=1.0,Z=1.0);
	PositionMultiplierY=(X=1.0,Y=1.0,Z=1.0);
	PositionMultiplierZ=(X=1.0,Y=1.0,Z=1.0);

	VelocityMultiplierX=(X=1.0,Y=1.0,Z=1.0);
	VelocityMultiplierY=(X=1.0,Y=1.0,Z=1.0);
	VelocityMultiplierZ=(X=1.0,Y=1.0,Z=1.0);

	PositionTarget=(X=1.0,Y=1.0,Z=1.0);
	VelocityTarget=(X=1.0,Y=1.0,Z=1.0);

}



