
/** returns as the goal the farthest NavigationPoint of the given list that is within the specified range
 * if none found within range, keeps searching until it finds one or it runs out of paths
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshGoal_FarthestNavInRange extends NavMeshPathGoalEvaluator
	native;

cpptext
{
	virtual UBOOL InitializeSearch( UNavigationHandle* Handle, const FNavMeshPathParams& PathParams );
	virtual UBOOL EvaluateGoal( FNavMeshPolyBase* PossibleGoal, const FNavMeshPathParams& PathParams, FNavMeshPolyBase*& out_GenGoal );
	virtual UBOOL DetermineFinalGoal( FNavMeshPolyBase*& out_GenGoal, class AActor** out_DestActor, INT* out_DestItem );
}

/** the maximum distance to search - will abort when this distance is reached unless none of the goal nodes have been encountered */
var int OptimalMaxDist;
/** list of goals to search for */
var array<BiasedGoalActor> GoalList;

var native map{FNavMeshPolyBase*,FBiasedGoalActor} PolyToGoalActorMap;

/** current best result */
var actor CurrentBest;

var native pointer CurrentBestPoly{FNavMeshPolyBase};

static function NavMeshGoal_FarthestNavInRange FarthestNavInRange(NavigationHandle NavHandle, int InOptimalMaxDist, const out array<BiasedGoalActor> InGoalList)
{
	local NavMeshGoal_FarthestNavInRange Eval;

	Eval = NavMeshGoal_FarthestNavInRange(NavHandle.CreatePathGoalEvaluator(default.class));

	Eval.OptimalMaxDist = InOptimalMaxDist;
	Eval.GoalList = InGoalList;
	NavHandle.AddGoalEvaluator(Eval);
	return Eval;
}

event Recycle()
{
	Super.Recycle();
	RecycleInternal();
}
native function RecycleInternal();

defaultproperties
{
	MaxPathVisits=10000 // don't want it to fail for this reason, reduce OptimalMaxDist to improve performance instead
}
