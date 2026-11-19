/**
* rates goals based on how far away they are from the target
*
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class NavMeshGoal_AwayFromPosition extends NavMeshPathGoalEvaluator
	native;

cpptext
{
	// Interface
	virtual UBOOL EvaluateGoal( FNavMeshPolyBase* PossibleGoal, const FNavMeshPathParams& PathParams, FNavMeshPolyBase*& out_GenGoal );
	virtual UBOOL DetermineFinalGoal( FNavMeshPolyBase*& out_GenGoal, class AActor** out_DestActor, INT* out_DestItem );
}

/** location to flee from */
var vector AvoidPos;
/** cached direction from AvoidPos to NavHandle.Location */
var vector AvoidDir;
/** exit with the best result so far if the travel distance to the nodes being evaluated exceeds this */
var int MaxDist;

/** best node we've found so far */
var native pointer BestPoly{FNavMeshPolyBase};
var int BestRating;

static function bool FleeFrom(NavigationHandle NavHandle, vector InAvoidPos, int InMaxDist)
{
	local NavMeshGoal_AwayFromPosition Eval;

	Eval = NavMeshGoal_AwayFromPosition(NavHandle.CreatePathGoalEvaluator(default.class));
	Eval.AvoidPos = InAvoidPos;
	Eval.AvoidDir = Normal(InAvoidPos - NavHandle.Outer.Location);
	Eval.MaxDist = InMaxDist;
	NavHandle.AddGoalEvaluator(Eval);
	return true;
}

function native NativeRecycle();

event Recycle()
{
	Super.Recycle();
	BestRating=0;
	NativeRecycle();
}

defaultproperties
{
}
