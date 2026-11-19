/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
//
// A Death Message.
//
// Switch 0: Kill
//	RelatedPRI_1 is the Killer.
//	RelatedPRI_2 is the Victim.
//	OptionalObject is the DamageType Class.
//

class TMDeathMessage extends TMLocalMessage
	config(game);

var(Message) localized string KilledString, SomeoneString;
var config bool bNoConsoleDeathMessages;

static function color GetConsoleColor( PlayerReplicationInfo RelatedPRI_1 )
{
    return class'HUD'.Default.GreenColor;
}

static function string GetString(
	optional int Switch,
	optional bool bPRI1HUD,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	local string KillerName, VictimName;

	if (Class<DamageType>(OptionalObject) == None)
		return "";

	if (RelatedPRI_1 == None)
		KillerName = Default.SomeoneString;
	else
		KillerName = RelatedPRI_1.PlayerName;

	if (RelatedPRI_2 == None)
		VictimName = Default.SomeoneString;
	else
		VictimName = RelatedPRI_2.PlayerName;

	if ( Switch == 1 )
	{
		// suicide
		return class'TMGame'.Static.ParseKillMessage(
			KillerName,
			VictimName,
			Class<TMDamageType>(OptionalObject).Static.SuicideMessage(RelatedPRI_2) );
	}

	return class'TMGame'.Static.ParseKillMessage(
		KillerName,
		VictimName,
		Class<TMDamageType>(OptionalObject).Static.DeathMessage(RelatedPRI_1, RelatedPRI_2) );
}

static function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if ( Switch == 1 )
	{
		if ( RelatedPRI_2 == P.PlayerReplicationInfo )
		{
			TMPlayerController(P).ClientMusicEvent(2);
			TMPlayerReplicationInfo(RelatedPRI_2).MultiKillLevel = 0;
		}
		if ( !Default.bNoConsoleDeathMessages )
		{
			Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		}
		return;
	}
	if ( (RelatedPRI_1 == P.PlayerReplicationInfo)
		|| ((P.PlayerReplicationInfo != None) && P.PlayerReplicationInfo.bIsSpectator && (Pawn(P.ViewTarget) != None) && (Pawn(P.ViewTarget).PlayerReplicationInfo == RelatedPRI_1)) )
	{
		TMPlayerController(P).ClientMusicEvent(1);
		// Interdict and send the child message instead.
		if ( P.myHud != None )
			P.myHUD.LocalizedMessage(
				class'TMKillerMessage',
				RelatedPRI_1,
				RelatedPRI_2,
				class'TMKillerMessage'.static.GetString(Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject),
				Switch,
				class'TMKillerMessage'.static.GetPos(Switch, P.myHUD),
				class'TMKillerMessage'.static.GetLifeTime(Switch),
				class'TMKillerMessage'.static.GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo),
				class'TMKillerMessage'.static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2),
				OptionalObject );

		if ( !Default.bNoConsoleDeathMessages )
			Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

		// check multikills
		if ( P.Role == ROLE_Authority )
		{
			// multikills checked already in LogMultiKills()
			if ( TMPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel > 0 )
				P.ReceiveLocalizedMessage( class'TMMultiKillMessage', TMPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel );
		}
		else if ( ( RelatedPRI_1 != RelatedPRI_2 ) && ( RelatedPRI_2 != None)
			&& ((RelatedPRI_2.Team == None) || (RelatedPRI_1.Team != RelatedPRI_2.Team)) )
		{
			if ( (P.WorldInfo.TimeSeconds - TMPlayerReplicationInfo(RelatedPRI_1).LastKillTime < 4) && (Switch != 1) )
			{
				TMPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel++;
				P.ReceiveLocalizedMessage( class'TMMultiKillMessage', TMPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel );
			}
			else
			{
				TMPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel = 0;
			}
			TMPlayerReplicationInfo(RelatedPRI_1).LastKillTime = P.WorldInfo.TimeSeconds;
		}
		else
		{
			TMPlayerReplicationInfo(RelatedPRI_1).MultiKillLevel = 0;
		}
	}
	else if (RelatedPRI_2 == P.PlayerReplicationInfo)
	{
		TMPlayerController(P).ClientMusicEvent(2);
		if ( P.myHud != None )
			P.myHUD.LocalizedMessage(
				class'TMVictimMessage',
				RelatedPRI_1,
				RelatedPRI_2,
				class'TMVictimMessage'.static.GetString(Switch, true, RelatedPRI_1, RelatedPRI_2, OptionalObject),
				0,
				class'TMVictimMessage'.static.GetPos(Switch, P.myHUD),
				class'TMVictimMessage'.static.GetLifeTime(Switch),
				class'TMVictimMessage'.static.GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo),
				class'TMVictimMessage'.static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2),
				OptionalObject );
		TMPlayerReplicationInfo(RelatedPRI_2).MultiKillLevel = 0;
		if ( !Default.bNoConsoleDeathMessages )
			Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	}
	else if ( !Default.bNoConsoleDeathMessages )
		Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

