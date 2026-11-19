/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_MoveToGoal extends AICommand
    within TGAI
	native(TGAI);

/** GoW global macros */

/** The last position we tried to skip ahead in the path from */
var BasedPosition SkipAheadLastUpdatePos;
/** if we've moved SkipAheadUpdateThreshold units away from SkipAheadlastupdatePos, a new skipahead update will be run */
var() float SkipAheadUpdateThreshold;
/** maximum number of nodes in a path to skip ahead */
var() int   SkipAheadMaxNodes;
/** maximum path distance to skip */
var() float SkipAheadMaxDist;
/** distance interval to check for pits when determining if it's safe to skip ahead */
var() float SkipAheadPitCheckInterval;
/** distance downward to trace for pit checks */
var() float SkipAheadPitCheckHeight;
/** disable/enable skipahead */
var() bool bEnableSkipAheadChecks;
/** internal use only, number of pending line check results we're waiting on */
var const int  SkipAheadNumActiveTests;
/** internal use only, whether any of the last batch of tests failed */
var const bool bSkipAheadFail;
/** internal use only, the index into the route cache of the current node we're testing for skip ahead */
var int  SkipAheadCurrentTestingIndex;
/** list of nav points which skipahead testing is not allowed to skip past (e.g. for when we're following a set route) */
var native const transient Map{ANavigationPoint*,UBOOL} NonSkippableWaypoints;

/** indicates that the our current routecache has changed since the last time GetNnextMoveTarget was called */
var bool bGoalChangedDueToSkipAhead;

/** internal use only, AI was firing weapon when move started, so don't cancel firing after */
var bool bFiringWeaponAtStart;

var int NumTimesGetNextMoveGoalReturnedSameNode;
var int LoopFailSafeCounter;

var bool bCachedShouldWalk;
var float LastShouldWalkCacheTime;

const bUseAsyncRaycastsForSkipAhead=0;

var BasedPosition LastPawnTargetPathLocation;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** Current RouteCache for controller is valid, no need to path find again */
var bool	bValidRouteCache;

/** if false, abort if we need to pathfind (i.e, if the current RouteCache becomes invalid) */
var bool bCanPathfind;
/** Allow any path generation to return best guess */
var bool bAllowPartialPath;

/** Intermediate move goal used when pathfinding to MoveGoal */
var Actor IntermediateMoveGoal;
/** trigger the AI needs to hit first before continuing on the path */
var Actor TriggerGoal;
/** list of nodes that we cannot traverse yet due to requiring a trigger
 * they are temporarily blocked when doing path searches
 */
var array<NavigationPoint> NodesRequiringTriggers;

var bool bAllowedToFire;

var bool bRunToPoint;



/** removes all navpts from the non-skippable waypoint list */
function native ClearNonSkippableWayPoints();
/** adds a nav point to the non-skippable waypoint list*/
function native AddNonSkippableWayPoint(NavigationPoint Point);

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToGoal( TGAI AI, Actor NewMoveGoal, optional Actor NewMoveFocus, optional float NewMoveOffset,
				optional bool bIsValidCache,
				optional bool bInCanPathfind = TRUE,
				optional bool bInAllowedToFire = TRUE,
				optional bool bInAllowPartialPath = TRUE )
{
    local AICmd_MoveToGoal Cmd;

	if( AI != None && NewMoveGoal != None )
	{
		Cmd = new(AI) class'AICmd_MoveToGoal';
		if( Cmd != None )
		{
			// Never actually want to move to a controller, substitute pawn instead
			if( Controller(NewMoveGoal) != None )
			{
				NewMoveGoal = Controller(NewMoveGoal).Pawn;
			}

			Cmd.Outer.MoveGoal		= NewMoveGoal;
			Cmd.Outer.MoveFocus		= NewMoveFocus;
			Cmd.Outer.MoveOffset	= NewMoveOffset;
			Cmd.bValidRouteCache	= bIsValidCache;
			Cmd.bCanPathfind		= bInCanPathfind;
			Cmd.bAllowedToFire		= bInAllowedToFire;
			Cmd.bAllowPartialPath	= bInAllowPartialPath;

			AI.SetBasedPosition( AI.MovePosition, vect(0,0,0) );
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}
	return FALSE;
}

static function bool MoveToPoint( TGAI AI, Vector NewMovePoint, optional Actor NewMoveFocus, optional float NewMoveOffset,
				optional bool bIsValidCache,
				optional bool bInCanPathfind = TRUE,
				optional bool bInAllowedToFire = TRUE,
				optional bool bInAllowPartialPath = TRUE )
{
	local AICmd_MoveToGoal Cmd;

	if( AI != None && NewMovePoint != vect(0,0,0) )
	{
		Cmd = new(AI) class'AICmd_MoveToGoal';
		if( Cmd != None )
		{
			Cmd.Outer.MoveFocus		= NewMoveFocus;
			Cmd.Outer.MoveOffset	= NewMoveOffset;
			Cmd.Outer.MoveGoal		= None;
			Cmd.bValidRouteCache	= bIsValidCache;
			Cmd.bCanPathfind		= bInCanPathfind;
			Cmd.bAllowedToFire		= bInAllowedToFire;
			Cmd.bAllowPartialPath	= bInAllowPartialPath;

			AI.SetBasedPosition( AI.MovePosition, NewMovePoint );
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

static function bool RunToPoint( TGAI AI, Vector NewMovePoint, optional Actor NewMoveFocus, optional float NewMoveOffset,
				optional bool bIsValidCache,
				optional bool bInCanPathfind = TRUE,
				optional bool bInAllowedToFire = TRUE,
				optional bool bInAllowPartialPath = TRUE )
{
	local AICmd_MoveToGoal Cmd;

	if( AI != None && NewMovePoint != vect(0,0,0) )
	{
		Cmd = new(AI) class'AICmd_MoveToGoal';
		if( Cmd != None )
		{
			Cmd.Outer.MoveFocus		= NewMoveFocus;
			Cmd.Outer.MoveOffset	= NewMoveOffset;
			Cmd.Outer.MoveGoal		= None;
			Cmd.bValidRouteCache	= bIsValidCache;
			Cmd.bCanPathfind		= bInCanPathfind;
			Cmd.bAllowedToFire		= bInAllowedToFire;
			Cmd.bAllowPartialPath	= bInAllowPartialPath;
			Cmd.bRunToPoint			= TRUE;

			AI.SetBasedPosition( AI.MovePosition, NewMovePoint );
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	if( GetBasedPosition( MovePosition ) != vect(0,0,0) )
	{
		return Super.GetDumpString()@"Point:"@GetBasedPosition(MovePosition)@"MoveFocus:"@MoveFocus@"Offset:"@MoveOffset@"IMG:"@IntermediateMoveGoal@"Focus:"@Focus;
	}
	else
	{
		return Super.GetDumpString()@"Destination:"@MoveGoal@"MoveFocus:"@MoveFocus@"Offset:"@MoveOffset@"IMG:"@IntermediateMoveGoal@"Focus:"@Focus;
	}
}


function Pushed()
{
	local int i;
	local NavigationPoint NavPt;

	Super.Pushed();

	// Set flag that says we are moving and MoveGoal info is valid
	bMovingToGoal		= TRUE;
	bReachedMoveGoal	= FALSE;
	;
	bReevaluatePath		= FALSE;

	MoveTarget			= None;
	SetDestinationPosition( Pawn.Location, TRUE );

	bFiringWeaponAtStart = (TGAI(GameAIOwner).bFire != 0);

	ClearNonSkippableWayPoints();
	// if we're moving on a route, and skipahead is on, copy the route into non-skippable points
	if(bEnableSkipAheadChecks && bMovingToRoute && ActiveRoute != none)
	{
		for(i=0;i<ActiveRoute.RouteList.length;i++)
		{
			NavPt = NavigationPoint( ActiveRoute.RouteList[i].Actor );
			if(NavPt != none)
			{
				AddNonSkippableWayPoint(NavPt);
			}
		}
	}

	// if we started a move < 1.4 seconds ago don't try and walk again
	if(IsTimerActive(nameof(AttemptToWalk),self))
	{
		ClearTimer(nameof(AttemptToWalk),self);
	}
	else
	{
		SetTimer( 1.4f, FALSE, nameof(AttemptToWalk), self );
	}
	SetTimer( 0.6f, TRUE, nameof(UpdateWalking), self );

	ForceSkipAheadUpdate();

	//// Start the move
	//MyTGPawn.hod.DoMove();
	bNeedDomove = TRUE;

	GotoState( 'MovingToGoal' );
}

function AttemptToWalk();

function UpdateWalking()
{
	local bool bWantsToWalk;
	bWantsToWalk = ShouldWalk();
	if(bWantsToWalk != Pawn.bIsWalking)
	{
		Pawn.SetWalking(bWantsToWalk);
	}
}

function Popped()
{
	Super.Popped();

	// No longer moving to a goal
	bMovingToGoal = FALSE;
	bReachedMoveGoal = (Status == 'Success');

	if (bReachedMoveGoal)
	{
		if (MoveGoal != none)
			MyTGPawn.hod.ReachGoal(MoveGoal);
		else
			MyTGPawn.hod.ReachGoal(,GetBasedPosition(MovePosition));
	}
	// Check for any latent move actions
	ClearLatentAction( class'SeqAct_AIMoveToActor', !bReachedMoveGoal );

	// clear the route cache to make sure any intermediate claims are destroyed
	RouteCache_Empty();

	// explicitly clear velocity/accel as they aren't necessarily
	// cleared by the physics code
	if( Pawn != None )
	{
		Pawn.ZeroMovementVariables();

		// stop any roadie run
		if( IsRoadieRunning() || IsCoverRunning() )
		{
			DictateSpecialMove( SM_None );
		}
	}
	MoveTarget = None;

	// stop any firing while moving
	if( !bFiringWeaponAtStart )
	{
		StopFiring();
	}

	ClearTimer( 'MoveToGoalTimedOut', self );
	ClearTimer( 'TimedAbortMove' );
	ClearTimer(nameof(CheckIfTetherGoalIsOccupied), self);
	ClearTimer(nameof(UpdateWalking), self);

	// make sure that if we are bailing we notify the Controller we're done trying to move
	ReachedMoveGoal();

	if( MyTGPawn != None )
	{
		MyTGPawn.SetTargetingMode(FALSE);
		MyTGPawn.Acceleration=vect(0,0,0);
	}

	LastMoveFinishTime = WorldInfo.TimeSeconds;
}

function Paused( GameAICommand NewCommand )
{
	Super.Paused( NewCommand );

	// Pause move timeout timer
	PauseTimer( TRUE, 'MoveToGoalTimedOut', self );
	PauseTimer( FALSE, 'TimedAbortMove' );
	PauseTimer( TRUE,nameof(CheckIfTetherGoalIsOccupied), self);
	PauseTimer( TRUE,nameof(UpdateWalking), self);

	// explicitly clear velocity/accel as they aren't necessarily
	// cleared by the physics code
	if( Pawn != None )
	{
		Pawn.ZeroMovementVariables();

		// stop any roadie run
		if( IsRoadieRunning() || IsCoverRunning() )
		{
			DictateSpecialMove( SM_None );
		}
	}
}

function Resumed( Name OldCommandName )
{
	local Name CS;
	Super.Resumed( OldCommandName );

	CS = ChildStatus;
	bNeedDomove = TRUE;

	NumTimesGetNextMoveGoalReturnedSameNode=0;

	if (OldCommandName == 'HodState_Arrival')
	{
		Status = ChildStatus;
		PopCommand(self);
	//	if (Pawn.ReachedDestination(MoveGoal))
	//	{
	//		Pawn.SetAnchor(NavigationPoint(MoveGoal));
	//		CS = 'Success';
	//	}
	//	else
	//		CS = 'Failure';
	}
	else if (bRunToPoint)
	{
		Status = 'Failure';
		PopCommand(self);
	}
	else if( CS == 'Success' )
	{
		// if we just arrived at a coverslotmarker make sure we're really close to it because we might have mantled and be far away
		if(CoverSlotMarker(MoveTarget) != none && RouteCache.length < 1 && !Pawn.ReachedDestination(MoveTarget) )
		{
			;
			bReevaluatePath=true;
		}
		else
		{
			// Unpause move timeout timer
			PauseTimer( FALSE, 'MoveToGoalTimedOut', self );
			PauseTimer( FALSE, 'TimedAbortMove' );
			PauseTimer( FALSE,nameof(CheckIfTetherGoalIsOccupied), self);
			PauseTimer( FALSE,nameof(UpdateWalking), self);

			bMovingToGoal = TRUE;
			bReachedMoveGoal = FALSE;

			//debug
			DebugLogRoute();

			// reset intermediate move goal so GetMoveGoal doesn't freak out when the current goal hasn't changed
			IntermediateMoveGoal=none;

			// Restart roadie run after getting back into normal run state
			if( ShouldRoadieRun() )
			{
				if( MyTGPawn.IsInCover() )
				{
					DictateSpecialMove( SM_CoverRun );
				}
				else
				{
					DictateSpecialMove( SM_RoadieRun );
				}
			}
		}

		ForceSkipAheadUpdate();
		ReEvaluatePath();
	}
	else if (CS == 'FinalMove')
	{
		Status = 'FinalMove';
		PopCommand(self);
	}
	else
	{
		Status = 'Failure';
		AbortCommand( self );
	}
}

function ReEvaluatePath()
{
	local NavigationPoint	BestAnchor;
	local float				Dist;

	;

	if( bReevaluatePath &&
		Pawn != None &&
		(MoveGoalIsValid() || MovePointIsValid()) )
	{
		//debug
		;

		if( !Pawn.ValidAnchor() )
		{
			BestAnchor = Pawn.GetBestAnchor( Pawn, Pawn.Location, TRUE, FALSE, Dist );
			;
			if (BestAnchor == None)
			{
				// this is baaad, teleport to the nearest node
				BestAnchor = class'NavigationPoint'.static.GetNearestNavToActor(Pawn);
				;
				Pawn.SetLocation(BestAnchor.Location);
			}
			Pawn.SetAnchor(BestAnchor);
		}

		RouteCache_Empty();
		;
		bReevaluatePath = FALSE;
		// Restart the movement state
		GotoState( 'MovingToGoal', 'Begin' );
		//MyTGPawn.hod.DoMove();

	}
	else
	if(HasReachedMoveGoal())
	{
		Status = 'Success';
		PopCommand(self);
	}
	//else
	//{
	//	if (bNeedDomove)
	//	{
	//		MyTGPawn.hod.DoMove();
	//		bNeedDomove = false;
	//	}
	//}
}


/** wrapper for Controller::FindPathToward() that sets the appopriate path search type first */
function Actor FindPathToward(Actor anActor)
{
	local EPathSearchType OldSearchType;
	local Actor Result;

	if (!bCanPathfind)
	{
		;
		Status = 'Failure';
		AbortCommand(self);
	}
	else
	{
		OldSearchType = Pawn.PathSearchType;
		Pawn.PathSearchType = PST_Constraint;
		Result = GeneratePathTo(anActor,,bAllowPartialPath);
		Pawn.PathSearchType = OldSearchType;
	}

	return Result;
}
/** wrapper for Controller::FindPathTo() that sets the appopriate path search type first */
// @MT-TODO:build constraints for point path finding so we dont' have to use newbestpathto for thsi
function Actor FindPathTo(vector aPoint)
{
	local EPathSearchType OldSearchType;
	local Actor Result;

	if (!bCanPathfind)
	{
		;
		Status = 'Failure';
		AbortCommand(self);
	}
	else
	{
		OldSearchType = Pawn.PathSearchType;
		Pawn.PathSearchType = PST_NewBestPathTo;
		Result = Outer.FindPathTo(aPoint);
		Pawn.PathSearchType = OldSearchType;
	}

	return Result;
}

function RouteCache_RemoveIndex( int Idx )
{
	;
	SkipAheadCurrentTestingIndex=0;
	outer.RouteCache_RemoveIndex(Idx);
}

function MoveToGoalTimedOut()
{
	//debug
	;

	Pawn.SetAnchor( GetFallbackAnchor() );
	ClearMoveAction();
	AbortCommand( self );
}

/** Check if given goal is valid */
function bool MoveGoalIsValid( optional Actor Goal )
{
	if( Goal == None )
	{
		Goal = MoveGoal;
	}
    return (Goal != None);
}

/** Check if given point is valid */
function bool MovePointIsValid( optional Vector Point )
{
	if( Point == vect(0,0,0) )
	{
		Point = GetBasedPosition( MovePosition );
	}
	return (Point != vect(0,0,0));
}

/** Check if AI has successfully reached the given goal */
function bool HasReachedMoveGoal( optional Actor Goal )
{
	if( Pawn == None )
	{
		return TRUE;
	}

	if( Goal == None )
	{
		Goal = MoveGoal;
	}

	Pawn.DestinationOffset = MoveOffset;
	if( MoveGoalIsValid( Goal ) )
	{
		//if( Pawn.Anchor == Goal )
		//{
		//	return TRUE;
		//}
		if( DynamicAnchor(Pawn.Anchor) != None )
		{
			// don't allow dynamic anchors to be valid for reach tests
			return FALSE;
		}

		return Pawn.ReachedDestination( Goal );
	}
	else
	if( GetBasedPosition( MovePosition ) != vect(0,0,0) )
	{
		if( VSize(GetBasedPosition(MovePosition)-Pawn.Location) < MoveOffset )
		{
			return TRUE;
		}
		return Pawn.ReachedPoint( GetBasedPosition(MovePosition), None );
	}

    return FALSE;
}

function TryToRun2Cover( bool bDirectMove )
{
	local CoverSlotMarker SM;
	// If the MoveToward set bShouldRun2Cover
	//`log(GetFuncName()@CoverOwner.bShouldRun2Cover@CoverOwner.IsAlert()@Coverowner.IsInCombat()@CurrentPath@bDirectMove);
	if( CoverOwner != None && CoverOwner.bShouldRun2Cover )
	{
		CoverOwner.bShouldRun2Cover = FALSE;
		if( CoverOwner.IsAlert() || CoverOwner.IsInCombat() )
		{
			if( bDirectMove ||
				CurrentPath == None ||
				CurrentPath.BlockedBy == None )
			{
				SM = CoverSlotMarker(IntermediateMoveGoal);

				if(SM.bStatic)
				{
					// Start the special move and let it finish the move into cover
					class'AICmd_Move_Run2Cover'.static.Run2Cover( TGAI_Cover(GameAIOwner), SM );
				}
			}
		}
	}
}

function bool MoveUnreachable( Vector AttemptedDest, Actor AttemptedTarget )
{
	Status = 'Failure';
	AbortCommand( self );
	return TRUE;
}

function bool HandlePathObstruction( Actor BlockedBy )
{
	//local Pawn BlockPawn;
	//local TGAI AI;

	////debug
	//`AILog( self@GetFuncName()@BlockedBy, 'Move' );

	//LastObstructionTime = WorldInfo.TimeSeconds;
	//BlockPawn = Pawn(BlockedBy);
	//if( BlockPawn != None)
	//{
	//	`AILog("- blocked anchor:"@BlockPawn.Anchor@BlockPawn.ReachedDestination(MoveGoal));

	//	// if they're touching our goal
	//	if( BlockPawn.ReachedDestination( MoveGoal ) )
	//	{
	//		`AILog("- they're touching my goal, finishing the move");

	//		// then just pretend we made it
	//		bReachedMoveGoal = TRUE;
	//		if( bMovingToTether && MoveGoal == TetherActor )
	//		{
	//			bReachedTether = TRUE;
	//		}

	//		Status = 'Success';
	//		PopCommand( self );
	//		return TRUE;
	//	}

	//	AI = TGAI(BlockPawn.Controller);
	//	if( AI != None && AI.StepAsideFor(Pawn) )
	//	{
	//		`AILog("- they're stepping aside for me");
	//		return TRUE;
	//	}
	//	else
	//	if( StepAsideFor(BlockPawn) )
	//	{
	//		`AILog("- stepping aside for them");
	//		return TRUE;
	//	}
	//}

	return FALSE;
}

function SetupSplinePoints(Actor InDestinationActor)
{

	if(MyTGPawn == none)
	{
		return;
	}


	if(InDestinationActor != none)
	{
		if(MoveTarget != none)
		{
			MyTGPawn.PrevSplineActor = MoveTarget;
		}
		else
		{
			MyTGPawn.PrevSplineActor = Pawn.Anchor;
		}

		MyTGPawn.CurrentSplineActor = InDestinationActor;

		// if ther's more route cache ahead of our current destination, use that
		if(RouteCache.length > 1)
		{
			MyTGPawn.FinalSplineActor = RouteCache[1];
			if (HDNegotiationPoint(InDestinationActor) != none &&
				HDNegoReachSpec(HDNegotiationPoint(InDestinationActor).GetReachSpecTo(RouteCache[1])) != none)
				MyTGPawn.FinalSplineActor = InDestinationActor;
		}
		else
		{
			//otherwise finalpt will be our destination
			if( MoveGoalIsValid() )
			{
				MyTGPawn.FinalSplineActor = MoveGoal;
			}
			else if( MovePointIsValid() )
			{
				SetBasedPosition( MyTGPawn.FinalSplinePt, GetBasedPosition(MovePosition) );
			}
		}

	}
	else
	{
		ClearSplinePoints();
	}

	//`log(GetFuncName()@bDirect@RouteCache.length@MyTGPawn.PrevPt@MyTGPawn.CurrentPt@MyTGPawn.FinalPt);
}
function ClearSplinePoints()
{
	local TGPawn GP;

	if(MyTGPawn != none)
	{
		GP = MyTGPawn;
	}
	else if(Pawn != none)
	{
		GP = TGPawn(Pawn);
	}

	if(GP != none)
	{
		GP.PrevSplineActor = none;
		GP.CurrentSplineActor = none;
		GP.FinalSplineActor = none;
		GP.SetBasedPosition( GP.FinalSplinePt, vect(0.f,0.f,0.f) );
	}
}

function bool CheckIfTetherGoalIsOccupied()
{
	local int Idx;

	//`AILog(GetFuncName());
	// if we're on a direct move (moving to the final goal), and we have several tether options check to see if the tether is occupied, if so try to find one that isn't occupied and use it instead
	if(MoveAction != none &&
		MoveAction.AvailableTethers.length > 1 &&
		TetherActor != none)
	{
		if(IsTetherOccupied(TetherActor))
		{
			for(Idx=0;Idx<MoveAction.AvailableTethers.length;Idx++)
			{
				// if we found an alternative that's not occupied, use that!
				if(MoveAction.AvailableTethers[Idx] != none && MoveAction.AvailableTethers[Idx] != TetherActor && !IsTetherOccupied(MoveAction.AvailableTethers[Idx]))
				{
					;
					AbortCommand( None, class'AICmd_MoveToTether' );
					//SetTether( MoveAction.AvailableTethers[Idx], MoveAction.TetherDistance,,, MoveAction.bInterruptable, , TRUE);
					return true;
				}
			}
			// if we got this far it means we don't have any more options.. so just keep running to the same one
		}
		SetTimer(1.0f,FALSE,nameof(CheckIfTetherGoalIsOccupied),self);
	}

	return false;
}

/**
 * Called after the type of move has been determined.
 */
function StartingMove( bool bDirectMove, float Distance, int PathLength, Actor Dest)
{
	local ReachSpec Spec;
	//local bool bWasInCover;

	//debug
	;

	//bWasInCover = (MyTGPawn != None && MyTGPawn.IsInCover());

	SetupSplinePoints(Dest);
	// If moving directly to a target, kill route cache (it confuses MoveToward)
	if( bDirectMove )
	{
		RouteCache_Empty();
	}

	// if we're on 'final approach' to our tether, check to see if it's occupied (to decide if we want to try another one of the supplied ethers)
	if(Dest == TetherActor && CheckIfTetherGoalIsOccupied())
	{
		return;
	}

	if( !bMovingToCover )
	{
		InvalidateCover( TRUE );
	}

	if( CoverOwner != None )
	{
		// If making a direct move OR
		// we must move to our anchor before moving on
		if( RouteCache.Length == 0 || RouteCache[0] == Pawn.Anchor )
		{
			//debug
			;

			CoverOwner.ResetCoverType();
		}
		else if( MyTGPawn != None )
		{
			//debug
			;

			Spec = Pawn.Anchor.GetReachSpecTo(RouteCache[0]);
			if( Spec != None )
			{
				MyTGPawn.PrepareMoveAlong( CoverOwner, Spec );
			}
			else
			{
				CoverOwner.ResetCoverType();
			}
		}
	}

	// Restart roadie run after getting back into normal run state
	;
	//@hack: make sure we don't roadie run to closed TriggeredPaths since we will need to wait
	//	need something more generic here
	if ((TriggeredPath(Dest) == None || TriggeredPath(Dest).bOpen) && ShouldRoadieRun())
	{
		if( MyTGPawn != none && MyTGPawn.IsInCover() )
		{
			if ( Pawn.Anchor != None && NavigationPoint(Dest) != None &&
				SlotToSlotReachSpec(Pawn.Anchor.GetReachSpecTo(NavigationPoint(Dest))) != None )
			{
				DictateSpecialMove( SM_CoverRun );
			}
			else if (IsRoadieRunning() || IsCoverRunning())
			{
				DictateSpecialMove(SM_None);
			}
		}
		// don't roadie run if we're not facing the proper direction
		else if (Dest == None || ((Normal(Dest.Location - Pawn.Location) dot vector(Pawn.Rotation)) > 0.0))
		{
			DictateSpecialMove( SM_RoadieRun );
		}
	}
	else if (IsRoadieRunning() || IsCoverRunning())
	{
		DictateSpecialMove(SM_None);
	}

	if (CombatMood != AICM_Passive && bAllowCombatTransitions)
	{
		if(MyTGPawn != none)
		{
			if ( TGAI_TDM(Outer) == None && IsAlert() && HasValidEnemy() && FireTarget != None &&
				!IsRoadieRunning() && !IsCoverRunning() && MyTGPawn.MyTGWeapon != None &&
				!MyTGPawn.MyTGWeapon.ShouldPreventTargeting()
				&& !MyTGPawn.IsCarryingAHeavyWeapon())
			{
				MyTGPawn.SetTargetingMode(TRUE);
			}
			else
			{
				MyTGPawn.SetTargetingMode(FALSE);
			}
		}

		//if we left cover we couldn't fire from, delay a bit before starting to fire
		//this prevents the AI from simultaneously getting out of cover and firing its first shot,
		//which looks bad, isn't something a human can do, and feels really unfair
		//when they kill you with the shot on top of it ;)
		//if(bAllowedToFire)
		//{
		//	if ( bWasInCover && MyTGPawn != none && !MyTGPawn.IsInCover() && CoverOwner != None &&
		//		(CoverOwner.bFailedToFireFromCover || WorldInfo.TimeSeconds - CoverOwner.LastFireFromCoverTime > 5.0) )
		//	{
		//		if (!Outer.IsTimerActive('StartFiring'))
		//		{

		//			SetTimer( 1.5 + FRand(), false, nameof(StartFiring) );
		//		}
		//	}
		//	else
		//	{
		//		StartFiring((TGAI_TDM(Outer) == None || GetDifficultyLevel() == DL_Casual) ? 1 : -1);
		//	}
		//}
	}
	else
	{
		//StopFiring();
		if (MyTGPawn != none)
		{
			MyTGPawn.SetTargetingMode(FALSE);
		}
	}

	//if (MyTGPawn.hod.a.movement == 'stop')
	//MyTGPawn.hod.notify('goal');
	//if (bNeedDomove)
	//{
	//	MyTGPawn.hod.DoMove();
	//	bNeedDomove = false;
	//}

}

private function bool AllowedToDoLeadInLeadOutWalk()
{
	return !IsInCombat()
		&& (CombatMood == AICM_None || CombatMood == AICM_Normal || CombatMood == AICM_Passive)
		&& (MoveAction == none || ( MoveAction.MovementStyle != EMS_Fast))
		&& MovementMood != AIMM_WithCover;
}

private function bool PonderWalking()
{
	local Controller Leader;
	local float DistToGoal,DistSLToGoal,TetherLeaderDist;
	local Vector IdealPos;
	local Actor TestMoveGoal;

	if (Pawn == None || WorldInfo.GRI.IsMultiplayerGame())
	{
    	return FALSE;
	}

	;

	if( bShouldRoadieRun )
	{
		;
		return FALSE;
	}

	if( ShouldAllowWalk() == FALSE )
	{
		;
		return FALSE;
	}

	if( MoveAction != None && MoveAction.MovementStyle == EMS_SLOW )
	{
		;
		return TRUE;
	}

	if( bMovingToSquadLeader )
	{
		Leader = GetSquadLeader();
		if( Leader != None && Leader.Pawn != None && !Leader.Pawn.IsHumanControlled() )
		{
			if( MoveGoalIsValid() || MovePointIsValid() )
			{
				if( !GetIdealSquadPosition(IdealPos) )
				{
					;
					return FALSE;
				}

				DistToGoal   = VSizeSq(IdealPos-Pawn.Location);
				DistSLToGoal = VSizeSq(Leader.Pawn.Location - IdealPos);

				TetherLeaderDist=GetTetherToLeaderDist();
				TetherLeaderDist*=TetherLeaderDist;
				// if we're far from our leader, and from our goal, and we aren't closer to the goal than the SL
				if( !IsCloseToSquadLeader(Pawn.Location) &&
						DistToGoal > TetherLeaderDist &&
						DistSLToGoal < DistToGoal)
				{
					;
					return FALSE;
				}
			}
			// if our leader is walking then we have an early out
			if (Leader.Pawn.bIsWalking)
			{
				;
				return TRUE;
			}
		}
	}
	// if not in combat
	if (AllowedToDoLeadInLeadOutWalk())
	{
		// if this is an initial move then walk
		if (IsTimerActive(nameof(AttemptToWalk),self))
		{
			;
			return TRUE;
		}
		if( MoveGoalIsValid() || MovePointIsValid() && TimeSince(LastMoveFinishTime) > 2.0f)
		{
			// if close to the goal then walk
			TestMoveGoal = /*IntermediateMoveGoal != None ? IntermediateMoveGoal :*/ MoveGoal;
			if (MoveGoalIsValid(TestMoveGoal))
			{
				DistToGoal = VSize(TestMoveGoal.Location-Pawn.Location);
			}
			else
			{
				DistToGoal = VSize(GetBasedPosition(MovePosition)-Pawn.Location);
			}
			;
			if (DistToGoal < 256.f)
			{
				return TRUE;
			}
		}
	}
	// run like the wind!
	return FALSE;
}

final function bool ShouldWalk()
{
	if (TimeSince(LastShouldWalkCacheTime) > 0.1)
	{
		bCachedShouldWalk = PonderWalking();
		LastShouldWalkCacheTime = WorldInfo.TimeSeconds;
	}
	return bCachedShouldWalk;
}

final function ForceSkipAheadUpdate()
{
	SetBasedPosition(SkipAheadLastUpdatePos,Pawn.Location+vect(1.f,0,0)*2.0f*SkipAheadUpdateThreshold);
}

final protected function SetNextFocusTarget()
{
    local HDFocusTargetRoute FRoute;
    local Actor      FActor;
    local SeqAct_AISetTarget Action;
    local int i;

    if(IntermediateMoveGoal == none)
        return;

    FRoute = HDFocusTargetRoute(ActiveRoute);
    if(FRoute != none)
    {
        //find the node
        for(i = 0; i < FRoute.RouteList.Length; i++)
        {
            if(FRoute.RouteList[i].Actor == IntermediateMoveGoal)
                break;
        }

        if(i < FRoute.RouteList.Length && i < FRoute.FocusActor.Length)
             FActor = FRoute.FocusActor[i];

        if(FActor != none)
        {
            ;

            //MoveFocus = FActor;
       //    FireTarget = none;
//           TargetList.Length = 0;
//       	 TargetList.AddItem(Focus);
           //MyTGPawn.SetTargetingMode(TRUE);

           Action = FRoute.AgentAction;
           Action.FocusTargets.Length = 0;
           Action.FocusTargets.AddItem(FActor);
           Action.InputLinks[0].bHasImpulse = true;
           OnAISetTarget(Action);
           Action.InputLinks[0].bHasImpulse = false;
           Action.FocusTargets.Length = 0;
        }
    }
}

native function bool CanMoveTo(NavigationPoint p);

state MovingToGoal 
{
	simulated function bool NotifyCoverClaimViolation( Controller NewClaim, CoverLink Link, int SlotIdx )
	{
		bValidRouteCache = FALSE;
		GotoState( GetStateName(), 'Begin' );
		return FALSE;
	}

	/**
	 *	Check combat zone information to see if we should delay movement through our target node
	 */
	function bool ShouldDelayMove()
	{
		local NavigationPoint Nav;
		local CombatZone	  CZ;
		local bool			  bResult;

		if (MyTGPawn != None)
		{
			// If moving to a navigation point that isn't our goal
			//	(Don't want to prevent reaching destination)
			Nav = NavigationPoint(IntermediateMoveGoal);
			if( Nav != None && Nav != MoveGoal )
			{
				CZ = MyTGPawn.GetCombatZoneForNav( Nav );
				if( CZ != None && CZ.CheckForMovementDelay( TGAI(GameAIOwner) ) )
				{
					bResult = TRUE;
				}
			}
		}

		return bResult;
	}

	function UpdateCombatZone()
	{
		local NavigationPoint Nav;
		local CombatZone	  CZ;

		if (MyTGPawn != None)
		{
			Nav = NavigationPoint(IntermediateMoveGoal);
			if( Nav != None )
			{
				CZ = MyTGPawn.GetCombatZoneForNav( Nav );
				SetPendingCombatZone(CZ);
			}
		}

	}

	/** checks if the AI needs to hit a trigger to use its current path
	* @return any trigger required
	*/
	final protected function bool CheckForTrigger()
	{
		local int i;
		local Actor NewGoal;
		local TGAI SquadMate;
		local bool bAlreadyCovered;
		local AICmd_MoveToGoal MoveCmd;

		for (i = 0; i < RouteCache.length; i++)
		{
			NewGoal = RouteCache[i].SpecialHandling(Pawn);
			if (NewGoal != None && NewGoal != RouteCache[i])
			{
				;
				// see if someone on our squad is already doing this
				foreach Squad.AllMembers(class'TGAI', SquadMate)
				{
					if (SquadMate != Outer)
					{
						if (SquadMate.MoveGoal == NewGoal)
						{
							bAlreadyCovered = true;
							break;
						}
						else
						{
							MoveCmd = SquadMate.FindCommandOfClass(class'AICmd_MoveToGoal');
							if (MoveCmd != None && MoveCmd.TriggerGoal == NewGoal)
							{
								bAlreadyCovered = true;
								break;
							}
						}
					}
				}
				if (!bAlreadyCovered)
				{
					NodesRequiringTriggers.AddItem(RouteCache[i]);
					TriggerGoal = NewGoal;
					return true;
				}
				else
				{
					;
				}
			}
		}

		return false;
	}

	/** blocks all nodes that are known to be requiring a trigger we haven't hit yet */
	final function BlockNodesRequiringTriggers()
	{
		local NavigationPoint N;

		foreach NodesRequiringTriggers(N)
		{
			N.TransientCost = class'ReachSpec'.const.BLOCKEDPATHCOST;
		}
	}

	final protected function bool GetNextMoveTarget( out Actor CurrentMoveTarget )
	{
		local bool bDone;
		local Actor OldMoveTarget;
		local bool bReachedDynamicAnchor;
		local Trigger PendingTrigger;

		//debug
		;

		// if we were going to hit a trigger needed for our path, but someone else did it, go back to our original path
		PendingTrigger = Trigger(TriggerGoal);
		if (PendingTrigger != None && PendingTrigger.bRecentlyTriggered)
		{
			;
			CurrentMoveTarget = None;
			return true;
		}

		bGoalChangedDueToSkipAhead=false;

		OldMoveTarget = CurrentMoveTarget;
		while( !bDone &&
			RouteCache.Length > 0 &&
			RouteCache[0] != None )
		{
			if( Pawn.ReachedDestination(RouteCache[0]) ||
				((Pawn.anchor == RouteCache[0]) && 
				 (RouteCache.Length > 1) &&
				 CanMoveTo(RouteCache[1]))
				)
			{

				//debug
				;

				// force skipahead update when we reach a goal
				ForceSkipAheadUpdate();

				// If our move goal has been reached
				if( RouteCache[0] == MoveGoal )
				{
					// Clear move target and exit
					bDone = TRUE;
					CurrentMoveTarget = None;
				}

				// MAKE SURE ANCHOR IS UPDATED -- this is cause of NO CURRENT PATH bug
				Pawn.SetAnchor( RouteCache[0] );

				// If we reached a dynamic anchor, return true so we don't abort the move
				bReachedDynamicAnchor = (DynamicAnchor(RouteCache[0]) != None);

				//debug
				;

				RouteCache_RemoveIndex( 0 );
			}
			else
			{
				//debug
				;

				break;
			}
		}

		if( !bDone )
		{
			if( RouteCache.Length > 0 )
			{
				//if (bReachedDynamicAnchor && RouteCache.Length > 1 && CanMoveTo(RouteCache[1]))
				//{
				//	RouteCache_RemoveIndex(0);
				//}
				CurrentMoveTarget = RouteCache[0];
			}
			// Otherwise, if not moving directly to movegoal and movegoal is not a nav point, try moving directly to it
			else if ( TriggerGoal != None && CurrentMoveTarget != TriggerGoal && NavigationPoint(TriggerGoal) == None &&
					ActorReachable(TriggerGoal) )
			{
				CurrentMoveTarget = TriggerGoal;
			}
			else if ( MoveGoal != None && CurrentMoveTarget != MoveGoal && NavigationPoint(MoveGoal) == None &&
					ActorReachable(MoveGoal) )
			{
				CurrentMoveTarget = MoveGoal;
			}
			else
			{
				CurrentMoveTarget = None;
			}
		}
		return bReachedDynamicAnchor || OldMoveTarget != CurrentMoveTarget;
	}

CheckMove:
	//debug
	;

	ClearTimer( 'MoveToGoalTimedOut', self );

Begin:
	if( HasReachedMoveGoal() )
	{
		Goto( 'ReachedGoal' );
	}
	//debug
	;

	//debug
	;

	TriggerGoal = None;
	NodesRequiringTriggers.length = 0;

	if( MoveGoalIsValid() )
	{
		//// if walking then add a bit of random delay to reduce the clone wars
		//if (ShouldWalk())
		//{
		//	Sleep(RandRange(0.1f,0.4f));
		//}
		//// if the actor is directly reachable (don't go direct to goal if we have a route cache we're trying to follow already)
		//if( !bValidRouteCache && ActorReachable( MoveGoal ) )
		//{
		//		//debug
		//	`AILog("- direct move to goal");

		//	StartingMove( TRUE, VSize(Pawn.Location - MoveGoal.Location), 0, MoveGoal );
		//	MyTGPawn.hod.ApproachGoal(MoveGoal);

		//	// If Pawn cannot strafe, then face destination before moving
		//	if( !Pawn.bCanStrafe && Vehicle(Pawn) == None )
		//	{
		//		PushState( 'RotateToFocus' );
		//	}

		//	SetTimer( GetMoveTimeOutDuration(MoveGoal.GetDestination(outer),AllowedToDoLeadInLeadOutWalk()), FALSE, nameof(self.MoveToGoalTimedOut), self );

		//	// Move directly to it
		//	// (this while loop helps catch cases interruption when a state is pushed)
		//	LoopFailSafeCounter=0;
		//	do
		//	{
		//		//debug
		//		`AILog( "Moving directly to move goal:"@MoveGoal@"from"@Pawn.Anchor@"Focus"@MoveFocus@"Offset"@MoveOffset@CurrentPath, 'Move' );

		//		if (MyTGPawn != None && !bMovingToCover && AllowedToDoLeadInLeadOutWalk())
		//		{
		//			MyTGPawn.LastMaxSpeedModifier = 0.f;
		//		}
		//		IntermediateMoveGoal = MoveGoal;
		//		MoveToward( IntermediateMoveGoal, bShouldRoadieRun ? None : MoveFocus, MoveOffset, FALSE, ShouldWalk() );

		//		TryToRun2Cover( TRUE );

		//		Sleep(0.1f);
		//	} until( HasReachedMoveGoal() || !ActorReachable( MoveGoal ) || LoopFailSafeCounter++ > 50);

		//	Goto( 'CheckMove' );
		//}
		//else 
		if (bValidRouteCache)
		{
			//debug
			;
			DebugLogRoute();

			IntermediateMoveGoal = (RouteCache.Length > 0) ? RouteCache[0] : None;

			bValidRouteCache = FALSE;
		}
		else
		{
			//debug
			;

			// look for a path
			IntermediateMoveGoal = FindPathToward( MoveGoal );
			if( IntermediateMoveGoal == None )
			{
				//InvalidateAnchor( Pawn.Anchor );
				if( !bValidRouteCache && ActorReachable( MoveGoal ) )
				{
					//debug
					;

					StartingMove( TRUE, VSize(Pawn.Location - MoveGoal.Location), 0, MoveGoal );
					MyTGPawn.hod.ApproachGoal(MoveGoal);

					// If Pawn cannot strafe, then face destination before moving
					if( !Pawn.bCanStrafe && Vehicle(Pawn) == None )
					{
						PushState( 'RotateToFocus' );
					}

					SetTimer( GetMoveTimeOutDuration(MoveGoal.GetDestination(outer),AllowedToDoLeadInLeadOutWalk()), FALSE, nameof(self.MoveToGoalTimedOut), self );

					// Move directly to it
					// (this while loop helps catch cases interruption when a state is pushed)
					LoopFailSafeCounter=0;
					do
					{
						//debug
						;

						if (MyTGPawn != None && !bMovingToCover && AllowedToDoLeadInLeadOutWalk())
						{
							MyTGPawn.LastMaxSpeedModifier = 0.f;
						}
						IntermediateMoveGoal = MoveGoal;
						MoveToward( IntermediateMoveGoal, bShouldRoadieRun ? None : MoveFocus, MoveOffset, FALSE, ShouldWalk() );

						TryToRun2Cover( TRUE );

						Sleep(0.1f);
					} until( HasReachedMoveGoal() || !ActorReachable( MoveGoal ) || LoopFailSafeCounter++ > 50);

					Goto( 'CheckMove' );
				}
			}

			//debug
			DebugLogRoute();
		}
	}
	else
	if( MovePointIsValid() )
	{
		// If point is directly reachable
		if( PointReachable( GetBasedPosition( MovePosition ) ) )
		{
			//debug
			;

			StartingMove( TRUE, VSize(Pawn.Location - GetBasedPosition( MovePosition ) ), 0, none );
			MyTGPawn.hod.ApproachGoal(, GetBasedPosition(MovePosition));

			// If Pawn cannot strafe, then face destination before moving
			if( !Pawn.bCanStrafe && Vehicle(Pawn) == None )
			{
				PushState( 'RotateToFocus' );
			}

			// Move directly to it
			// (this while loop helps catch cases interruption when a state is pushed)
			SetTimer( GetMoveTimeOutDuration(GetBasedPosition(MovePosition),AllowedToDoLeadInLeadOutWalk()), FALSE, nameof(self.MoveToGoalTimedOut), self );
			do
			{
				//debug
				;

				if (MyTGPawn != None && AllowedToDoLeadInLeadOutWalk())
				{
					MyTGPawn.LastMaxSpeedModifier = 0.f;
				}
				MoveTo( GetBasedPosition( MovePosition ), MoveFocus, , ShouldWalk() );
			} until( HasReachedMoveGoal() || !PointReachable( GetBasedPosition( MovePosition ) ) );

			Goto( 'CheckMove' );
		}
		else
		if( bValidRouteCache )
		{
			//debug
			;

			IntermediateMoveGoal = (RouteCache.Length > 0) ? RouteCache[0] : None;
			bValidRouteCache = FALSE;
		}
		else
		{
			// Otherwise, try to find a path
			IntermediateMoveGoal = FindPathTo( GetBasedPosition( MovePosition ) );
			if( IntermediateMoveGoal == None )
			{
				InvalidateAnchor( Pawn.Anchor );
			}
		}
	}
	// If need to move along a path
	if( IntermediateMoveGoal != None )
	{
		//debug
		if( MoveGoal != None ) { ;	}
		else				   { ;	}

		while (CheckForTrigger())
		{
			if (ActorReachable(TriggerGoal))
			{
				;
				// make AI face the trigger as it is a requirement for some
				RouteCache.length = 0;
				StopFiring();
				Focus = MoveTarget;
				SetFocalPoint(Focus.Location, false);
				MoveTarget = TriggerGoal;
				IntermediateMoveGoal = TriggerGoal;
				FinishRotation();
				if (Pawn.ReachedDestination(TriggerGoal))
				{
					TriggerGoal.Touch(Pawn, None, Pawn.Location, vect(0,0,1)); // retrigger it
					Sleep(0.0);
					Goto('CheckMove');
				}
			}
			else
			{
				// sleep for a frame to avoid multiple pathfinds at a time
				Sleep(0.0);
				BlockNodesRequiringTriggers();
				IntermediateMoveGoal = FindPathToward(TriggerGoal);
				if (IntermediateMoveGoal == None)
				{
					;
					Sleep(0.5);
					Goto('FailedMove');
				}
			}
		}

		GetNextMoveTarget( IntermediateMoveGoal );

		// If first move target is the anchor and we can reach the next one
		if( IntermediateMoveGoal == Pawn.Anchor &&
			RouteCache.Length > 1 &&
			ActorReachable(RouteCache[1]) )
		{
			//debug
			;

			// Remove anchor from route and grab next point
			RouteCache_RemoveIndex( 0 );
			GetNextMoveTarget( IntermediateMoveGoal );
		}

		//debug
		;
		DebugLogRoute();

		if( IntermediateMoveGoal == None )
		{
			//debug
			;

			Sleep( 0.5f );
			Goto( 'CheckMove' );
		}

		ClearTimer( 'MoveToGoalTimedOut', self );
		while( IntermediateMoveGoal != None )
		{
			//debug
			;

			// Check for any global interrupts (enemy with melee range)
			CheckInterruptCombatTransitions();

			// If Pawn cannot strafe, then face destination before moving
			if( !Pawn.bCanStrafe && Vehicle(Pawn) == None )
			{
				PushState( 'RotateToFocus' );
			}

			// Check if we should delay our move a little
			LastDetourCheckTime = WorldInfo.TimeSeconds;
			while( ShouldDelayMove() )
			{
				if( Pawn != None )
				{
					Pawn.ZeroMovementVariables();
				}

				// If it's been a while since our last detour check
				if( TimeSince( LastDetourCheckTime ) > 10.0f )
				{
					// Restart the move
					LastDetourCheckTime = WorldInfo.TimeSeconds;
					bValidRouteCache = FALSE;
					;
					Goto( 'CheckMove' );
				}
				;
				Focus = IntermediateMoveGoal;
				Sleep( 0.1f );
			}

			UpdateCombatZone();


			// Setup the next move
			StartingMove( FALSE, GetRouteCacheDistance(), RouteCache.Length, IntermediateMoveGoal);

			// Move to the target - latent
			// if the goal has been changed in between that last time we called getnextmovegoal and now, we need to go to the new goal!
			if(bGoalChangedDueToSkipAhead)
			{
				;
				if( !GetNextMoveTarget( IntermediateMoveGoal ) )
				{
					//debug
					;
					DebugLogRoute();

					// issue with movetarget not changing
					IntermediateMoveGoal = None;
					break;
				}

				SetupSplinePoints(IntermediateMoveGoal);
			}

			if (IntermediateMoveGoal == MoveGoal)
				MyTGPawn.hod.ApproachGoal(MoveGoal);

			SetNextFocusTarget();
			;
			MoveToward( IntermediateMoveGoal, bShouldRoadieRun ? None : MoveFocus, (IntermediateMoveGoal == MoveGoal) ? MoveOffset : 0.f, FALSE, ShouldWalk() );
			;

			if( bReevaluatePath )
			{
				ReEvaluatePath();
			}
			else
			// if goal changed during movetoward, wipe spline points
			if(bGoalChangedDueToSkipAhead)
			{
				;
				//DebugFreezeGame();
				ClearSplinePoints();
				IntermediateMoveGoal=none;
			}

			TryToRun2Cover( FALSE );

			// if we are moving towards a Pawn, repath every time we successfully re ach the next node
			// as that Pawn's movement may cause the best path to change
			if (Pawn(MoveGoal) != None
				&& NodesRequiringTriggers.length == 0
				&& Pawn.ReachedDestination(IntermediateMoveGoal)
				&& VSizeSq( MoveGoal.Location - GetBasedPosition(LastPawnTargetPathLocation) ) > 768.f*768.f)
			{
				SetBasedPosition(LastPawnTargetPathLocation,MoveGoal.Location);
				;
				Goto('CheckMove');
			}
			else if (IntermediateMoveGoal == MoveGoal && HasReachedMoveGoal())
			{
				Goto( 'CheckMove' );
			}
			else
			{
				if( GetNextMoveTarget( IntermediateMoveGoal ) )
				{
					NumTimesGetNextMoveGoalReturnedSameNode=0;
				}
				else
				{
					NumTimesGetNextMoveGoalReturnedSameNode++;
				}
				// Once reached target, grab next
				if( IntermediateMoveGoal == none || NumTimesGetNextMoveGoalReturnedSameNode > 5)
				{
					//debug
					;
					DebugLogRoute();

					// issue with movetarget not changing
					IntermediateMoveGoal = None;

					if(NumTimesGetNextMoveGoalReturnedSameNode > 5)
					{
						;
						Goto('FailedMove');
					}

				}
				else
				{
					//debug
					;
				}

			}
		}

		// If moving to a point
		if( GetBasedPosition(MovePosition) != vect(0,0,0) )
		{
			// Move directly to it
			// (this while loop helps catch cases interruption when a state is pushed)
			while( !HasReachedMoveGoal() )
			{
				if( !PointReachable(GetBasedPosition(MovePosition)) )
				 {
					 ;
					 Sleep(0.5f);
					 Goto('FailedMove');
				 }

				// If Pawn cannot strafe, then face destination before moving
				if( !Pawn.bCanStrafe && Vehicle(Pawn) == None )
				{
					PushState( 'RotateToFocus' );
				}

				//debug
				;

				// Finish up direct move
				MoveTo( GetBasedPosition(MovePosition), MoveFocus, ,ShouldWalk() );
			}
		}
	}
	else
	// Otherwise, if haven't reached move goal
	if( !HasReachedMoveGoal() )
	{
		//debug
		if( MoveGoal != None ) { ; }
		else				   { ; }

		Sleep( 0.5f );
		Goto( 'FailedMove' );
	}

	//debug
	;

	Goto( 'CheckMove' );

FailedMove:
	Status = 'Failure';
	GotoState('DelayFailure');
	Stop;

ReachedGoal:
	//debug
	if( MoveGoal != None ) { ; }
	else				   { ; }

	Status = 'Success';
	PopCommand( self );
}

state RotateToFocus 
{
Begin:
	;
	Focus = MoveFocus;
	if( Focus == None )
	{
		SetFocalPoint( (IntermediateMoveGoal != None) ? IntermediateMoveGoal.Location : MoveGoal.Location );
	}

	Pawn.SetDesiredRotation(Normalize(Rotator( (Focus == None ? GetFocalPoint() : Focus.Location) - Pawn.Location )));
	//DesiredRotation = Pawn.DesiredRotation;

	// @fixme laurent -- can't get this to work without using ForceDesiredRotation. grrrrr.
	//bForceDesiredRotation = TRUE;
	FinishRotation();
	//bForceDesiredRotation = FALSE;

	PopState();
}

event DrawDebug( HUD H, Name Category )
{
	local int Idx;

	Super.DrawDebug( H, Category );

	if(Category != 'Pathing')
	{
		return;
	}

	// BLUE
	DrawDebugLine( Pawn.Location, GetDestinationPosition(), 0, 0, 255 );

	if( MoveTarget != None )
	{
		// BLUE
		DrawDebugLine( Pawn.Location, MoveTarget.Location - vect(0,0,15), 0, 0, 255 );
	}

	if( MoveGoalIsValid() )
	{
		// GREEN
		DrawDebugLine( Pawn.Location, MoveGoal.Location, 0, 255, 0 );
	}
	else
	if( MovePointIsValid() )
	{
		// GREEN
		DrawDebugLine( Pawn.Location, GetBasedPosition(MovePosition), 0, 255, 0 );
	}

	if( RouteCache.Length > 0 )
	{
		if( Pawn.Anchor != None && RouteCache[0] != None )
		{
			// RED
			DrawDebugLine( RouteCache[0].Location, Pawn.Anchor.Location, 255, 128, 0 );
		}

		for( Idx = 1; Idx < RouteCache.Length; Idx++ )
		{
			// ORANGE
			if( RouteCache[Idx] != None &&
				RouteCache[Idx-1] != None )
			{
				DrawDebugLine( RouteCache[Idx-1].Location, RouteCache[Idx].Location, 255, 128, 0 );
			}
		}
	}
}


