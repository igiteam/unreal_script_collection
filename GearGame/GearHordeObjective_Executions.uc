/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHordeObjective_Executions extends GearHordeBonusObjective;

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

/** @return whether enemies killed with this damagetype should count as progress towards the objective */
function bool IsValidDamageType(class<DamageType> DamageType)
{
	return ( DamageType == class'GDT_Chainsaw' || DamageType == class'GDT_Bayonet' || DamageType == class'GDT_FragTag' ||
		DamageType == class'GDT_InkTag' || DamageType == class'GDT_IncendiaryTag' || ClassIsChildOf(DamageType, class'GDT_Execution_Base') );
}

function ProcessKill(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
	local ObjectiveInfo ObjInfo;

	if (Killer != None && Killer.GetTeamNum() == 0 && !Killer.WorldInfo.GRI.OnSameTeam(Killer, KilledPlayer) && IsValidDamageType(DamageType))
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

function ModifyMinCount(EAITypes EnemyType, out int MinCount)
{
	// force there to be a drone at all times so there are always enemies that can be executed
	if (EnemyType == AIType_Drone || EnemyType == AIType_DroneGrenadier)
	{
		MinCount = Max(MinCount, 1);
	}
}

defaultproperties
{
	bAllowSquads=false
}
