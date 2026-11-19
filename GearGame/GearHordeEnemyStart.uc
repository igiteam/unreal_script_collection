/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHordeEnemyStart extends PlayerStart;

/** whether to allow large enemies to spawn here (brumaks, reavers, etc) */
var() bool bAllowLargeEnemies;
/** whether to allow an entire squad to spawn here at once (with e-hole effects) */
var() bool bSquadSpawnPoint;

defaultproperties
{
	TeamIndex=254
}
