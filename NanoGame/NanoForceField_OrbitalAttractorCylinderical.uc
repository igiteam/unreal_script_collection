/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoForceField_OrbitalAttractorCylinderical extends NxCylindricalForceFieldCapsule;



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


	RadialStrength=-100.0f
	RotationalStrength=10.0f
	LiftStrength=10.0f

	ForceRadius=128.0f
	ForceTopRadius=128.0f

	LiftFalloffHeight=5.0f

	EscapeVelocity=32.0f

	ForceHeight=5.0f

}



