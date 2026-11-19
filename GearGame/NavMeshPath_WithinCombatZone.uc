/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshPath_WithinCombatZone extends NavMeshPathConstraint
	native(AI);

// if this is non-null we will check to see if the nodes are in this combat zone only, rather than checking the list
var CombatZone SpecificCombatZone;
cpptext
{
	// Interface
	virtual UBOOL EvaluatePath( FNavMeshEdgeBase* Edge, FNavMeshPolyBase* SrcPoly, FNavMeshPolyBase* DestPoly, const FNavMeshPathParams& PathParams, INT& out_PathCost, INT& out_HeuristicCost, const FVector& EdgePoint );
}

var GearAI AI;

/** penalty to apply to edges which start inside a desired combat zone and then leave (to encourage traversal within combat zones first) **/
var() int LeavingCombatZonePenalty;

static function bool WithinCombatZone( NavigationHandle NavHandle, optional int inPenalty, optional CombatZone InSpecificCombatZone )
{
	local NavMeshPath_WithinCombatZone Constraint;
	local GearAI C;

	if( NavHandle != None )
	{
		C = GearAI(NavHandle.Outer);
		if( C != None && C.CombatZoneList.Length > 0 )
		{
			Constraint = NavMeshPath_WithinCombatZone(NavHandle.CreatePathConstraint(default.class));
			if( Constraint != None )
			{
				if( inPenalty > 0 )
				{
					Constraint.LeavingCombatZonePenalty = inPenalty;
				}
				Constraint.AI = C;
				Constraint.SpecificCombatZone = InSpecificCombatZone;
				NavHandle.AddPathConstraint( Constraint );
				return TRUE;
			}
		}
	}

	return FALSE;
}

function Recycle()
{
	AI=none;
	Super.Recycle();
}

defaultproperties
{
	LeavingCombatZonePenalty=100
}

