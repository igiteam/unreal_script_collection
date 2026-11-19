/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class ReplicatedSpawnedGearEmitter extends SpawnedGearEmitter
	native
	notplaceable
	abstract;

/** How long this actor lives on a dedicated server */
var float ServerLifeSpan;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		LifeSpan = ServerLifeSpan;
	}
	else
	{
		SetTemplate(ParticleSystem,true);
	}
}

defaultproperties
{
	ServerLifeSpan=0.2
	bNetInitialRotation=true
	RemoteRole=ROLE_SimulatedProxy
	bNetTemporary=true
}
