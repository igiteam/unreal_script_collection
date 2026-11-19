/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPartyPRI extends GearPRI;

/** Whether the player is a guest of another player or not */
var bool bIsGuest;

/** bitfield of all mutators unlocked by this player. Corrseponds to MutatorClassArray in UIWidget_MainMenu */
var int MutatorsUnlockedBitfield;

replication
{
	if (bNetDirty)
		bIsGuest;
}

simulated function bool ShouldBroadCastWelcomeMessage(optional bool bExiting)
{
	return FALSE;
}

defaultproperties
{
	SessionName="Party"
}
