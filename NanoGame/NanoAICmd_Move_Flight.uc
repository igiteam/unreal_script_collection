/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Move_Flight extends NanoAICmd within NanoAI;

var() Vector TakeOffPosition, LandPosition;
var() FlightPivot SrcPivot, DestPivot;
var array<NavigationPoint> FlightRouteCache;
var() BasedPosition FinalDestination;
var() bool bOldUseBoidMovement;

/** Name of navigation state we are going to use */
var() Name	PendingStateName;


/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToPoint
(
			 NanoAI	AI, 
			 Vector	NewMovePoint
)
{
	local NanoAICmd_Move_Flight Cmd;

	if( AI != None && NewMovePoint != vect(0,0,0) )
	{
		Cmd = new(AI) default.class;
		if( Cmd != None )
		{
			AI.Vect2BP( Cmd.FinalDestination, NewMovePoint );
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

// HAX - should handle moving to a dynamic actor not just the snap shot location
/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToActor
(
	NanoAI	AI, 
	Actor	NewMoveActor
 )
{
	local NanoAICmd_Move_Flight Cmd;
	local Vector NewLoc, TestLoc;
	local Rotator Rot;
	local int i;

	if( AI != None && NewMoveActor != None )
	{
		NewLoc = NewMoveActor.Location;
		// Pick offset from the pawn to move to
		if( Pawn(NewMoveActor) != None )
		{
			Rot = rot(0,16384,0) * Rand(3);
			for( i = 0; i < 4; i++ )
			{
				TestLoc = NewLoc + (vect(1,0,0) >> (Rot + (i * rot(0,16384,0)))) * 256.f;
				if( class'NavigationHandle'.static.GetPylonFromPos(TestLoc) != None &&
					NewMoveActor.FastTrace(TestLoc, NewMoveActor.Location) )
				{
					NewLoc = TestLoc;
					break;
				}
			}
		}

		Cmd = new(AI) default.class;
		if( Cmd != None )
		{
			AI.Vect2BP( Cmd.FinalDestination, NewLoc );
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();

	bOldUseBoidMovement = bUseBoidMovement;
	GotoState( 'ChooseNavigationMethod' );
}

function Popped()
{
	Super.Popped();
	SetUseBoidMovement( bOldUseBoidMovement );
}

function FlightVolume GetFlightVolumeFromPos( Vector Loc )
{
	local NanoGame NG;
	local int Idx;

	NG = NanoGame(WorldInfo.Game);
	if( NG != None )
	{
		for( Idx = 0; Idx < NG.FlightVolumes.Length; Idx++ )
		{
			if( NG.FlightVolumes[Idx].EncompassesPoint( Loc ) )
			{
				return NG.FlightVolumes[Idx];
			}
		}
	}
	return None;
}


state ChooseNavigationMethod `DEBUGSTATE
{
	function PickAction()
	{
		local Pylon SrcPylon, DestPylon;
		local Vector Src, Dest;
		local float Dist;
		local bool bWalkReachable;
		local NanoNavigationHandle NH;
		local int RtIdx;
		local bool bDrawDebugInfo;
		
		Src = Pawn.Location;
		Dest = BP2Vect( FinalDestination );
		Dist = VSize(Pawn.Location-Dest);

		// If can get directly to the goal location, just move right there
		if( NavigationHandle.PointReachable(Dest) )
		{
			PendingStateName = 'UseNavigationMesh';
			return;
		}

		SrcPylon = NavigationHandle.GetPylonFromPos( Src );
		DestPylon = NavigationHandle.GetPylonFromPos( Dest );
	
		//debug
		`AILog( GetFuncName()@SrcPylon@DestPylon@Dist );

		bDrawDebugInfo = FALSE;
		if( bDrawDebugInfo )
		{
			FlushPersistentDebugLines();
			DrawDebugBox( Src, vect(10,10,10), 255, 255, 255, TRUE );
			DrawDebugBox( Dest, vect(10,10,10), 255, 255, 255, TRUE );
		}

		// If both src and dest are on the ground
		if( SrcPylon != None )
		{
			// If pylons can reach eachother
			if( SrcPylon.CanReachPylon( DestPylon, GameAIOwner ) )
			{
				//	Set reachable flag
				bWalkReachable = TRUE;
				//	If dist is short enough
				if( Dist < 1024.f )
				{
					// Don't bother trying to fly... just walk
					PendingStateName = 'UseNavigationMesh';
					return;
				}
			}
		}

		NH = NanoNavigationHandle(NavigationHandle);
		if( NH != None )
		{
			//	If I can reach a flight volume from src pylon
			if( NH.CanUseFlightNetwork( Src, Dest, TakeOffPosition, LandPosition, SrcPivot, DestPivot ) )
			{
				// DRAW DEBUG STUFF!
				if( bDrawDebugInfo )
				{
					DrawDebugBox( TakeOffPosition, vect(10,10,10), 0, 255, 0, TRUE );
					DrawDebugBox( LandPosition, vect(10,10,10), 255, 0, 0, TRUE );
					DrawDebugBox( SrcPivot.Location, vect(10,10,10), 0, 255, 0, TRUE );
					DrawDebugBox( DestPivot.Location, vect(10,10,10), 255, 0, 0, TRUE );
					for( RtIdx = 0; RtIdx < RouteCache.Length; RtIdx++ )
					{
						if( RouteCache[RtIdx] != SrcPivot && 
							RouteCache[RtIdx] != DestPivot )
						{
							DrawDebugBox( RouteCache[RtIdx].Location, vect(10,10,10), 0, 0, 255, TRUE );
						}
					}
				}

				FlightRouteCache = RouteCache;
				PendingStateName = 'UseFlightNetwork';
				return;
			}
		}

		//	If reachable flag is set
		if( bWalkReachable )
		{
			PendingStateName = 'UseNavigationMesh';
			return;
		}
		
		// FAIL
		PendingStateName = '';
	}

Begin:
	//debug
	`AILog( "BEGIN TAG"@ BP2Vect(FinalDestination) );

	PickAction();
	if( PendingStateName != '' )
	{
		GotoState( PendingStateName );
	}

	Status = 'Failure';
	PopCommand(self);
}

state UseNavigationMesh `DEBUGSTATE
{
Begin:
	//debug
	`AILog( "BEGIN TAG" );

	if( NavigationHandle.PointReachable(BP2Vect(FinalDestination)) )
	{
		MoveTo( BP2Vect(FinalDestination), Focus, GetDestinationOffset() );
	}
	else
	{
		`AILog("Searching for path to point");
		if( GeneratePathToLocation( BP2Vect(FinalDestination) ) )
		{
			class'NanoAICmd_Move_Mesh'.static.MoveToPoint(GameAIOwner, BP2Vect(FinalDestination), TRUE);
		}
		else
		{
			`AILog("Failed to find path to move location, aborting");
			AbortCommand(self);
		}
	}

	Status = 'Success';
	PopCommand(self);
}

state UseFlightNetwork `DEBUGSTATE
{
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState( PreviousStateName );
		SetUseBoidMovement( FALSE );
	}
	
Begin:
	//debug
	`AILog( "BEGIN TAG"@TakeOffPosition@SrcPivot@LandPosition@DestPivot);

	if( TakeOffPosition != Pawn.Location )
	{
		// Move to TakeOffPosition
		if( NavigationHandle.PointReachable( TakeOffPosition) )
		{
			`AILog( "Direct move to take off position" );
			MoveTo( TakeOffPosition, Focus, GetDestinationOffset() );
		}
		else
		{
			`AILog("Searching for path to point");
			if( GeneratePathToLocation( TakeOffPosition ) )
			{
				class'NanoAICmd_Move_Mesh'.static.MoveToPoint(GameAIOwner, TakeOffPosition, TRUE);
			}
			else
			{
				`AILog("Failed to find path to move location, aborting");
				AbortCommand(self);
			}
		}
	}

	// Fly up into flight volume
	PrepareForFlight();
	`AILog( "Fly up into the flight volume" );
	
	MoveTo( (Pawn.Location*vect(1,1,0)) + (SrcPivot.Location*vect(0,0,1)), None, GetDestinationOffset() );

	if( SrcPivot != None )
	{
		`AILog( "Direct move to src pivot" );
		MoveToward( SrcPivot,, GetDestinationOffset() );
	}
	
	// Use route cache to fly from pivot to pivot
	RouteCache = FlightRouteCache;
FlyLoop:
	// Fly to above dest poly center
	
	LandPosition.Z = Pawn.Location.Z;
	if( PointReachable( LandPosition ) )
	{
		`AILog( "Fly to landing position" );
		if( !Pawn.ReachedPoint( LandPosition, None ) )
		{
			MoveTo( LandPosition, None, GetDestinationOffset() );
		}		
	}
	else
	{
		while( RouteCache.Length > 0 && Pawn.ReachedDestination(RouteCache[0]) )
		{
			RouteCache.Remove( 0, 1 );
		}

		if( RouteCache.Length > 0 )
		{
			//debug
			`AILog( "FlyLoop -- MoveToward"@RouteCache[0] );

			MoveToward( RouteCache[0],, GetDestinationOffset() );
			Goto( 'FlyLoop' );
		}
		else
		{
			`AILog( "ERROR: Got to end of flight pivot cache without being able to reach the landing position?!" );
		}		
	}

	// Drop to ground
	`AILog( "Drop to ground" );
	PrepareForLanding();
	while( Pawn.Physics != PHYS_Walking )
	{
		Sleep( 0.5f );
	}

	// Do regular move to final dest
	if( NavigationHandle.PointReachable(BP2Vect( FinalDestination )) )
	{
		`AILog( "Direct move to final destination" );
		GameAIOwner.MoveTo(BP2Vect( FinalDestination ), Focus, GetDestinationOffset() );
	}
	else
	{
		`AILog("Searching for path to point");
		if( GeneratePathToLocation( BP2Vect( FinalDestination ) ) )
		{
		class'NanoAICmd_Move_Mesh'.static.MoveToPoint(GameAIOwner, BP2Vect( FinalDestination ), TRUE);
		}
		else
		{
			`AILog("Failed to find path to move location, aborting");
			AbortCommand(self);
		}
	}
	
	`AILog( "YAY!" );
	Status = 'Success';
	PopCommand(self);
}

defaultproperties
{
}