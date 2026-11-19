/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHordeObjective_BuildFlag extends GearHordeBonusObjective;

function CompleteObjective()
{
	local ObjectiveInfo ObjInfo;

	GetObjectiveInfo(ObjInfo);
	ObjInfo.bCompleted = true;
	SendObjectiveUpdate(ObjInfo);

	// no reward for this objective

	Game.ActiveBonusObjective = None;
}

function FailObjective()
{
	local ObjectiveInfo ObjInfo;

	GetObjectiveInfo(ObjInfo);
	ObjInfo.bFailed = true;
	SendObjectiveUpdate(ObjInfo);

	Game.ActiveBonusObjective = None;
}

function Timer()
{
	if (GearGRI_Horde(Game.GameReplicationInfo).FortificationFlags.length > 0)
	{
		CompleteObjective();
	}
	else if (!GearGRI_Horde(Game.GameReplicationInfo).bCanPlaceFortifications)
	{
		FailObjective();
	}
	else
	{
		//@hack: ick, hacky way to pause the deployment phase
		Game.WaveSpawningStartTime += 1.0;
		Game.SetTimer(Game.DeploymentPhaseDuration, false, nameof(Game.EndDeploymentPhase));
		Game.SetTimer(Game.WaveSpawningStartTime - Game.WorldInfo.TimeSeconds, false, nameof(Game.PlayEnemySpawnWarning));
	}
}
