/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshPath_AvoidJumpUpsThatAreTooHigh extends NavMeshPathConstraint
	native(AI);

var transient float HowHighCanJumpInUnits;

cpptext
{
	virtual UBOOL EvaluatePath( FNavMeshEdgeBase* Edge, FNavMeshPolyBase* SrcPoly, FNavMeshPolyBase* DestPoly, const FNavMeshPathParams& PathParams, INT& out_PathCost, INT& out_HeuristicCost, const FVector& EdgePoint );
}


static function bool AvoidJumpUpsThatAreTooHigh( NavigationHandle NavHandle, float InHowHighCanJumpInUnits )
{
	local NavMeshPath_AvoidJumpUpsThatAreTooHigh Constraint;

	Constraint = NavMeshPath_AvoidJumpUpsThatAreTooHigh(NavHandle.CreatePathConstraint(default.class));
	if( Constraint != None )
	{
		Constraint.HowHighCanJumpInUnits = InHowHighCanJumpInUnits;

		NavHandle.AddPathConstraint( Constraint );
		return TRUE;
	}
	
	return FALSE;
}


defaultproperties
{
}

