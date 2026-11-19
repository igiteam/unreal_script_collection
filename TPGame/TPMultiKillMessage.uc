/**
 * Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
 */
class TPMultiKillMessage extends LocalMessage;

var	localized string 	KillString[7];
//var name KillSoundName[6];

static function string GetString(
	optional int Switch,
	optional bool bPRI1HUD,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	return Default.KillString[Min(7,Switch)-1];
}

static simulated function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (P.GamePlayEndedState())
	{
		;
		ScriptTrace();
	}

	/*if ( Switch < 2 )
		UTPlayerController(P).ClientMusicEvent(9);
	else if ( Switch < 4 )
		UTPlayerController(P).ClientMusicEvent(11);
	else
		UTPlayerController(P).ClientMusicEvent(12);*/

	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	/*if ( class'UTPlayerController'.default.bNoMatureLanguage )
		UTPlayerController(P).PlayAnnouncement(default.class, Min(Switch-1,4));
	else
		UTPlayerController(P).PlayAnnouncement(default.class, Min(Switch-1,5));*/
}

/*static function Name AnnouncementSound(byte MessageIndex)
{
	return Default.KillSoundName[MessageIndex];
}*/


static function bool IsRewardAnnouncement(byte MessageIndex)
{
	return true;
}

static function int GetFontSize( int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer )
{
	if ( Switch < 4 )
		return 1;
	else if ( Switch < 7 )
		return 2;
	else
		return 3;
}

