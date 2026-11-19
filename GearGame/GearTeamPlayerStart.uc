/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */


class GearTeamPlayerStart extends PlayerStart;

/** The first round that a player can spawn from this playerstart. */
var() int FirstRoundForSpawning;

/** The last round that a player can spawn from this playerstart.  If left alone only the FirstRoundForSpawning value will be used. */
var() int LastRoundForSpawning;

/** whether Horde enemies can use this PlayerStart */
var() bool bHordeEnemySpawn;

defaultproperties
{
	FirstRoundForSpawning=-1
	LastRoundForSpawning=-1
	bHordeEnemySpawn=true
}
