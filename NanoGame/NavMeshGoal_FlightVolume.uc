/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NavMeshGoal_FlightVolume extends NavMeshPathGoalEvaluator
	native(AI);
	
cpptext
{
	// Interface
	virtual UBOOL InitializeSearch( UNavigationHandle* Handle, const FNavMeshPathParams& PathParams);
	virtual UBOOL EvaluateGoal( FNavMeshPolyBase* PossibleGoal, const FNavMeshPathParams& PathParams, FNavMeshPolyBase*& out_GenGoal );
	virtual UBOOL DetermineFinalGoal( FNavMeshPolyBase*& out_GenGoal, class AActor** out_DestActor, INT* out_DestItem );
}

/** Flight volume we are attempting to find a poly to reach */
var() transient FlightVolume GoalVolume;

static function bool ToFlightVolume( NavigationHandle NavHandle, optional FlightVolume inGoalVolume )
{
	local NavMeshGoal_FlightVolume Eval;

	if( NavHandle != None )
	{
		Eval = NavMeshGoal_FlightVolume(NavHandle.CreatePathGoalEvaluator(default.class));

		if( Eval != None )
		{
			Eval.GoalVolume	= inGoalVolume;
			NavHandle.AddGoalEvaluator( Eval );
			return TRUE;
		}
	}

	return FALSE;
}


function Recycle()
{
	GoalVolume = None;
	Super.Recycle();
}

defaultproperties
{
	MaxPathVisits=1024
}
