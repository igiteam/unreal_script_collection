/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.

 finds the location of the best poly location for the AI to plant a grenade (with some random weighting)  
*/
class NavMeshGoal_GrenadePlantLoc extends NavMeshPathGoalEvaluator
	native(AI);

cpptext
{
	virtual UBOOL EvaluateGoal(FNavMeshPolyBase* PossibleGoal, const FNavMeshPathParams& PathParams, FNavMeshPolyBase*& out_GenGoal);
	virtual UBOOL DetermineFinalGoal(FNavMeshPolyBase*& out_GenGoal, class AActor** out_DestActor, INT* out_DestItem);
}

/** minimum path distance poly must be to be considered */
var int MinDist;

var native private pointer CurrentBestPoly{FNavMeshPolyBase};
var float BestRating;

static final function GrenadePlantLoc(NavigationHandle NavHandle, int InMinDist)
{
	local NavMeshGoal_GrenadePlantLoc Eval;

	Eval = NavMeshGoal_GrenadePlantLoc(NavHandle.CreatePathGoalEvaluator(default.class));
	Eval.MinDist = InMinDist;
	NavHandle.AddGoalEvaluator(Eval);
}

native final function RecycleNative();

event Recycle()
{
	RecycleNative();
	BestRating = default.BestRating;
	MinDist = default.MinDist;

	Super.Recycle();
}

defaultproperties
{
	BestRating=10000000.0
}
