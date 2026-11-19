/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Move_UntilInRange extends NanoAICmd_Move_UntilReachable;

var Actor DesiredMoveActor;


/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToVisibleActor
(
			 GameAIController	AI, 
			 Actor				NewMoveActor, 
	optional bool				bIsValidCache,
    optional float              MaxMoveTime
)
{
	local NanoAICmd_Move_UntilInRange Cmd;

	if( AI != None && NewMoveActor != None )
	{
		Cmd = new(AI) default.class;
		if( Cmd != None )
		{
			Cmd.bValidPathCache	= bIsValidCache;
			Cmd.DesiredMoveActor = NewMoveActor;
			AI.Vect2BP( AI.NavigationHandle.FinalDestination, NewMoveActor.Location );
			AI.PushCommand( Cmd );
			if (MaxMoveTime > 0.f)
			{
				AI.SetTimer(MaxMoveTime,FALSE,'MoveExpired',Cmd);
			}
			return TRUE;
		}
	}

	return FALSE;
}

function MoveExpired()
{
    AbortCommand(self);
}

/** Considered reached goal when we can move directly to the target */
function bool HasReachedGoal()
{
	local Vector FD;
	local NanoAI NAI;

	if( Pawn == None )
	{
		return TRUE;
	}

	NAI = NanoAI(GameAIOwner);
	if (DesiredMoveActor != None)
	{
		NAI.Vect2BP(NAI.NavigationHandle.FinalDestination, DesiredMoveActor.Location);
		if (!NAI.LineOfSightTo(DesiredMoveActor))
		{
			return FALSE;
		}
	}

	FD = BP2Vect( NavigationHandle.FinalDestination ); 
	if( FD != vect(0,0,0) )
	{
		if( NAI.IsPointWithinRange( FD ) && NavigationHandle.PointReachable( FD ) )
		{
			return TRUE;
		}
	}

    return FALSE;
}

