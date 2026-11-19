/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshGoal_SpawnPoints extends NavMeshPathGoalEvaluator
	native(AI);

cpptext
{
	// Interface
	virtual UBOOL EvaluateGoal( FNavMeshPolyBase* PossibleGoal, const FNavMeshPathParams& PathParams, FNavMeshPolyBase*& out_GenGoal );
	virtual UBOOL DetermineFinalGoal( FNavMeshPolyBase*& out_GenGoal, class AActor** out_DestActor, INT* out_DestItem );
}

/** AI looking for cover */
var GearAI_Cover AI;
var array<Vector> PickedSpawnPoints;
// list of spawn points to use in case we didn't find any really good ones
var array<Vector> BackupSpawnPoints;

var int NumSpawnpointsNeeded;
var float MinDistToEnemy;

static function NavMeshGoal_SpawnPoints FindSpawnPoints(NavigationHandle NavHandle, GearAI_Cover InAI, int InNumSpawnPointsNeeded,float InMinDistToEnemy, optional int InMaxpathvisits=-1)
{
	local NavMeshGoal_SpawnPoints Eval;
	if(NavHandle != none && InAI != none)
	{
		Eval = NavMeshGoal_SpawnPoints(NavHandle.CreatePathGoalEvaluator(default.class));
		if(Eval != none)
		{
			Eval.AI = InAI;
			Eval.NumSpawnpointsNeeded = InNumSpawnPointsNeeded;
			Eval.MinDistToEnemy = InMinDistToEnemy;

			if(InMaxPathVisits > 0)
			{
				Eval.MaxPathVisits = InMaxPathVisits;
			}
			NavHandle.AddGoalEvaluator(Eval);
			return Eval;
		}
	}

	return none;
}

function Recycle()
{
	BackupSpawnPoints.length=0;
	AI=none;
	NumSpawnpointsNeeded=default.NumSpawnpointsNeeded;
	maxPathVisits=default.MaxPathVisits;
	MinDistToEnemy=default.MinDistToEnemy;
	Super.Recycle();
}

function ClearFoundSpawns()
{
	PickedSpawnPoints.length=0;
}
defaultproperties
{
	NumSpawnpointsNeeded=1
	MinDistToEnemy=1024
	MaxPathVisits=750
}
