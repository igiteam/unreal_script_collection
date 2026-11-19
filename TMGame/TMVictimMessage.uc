/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMVictimMessage extends TMWeaponKillMessage;

var(Message) localized string YouWereKilledBy, KilledByTrailer, OrbSuicideString, RunOverString, SpiderMineString, ScorpionKamikazeString, ViperKamikazeString, TelefragString;

static function string GetString(
	optional int Switch,
	optional bool bPRI1HUD,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	local string VictimString;
	local class<TMDamageType> VictimDamageType;

	if (RelatedPRI_1 == None)
	{
		return "";
	}

	if (RelatedPRI_1.PlayerName != "")
	{
		VictimString = Default.YouWereKilledBy@RelatedPRI_1.PlayerName$Default.KilledByTrailer;
		VictimDamageType = Class<TMDamageType>(OptionalObject);
		if ( VictimDamageType != None )
		{
			if ( VictimDamageType.default.DamageWeaponClass != None )
			{
				VictimString = VictimString$" ("$VictimDamageType.default.DamageWeaponClass.default.PickupMessage$")";
			}
			else if ( (class<TMDmgType_RanOver>(VictimDamageType) != None)
						|| (VictimDamageType.default.KillStatsName == 'KILLS_SCORPIONBLADE') )
			{
				VictimString = VictimString@default.RunOverString;
			}
			else if ( VictimDamageType.default.KillStatsName == 'KILLS_SPIDERMINE' )
			{
				VictimString = VictimString@default.SpiderMineString;
			}
			else if ( VictimDamageType.default.KillStatsName == 'KILLS_SCORPIONSELFDESTRUCT' )
			{
				VictimString = VictimString@default.ScorpionKamikazeString;
			}
			else if ( VictimDamageType.default.KillStatsName == 'KILLS_VIPERSELFDESTRUCT' )
			{
				VictimString = VictimString@default.ViperKamikazeString;
			}
			else if ( VictimDamageType.default.KillStatsName == 'KILLS_TRANSLOCATOR' )
			{
				VictimString = VictimString@default.TelefragString;
			}
		}
		return VictimString;
	}
	else
	{
		return "";
	}
}

