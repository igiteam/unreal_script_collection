/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshPath_AvoidJumpsDownThatWillKill extends NavMeshPathConstraint
	native(AI);

var transient float DestZValueThatICanSurvive;

cpptext
{
	virtual UBOOL EvaluatePath( FNavMeshEdgeBase* Edge, FNavMeshPolyBase* SrcPoly, FNavMeshPolyBase* DestPoly, const FNavMeshPathParams& PathParams, INT& out_PathCost, INT& out_HeuristicCost, const FVector& EdgePoint );
}


static function bool AvoidJumpsThatWillKill( NavigationHandle NavHandle, float InDestZValueThatICanSurvive )
{
	local NavMeshPath_AvoidJumpsDownThatWillKill Constraint;

	Constraint = NavMeshPath_AvoidJumpsDownThatWillKill(NavHandle.CreatePathConstraint(default.class));
	if( Constraint != None )
	{
		Constraint.DestZValueThatICanSurvive = InDestZValueThatICanSurvive;

		NavHandle.AddPathConstraint( Constraint );
		return TRUE;
	}
	
	return FALSE;
}


defaultproperties
{
}

