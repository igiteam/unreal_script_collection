/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshGoalFilter_MinDistance extends NavMeshGoal_Filter
	native(AI);



var transient protected vector FromLocation;

var transient protected int MinDistanceFromLocation;


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


static function bool MinDistanceFromLoc( NavMeshGoal_GenericFilterContainer FilterContainer, const vector InFromLocation, int InMinDistanceFromLocation )
{
	local NavMeshGoalFilter_MinDistance	Eval;

	if( FilterContainer != None )
	{
		Eval = NavMeshGoalFilter_MinDistance(FilterContainer.GetFilterOfType(default.class));

		if( Eval != None )
		{
			Eval.FromLocation = InFromLocation;
			Eval.MinDistanceFromLocation = InMinDistanceFromLocation;
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
