/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_MoveToRoute extends AICommand
	within GearAI;

/** GoW global macros */

/** Currently assigned route, which is used to update tethers */
var Route			RouteMoveGoal;
/** Current direction for the route */
var	ERouteDirection	RouteDirection;
/** Current index within route stream */
var int				RouteIndex;
/** Running route is interruptable by enemies? */
var bool			bInterruptable;

/** direction to go if something fails and we need to try again */
var ERouteDirection FallBackDirection;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToRoute( GearAI AI, Route NewRouteMoveGoal, optional ERouteDirection NewRouteDirection, optional bool inbInterruptable = TRUE )
{
    local AICmd_MoveToRoute Cmd;

    if( AI != None && NewRouteMoveGoal != None )
    {
	Cmd = new(AI) class'AICmd_MoveToRoute';
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
	bShouldRoadieRun = (MoveAction != None && MoveAction.MovementStyle == EMS_Fast);
	if(!MoveToNextRoutePoint())
	{
		GotoState('DelayFailure');
	}
}

function bool MoveToNextRoutePoint()
{
	local Actor NewRouteNode;

	NewRouteNode = GetNextRouteNode();
	if(NewRouteNode == none)
	{
		return false;
	}
	return SetTether(NewRouteNode.Location , NewRouteNode, Pawn.GetCollisionRadius(),,, bInterruptable );
}

function Popped()
{
	Super.Popped();
	// clear out existing tether in case we got interrupted
	ClearTether();
	ActiveRoute = None;
	NotifyRouteComplete();
	bMovingToRoute = FALSE;
}

function Resumed( Name OldCommandName )
{

	Super.Resumed( OldCommandName );

	// Don't continue routes when in combat
	if( bInterruptable && HasAnyEnemies() )
	{
		Status = (ChildStatus != 'Success') ? 'Failure' : 'Success';
		PopCommand( self );
	}
	else
	{
		if(!MoveToNextRoutePoint())
		{
			Status = (ChildStatus != 'Success') ? 'Failure' : 'Success';
			PopCommand( self );
		}
	}
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
final protected function Actor GetNextRouteNode()
{
	local byte bReverse, bComplete;

	bReachedMoveGoal = FALSE;

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
				FallBackDirection = ERD_Forward;
				RouteDirection	= ERD_Reverse;
			}
		}
		else
		{
			`AILog(GetFuncName()@"RouteDir != FORWARD, resolving index "$RouteIndex-1);
			RouteIndex = RouteMoveGoal.ResolveRouteIndex( RouteIndex-1, RouteDirection, bComplete, bReverse );
			if( bReverse != 0 )
			{
				FallBackDirection = ERD_Reverse;
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
	`AILog( GetFuncName()@"L?"@IsSquadLeader()@"SquadRoute:"@Squad.SquadRoute, 'Scripted' );

	// this is so that if we're given a route from a spawner tether we clear it out once we arrive
	bSpawnerTetherInterruptable=TRUE;

	// if we're the squad leader and we got to the end of the route, clear the squad route
	if(IsSquadLeader() &&  Squad.SquadRoute != none )
	{
		Squad.SetSquadRoute(none);
	}
	// Notify the move action that the goal has been reached
	if( MoveAction != None )
	{
		if(Status=='Success')
		{
			MoveAction.ReachedGoal( AIOwner );
		}
		ClearMoveAction();
	}
}

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

// if a repath is required, we need to abort active movetogoal, so that we can have a chance to re-stich
function NotifyNeedRepath()
{
	`AILog(self@GetFuncName()@"Aborting tether/movetogoal and initiating a re-stitch"@RouteIndex@RouteMoveGoal.RouteType@FallBackDirection);
	CachedGearChildCommand.NotifyNeedRepath();
	RouteIndex = -1;
	RouteDirection = FallBackDirection;
	bReevaluatePath = false;
	AbortCommand(None, class'AICmd_MoveToTether');
	AbortCommand(None, class'AICmd_MoveToGoal_Mesh');
}

