/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * goal evaluator which will keep going until a candidate is found which is not in an avoidance volume
 */
class NavMeshGoal_OutsideAvoidanceVolumes extends NavMeshPathGoalEvaluator
	native(AI);

var GearAI AI;
cpptext
{
	// Interface
	virtual UBOOL EvaluateGoal( FNavMeshPolyBase* PossibleGoal, const FNavMeshPathParams& PathParams, FNavMeshPolyBase*& out_GenGoal );
}


static function bool GoOutOfVolumes( NavigationHandle NavHandle, GearAI InAI )
{
	local NavMeshGoal_OutsideAvoidanceVolumes Eval;

	if( NavHandle != None )
	{
		Eval = NavMeshGoal_OutsideAvoidanceVolumes(NavHandle.CreatePathGoalEvaluator(default.class));

		if( Eval != None )
		{
			Eval.AI = InAI ;
			NavHandle.AddGoalEvaluator( Eval );
			return TRUE;
		}
	}

	return FALSE;
}

event Recycle()
{
	Super.Recycle();	
	AI=none;
}

defaultproperties
{
	// this is expensive, and shouldn't be necessary for more than a few hops
	MaxPathVisits=32
}
