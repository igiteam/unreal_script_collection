/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_MoveToTether extends AICommand
	within GearAI;

/** GoW global macros */

/** Actor we are currently attached to */
var BasedPosition TetherPosition;

/** Time the tether should persist */
var float TetherPersistDuration;
/** Desired tether distance, which TetherDistance will set back to when valid */
var float DesiredTetherDistance;
/** Dynamic tether distance */
var float TetherDistance;
/** Time at which the AI acquired the tether */
var transient float TetherAcquireTime;
/** Is this a dynamic (ie moving) tether? */
var bool bDynamicTether;
var bool bSetMovingToSquadLeader;
/** Tether move can be interupted */
var bool bInteruptable;
var bool bIsValidCache;

var bool bSavedIgnoreStepAside;

/** Last command push was a move to cover on the way to tether */
var bool	bMovedToCover;
/** Last command pushed was a peek over cover */
var bool	bPeeked;
/** No move to cover... making the final move to tether location because it's close enough */
var bool	bFinalMove;
/** Force final move (usually because a move to cover failed) */
var bool	bForceFinalMove;
/** Internal flag */
var bool	bFoundPath;

var CoverInfo CovToTether;
var float	  RouteCacheDist;
var Actor	  PathToTarget;

/** keeps track of if we have tried to move to another poly because our anchor is inescapable already*/
var bool bHasTriedToEscapeFromAnchor;

var bool bFailedPathFind;


/** Constructor that pushes a new instance of the command for the AI */
static function bool MoveToTether
(
	GearAI AI,
	Vector	NewTetherLocation,
	optional Actor NewTetherActor,
	optional float NewTetherDistance,
	optional bool NewbDynamicTether,
	optional float NewTetherPersistDuration,
	optional bool NewbInteruptable,
	optional bool NewbIsValidCache
)
{
	local Controller	ControllerTether;
	local GearPRI		PRI;
	local bool			bNewSetMovingToSquadLeader;
    local AICmd_MoveToTether Cmd;

	// Don't allow tethering to controllers, instead to their pawns
	ControllerTether = Controller(NewTetherActor);
	if( ControllerTether != None )
	{
		// Only if it's a valid pawn
		if( ControllerTether.Pawn != None && ControllerTether.Pawn.Health > 0 )
		{
			// By default move to the pawn
			NewTetherActor = ControllerTether.Pawn;
			// check to see if it's a player with a squad we can join
			PRI = GearPRI(ControllerTether.PlayerReplicationInfo);
			if( PRI != None && AI.IsFriendly( ControllerTether ) )
			{
				// if we're already in the squad don't join it again
				if(AI.Squad.SquadName != PRI.SquadName)
				{
					AI.SetSquadName( PRI.SquadName );
				}
				bNewSetMovingToSquadLeader=FALSE;
			}
		}
		else
		{
			NewTetherActor = None;
		}
	}


	if( AI != None )
	{
		if( Pawn(NewTetherActor) != None )
		{
			// Enforce a min tether distance
			NewTetherDistance = FMax( NewTetherDistance, 256.f );
		}

		Cmd = new(AI) class'AICmd_MoveToTether';
		if( Cmd != None )
		{
			AI.Vect2BP( Cmd.TetherPosition, NewTetherLocation, NewTetherActor );
			Cmd.TetherPersistDuration	= NewTetherPersistDuration;
			Cmd.TetherAcquireTime		= AI.WorldInfo.TimeSeconds;
			Cmd.TetherDistance			= NewTetherDistance;
			Cmd.DesiredTetherDistance	= Cmd.TetherDistance;
			Cmd.bDynamicTether			= NewbDynamicTether;				// Mark whether or not it is dynamic
			Cmd.bSetMovingToSquadLeader = bNewSetMovingToSquadLeader;
			Cmd.bInteruptable			= NewbInteruptable;
			Cmd.bIsValidCache			= NewbIsValidCache;

			AI.PushCommand( Cmd );
			return TRUE;
		}
    }
    return FALSE;
}

final function Vector GetTetherLocation()
{
	return BP2Vect( TetherPosition );
}
final function Actor GetTetherActor()
{
	return TetherPosition.Base;
}
final function String PrintTetherInfo()
{
	return ""$GetTetherActor()@"["$GetTetherLocation()$"]";
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@"Tether:"@PrintTetherInfo()@TetherDistance;
}

function bool SetTetherInfo()
{
	local vector TetherLoc;
	TetherLoc = GetTetherLocation();

	if( NavigationHandle.ComputeValidFinalDestination(TetherLoc) )
	{
		Vect2BP( TetherPosition, TetherLoc, GetTetherActor() );
		if( AIOwner != None )
		{
			AIOwner.SetTetherInfo( TetherLoc, GetTetherActor() );
			AIOwner.TetherPersistDuration	= TetherPersistDuration;
			AIOwner.TetherAcquireTime		= TetherAcquireTime;
			AIOwner.TetherDistance			= TetherDistance;
			AIOwner.DesiredTetherDistance	= DesiredTetherDistance;
			AIOwner.bDynamicTether			= bDynamicTether;
		}
	}
	else
	{
		`AILog( ">>>>>>>>>>> MOVE FAIL! SetTetherInfo failed to compute valid pathable position! (desitnation off the mesh? or in an obstacle?)" );
		Vect2BP( TetherPosition, vect(0,0,0) );
		ClearMoveAction();
		GotoState( 'DelayFailure' );
		return false;
	}

	return true;
}

function ClearTetherInfo()
{
	Vect2BP( TetherPosition, vect(0,0,0) );
	if( AIOwner != None )
	{
		AIOwner.ClearTether();
	}
}

function Pushed()
{
	Super.Pushed();

	//debug
	`AILog( "Set tether,"@PrintTetherInfo()@TetherDistance@"dynamic?"@bDynamicTether@"duration?"@TetherPersistDuration@"moving to squad?"@bMovingToSquadLeader );

	bReachedTether			 = FALSE;
	bMovingToTether			 = TRUE;
	bTeleportOnTetherFailure = FALSE;
	bSavedIgnoreStepAside    = bIgnoreStepAside;
	if( bSetMovingToSquadLeader )
	{
		bMovingToSquadLeader = TRUE;
	}

	if( TetherPersistDuration > 0.f )
	{
		SetTimer( TetherPersistDuration, FALSE, nameof(self.TetherPersistDurationExpired), self );
	}
	else
	{
		ClearTimer( 'TetherPersistDurationExpired', self );
	}

	// Setup AI info with the actor we are moving to
	if ( SetTetherInfo() )
	{
		if( !IsWithinTether( Pawn.Location ) )
		{
			DoMove();
		}
		else
		{
			//debug
			`AILog("Already within tether:"@PrintTetherInfo()@TetherDistance@VSize(Pawn.Location-GetTetherLocation()));

			// Already touching it, notify completion
			NotifyReachedTether();

			GotoState('DelaySuccess');
		}
	}

}

function Popped()
{
	Super.Popped();

	bTeleportOnTetherFailure = FALSE;

	if( bSetMovingToSquadLeader )
	{
		bMovingToSquadLeader = FALSE;
	}
	// No longer moving to tether
	bMovingToTether = FALSE;
	bIgnoreStepAside = bSavedIgnoreStepAside;

	ClearTimer('TryPeek', self);

	bReachedMoveGoal = (Status == 'Success');

	if( bFailedPathFind )
	{
		HandleFailedPathFind(GetTetherActor());
	}
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	if( ChildStatus == 'Success' )
	{
		bIsValidCache=false;
		SetTetherInfo();

		//debug
		`AILog( "Resuming..."@bMovedToCover@bMovingToSquadLeader@bMovingToCover@bFinalMove@IsWithinTether(Pawn.Location)@AIOwner.PrintTetherInfo() );

		// If moved to cover, try peeking over the cover
		if( bMovedToCover )
		{
			bMovedToCover = FALSE;
			SetTimer( 0.5f + FRand() * 1.5f, FALSE, nameof(self.TryPeek), self );
		}
		else
		// Otherwise, if within tether, notify
		if( (!bMovingToCover && bMovingToSquadLeader) || bFinalMove || IsWithinTether(Pawn.Location) )
		{
			// we never want to return success if we are not near our cover because we'll end up setting cover type when we're far away from our cover
			Pawn.DestinationOffset=0;
			if(bMovingToCover && !Pawn.ReachedPoint(GetTetherLocation(),Pawn.Anchor) )
			{
				`AILog("Moving to Cover finished, but not within tether, so returning failure..."@bMovedToCover@bMovingToSquadLeader@bMovingToCover@bFinalMove@IsWithinTether(Pawn.Location)@AIOwner.PrintTetherInfo());
// 				Pawn.DrawDebugLine(Pawn.Location,Pawn.Location+vect(0,0,50.f),255,255,0,true);
// 				Pawn.DrawDebugLine(Pawn.Location,GetTetherLocation(),255,0,0,true);
// 				Pawn.DrawDebugLine(GetTetherLocation(),GetTetherLocation()+vect(0,0,150.f),255,0,0,true);


				NotifyReachedTether();
				Status = 'Failure';
				PopCommand( self );
			}
			else
			{
				`AILog("Tether reached successfuly, calling NotifyReachedTether"@`showvar(MoveAction));
				NotifyReachedTether();
				Status = 'Success';
				PopCommand( self );
			}

		}
		else
		{
			// Otherwise, do another move (delay after peeking)
			if( bPeeked )
			{
				bPeeked = FALSE;
				SetTimer( 0.5f + FRand() * 0.5f, FALSE, nameof(self.DoMove), self );
			}
			else
			{
				DoMove();
			}
		}
	}
	else
	{
		//debug
		`AILog( "Failed to reached tether"@PrintTetherInfo()@"move action:"@MoveAction@bFinalMove@bForceFinalMove@"teleport?"@bTeleportOnTetherFailure@ChildStatus );

		bMovedToCover = false;

		if( !bFinalMove && !bForceFinalMove )
		{
			bForceFinalMove = TRUE;
			DoMove();
		}
		else
		{
			if( bTeleportOnTetherFailure )
			{
				//debug
				`AILog("Teleporting to tether location");

				Pawn.SetLocation(GetTetherLocation());
				NotifyReachedTether();
			}
			`AILog( "Clearing tether on Resume"@PrintTetherInfo()@"move action:"@MoveAction@bFinalMove@bForceFinalMove);
			ClearMoveAction();
			Status = 'Failure';
			PopCommand( self );
		}
	}
}

final function TetherPersistDurationExpired()
{
	//debug
	`AILog("Tether duration expired, clearing:"@PrintTetherInfo());

	ClearTetherInfo();
}

final private function DoMove()
{
	local bool bPointReachable;
	local vector EffectiveTetherLoc;
	local Actor MoveFocus;

	bReachedTether	= FALSE;
	if( IsTethered() )
	{
		//debug
		`AILog( "Move to tether point..."@PrintTetherInfo() );

		bFinalMove = true;
		EffectiveTetherLoc = GetTetherLocation();

		bPointReachable = NavigationHandle.PointReachable( GetTetherLocation() );
		if ( bPointReachable || GeneratePathToValidatedLocation(EffectiveTetherLoc,,FALSE ) )
		{
			if( MoveAction != None )
			{
				MoveFocus = Focus;
			}
			
			`AILog("Calling SetMovePoint - Reachable?"@bPointReachable);

			SetMovePoint( EffectiveTetherLoc, MoveFocus, bInteruptable,, TRUE );
		}
		else
		{	
			if(!bHasTriedToEscapeFromAnchor && NavigationHandle.IsAnchorInescapable())
			{
				`AILog("Path failed, but we are in a poly which is inescapable.. trying to get out!");
				GotoState('MoveToValidStartLoc');
				return;
			}
			`LogPathFailure(GetTetherActor(),GetFuncName()@"not reachable, and no path found.. bailing");
			FailedToFindPath( GetTetherActor() );
		}
	}
}

state MoveToValidStartLoc `DEBUGSTATE
{
	function vector GetFailsafePoint()
	{
		local vector CurLoc;
		local float PawnCollisionRadius;
		local array<vector> Positions;
		local vector Extent;

		CurLoc = Pawn.Location;

		if(!NavigationHandle.ComputeValidFinalDestination(CurLoc))
		{
			PawnCollisionRadius = Pawn.GetCollisionRadius();
			Extent = Pawn.GetCollisionExtent();
			Extent.Z = 256;
			NavigationHandle.GetValidPositionsForBox(CurLoc,3.0*PawnCollisionRadius,Extent,FALSE,Positions,1);
			if(Positions.length > 0)
			{
				CurLoc = Positions[0];
			}
			else
			{
				`LogPathFailure(GetTetherActor(),"Could not resolve failsafe starting location, bailing!");
				GotoState('DelayFailure');
				return Pawn.Location;
			}
		}

		return CurLoc;
	}

Begin:

	bHasTriedToEscapeFromAnchor=true;
	bIgnoreStepAside = TRUE;
	MoveToDirectNonPathPos(GetFailsafePoint());
	DoMove();	
};


/**
 *	Used to try to path through cover along the way to the tether.
 *	Delays the cover search to another frame, so we aren't doing (potentially) 3
 *	path searches on a single frame.
 */
state PathToCover
{
Begin:
	// Small delay between path searches
	Sleep(0.1f);

	// Limit our route length
	LimitRouteCacheDistance( RouteCacheDist * GetCoverDistModifier() );
	PathToTarget = RouteCache[RouteCache.Length-1];

	//debug
	`AILog( "About to search for cover..."@PathToTarget );

	// If found cover along the path to the last node in the route and
	// path is shorter than our original path to the tether target
	bFoundPath = CoverOwner.EvaluateCover( SearchType_AlongPath, PathToTarget, CovToTether );

	//debug
	`AILog( "path?"@bFoundPath@GetRouteCacheDistance()@RouteCacheDist@CovToTether.Link@CovToTether.SlotIdx );

	if( bFoundPath &&
		GetRouteCacheDistance() < RouteCacheDist )
	{
		// Move using cover
		bMovedToCover = TRUE;
		CoverOwner.SetCoverGoal( CovToTether, TRUE );
		Goto('End');
	}
	else
	{
		// Otherwise, failed to use cover and route cache is no longer good
		bFoundPath = FALSE;
	}

	if( bFoundPath )
	{
		//debug
		`AILog( "Found path to new tether target"@PathToTarget );

//		TetherActor = PathToTarget;

		// If moving to squad leader using original route... limit the cache length
		if( bMovingToSquadLeader && !bFinalMove )
		{
//			TetherActor = LimitRouteCacheDistance(FMin(VSize(TetherActor.Location - Pawn.Location), 512.0));

			//debug
			`AILog( "Limit cache moving to squad leader" );
		}
	}

	// Move to the goal
//	SetMoveGoal( TetherActor,, bInteruptable,, bFoundPath,,TRUE );

End:
	Stop;
};


/**
 *	Adds a small delay once getting into cover, peek over
 *	before continuing move toward tether
 */
final function TryPeek()
{
	CoverOwner.NextAllowPeekTime = 0.f;
	bPeeked = TRUE;
	if( !CoverOwner.PeekFromCover() )
	{
		//debug
		`AILog( "Failed to peek, continuing on..." );

		bPeeked = FALSE;
		DoMove();
	}
}

final function FailedToFindPath( Actor A )
{
	//debug
	`AILog( GetFuncName()@"to"@PrintTetherInfo()@"("$A$")"@"from"@Pawn.Anchor@"["@Pawn.Location@"]  Clearing tether", 'Move' );

	bFailedPathFind = TRUE;
	ClearMoveAction();

	GotoState( 'DelayFailure' );
}

function float GetCoverDistModifier()
{
	local float Result;

	Result = 1.f;
	switch( CombatMood )
	{
	case AICM_Passive: //fall through
	case AICM_Ambush:
		Result = 0.25f;
		break;
	case AICM_Aggressive:
		Result = 0.65f;
		break;
	case AICM_Normal:
		Result = 0.40f;
		break;
	}
	return Result;
}


/**
* Called once the tether has been reached.
*/
final function NotifyReachedTether()
{
	//debug 
	`AILog( "Reached tether"@MoveAction@TetherPersistDuration@`TimeSince(TetherAcquireTime) );

	bSpawnerTetherInterruptable = TRUE;
	bReachedTether = TRUE;

	// clear the focus
	Focus = None;

	// If there is an assigned move action
	if( MoveAction != None )
	{
		//debug
		`AILog("Clear move action"@MoveAction@MoveAction.bClearTetherOnArrival@bMovingToSquadLeader);


		Outer.NotifyReachedTether(GetTetherActor());
		// check to see if the scripted tether should be cleared
		if( MoveAction.bClearTetherOnArrival || bMovingToSquadLeader )
		{
			ClearTetherInfo();
		}
		else
		{
			// If tether actor hasn't been cleared
			// Keep it! (instead of moving back to squad formation position)
			// MUST do this for moves that have bClearTetherOnArrival == FALSE
			// so AI doesn't clear tether in Sleep section of Action_Idle and
			// move back to squad leader
			bKeepTether = TRUE;
		}

		// then notify the action that the move is complete
		if(!bMovingToRoute)
		{
			MoveAction.ReachedGoal( AIOwner );
			// tether dist 0 is magical, means don't ever move from where I just put you
			if(AllowedToMove())
			{
				ClearMoveAction();
			}

		}
	}
	else
	{
		if( TetherPersistDuration == 0.f || `TimeSince(TetherAcquireTime) >= TetherPersistDuration )
		{
			// clear AI generated tethers by default
			`AILog("Clearing tether because we arrived at our tether and TetherPersistDuration was 0");
			ClearTetherInfo();
			ClearTimer( 'TetherPersistDurationExpired', self );
		}
	}
}

event DrawDebug( HUD H, Name Category )
{
	Super.DrawDebug( H, Category );

	if( Category == 'Pathing')
	{
		// PURPLE
		DrawDebugLine( Pawn.Location, GetTetherLocation(), 184, 152, 250 );
		DrawDebugCylinder( GetTetherLocation(), GetTetherLocation(), TetherDistance, 10.f, 184, 152, 250 );
	}
}

defaultproperties
{
}
