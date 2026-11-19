/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoFractureManager extends FractureManager;

// this should be promoted to GameFramework. 


/** Function use to spawn particle effect when a chunk is destroyed. */
simulated event SpawnChunkDestroyEffect(ParticleSystem Effect, box ChunkBox, vector ChunkDir, float Scale)
{
	local Emitter ExplodeEffect;
	local vector ChunkMiddle;

	ChunkMiddle = 0.5 * (ChunkBox.Min + ChunkBox.Max);
	ExplodeEffect = NanoGRI(WorldInfo.GRI).NOP.GetImpactEmitter(Effect, ChunkMiddle, rotator(ChunkDir));
	`assert(ExplodeEffect != None);
	ExplodeEffect.SetDrawScale(Scale);
	ExplodeEffect.ParticleSystemComponent.ActivateSystem();
}

/** Returns a scalar to the percentage chance of a fractured static mesh spawning a rigid body after taking direct damage */
function float GetFSMDirectSpawnChanceScale()
{
	local float Scale;

	Scale = class'Engine'.static.IsSplitScreen() ? 0.5 : 1.0;

	return Super.GetFSMDirectSpawnChanceScale() * Scale;
}

/** Returns a scalar to the percentage chance of a fractured static mesh spawning a rigid body after taking radial damage, such as from an explosion */
function float GetFSMRadialSpawnChanceScale()
{
	local float Scale;

	Scale = class'Engine'.static.IsSplitScreen() ? 0.5 : 1.0;

	return Super.GetFSMRadialSpawnChanceScale() * Scale;
}

/** Returns a distance scale for whether a fractured static mesh should actually fracture when damaged */
function float GetFSMFractureCullDistanceScale()
{
	local float Scale;

	Scale = class'Engine'.static.IsSplitScreen() ? 0.5 : 1.0;

	return Super.GetFSMFractureCullDistanceScale() * Scale;
}

defaultproperties
{
	FSMPartPoolSize=200
}