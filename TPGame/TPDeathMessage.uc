/**
 * Copyright ? 2004-2005 Epic Games, Inc. All Rights Reserved.
 */
//
// A Death Message.
//
// Switch 0: Kill
//	RelatedPRI_1 is the Killer.
//	RelatedPRI_2 is the Victim.
//	OptionalObject is the DamageType Class.
//

class TPDeathMessage extends LocalMessage
	config(game);

var(Message) localized string KilledString, SomeoneString;
var globalconfig bool bNoConsoleDeathMessages;

static function color GetConsoleColor( PlayerReplicationInfo RelatedPRI_1 )
{
    return class'TPHUD'.Default.GreenColor;
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
	//local class<DamageType> CurrentDamageType;

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

	VictimName = Repl(VictimName, "<", "\\<");
	KillerName = Repl(KillerName, "<", "\\<");

	if ( Switch == 1 )
	{
		// suicide
		return "<Fonts:FDiazPack.DeathMSGFont>@ <Fonts:/>"$"<Fonts:EngineFonts.MediumFont>"$VictimName$"<Fonts:/>";
		/*class'GameInfo'.Static.ParseKillMessage(
			KillerName,
			VictimName,
			Class<DamageType>(OptionalObject).Static.SuicideMessage(RelatedPRI_2) );*/
	}

	return "<Fonts:EngineFonts.MediumFont>"$KillerName$"<Fonts:/>"$"<Fonts:FDiazPack.DeathMSGFont> @ <Fonts:/>"$"<Fonts:EngineFonts.MediumFont>"$VictimName$"<Fonts:/>";
	/*class'GameInfo'.Static.ParseKillMessage(
		KillerName,
		VictimName,
		Class<DamageType>(OptionalObject).Static.DeathMessage(RelatedPRI_1, RelatedPRI_2) );*/
}

static function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	local TPPlayerReplicationInfo tpRelatedPRI_1, tpRelatedPRI_2;

	if ( Switch == 1 )
	{
		/*if ( RelatedPRI_2 == P.PlayerReplicationInfo )
			UTPlayerController(P).ClientMusicEvent(2);*/
		if ( !Default.bNoConsoleDeathMessages )
		{
			Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		}
		return;
	}

	tpRelatedPRI_1 = TPPlayerReplicationInfo(RelatedPRI_1);
	tpRelatedPRI_2 = TPPlayerReplicationInfo(RelatedPRI_2);

	if ( (RelatedPRI_1 == P.PlayerReplicationInfo)
		|| (P.PlayerReplicationInfo.bOnlySpectator && (Pawn(P.ViewTarget) != None) && (Pawn(P.ViewTarget).PlayerReplicationInfo == RelatedPRI_1)) )
	{
		//TPPlayerController(P).ClientMusicEvent(1);
		// Interdict and send the child message instead.
		if ( P.myHud != None )
			P.myHUD.LocalizedMessage(
				class'TPKillerMessage',
				RelatedPRI_1,
				class'TPKillerMessage'.static.GetString(Switch, true, RelatedPRI_1, RelatedPRI_2, OptionalObject),
				Switch,
				class'TPKillerMessage'.static.GetPos(Switch,P.myHUD),
				class'TPKillerMessage'.static.GetLifeTime(Switch),
				class'TPKillerMessage'.static.GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo),
				class'TPKillerMessage'.static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2) );

		if ( !Default.bNoConsoleDeathMessages )
			Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	}
	else if (RelatedPRI_2 == P.PlayerReplicationInfo)
	{
		//UTPlayerController(P).ClientMusicEvent(2);
		P.ReceiveLocalizedMessage( class'TPVictimMessage', 0, RelatedPRI_1 );
		if ( !Default.bNoConsoleDeathMessages )
			Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	}
	else if ( !Default.bNoConsoleDeathMessages )
		Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	CheckForMultiKill(P, tpRelatedPRI_1, tpRelatedPRI_2);
}

static function CheckForMultiKill(PlayerController P, TPPlayerReplicationInfo tpRelatedPRI_1, TPPlayerReplicationInfo tpRelatedPRI_2)
{
	// check multikills
	if ( P.Role == ROLE_Authority )
	{
		// multikills checked already in LogMultiKills()
		if ( tpRelatedPRI_1.MultiKillLevel > 0 )
			P.ReceiveLocalizedMessage( class'TPMultiKillMessage', tpRelatedPRI_1.MultiKillLevel );
	}
	else
	{
		if ( ( tpRelatedPRI_1 != tpRelatedPRI_2 ) && ( tpRelatedPRI_2 != None)
			/*&& ((RelatedPRI_2.Team == None) || (RelatedPRI_1.Team != RelatedPRI_2.Team))*/ )
		{
			if ( (P.WorldInfo.TimeSeconds - tpRelatedPRI_1.LastKillTime < tpRelatedPRI_1.MultiKillTimeout) )
			{
				tpRelatedPRI_1.MultiKillLevel++;
				P.ReceiveLocalizedMessage( class'TPMultiKillMessage', tpRelatedPRI_1.MultiKillLevel );
			}
			else
				tpRelatedPRI_1.MultiKillLevel = 0;
			
			tpRelatedPRI_1.LastKillTime = P.WorldInfo.TimeSeconds;
		}
		else
			tpRelatedPRI_1.MultiKillLevel = 0;
	}
}

