/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMDmgType_ScorpionSelfDestruct extends TMDmgType_Burning;

/** Amount of damage to given when hitting a vehicle **/
var int DamageGivenForSelfDestruct;

static function int IncrementKills(TMPlayerReplicationInfo KillerPRI)
{
	if ( TMPlayerController(KillerPRI.Owner) != None )
	{
		TMPlayerController(KillerPRI.Owner).BullseyeMessage();
	}
	return super.IncrementKills(KillerPRI);
}

