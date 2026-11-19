/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Maintains game state while reading a game stats file
 */
class GearGameStateObject extends GameStateObject
	native(GameStats)
	config(GearGame);

/** State variables related to a game team */
struct native GearTeamState extends TeamState
{

};

/** Contains the notion of player state while parsing the stats stream */
struct native GearPlayerState extends PlayerState
{
	var float RoadieRunStartTime;
	var float LastRoadieRunTime;

	var float EnterCoverStartTime;
	var float LastCoverTime;
};

cpptext
{
	/*
	 *   Get a given team's current state, creating a new one if necessary
	 *   @param TeamIndex - index of team to return state for
	 *   @return State for team player
	 */
	virtual FTeamState* GetTeamState(INT TeamIndex)
	{
		INT TeamStateIdx = 0;
		for (; TeamStateIdx < TeamStates.Num(); TeamStateIdx++)
		{
			if (TeamStates(TeamStateIdx)->TeamIndex == TeamIndex)
			{
				break;
			}
		}

		//Create a new team if necessary
		if (TeamStateIdx == TeamStates.Num())
		{
			FTeamState* NewTeamState = new FGearTeamState;
			NewTeamState->TeamIndex = TeamIndex;
			TeamStateIdx = TeamStates.AddItem(NewTeamState);
		}

		return TeamStates(TeamStateIdx);
	}

	/*
	 *   Get a given team's current state, creating a new one if necessary
	 *   @param TeamIndex - index of team to return state for
	 *   @return State for team player
	 */
	FGearTeamState* GetGearTeamState(INT TeamIndex)
	{
		return static_cast<FGearTeamState*>(GetTeamState(TeamIndex));
	}

	/*
	 *   Get a given player's current state, creating a new one if necessary
	 *   @param PlayerIndex - index of player to return state for
	 *   @return State for given player
	 */
	virtual FPlayerState* GetPlayerState(INT PlayerIndex)
	{
		INT PlayerStateIdx = 0;
		for (; PlayerStateIdx < PlayerStates.Num(); PlayerStateIdx++)
		{
			if (PlayerStates(PlayerStateIdx)->PlayerIndex == PlayerIndex)
			{
				break;
			}
		}

		//Create a new player if necessary
		if (PlayerStateIdx == PlayerStates.Num())
		{
			FGearPlayerState* NewPlayerState = new FGearPlayerState;
			NewPlayerState->PlayerIndex = PlayerIndex;
			NewPlayerState->CurrentTeamIndex = INDEX_NONE;
			NewPlayerState->TimeSpawned = 0;
			NewPlayerState->TimeAliveSinceLastDeath = 0;
			NewPlayerState->RoadieRunStartTime = 0;
			NewPlayerState->LastRoadieRunTime = 0;
			NewPlayerState->EnterCoverStartTime = 0;
			NewPlayerState->LastCoverTime = 0;

			PlayerStateIdx = PlayerStates.AddItem(NewPlayerState);
		}

		return PlayerStates(PlayerStateIdx);
	}

	/*
	 *   Get a given player's current state, creating a new one if necessary
	 *   @param PlayerIndex - index of player to return state for
	 *   @return State for given player
	 */
	FGearPlayerState* GetGearPlayerState(INT PlayerIndex)
	{
		return static_cast<FGearPlayerState*>(GetPlayerState(PlayerIndex));
	}

	/** The function that does the actual handling of data (override with particular implementation) */
	virtual void HandleEvent(struct FGameEventHeader& GameEvent, class IGameEvent* GameEventData);

	/** Handlers for parsing the game stats stream */
	void HandlePlayerIntEvent(struct FGameEventHeader& GameEvent, struct FPlayerIntEvent* GameEventData);
	void HandlePlayerLoginEvent(struct FGameEventHeader& GameEvent, struct FPlayerLoginEvent* GameEventData);

	/*
	 *   Cleanup a player state (round over/logout)
	 */
	virtual void CleanupPlayerState(INT PlayerIndex, FLOAT TimeStamp);
};

/** A chance to do something before the stream starts */
native event PreProcessStream();



