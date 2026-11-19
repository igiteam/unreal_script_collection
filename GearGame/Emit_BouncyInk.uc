/**
 * Semi-persistent bits of fire stuck to the world.  Deposited by flamethrower, etc.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Emit_BouncyInk extends Emit_BouncyFire
	config(Weapon);

defaultproperties
{
	VelocityDampingFactor=1.f
	Bounciness=0.45f
	SurfaceAdhesion=0.65f
	DistBetweenSpawnsRange=(X=100,Y=100)

	SurfaceTraceJitterAngleDeg=0
	StopSimulatingVelThreshold=50
	MinInitialVel=200
	MaxInitialVel=1600
	DecelRange=(X=1000,Y=200)
	MaxStickyFires=4

	BounceJitterAngleDeg=0.f
	SiblingRepulsionConstant=0.f
	MaxSiblingRepulsion=0.f
	bCanJitterBounce=false

	MaxDistanceBetweenBounceSpawns=300

	StickyFireClass=class'Emit_StickyInk'
	DamageType=class'GDT_InkGrenade'
	bExtinguishInWater=false

	bDrawDebug=0
}
