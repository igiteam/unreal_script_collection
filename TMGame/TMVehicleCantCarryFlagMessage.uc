/**
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMVehicleCantCarryFlagMessage extends TMLocalMessage;

var localized string FlagMessage;
var SoundNodeWave FlagAnnouncement;
var localized string OrbMessage;
var SoundNodeWave OrbAnnouncement;

static simulated function ClientReceive( PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
						optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	TMPlayerController(P).PlayAnnouncement(default.class, Switch);
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
	return (MessageIndex == 0) ? default.FlagAnnouncement : default.OrbAnnouncement;
}

static function byte AnnouncementLevel(byte MessageIndex)
{
	return 2;
}

static function string GetString( optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1,
					optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	return (Switch == 0) ? default.FlagMessage : default.OrbMessage;
}

