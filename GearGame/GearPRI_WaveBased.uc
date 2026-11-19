/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPRI_WaveBased extends GearMPPRI
	native
	abstract;

/** The score of the match at player join to support scoring based upon runs and not whole matches */
var int ScoreAtJoinTime;
/** Whether the high score string was shown or not */
var bool bHasShownHighScore;
/** The wave this person joined at for compounding Horde/Beast XP */
var int WaveNumAtJoinTime;

replication
{
	// sent to everyone
	if (bNetDirty)
		ScoreAtJoinTime;
}

defaultproperties
{
	// Default to an invalid score so we know when to set it properly
	ScoreAtJoinTime=-1
}
