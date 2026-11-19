/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGRI_CTL extends GearGRI_MP;

/** amount of time remaining before the given team wins due to holding the leader long enough */
var byte CaptureTimeRemaining[2];
/** indicates whether each team is holding the enemy leader */
var byte bEnemyLeaderHeld[2];

/** PRI of the player to kill the COG leader */
var GearPRI KillerOfCOGLeaderPRI;
/** PRI of the player to kill the Locust leader */
var GearPRI KillerOfLocustLeaderPRI;

/** The player to capture the Meatflag in CTM */
var GearPRI MeatflagKidnapper;


replication
{
	if (bNetDirty)
		bEnemyLeaderHeld, KillerOfCOGLeaderPRI, KillerOfLocustLeaderPRI, MeatflagKidnapper, CaptureTimeRemaining;
}
