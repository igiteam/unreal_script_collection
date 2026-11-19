/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshGoalFilter_OnRooftop extends NavMeshGoal_Filter
	native(AI);




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




static function bool MustBeOnRooftop( NavMeshGoal_GenericFilterContainer FilterContainer )
{
	local NavMeshGoalFilter_OnRooftop	Eval;

	if( FilterContainer != None )
	{
		Eval = NavMeshGoalFilter_OnRooftop(FilterContainer.GetFilterOfType(default.class));

		if( Eval != None )
		{
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
