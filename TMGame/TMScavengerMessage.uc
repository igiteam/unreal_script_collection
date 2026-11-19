/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMScavengerMessage extends TMLocalMessage;

var localized array<string>	MessageText;


static function string GetString(
	optional int Switch,
	optional bool bPRI1HUD,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	return Default.MessageText[Switch];
}

