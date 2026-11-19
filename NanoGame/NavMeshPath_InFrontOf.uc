/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshPath_InFrontOf extends NavMeshPathConstraint
	native(AI);

/** Location to compare from **/
var transient vector Location;

var transient vector Rotation;


cpptext
{
	// Interface
	virtual UBOOL EvaluatePath( FNavMeshEdgeBase* Edge, FNavMeshPolyBase* SrcPoly, FNavMeshPolyBase* DestPoly, const FNavMeshPathParams& PathParams, INT& out_PathCost, INT& out_HeuristicCost, const FVector& EdgePoint );
}


static function bool InFrontOf( NavigationHandle NavHandle, vector InLocation, rotator InRotation )
{
	local NavMeshPath_InFrontOf Con;

	if( NavHandle != None )
	{
		Con = NavMeshPath_InFrontOf(NavHandle.CreatePathConstraint(default.class));
		if( Con != None )
		{
			Con.Location = InLocation;
			Con.Rotation = vector(InRotation);
			NavHandle.AddPathConstraint( Con );

			return TRUE;
		}
	}

	return FALSE;
}

function Recycle()
{
	Super.Recycle();
}

defaultproperties
{
}
