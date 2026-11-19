/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshPath_PreferWalls extends NavMeshPathConstraint
	native(AI);

var int FloorPenalty;

cpptext
{
	// Interface
	virtual UBOOL EvaluatePath( FNavMeshEdgeBase* Edge, FNavMeshPolyBase* SrcPoly, FNavMeshPolyBase* DestPoly, const FNavMeshPathParams& PathParams, INT& out_PathCost, INT& out_HeuristicCost, const FVector& EdgePoint );
}


static function bool PreferWalls( NavigationHandle NavHandle, optional int inFloorPenalty )
{
	local NavMeshPath_PreferWalls Constraint;

	if (NavHandle != None)
	{
		Constraint = NavMeshPath_PreferWalls(NavHandle.CreatePathConstraint(default.class));
		if( Constraint != None && inFloorPenalty > 0 )
		{
			Constraint.FloorPenalty = inFloorPenalty;
			NavHandle.AddPathConstraint( Constraint );
			return TRUE;
		}
	}

	return FALSE;
}
function Recycle()
{
	Super.Recycle();
	FloorPenalty = default.FloorPenalty;
}

defaultproperties
{
	FloorPenalty=10
}

