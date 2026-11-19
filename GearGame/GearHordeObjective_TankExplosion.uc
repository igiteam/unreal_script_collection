/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHordeObjective_TankExplosion extends GearHordeBonusObjective;

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

static function bool CanBeSelected(GearGameHorde_Base InGame)
{
	local int i;
	local GearHordeEnemyList List;
	local EnemySelection Choice;

	// only allow if a flame drone or boomer can actually spawn this wave
	foreach InGame.EnemyLists(List)
	{
		Choice.List = List;
		for (i = 0; i < List.EnemyList.length; i++)
		{
			Choice.Index = i;
			if (InGame.IsValidEnemyChoice(Choice, false))
			{
				if (List.EnemyList[i].EnemyType == AIType_FlameDrone || List.EnemyList[i].EnemyType == AIType_BoomerFlame)
				{
					return true;
				}
			}
		}
	}

	return false;
}

function ModifyMinCount(EAITypes EnemyType, out int MinCount)
{
	// make sure there are always the required enemies around so the players have enough chances to complete the objective
	if (EnemyType == AIType_FlameDrone || EnemyType == AIType_BoomerFlame)
	{
		MinCount = Max(MinCount, 1);
	}
}

function ProcessKill(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
	local ObjectiveInfo ObjInfo;

	if ( Killer != None && Killer.GetTeamNum() == 0 && !Killer.WorldInfo.GRI.OnSameTeam(Killer, KilledPlayer) && DamageType == class'GDT_FlameTankExplosion' &&
		(KilledPawn.IsA('GearPawn_LocustBoomerFlame') || KilledPawn.IsA('GearPawn_LocustFlameDrone')) )
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
