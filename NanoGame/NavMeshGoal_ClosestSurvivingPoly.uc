/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshGoal_ClosestSurvivingPoly extends NavMeshPathGoalEvaluator
	native(AI);


/** show debug lines **/
// TODO: prob should promote this
var bool bShowDebug;

/** Location to compare from **/
var transient vector Location;

var transient NavigationHandle DasNavHandle;

var transient native pointer BestRooftopPoly{FNavMeshPolyBase};

var transient float HACK_DistanceToCheck;

var transient vector HACK_ExtentToCheck;

cpptext
{
	virtual UBOOL EvaluateGoal( FNavMeshPolyBase* PossibleGoal, const FNavMeshPathParams& PathParams, FNavMeshPolyBase*& out_GenGoal );
	// determine which goal actor we pathed to first (which was closest)
	virtual UBOOL DetermineFinalGoal( FNavMeshPolyBase*& out_GenGoal, class AActor** out_DestActor, INT* out_DestItem );

}

native function RecycleNative();


static function bool ClosestSurvivingPoly( NavigationHandle NavHandle, vector InLocation, float InHACK_DistanceToCheck, vector InHACK_ExtentToCheck )
{
	local NavMeshGoal_ClosestSurvivingPoly Eval;

	if( NavHandle != None )
	{
		Eval = NavMeshGoal_ClosestSurvivingPoly(NavHandle.CreatePathGoalEvaluator(default.class));

		if( Eval != None )
		{
			Eval.DasNavHandle = NavHandle;
			Eval.Location = InLocation;
			Eval.HACK_DistanceToCheck = InHACK_DistanceToCheck;
			Eval.HACK_ExtentToCheck = InHACK_ExtentToCheck;
			NavHandle.AddGoalEvaluator( Eval );
			return TRUE;
		}
	}

	return FALSE;
}


event Recycle()
{
	RecycleNative();
	Super.Recycle();
}



defaultproperties
{
	MaxPathVisits=1024
	bShowDebug=TRUE
	//bAlwaysCallEvaluateGoal=TRUE
}
