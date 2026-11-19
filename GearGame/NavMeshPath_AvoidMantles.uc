/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshPath_AvoidMantles extends NavMeshPathConstraint
	native(AI);

var GearAI AI;
cpptext
{
	// Interface
	virtual UBOOL EvaluatePath( FNavMeshEdgeBase* Edge, FNavMeshPolyBase* SrcPoly, FNavMeshPolyBase* DestPoly, const FNavMeshPathParams& PathParams, INT& out_PathCost, INT& out_HeuristicCost, const FVector& EdgePoint );
}


static function bool AvoidMantlesWhenOutOfCombat( NavigationHandle NavHandle, GearAI inAI )
{
	local NavMeshPath_AvoidMantles Constraint;

	if (NavHandle != None && inAI.bAvoidIdleMantling && inAI.Squad != None && inAI.Squad.EnemyList.length == 0)
	{
		Constraint = NavMeshPath_AvoidMantles(NavHandle.CreatePathConstraint(default.class));
		if( Constraint != None )
		{
			Constraint.AI = inAI;
			NavHandle.AddPathConstraint( Constraint );
			return TRUE;
		}
	}

	return FALSE;
}
function Recycle()
{
	Super.Recycle();
	AI = none;
}

defaultproperties
{
}

