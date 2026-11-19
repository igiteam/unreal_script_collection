/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHordeObjective_KillStreak extends GearHordeBonusObjective;

/** number of kills required */
var config int RequiredKills;
/** amount of time players have to get the required number of kills */
var config float RequiredTime;

/** alternate text used when the objective has been partially completed */
var localized string InProgressText;

/** times when enemies have been killed */
var array<float> KillTimeStamps;
/** highest number of kills in the time period, used for partial bonus on failure */
var int BestScore;

static function bool CanBeSelected(GearGameHorde_Base InGame)
{
	return (InGame.CurrentWave > 3);
}

function GetObjectiveInfo(out ObjectiveInfo ObjInfo)
{
	Super.GetObjectiveInfo(ObjInfo);

	ObjInfo.ObjectiveDescVars $= "|" $ (RequiredKills - KillTimeStamps.length) $ "|";
	if (KillTimeStamps.length > 0)
	{
		ObjInfo.ObjectiveDesc = PathName(Class) $ ".InProgressText";
		ObjInfo.ObjectiveDescVars $= int(RequiredTime - (Game.WorldInfo.TimeSeconds - KillTimeStamps[0]));
	}
	else
	{
		ObjInfo.ObjectiveDescVars $= int(RequiredTime);
	}
}

function float GetCompletionPercentage()
{
	return float(BestScore) / float(RequiredKills);
}

/** remove kills that are outside the time window from the array */
final function RemoveOutdatedKills()
{
	while (KillTimeStamps.length > 0 && KillTimeStamps[0] < Game.WorldInfo.TimeSeconds - RequiredTime)
	{
		KillTimeStamps.Remove(0, 1);
	}
}

function ProcessKill(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
	local ObjectiveInfo ObjInfo;

	if (Killer != None && Killer.GetTeamNum() == 0 && !Killer.WorldInfo.GRI.OnSameTeam(Killer, KilledPlayer))
	{
		RemoveOutdatedKills();

		KillTimeStamps.AddItem(Killer.WorldInfo.TimeSeconds);
		BestScore = Max(BestScore, KillTimeStamps.length);
		if (KillTimeStamps.length >= RequiredKills)
		{
			CompleteObjective();
		}
		else
		{
			GetObjectiveInfo(ObjInfo);
			ObjInfo.bNotifyPlayer = false;
			SendObjectiveUpdate(ObjInfo);
		}
	}
}

function Timer()
{
	local ObjectiveInfo ObjInfo;

	if (KillTimeStamps.length > 0)
	{
		RemoveOutdatedKills();

		GetObjectiveInfo(ObjInfo);
		ObjInfo.bNotifyPlayer = false;
		SendObjectiveUpdate(ObjInfo);
	}
}
