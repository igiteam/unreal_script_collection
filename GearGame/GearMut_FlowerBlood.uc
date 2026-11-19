/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_FlowerBlood extends GearMutator;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	WorldInfo.EmitterPoolClassPath = "GearGame.GearFlowerEmitterPool";
	if (WorldInfo.MyEmitterPool != None)
	{
		WorldInfo.MyEmitterPool.Destroy();
		WorldInfo.MyEmitterPool = WorldInfo.Spawn(class'GearFlowerEmitterPool', WorldInfo,, vect(0,0,0), rot(0,0,0));
	}
}

function bool CheckReplacement(Actor Other)
{
	if (Other.IsA('GearPawn_LocustBerserkerLambentBase'))
	{
		GearPawn_LocustBerserkerLambentBase(Other).PS_HeartDamage = ParticleSystem'Effects_Gameplay.Mutators.Happy.P_Mutator_Happy_Blood';
	}

	return true;
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	NetUpdateFrequency=0.1
	bOnlyDirtyReplication=true
	bAlwaysRelevant=true
}
