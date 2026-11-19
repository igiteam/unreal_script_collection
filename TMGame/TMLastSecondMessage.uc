/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMLastSecondMessage extends TMLocalMessage;

var localized string LastSecondRed, LastSecondBlue;

static function string GetString(
	optional int Switch,
	optional bool bPRI1HUD,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if ( TeamInfo(OptionalObject) == None )
		return "";
	if ( TeamInfo(OptionalObject).TeamIndex == 0 )
		return Default.LastSecondRed;
	else
		return Default.LastSecondBlue;
}

static simulated function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	TMPlayerController(P).PlayAnnouncement(default.class,Switch );

	if ( P.PlayerReplicationInfo == RelatedPRI_1 )
		TMPlayerController(P).ClientMusicEvent(2);
	else
		TMPlayerController(P).ClientMusicEvent(10);
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
	if ( MessageIndex == 1 )
		return SoundNodeWave'A_Gameplay.Portal.Portal_Loop01';
	else
		return SoundNodeWave'A_Gameplay.Portal.Portal_Loop01';
}

