/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/** this class is used for the Lambent in the Lambent gametype so that they pass on their scoring info to the global aggregates */
class GearPRI_Lambent extends GearMPPRI;

function int ModifyScore(int Amt, EExperienceBuckets Bucket)
{
	Amt = Super.ModifyScore(Amt, Bucket);

	GearGRI_Lambent(WorldInfo.GRI).LambentScore += Amt;
	return Amt;
}

function ScoreExecution(GearPRI VictimPRI, class<GearDamageType> KillType, EGearDeathType DeathType)
{
	Super.ScoreExecution(VictimPRI, KillType, DeathType);
	GearGRI_Lambent(WorldInfo.GRI).LambentKills += Score_Kills;
	Score_Kills = 0;
}

function ScoreInstantKill(GearPRI VictimPRI, class<GearDamageType> KillType, EGearDeathType DeathType)
{
	Super.ScoreInstantKill(VictimPRI, KillType, DeathType);
	GearGRI_Lambent(WorldInfo.GRI).LambentKills += Score_Kills;
	Score_Kills = 0;
}

function ScoreTakeDown(GearPRI VictimPRI, class<GearDamageType> TakedownType)
{
	Super.ScoreTakeDown(VictimPRI, TakedownType);
	GearGRI_Lambent(WorldInfo.GRI).LambentDowns += Score_Takedowns;
	Score_Takedowns = 0;
}
