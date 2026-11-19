/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Move_UntilReachable extends NanoAICmd_Move_Mesh;

var float CheckGoalInterval;

function Pushed()
{
	Super.Pushed();
	SetTimer( CheckGoalInterval, TRUE, nameof(CheckReachedGoal), self );
}

function Popped()
{
	Super.Popped();
	ClearTimer( nameof(CheckReachedGoal), self );
}

function CheckReachedGoal()
{
	if( HasReachedGoal() )
	{
		`AILog( "REACHED GOAL EARLY" );
		MoveTimer = -1.f;
	}
}

/** Considered reached goal when we can move directly to the target */
function bool HasReachedGoal()
{
	if( Pawn == None )
	{
		return TRUE;
	}

	if( BP2Vect( NavigationHandle.FinalDestination ) != vect(0,0,0) )
	{
		return NavigationHandle.PointReachable( BP2Vect(NavigationHandle.FinalDestination) );
	}

    return FALSE;
}

defaultproperties
{
	CheckGoalInterval=0.5f
}

