/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
//
// OptionalObject is an Pickup class
//
class TMWeaponSwitchMessage extends TMLocalMessage;

static function string GetString(
	optional int Switch,
	optional bool bPRI1HUD,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if ( Actor(OptionalObject) != None )
	{
		return Actor(OptionalObject).GetHumanReadableName();
	}
	return "";
}

