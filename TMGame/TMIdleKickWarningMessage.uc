/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMIdleKickWarningMessage extends TMLocalMessage;

static function string GetString(
	optional int Switch,
	optional bool bPRI1HUD,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	TMPlayerController(OptionalObject).LastKickWarningTime = TMPlayerController(OptionalObject).WorldInfo.TimeSeconds;
    return class'GameMessage'.Default.KickWarning;
}

