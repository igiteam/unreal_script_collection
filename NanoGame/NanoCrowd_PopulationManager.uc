/**
 *  Manages adding appropriate crowd population around player
 *  Agents will be spawned/recycled at any available active GameCrowdDestination
 *
 *  Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoCrowd_PopulationManager extends GameCrowdPopulationManager
	config(Game);


/** Amoutn of time that must pass after a chaos event to allow crowd guys that can become AI to spawn again **/
var config float TimeToStartSpawningCopsAfterChaosOccurs;


function OnNanoCrowdPopulationManagerToggle( SeqAct_NanoCrowdPopulationManagerToggle inAction)
{
	OnGameCrowdPopulationManagerToggle( inAction );
}

/** returns whether we want spawning to currently be active */
function bool IsSpawningActive()
{
	// flag must be true, and chaos must be low
	return bSpawningActive && (NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() < 2);
}

/**
  * Create new GameCrowdAgent and initialize it
  */
function GameCrowdAgent CreateNewAgent(GameCrowdDestination SpawnLoc, GameCrowdAgent AgentTemplate, GameCrowdGroup NewGroup)
{
	local ChaosPacifismManager CM;

	if( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() > 0 )
	{
		if( NanoCrowd_PedestrianBase(AgentTemplate).bShouldSpawnAnAIWhenShot == TRUE )
		{
			//`log( "NotSpawning due to being an AI" );
			return None;
		}
	}


	CM = NanoGRI(WorldInfo.GRI).GetCurrentChaosManager();

	if( CM != None )
	{
		if( NanoCrowd_PedestrianBase(AgentTemplate).bShouldSpawnAnAIWhenShot == TRUE )
		{
			if( `TimeSince(CM.GetTimeChaosLevelLastIncreased()) < TimeToStartSpawningCopsAfterChaosOccurs )
			{
				//`log( "NotSpawning due to being an AI AND" @ `showvar(`TimeSince(CM.GetTimeChaosLevelLastIncreased())) @ `showvar(TimeToStartSpawningCopsAfterChaosOccurs) );
				return None;
			}
		}
	}

	

	//`log( "Spawning a Crowd dude" @ `showvar(AgentTemplate) );
	return Super.CreateNewAgent( SpawnLoc, AgentTemplate, NewGroup );
}



defaultproperties
{
}
