/**
 * Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
 */
class TPKillerMessage extends LocalMessage;

var(Message) localized string YouKilled;
var(Message) localized string YouKilledTrailer;

static function string GetString(
	optional int Switch,
	optional bool bPRI1HUD,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (RelatedPRI_1 == None)
		return "";

	if (RelatedPRI_2.PlayerName != "")
		return Default.YouKilled@RelatedPRI_2.PlayerName@Default.YouKilledTrailer;
}

