/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Move_Mesh extends NanoAICmd;

/** Current PathCache for nav handle is valid, no need to path find again */
var transient bool	bValidPathCache;
/** Keep partial paths generated along the way and accept best guess if no direct path found */
var transient bool	bAllowPartialPath;

var transient Vector	IntermediatePoint;

var transient bool	bIntermediatePointRedirected;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToPoint
(
			 GameAIController	AI, 
			 Vector				NewMovePoint, 
	optional bool				bIsValidCache,
	optional bool				bAllowPartial,
	optional float              MaxMoveTime
)
{
	local NanoAICmd_Move_Mesh Cmd;

	if( AI != None && NewMovePoint != vect(0,0,0) )
	{
		Cmd = new(AI) default.class;
		if( Cmd != None )
		{
			Cmd.bValidPathCache	= bIsValidCache;
			Cmd.bAllowPartialPath = bAllowPartial;
			AI.Vect2BP( AI.NavigationHandle.FinalDestination, NewMovePoint ); // so this is actually setting the FinalDestination on the NavHandle. Which then GetNextMoveLocation() uses to get to a point that is not the center of the poly
			AI.PushCommand( Cmd );

			if (MaxMoveTime > 0.f)
			{
				AI.SetTimer(MaxMoveTime,FALSE,nameof(Cmd.MoveExpired),Cmd);
			}

			return TRUE;
		}
	}

	return FALSE;
}


function MoveExpired()
{
	`AILog(`location);
	if (Pawn != None)
	{
		Pawn.Acceleration = vect(0,0,0);
	}
	Status = 'Failure';
	AbortCommand(self);
}


function SpecialMoveRedirect(vector NewIntermediatePoint)
{
	IntermediatePoint = NewIntermediatePoint;
	bIntermediatePointRedirected = TRUE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@"Point:"@BP2Vect(NavigationHandle.FinalDestination)@"Focus:"@Focus;
}

function Pushed()
{
	Super.Pushed();

	// Start the move
	GotoState( 'MovingToGoal' );
}


function Popped()
{
	Super.Popped();

	// clear the route cache to make sure any intermediate claims are destroyed
	NavigationHandle.PathCache_Empty();
	MoveTimer = -1.f;

	// explicitly clear velocity/accel as they aren't necessarily
	// cleared by the physics code
	if( Pawn != None )
	{
		Pawn.ZeroMovementVariables();
	}
}

function Paused( GameAICommand NewCommand )
{
	Super.Paused( NewCommand );

	// explicitly clear velocity/accel as they aren't necessarily
	// cleared by the physics code
	if( Pawn != None )
	{
		Pawn.ZeroMovementVariables();
	}
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	if( ChildStatus == 'Success' )
	{
	}
	else
	{
		Status = 'Failure';
		AbortCommand( self );
	}
}

/** Check if AI has successfully reached the given goal */
function bool HasReachedGoal()
{
	if( Pawn == None )
	{
		return TRUE;
	}

	if( GetMovePoint() != vect(0,0,0) )
	{
		// we can check here to see if we are withing MoveOffset distance
		if( VSize(GetMovePoint()-Pawn.Location) <  NanoAIBase(Outer).MoveOffset )
		{
			return TRUE;
		}

		return Pawn.ReachedPoint( GetMovePoint(), None );
	}

    return FALSE;
}

function bool ShouldWaitForSpecialAction()
{
	local NanoPawn NP;

	NP = NanoPawn(Pawn);
	if( NP != None )
	{
		if( NSM_Mantle_Base(NP.ActiveSpecialMove) != None || NSM_Jump_Base(NP.ActiveSpecialMove) != None )
		{
			return TRUE;
		}
		if( NP.CurrentLadder != None )
		{
			return TRUE;
		}
	}
	return FALSE;
}

state MovingToGoal `DEBUGSTATE
{
Begin:
	//debug
	`AILog( "BEGIN TAG"@ BP2Vect(NavigationHandle.FinalDestination)@bValidPathCache@NavigationHandle );

	if( HasReachedGoal() )
	{
		Goto( 'ReachedGoal' );
	}
	else
	if( NavigationHandle.PointReachable( BP2Vect(NavigationHandle.FinalDestination) ) )
	{
		IntermediatePoint = BP2Vect(NavigationHandle.FinalDestination);
	}	
	else
	if( bValidPathCache )
	{
		//debug
		`AILog( "Use existing route cache", 'Move' );
		bValidPathCache = FALSE;
		if( !NavigationHandle.GetNextMoveLocation( IntermediatePoint, Pawn.GetCollisionRadius() ) )
		{
			//debug
			`AILog( "...but couldn't retrieve next move location?" );

			Goto( 'FailedMove' );
		}
	}
	else
	{
		// this probably needs some some "withindistance"
		if( !GeneratePathToLocation( BP2Vect(NavigationHandle.FinalDestination),, bAllowPartialPath ) )
		{
			//debug
			`AILog( "Couldn't generate path to location"@BP2Vect(NavigationHandle.FinalDestination));

			Goto( 'FailedMove' );
		}

		//debug
		`AILog( "Generated path..."@NavigationHandle.GetPathCacheLength() );

		if( !NavigationHandle.GetNextMoveLocation( IntermediatePoint, Pawn.GetCollisionRadius() ) )
		{
			//debug
			`AILog( "Generated path, but couldn't retrieve next move location?" );

			Goto( 'FailedMove' );
		}
	}

	while( TRUE )
	{
		//debug
		`AILog( "Still moving to"@IntermediatePoint, 'Loop' );

		if( !NavigationHandle.SuggestMovePreparation( IntermediatePoint, outer ) )
		{
			`AILog("Calling MoveTo -- "@IntermediatePoint);
			MoveTo( IntermediatePoint, Focus, GetDestinationOffset() );
			`AILog("MoveTo Finished -- "@IntermediatePoint);
			if (bIntermediatePointRedirected)
			{
				`AILog("- post move delay");
				bIntermediatePointRedirected = FALSE;
				Sleep(0.5f);
			}
		}
		else
		{
			`AILog("Suggest move preparation == TRUE");
			if( ShouldWaitForSpecialAction() )
			{
				do 
				{
					Sleep(0.1f);
				} until(!ShouldWaitForSpecialAction());
			}
		}
		
		if( HasReachedGoal() )
		{
			Goto( 'ReachedGoal' );
		}
		else
		if( !NavigationHandle.GetNextMoveLocation( IntermediatePoint, Pawn.GetCollisionRadius() ) )
		{
			`AILog( "Couldn't get next move location" );

			Sleep(0.1f);
			Goto( 'FailedMove' );
		}
		else
		{
			//debug
			`AILog( "NextMove"@IntermediatePoint );
		}
	}

	//debug
	`AILog( "Reached end of move loop??" );

FailedMove:
	Status = 'Failure';
	GotoState('DelayFailure');
	Stop;

ReachedGoal:
	//debug
	`AILog("Reached move point:"@BP2Vect(NavigationHandle.FinalDestination)@VSize(Pawn.Location-BP2Vect(NavigationHandle.FinalDestination)));

	Status = 'Success';
	PopCommand( self );
}


event DrawDebug( HUD H, Name Category )
{
	Super.DrawDebug( H, Category );

	// BLUE
	DrawDebugLine( Pawn.Location, GetDestinationPosition(), 0, 0, 255 );
	// GREEN
	DrawDebugLine( Pawn.Location, BP2Vect(NavigationHandle.FinalDestination), 0, 255, 0 );

	NavigationHandle.DrawPathCache( vect(0,0,15) );
}


final function vector GetMovePoint()
{
	return BP2Vect(NavigationHandle.FinalDestination);
}


defaultproperties
{
}
