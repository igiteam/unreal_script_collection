/** 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProceduralEnemySpawnPoint extends NanoTargetPoint;


struct NanoProceduralEnemySpawnModifer
{
	/** which enemy to spawn **/
	var() class<NanoPawnBase> EnemyType;

	/** what percentage to spawn this guy**/
	var() int PercentageToSpawn;

	structdefaultproperties
	{
	    PercentageToSpawn=100
	}
};

var(Nano) array<NanoProceduralEnemySpawnModifer> SpawnPointSpawns;

/** If a AIs need to despawn this is a valid point for them to return to **/
var(Nano) bool bValidDespawnPoint;

/** Is this spawn point active **/
var(Nano) bool bIsSpawnPointActive;


simulated event PostBeginPlay()
{
	local int Idx;

	Super.PostBeginPlay();

	// need to reset bad data here
	for( Idx = 0; Idx < SpawnPointSpawns.Length; ++Idx )
	{
		if( SpawnPointSpawns[Idx].PercentageToSpawn == 0 )
		{
            SpawnPointSpawns[Idx].PercentageToSpawn = 100;
		}
	}
}


simulated function OnToggle( SeqAct_Toggle Action )
{
	// Turn ON
	if( Action.InputLinks[0].bHasImpulse )
	{
		bIsSpawnPointActive = TRUE;
	}
	// Turn OFF
	else if( Action.InputLinks[1].bHasImpulse )
	{
		bIsSpawnPointActive = FALSE;
	}
	// Toggle
	else if( Action.InputLinks[2].bHasImpulse )
	{
		bIsSpawnPointActive = !bIsSpawnPointActive;
	}
}


defaultproperties
{
	bValidDespawnPoint=TRUE
	bIsSpawnPointActive=TRUE

	// we eventually need to support these
	SupportedEvents.Add(class'SeqEvt_NanoSpawnerActivated')
	SupportedEvents.Add(class'SeqEvt_NanoSpawnerDeactivated')

}