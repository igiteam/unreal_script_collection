/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_MoveToRoute extends NanoAICmd
	within NanoAI;
	
var SeqAct_MoveAlongRoute RouteAction;

/** Currently assigned route, which is used to update tethers */
var Route			RouteMoveGoal;
/** Current direction for the route */
var	ERouteDirection	RouteDirection;
/** Current index within route stream */
var int				RouteIndex;
/** Running route is interruptable by enemies? */
var bool			bInterruptable;


/** internal vars used for route stitching */
var Actor CurRouteActor;
var int OldRouteIdx;
var int WayPointsProcessed;
var byte bWrapped;
var byte bLastRouteWasEnd;
var int FailCount;
/******************************************/

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToRoute( NanoAI AI, Route NewRouteMoveGoal, optional ERouteDirection NewRouteDirection, optional bool inbInterruptable = TRUE )
{
    local NanoAICmd_MoveToRoute Cmd;

    if( AI != None && NewRouteMoveGoal != None )
    {
        Cmd = new(AI) class'NanoAICmd_MoveToRoute';
        if( Cmd != None )
        {
            Cmd.RouteMoveGoal		= NewRouteMoveGoal;
			Cmd.RouteDirection		= NewRouteDirection;
			Cmd.RouteIndex			= -1;
			Cmd.bInterruptable		= inbInterruptable;
            AI.PushCommand( Cmd );
            return TRUE;
        }
    }
    return FALSE;
}

static function MoveUsingRouteAction(NanoAI AI, SeqAct_MoveAlongRoute Action)
{
    local NanoAICmd_MoveToRoute Cmd;
    if( AI != None && Action.Route != None )
    {
        Cmd = new(AI) class'NanoAICmd_MoveToRoute';
        if( Cmd != None )
        {
			Cmd.RouteAction			= Action;
            Cmd.RouteMoveGoal		= Action.Route;
			Cmd.RouteDirection		= Action.RouteDirection;
			Cmd.RouteIndex			= -1;
			Cmd.bInterruptable		= TRUE;
            AI.PushCommand( Cmd );
        }
    }
}

function bool HandleMoodChange(EAIMoods NewMood)
{
	if (RouteAction != None && NewMood >= RouteAction.InterruptOnMood)
	{
		Status = 'Interrupted';
		AbortCommand(self);
		return TRUE;
	}
	return Super.HandleMoodChange(NewMood);
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@"Route:"@RouteMoveGoal@"Direction:"@RouteDirection;
}

function Pushed()
{
	Super.Pushed();

	bMovingToRoute   = TRUE;
	ActiveRoute = RouteMoveGoal;
	GotoState('MoveAlongRoute');
}

function Popped()
{
	Super.Popped();

	if (RouteAction != None)
	{
		if (Status != 'Success')
		{
			// interrupted
			RouteAction.ActivateOutputLink(RouteAction.OutputLinks.Length-3);
		}
		else
		{
			// finished
			RouteAction.ActivateOutputLink(RouteAction.OutputLinks.Length-1);
		}
		LatentActions.RemoveItem(RouteAction);
	}

	// clear out existing tether in case we got interrupted
	ActiveRoute = None;
	NotifyRouteComplete();
	bMovingToRoute = FALSE;
}

function Resumed( Name OldCommandName )
{

	Super.Resumed( OldCommandName );

	`AILog( "Route resumed..."@FailCount@RouteIndex@bLastRouteWasEnd );

	`AILog(`showvar(ChildStatus)@`showvar(RouteAction)@`showvar(CurRouteActor));
	if (ChildStatus == 'Success' && RouteAction != None)
	{
		// activate matching route index output
		RouteAction.LastReached = CurRouteActor;
		RouteAction.PopulateLinkedVariableValues();
		RouteAction.ActivateOutputLink(RouteIndex);
		// and activate the any output
		RouteAction.ActivateOutputLink(RouteAction.OutputLinks.Length-2);
	}

	//fix
/*	// Don't continue routes when in combat
	if( bInterruptable && HasAnyEnemies() )
	{
		Status = (ChildStatus != 'Success') ? 'Failure' : 'Success';
		PopCommand( self );
	}
	else
	{*/
		// if we're not done yet, try again!
		if( FailCount < 5 && (RouteIndex != -1 && bLastRouteWasEnd == 0) )
		{
			// if child command failed (we failed to make our target) try again from the best starting node
			if(ChildStatus == 'Failure')
			{
				RouteIndex = -1;
				FailCount++;
			}
			GotoState('MoveAlongRoute',,TRUE);
		}
		else
		{
			`AILog(`location@`showvar(ChildStatus));
			Status = (ChildStatus != 'Success') ? 'Failure' : 'Success';
			PopCommand( self );
		}
//	}
}

function Paused(GameAICommand NewCommand)
{
	//debug
	`AILog( "COMMAND PAUSED:"@self@"by"@NewCommand );
}


/**
 *	Retrieve next point along the route
 *	Handle reversing directions, wrapping route, etc
 */
final protected function Actor GetNextRouteNode( out byte bReverse, out byte bComplete )
{
	bComplete = 0;
	bReverse  = 0;

	if( RouteIndex < 0 )
	{
		RouteIndex = RouteMoveGoal.MoveOntoRoutePath( Pawn, RouteDirection );
	}
	else
	{
		if( RouteDirection == ERD_Forward )
		{
			`AILog(GetFuncName()@"RouteDir=FORWARD, resolving index "$RouteIndex+1);
			RouteIndex = RouteMoveGoal.ResolveRouteIndex( RouteIndex+1, RouteDirection, bComplete, bReverse );
			if( bReverse != 0 )
			{
				RouteDirection	= ERD_Reverse;
			}
		}
		else
		{
			`AILog(GetFuncName()@"RouteDir != FORWARD, resolving index "$RouteIndex-1);
			RouteIndex = RouteMoveGoal.ResolveRouteIndex( RouteIndex-1, RouteDirection, bComplete, bReverse );
			if( bReverse != 0 )
			{
				RouteDirection	= ERD_Forward;
			}
		}

	}

	`AILog(GetFuncName()@"Using route index"@RouteIndex@( RouteIndex >= 0 ? RouteMoveGoal.RouteList[RouteIndex].Actor : None )@bReverse);
	return ( RouteIndex >= 0 ? RouteMoveGoal.RouteList[RouteIndex].Actor : None );
}



/** Route has been completed, trigger events */
final function NotifyRouteComplete()
{
	//debug
	`AILog( GetFuncName(), 'Scripted' );

	//fix
/*	// Notify the move action that the goal has been reached
	if( MoveAction != None )
	{
		if( Status == 'Success' )
		{
			MoveAction.ReachedGoal( GameAIOwner );
		}
		ClearMoveAction();
	}*/
}

final function int GetRouteLength()
{
	if( RouteMoveGoal.RouteType == ERT_Circle )
	{
		return RouteMoveGoal.RouteList.Length-1;
	}

	return RouteMoveGoal.RouteList.Length;
}

state MoveAlongRoute
{
Begin:
	WayPointsProcessed = 0;
	OldRouteIdx = RouteIndex;

	// Get potential move goal
	CurRouteActor = GetNextRouteNode( bWrapped, bLastRouteWasEnd );
	while( bWrapped == 0 && bLastRouteWasEnd == 0 && WayPointsProcessed++ < GetRouteLength() )
	{
		if( (CurRouteActor == None || Pawn.ReachedDestination( CurRouteActor )) && WayPointsProcessed < GetRouteLength() )
		{
			`AILog("Skipping current waypoint:"@CurRouteActor);
			CurRouteActor = GetNextRouteNode( bWrapped, bLastRouteWasEnd );
			continue;				
		}
		else
		{
			`AILog( "Try to path to route actor..."@CurRouteActor );
			break;
		}
	}

	if( CurRouteActor == None )
	{
		if (bLastRouteWasEnd != 0)
		{
			`AILog("Last route was end");
			Status = 'Success';
			PopCommand(self);
		}
		//debug
		`AILog(GetStateName()@"failed to path get route actor");
		RouteIndex = OldRouteIdx;
		if( FailCount++ > 5 )
		{
			GotoState( 'DelayFailure' );
		}
	}

	MoveToActor( CurRouteActor,, TRUE );

	// Shouldn't get here - SHOULD BE POPPED THRU RESUME ONLY
	`AILog( "ROUTE ENDED WRONG?!?!" );
	Status = (ChildStatus != 'Success') ? 'Failure' : 'Success';
	PopCommand( self );
};

event DrawDebug( HUD H, Name Category )
{
	local int Idx;

	Super.DrawDebug( H, Category );

	if(Category != 'Pathing')
	{
		return;
	}

	if( RouteMoveGoal != None )
	{
		for( Idx = 1; Idx < RouteMoveGoal.RouteList.Length; Idx++ )
		{
			DrawDebugLine( RouteMoveGoal.RouteList[Idx-1].Actor.Location + vect(0,0,15), RouteMoveGoal.RouteList[Idx].Actor.Location + vect(0,0,15), 255, 128, 255 );
		}
	}
}

defaultproperties
{
}

