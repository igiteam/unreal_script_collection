/**
 * Hack to fix police cars spawning near each other due to goals being non composeable.
 *
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshPath_NotNearOtherPoliceCars extends NavMeshPathConstraint
	native(AI);


var transient float HowFarAwayFromOtherPolicCars;


cpptext
{
	virtual UBOOL EvaluatePath( FNavMeshEdgeBase* Edge, FNavMeshPolyBase* SrcPoly, FNavMeshPolyBase* DestPoly, const FNavMeshPathParams& PathParams, INT& out_PathCost, INT& out_HeuristicCost, const FVector& EdgePoint );
}


static function bool NotNearOtherPoliceCars( NavigationHandle NavHandle, float InHowFarAwayFromOtherPolicCars )
{
	local NavMeshPath_NotNearOtherPoliceCars Constraint;

	Constraint = NavMeshPath_NotNearOtherPoliceCars(NavHandle.CreatePathConstraint(default.class));
	if( Constraint != None )
	{
		Constraint.HowFarAwayFromOtherPolicCars = InHowFarAwayFromOtherPolicCars;

		NavHandle.AddPathConstraint( Constraint );
		return TRUE;
	}
	
	return FALSE;
}


defaultproperties
{
}

