/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshGoal_SeedOnRooftop extends NavMeshPathGoalEvaluator
	native(AI);


/** show debug lines **/
var bool bShowDebug;

/** Location to compare from **/
var transient vector Location;

var transient vector Rotation;

var transient vector SearchForRooftopPylonsExtent;

/**
 * Whether we should traverse the list of other goals and call InitializeSearch.  Usually we don't want to do this
 * as the default implementation calls GetPylonAndPolyFromPos
 **/
var transient bool bCallFurtherGoalInitializeSearch;

cpptext
{
	virtual UBOOL InitializeSearch( UNavigationHandle* Handle, const FNavMeshPathParams& PathParams );
	// overridden to add the polys all our goal points are in to the working set instead of just the anchor
	virtual UBOOL SeedWorkingSet( FNavMeshPolyBase*& OpenList, FNavMeshPolyBase* AnchorPoly, DWORD PathSessionID,UNavigationHandle* Handle, const FNavMeshPathParams& PathParams );
	// stop when we reach the anchor
	virtual UBOOL EvaluateGoal( FNavMeshPolyBase* PossibleGoal, const FNavMeshPathParams& PathParams, FNavMeshPolyBase*& out_GenGoal );

	virtual UBOOL DetermineFinalGoal( FNavMeshPolyBase*& out_GenGoal, class AActor** out_DestActor, INT* out_DestItem );
}




static function bool SeedOnRooftop( NavigationHandle NavHandle, vector InLocation, rotator InRotation, vector InSearchForRooftopPylonsExtent, bool InbCallFurtherGoalInitializeSearch )
{
	local NavMeshGoal_SeedOnRooftop Eval;

	if( NavHandle != None )
	{
		Eval = NavMeshGoal_SeedOnRooftop(NavHandle.CreatePathGoalEvaluator(default.class));

		if( Eval != None )
		{
			Eval.Location = InLocation;
			Eval.Rotation = vector(InRotation);
			Eval.SearchForRooftopPylonsExtent = InSearchForRooftopPylonsExtent;
			Eval.bCallFurtherGoalInitializeSearch = InbCallFurtherGoalInitializeSearch;
			NavHandle.AddGoalEvaluator( Eval );
			return TRUE;
		}
	}

	return FALSE;
}




defaultproperties
{
	bShowDebug=TRUE
	//bAlwaysCallEvaluateGoal=TRUE;
}
