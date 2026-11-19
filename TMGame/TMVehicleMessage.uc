/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMVehicleMessage extends TMLocalMessage;

var localized array<string> MessageText;

var array<Color> DrawColors;

var array<SoundNodeWave> MessageAnnouncements;

var array<int> CustomMessageArea;



static simulated function ClientReceive(
										PlayerController P,
										optional int Switch,
										optional PlayerReplicationInfo RelatedPRI_1,
										optional PlayerReplicationInfo RelatedPRI_2,
										optional Object OptionalObject
										)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	if (default.MessageAnnouncements[Switch] != None)
	{
		TMPlayerController(P).PlayAnnouncement(default.class, Switch);
	}
}


static function byte AnnouncementLevel(byte MessageIndex)
{
	return 2;
}

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


static function color GetColor(
							   optional int Switch,
							   optional PlayerReplicationInfo RelatedPRI_1,
							   optional PlayerReplicationInfo RelatedPRI_2,
								optional Object OptionalObject
							   )
{
	return Default.DrawColors[Switch];
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
	return default.MessageAnnouncements[MessageIndex];
}

