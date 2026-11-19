/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoForceField_OrbitalAttractorGeneric extends NxForceFieldGeneric;



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


	Constant=(X=-50.0,Y=-50.0,Z=-50.0);



}



