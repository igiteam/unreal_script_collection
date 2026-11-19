/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHordeObjective_Headshot extends GearHordeBonusObjective;

/** number of kills required */
var config int RequiredKills;

function GetObjectiveInfo(out ObjectiveInfo ObjInfo)
{
	Super.GetObjectiveInfo(ObjInfo);
	ObjInfo.ObjectiveDescVars $= "|" $ string(RequiredKills);
}

function float GetCompletionPercentage()
{
	return 1.0 - float(RequiredKills) / float(default.RequiredKills);
}

function ProcessKill(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
	local ObjectiveInfo ObjInfo;

	if ( Killer != None && Killer.GetTeamNum() == 0 && !Killer.WorldInfo.GRI.OnSameTeam(Killer, KilledPlayer) &&
		GearPawn(KilledPawn) != None && GearPawn(KilledPawn).bLastHitWasHeadShot  )
	{
		RequiredKills--;
		if (RequiredKills == 0)
		{
			CompleteObjective();
		}
		else
		{
			GetObjectiveInfo(ObjInfo);
			SendObjectiveUpdate(ObjInfo);
		}
	}
}

defaultproperties
{
	bAllowSquads=false
}

