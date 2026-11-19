/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshGoal_SeedOnStreet extends NavMeshPathGoalEvaluator
	native(AI);


/** show debug lines **/
// TODO: prob should promote this
var bool bShowDebug;

/** Location to compare from **/
var transient vector Location;

var transient vector Rotation;

var transient vector SearchForStreetPylonsExtent;

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

static function bool SeedOnStreet( NavigationHandle NavHandle, vector InLocation, rotator InRotation, vector InSearchForStreetPylonsExtent, bool InbCallFurtherGoalInitializeSearch )
{
	local NavMeshGoal_SeedOnStreet Eval;

	if( NavHandle != None )
	{
		Eval = NavMeshGoal_SeedOnStreet(NavHandle.CreatePathGoalEvaluator(default.class));

		if( Eval != None )
		{
			Eval.Location = InLocation;
			Eval.Rotation = vector(InRotation);
			Eval.SearchForStreetPylonsExtent = InSearchForStreetPylonsExtent;
			Eval.bCallFurtherGoalInitializeSearch = InbCallFurtherGoalInitializeSearch;
			NavHandle.AddGoalEvaluator( Eval );
			return TRUE;
		}
	}

	return FALSE;
}


defaultproperties
{
	MaxPathVisits=1024
	bShowDebug=TRUE
	//bAlwaysCallEvaluateGoal=TRUE;
}
