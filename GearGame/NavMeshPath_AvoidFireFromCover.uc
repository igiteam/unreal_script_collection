/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshPath_AvoidFireFromCover extends NavMeshPathConstraint
	native(AI);

cpptext
{
	// Interface
	virtual UBOOL EvaluatePath( FNavMeshEdgeBase* Edge, FNavMeshPolyBase* SrcPoly, FNavMeshPolyBase* DestPoly, const FNavMeshPathParams& PathParams, INT& out_PathCost, INT& out_HeuristicCost, const FVector& EdgePoint );
}

var GearAI AI;

struct native NavMeshEnemyCoverInfo
{
	var GearPawn Enemy;
	var CoverInfo Cover;
};

var array<NavMeshEnemyCoverInfo> EnemyList;

/** if > 0, nodes within this distance don't use this constraint (i.e. allow briefly moving through dangerous areas) */
var int IgnoreDist;

static function bool AvoidFireFromCover( NavigationHandle NavHandle )
{
	local NavMeshPath_AvoidFireFromCover Con;
	local GearAI TheAI;
	local GearPawn Enemy;
	local NavMeshEnemyCoverInfo EnemyInfo;

	TheAI = GearAI(NavHandle.Outer);
	if (TheAI != None && TheAI.Squad != None)
	{
		Con = NavMeshPath_AvoidFireFromCover(NavHandle.CreatePathConstraint(default.class));
		Con.AI = TheAI;
		foreach TheAI.Squad.AllEnemies(class'GearPawn', Enemy, TheAI)
		{
			if (Enemy.IsPlayerOwned() && TheAI.GetPlayerCover(Enemy, EnemyInfo.Cover, false))
			{
				EnemyInfo.Enemy = Enemy;
				Con.EnemyList.AddItem(EnemyInfo);
			}
		}
		if (Con.EnemyList.length > 0)
		{
			NavHandle.AddPathConstraint(Con);
		}
		return TRUE;
	}

	return FALSE;
}

function Recycle()
{
	Super.Recycle();

	AI = None;
	EnemyList.length = 0;
	IgnoreDist = 0;
}
defaultproperties
{
}
