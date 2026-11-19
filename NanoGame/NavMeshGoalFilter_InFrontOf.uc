/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshGoalFilter_InFrontOf extends NavMeshGoal_Filter
	native(AI);

/** Location to compare from **/
var transient vector Location;

var transient vector Rotation;


cpptext
{
	// Interface
		/**
	 * Called on each Goal_Filter that is in the list of a generic filter container to determine a goal's fitness for being 'the one'
	 * @param PossibleGoal - the chosen (cheapest) successor from the open list
	 * @param PathParams   - the cached pathfinding params for the pathing entity
	 * @return - TRUE indicates according to this filter's criteria this goal is valid
	 */
	virtual UBOOL IsValidFinalGoal( FNavMeshPolyBase* PossibleGoal, const FNavMeshPathParams& PathParams );
}


static function bool InFrontOf( NavMeshGoal_GenericFilterContainer FilterContainer, vector InLocation, rotator InRotation )
{
	local NavMeshGoalFilter_InFrontOf Eval;

	if( FilterContainer != None )
	{
		Eval = NavMeshGoalFilter_InFrontOf(FilterContainer.GetFilterOfType(default.class));
		if( Eval != None )
		{
			Eval.Location = InLocation;
			Eval.Rotation = vector(InRotation);
			FilterContainer.GoalFilters.AddItem(Eval);

			return TRUE;
		}
	}

	return FALSE;
}


defaultproperties
{
	bShowDebug=FALSE
}
