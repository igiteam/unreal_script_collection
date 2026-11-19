/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class SeqAct_GameCrowdSpawner_Nano extends SeqAct_GameCrowdSpawner;

/** Max tier where crowd agents will still be spawned from this spawner */
var() EChaosTier MaxChaosTier;

event GameCrowdAgent SpawnAgent(Actor SpawnLoc)
{
	local ChaosPacifismManager CM;

	CM = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetCurrentChaosManager();

	// Don't spawn more crowds above tier 2
	// might be broken to do this, but we currently only spawn crowds around the player so this should still work
	if( ( CM != none ) && ( CM.GetChaosTier() >= MaxChaosTier ) )
	{
		return None;
	}
	
	return 	Super.SpawnAgent(SpawnLoc);

}

defaultproperties
{
	MaxChaosTier=ECT_Tier2
	ObjName="Game Crowd Spawner"
	ObjCategory="Crowd"
	
	bForceNavMeshPathing=true
}