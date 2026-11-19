/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_MoveToGoal_Mesh extends AICommand
    within GearAI
	native(AI);

/** Current RouteCache for controller is valid, no need to path find again */
var bool	bValidRouteCache;

/** if false, abort if we need to pathfind (i.e, if the current RouteCache becomes invalid) */
var bool bCanPathfind;
/** Allow any path generation to return best guess */
var bool bAllowPartialPath;

var bool bAllowedToFire;

var vector		  IntermediatePoint;

/** is this AI on 'final approach' ( i.e. moving directly to it's end-goal destination )*/
var bool bFinalApproach;

var bool bCachedShouldWalk;
var float LastShouldWalkCacheTime;

/** internal use only, AI was firing weapon when move started, so don't cancel firing after */
var bool bFiringWeaponAtStart;

/** fail-safe vars used to determine when a move has failed and needs to be started over */
var vector LastMovePoint;
var int    NumMovePointFails;
/** maximum number of times we will accept the same move point before failing */
var int    MaxMovePointFails;

/** storage of initial desired move location */
var vector InitialFinalDestination;
var Vector FailSafeDestination;

/** Actor we're trying to reach with this move (if any). Used for final approach and for repathing if the target moves. */
var Actor MoveToActor;
/** location of MoveToActor last time we did pathfinding */
var BasedPosition LastMoveTargetPathLocation;

/** keeps track of if we have tried to move to another poly because our anchor is inescapable already*/
var bool bHasTriedToEscapeFromAnchor;

var bool bSavedIgnoreStepAside;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool MoveToGoal( GearAI AI, vector NewMovePoint, optional Actor NewMoveToActor, optional Actor NewMoveFocus,
				optional bool bIsValidCache,
				optional bool bInCanPathfind = TRUE,
				optional bool bInAllowedToFire = TRUE,
				optional bool bInAllowPartialPath = TRUE )
{
	local AICmd_MoveToGoal_Mesh Cmd;

	if( AI != None && NewMovePoint != vect(0,0,0) )
	{
		Cmd = new(AI) class'AICmd_MoveToGoal_Mesh';
		if( Cmd != None )
		{
			AI.MoveFocus = NewMoveFocus; //@FIXME: doesn't support stacking!
			Cmd.MoveToActor = NewMoveToActor;
			Cmd.bValidRouteCache	= bIsValidCache;
			Cmd.bCanPathfind		= bInCanPathfind;
			Cmd.bAllowedToFire		= bInAllowedToFire;
			Cmd.bAllowPartialPath	= bInAllowPartialPath;
			Cmd.InitialFinalDestination = NewMovePoint;

			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@"Point:"@BP2Vect(NavigationHandle.FinalDestination)@"MoveFocus:"@MoveFocus@"Offset:"@MoveOffset@"Focus:"@Focus;
}

function Pushed()
{
	Super.Pushed();

	//test
//	MyGearPawn.FitCollision();

	// call outer's function to notify it we're now in a movement state
	StartingMovement();

	bSavedIgnoreStepAside = bIgnoreStepAside;

	if( (!bValidRouteCache && !NavigationHandle.ComputeValidFinalDestination(InitialFinalDestination)) ||
		!NavigationHandle.SetFinalDestination(InitialFinalDestination))
	{
//		DrawDebugBox( InitialFinalDestination, vect(5,5,5), 255, 0, 0, true );

		HandleFailedPathFind(MoveToActor);
		`AILog("ABORTING! Final destination"@InitialFinalDestination@"is not reachable! (ComputeValidFinalDestination returned FALSE)"@`showvar(bValidRouteCache));
		GotoState('DelayFailure');
	}
	else
	{
		// Set flag that says we are moving and MoveGoal info is valid
		bMovingToGoal		= TRUE;
		bReachedMoveGoal	= FALSE;
		`AILOG(GetFuncName()@"disabling bReevaluatePath");
		bReevaluatePath		= FALSE;

		Outer.MoveGoal = MoveToActor;
		Outer.MovePosition = NavigationHandle.FinalDestination;
		MoveTarget			= None;

		bFiringWeaponAtStart = (AIOwner.bFire != 0);

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

		// reset error handling vars
		NumMovePointFails=0;
		LastMovePoint=vect(0,0,0);

		// Start the move
		GotoState( 'MovingToGoal' );
	}
}

function AttemptToWalk();

function UpdateWalking()
{
	local bool bWantsToWalk;
	if( Pawn != None )
	{
		bWantsToWalk = ShouldWalk();
		if(bWantsToWalk != Pawn.bIsWalking)
		{
			Pawn.SetWalking(bWantsToWalk);
		}
	}
}

function Popped()
{
	Super.Popped();

	// No longer moving to a goal
	bMovingToGoal = FALSE;
	bReachedMoveGoal = (Status == 'Success');

	// call outer's function to notify it we're no longer in a movement state
	StoppingMovement();

	// Check for any latent move actions
	ClearLatentAction( class'SeqAct_AIMoveToActor', !bReachedMoveGoal );

	// clear the route cache to make sure any intermediate claims are destroyed
	NavigationHandle.PathCache_Empty();

	// explicitly clear velocity/accel as they aren't necessarily
	// cleared by the physics code
	if( Pawn != None )
	{
		Pawn.ZeroMovementVariables();

		// stop any roadie run
		if(IsRoadieRunning())
		{
			DictateSpecialMove( SM_None );
		}

		Pawn.DestinationOffset=0.f;
	}
	MoveTarget = None;

	// stop any firing while moving
	if( !bFiringWeaponAtStart )
	{
		StopFiring();
	}

	ClearTimer( 'MoveToGoalTimedOut', self );
	ClearTimer(nameof(CheckIfTetherGoalIsOccupied), self);
	ClearTimer(nameof(UpdateWalking), self);

	// make sure that if we are bailing we notify the Controller we're done trying to move
	ReachedMoveGoal();

	if (MyGearPawn != None)
	{
		// while holding shield stay in targeting mode to take advantage of its protection
		if (!MyGearPawn.IsCarryingShield())
		{
			MyGearPawn.SetTargetingMode(false);
		}
		MyGearPawn.Acceleration = vect(0,0,0);
	}

	LastMoveFinishTime = WorldInfo.TimeSeconds;

	bIgnoreStepAside = bSavedIgnoreStepAside;
}

function Paused( GameAICommand NewCommand )
{
	Super.Paused( NewCommand );

	// call outer's function to notify it we're no longer in a movement state
	StoppingMovement();

	// Pause move timeout timer
	PauseTimer(true, 'MoveToGoalTimedOut', self);
	if (CommandList.ChildCommand == self) //@FIXME: hacky, should be MoveToGoal init parameter or something
	{
		PauseTimer(true, 'TimedAbortMove');
	}
	PauseTimer(true, nameof(CheckIfTetherGoalIsOccupied), self);
	PauseTimer(true, nameof(UpdateWalking), self);

	// explicitly clear velocity/accel as they aren't necessarily
	// cleared by the physics code
	if( Pawn != None )
	{
		Pawn.ZeroMovementVariables();

		// stop any roadie run
		if (IsRoadieRunning())
		{
			DictateSpecialMove( SM_None );
		}
	}
}

function Resumed(name OldCommandName)
{
	Super.Resumed(OldCommandName);

	if (ChildStatus == 'Success')
	{
		// Unpause move timeout timer
		PauseTimer(false, 'MoveToGoalTimedOut', self);
		if (CommandList.ChildCommand == self) //@FIXME: hacky, should be MoveToGoal init parameter or something
		{
			PauseTimer(false, 'TimedAbortMove');
		}
		PauseTimer(false, nameof(CheckIfTetherGoalIsOccupied), self);
		PauseTimer(false, nameof(UpdateWalking), self);

		bMovingToGoal = true;
		bReachedMoveGoal = false;
		bHasTriedToEscapeFromAnchor = false;
		Outer.MoveGoal = MoveToActor;


		// NavigationHandle properties might have been clobbered by a child MoveToGoal
		if (VSizeSq(BP2Vect(NavigationHandle.FinalDestination) - InitialFinalDestination) > 1.0)
		{
			NavigationHandle.SetFinalDestination(InitialFinalDestination);
		}
		Outer.MovePosition = NavigationHandle.FinalDestination;

		//debug
		`AILog(GetFuncName()@`showvar(bFinalApproach)@`showvar(MoveToActor)@`showvar(BP2Vect(MovePosition))@HasReachedGoal() );
		DebugLogRoute();

		// reset intermediate move goal so GetMoveGoal doesn't freak out when the current goal hasn't changed
		// also make sure our path wasn't clobbered by another pushed MoveToGoal; if so, pathfind again
		if (!NavigationHandle.GetNextMoveLocation(IntermediatePoint, Outer.IntermediatePointArrivalDist))
		{
			`AILog("@WARN - GetNextMoveLocation returned false in Resumed(), setting bReevaluatePath to true!");
			bReevaluatePath = true;
		}

		// Restart roadie run after getting back into normal run state
		if (ShouldRoadieRun())
		{
			if (MyGearPawn != None && !MyGearPawn.IsDoingSpecialMove(SM_RoadieRunStab))
			{
				if (MyGearPawn.IsInCover())
				{
					DictateSpecialMove(SM_CoverRun);
				}
				else if (MyGearPawn.CanDoSpecialMove(SM_RoadieRunStab) && ShouldChargeStab())
				{
					// ugh, hacky
					GearWeap_RetroLancer(MyGearPawn.Weapon).DoRoadieRunStab();
				}
				else
				{
					DictateSpecialMove(SM_RoadieRun);
				}
			}
		}

		ReEvaluatePath();
		// call outer's function to notify it we're now in a movement state
		StartingMovement();
	}
	else
	{
		Status = 'Failure';
		AbortCommand(self);
	}
}

function ReEvaluatePath()
{
	`AILog(GetFuncName()@bReevaluatePath);

	if( HasReachedGoal() )
	{
		Status = 'Success';
		PopCommand(self);
	}
	else if( bReevaluatePath &&
		Pawn != None &&
		MovePointIsValid() )
	{
		//debug
		`AILog( "Move continued... Goal"@MoveGoal@"Anchor"@Pawn.Anchor);

		NavigationHandle.PathCache_Empty();
		`AILog(GetFuncName()@"disabling bReevaluatePath");
		bReevaluatePath = FALSE;
		bValidRouteCache= FALSE;

		// Restart the movement state
		GotoState( 'MovingToGoal', 'Begin' );
	}
}

function vector GetMovePoint()
{
	return BP2Vect(NavigationHandle.FinalDestination);
}
/** Check if AI has successfully reached the given goal */
function bool HasReachedGoal()
{
	if( Pawn == None )
	{
		return TRUE;
	}

	`AILog(GetFuncName()@bFinalApproach@MoveToActor);
	if(bFinalApproach && MoveToActor != None)
	{
		return Pawn.ReachedDestination(MoveToActor);
	}

	if( BP2Vect( NavigationHandle.FinalDestination ) != vect(0,0,0) )
	{
		if( VSize(GetMovePoint()-Pawn.Location) < MoveOffset )
		{
			return TRUE;
		}
		return Pawn.ReachedPoint( BP2Vect(NavigationHandle.FinalDestination), None );
	}

    return FALSE;
}

function MoveToGoalTimedOut()
{
	//debug
	`AILog( GetFuncName()@Pawn.Anchor@MoveGoal );

	ClearMoveAction();
	`LogPathFailure(MoveToActor,"Move timed out");
	AbortCommand( self );
}

/** Check if given point is valid */
function bool MovePointIsValid( optional Vector Point )
{
	if( Point == vect(0,0,0) )
	{
		Point = BP2Vect(NavigationHandle.FinalDestination);
	}
	return (Point != vect(0,0,0));
}

function TryToRun2Cover( )
{
	local CoverInfo Cover;
	// If the MoveToward set bShouldRun2Cover
	//`log(GetFuncName()@CoverOwner.bShouldRun2Cover@CoverOwner.IsAlert()@Coverowner.IsInCombat());
	if( CoverOwner != None && CoverOwner.bShouldRun2Cover )
	{
		CoverOwner.bShouldRun2Cover = FALSE;
		if( CoverOwner.IsAlert() || CoverOwner.IsInCombat() )
		{
			if( MyGearPawn != none )
			{
				Cover = Coverowner.CoverGoal;
				if(Cover.Link.bStatic)
				{
					// Start the special move and let it finish the move into cover
					NavigationHandle.ClearCurrentEdge();
					class'AICmd_Move_Run2Cover'.static.Run2Cover( CoverOwner, Cover, Cover.Link.GetSlotLocation(Cover.SlotIdx));
				}
			}
		}
	}
}

function bool MoveUnreachable( Vector AttemptedDest, Actor AttemptedTarget )
{
	// allow child to override this behavior and consider the failed move acceptable
	if (CachedGearChildCommand == None || !CachedGearChildCommand.MoveUnreachable(AttemptedDest, AttemptedTarget))
	{
		Status = 'Failure';
		`LogPathFailure(MoveToActor,"MoveUnreachable");
		AbortCommand( self );
	}
	return true;
}

function bool HandlePathObstruction( Actor BlockedBy )
{
	local Pawn BlockPawn;
	local GearAI AI;

	//debug
	`AILog( self@GetFuncName()@BlockedBy, 'Move' );

	LastObstructionTime = WorldInfo.TimeSeconds;
	BlockPawn = Pawn(BlockedBy);
	if( BlockPawn != None)
	{

		// if they're touching our goal
		if( BlockPawn.ReachedPoint( GetMovePoint(), none) )
		{
			`AILog("- they're touching my goal, finishing the move");

			// then just pretend we made it
			bReachedMoveGoal = TRUE;
			if( bMovingToTether && MoveGoal == GetTetherActor() )
			{
				bReachedTether = TRUE;
			}

			Status = 'Success';
			PopCommand( self );
			return TRUE;
		}

		AI = GearAI(BlockPawn.Controller);
		if( AI != None && AI.StepAsideFor(Pawn) )
		{
			`AILog("- they're stepping aside for me");
			return TRUE;
		}
		else
			if( StepAsideFor(BlockPawn) )
			{
				`AILog("- stepping aside for them");
				return TRUE;
			}
	}

	return FALSE;
}

function bool CheckIfTetherGoalIsOccupied()
{
	local int Idx;

	//`AILog(GetFuncName());
	// if we're on a direct move (moving to the final goal), and we have several tether options check to see if the tether is occupied, if so try to find one that isn't occupied and use it instead
	if(MoveAction != none &&
		MoveAction.AvailableTethers.length > 1 &&
		GetTetherActor() != None)
	{
		if(IsTetherOccupied(GetTetherActor()))
		{
			for(Idx=0;Idx<MoveAction.AvailableTethers.length;Idx++)
			{
				// if we found an alternative that's not occupied, use that!
				if(MoveAction.AvailableTethers[Idx] != none && MoveAction.AvailableTethers[Idx] != GetTetherActor() && !IsTetherOccupied(MoveAction.AvailableTethers[Idx]))
				{
					`AILog("Current tether"@PrintTetherInfo()@"Was occupied on final approach!, switching to "@MoveAction.AvailableTethers[Idx]);
					AbortCommand( None, class'AICmd_MoveToTether' );
					SetTether( MoveAction.AvailableTethers[Idx].Location, MoveAction.AvailableTethers[Idx], MoveAction.TetherDistance,,, MoveAction.bInterruptable );
					return true;
				}
			}
			// if we got this far it means we don't have any more options.. so just keep running to the same one
		}
		SetTimer(1.0f,FALSE,nameof(CheckIfTetherGoalIsOccupied),self);
	}

	return false;
}

/** @return whether we should use the charge stab in place of a normal roadie run (if able) */
final function bool ShouldChargeStab()
{
	return (GearPawn(MoveToActor) != None && VSize(MoveToActor.Location - Pawn.Location) < EnemyDistance_MeleeCharge && !WorldInfo.GRI.OnSameTeam(MoveToActor, Outer));
}

/**
* Called after the type of move has been determined.
*/
function StartingMove()
{
	local bool bWasInCover;
	local bool bCanFire;
	local Controller Leader;
	local GearPawn LeaderGP;


	//debug
	`AILog(GetFuncName()@bMovingToCover@"preparing move?"@bPreparingMove@IsAlert(),'MoveDebug');

	`AILog("Moving toward new edge:"@NavigationHandle.GetCurrentEdgeDebugText()@`showvar(bFinalApproach)@`showvar(CheckIfTetherGoalIsOccupied()),'MoveDebug');

	bWasInCover = (MyGearPawn != None && MyGearPawn.IsInCover());

	if( bMovingToSquadLeader && MyGearPawn != None )
	{
		Leader = GetSquadLeader();
		if( Leader != None )
		{
			LeaderGP = GearPawn(Leader.Pawn);
			if( LeaderGP != None )
			{
				MyGearPawn.bIsRoadieJogging = LeaderGP.bIsRoadieJogging;
			}
		}
	}

	// if we're on 'final approach' to our tether, check to see if it's occupied (to decide if we want to try another one of the supplied ethers)
	if (bFinalApproach && CheckIfTetherGoalIsOccupied())
	{
		return;
	}

	if (!bMovingToCover)
	{
		InvalidateCover(true);
	}

	if (CoverOwner != None && NavigationHandle.GetCurrentEdgeType() != NAVEDGE_Coverslip)
	{
		CoverOwner.ResetCoverType();
	}

	// Restart roadie run after getting back into normal run state
	`AILog(GetFuncName()@self@outer@"ShouldRoadieRun?"@ShouldRoadieRun());
	//@FIXME: missing cover running code and some special cases, see old AICmd_MoveToGoal
	if ( ShouldRoadieRun() && MyGearPawn != None && !MyGearPawn.IsInCover() &&
		(Normal(IntermediatePoint - Pawn.Location) dot vector(Pawn.Rotation)) > 0.0 &&
		// don't need to do anything if already in the move
		 !MyGearPawn.IsDoingSpecialMove(SM_RoadieRunStab) )
	{
		if (MyGearPawn.CanDoSpecialMove(SM_RoadieRunStab) && ShouldChargeStab())
		{
			// ugh, hacky
			GearWeap_RetroLancer(MyGearPawn.Weapon).DoRoadieRunStab();
		}
		else
		{
			DictateSpecialMove(SM_RoadieRun);
		}
	}
	else if (IsRoadieRunning())
	{
		DictateSpecialMove(SM_None);
	}

	if (CombatMood != AICM_Passive && bAllowCombatTransitions)
	{
		if (MyGearPawn != None)
		{
			if ( GearAI_TDM(Outer) == None && IsAlert() && HasValidEnemy() && FireTarget != None &&
				!IsRoadieRunning() && MyGearPawn.MyGearWeapon != None &&
				!MyGearPawn.MyGearWeapon.ShouldPreventTargeting()
				&& !MyGearPawn.IsCarryingAHeavyWeapon())
			{
				MyGearPawn.SetTargetingMode(true);
			}
			else
			{
				MyGearPawn.SetTargetingMode(false);
			}
		}

		bCanFire = true;
		if (MyGearPawn != None && MyGearPawn.MyGearWeapon != None)
		{
			bCanFire = (MyGearPawn.MyGearWeapon.WeaponID != WC_Melee && MyGearPawn.MyGearWeapon.WeaponID != WC_Cleaver);
		}

		// if we left cover we couldn't fire from, delay a bit before starting to fire
		// this prevents the AI from simultaneously getting out of cover and firing its first shot,
		// which looks bad, isn't something a human can do, and feels really unfair
		// when they kill you with the shot on top of it ;)
		if (bAllowedToFire && bCanFire)
		{
			if (FireTarget != None)
			{
				// if we're firing we need to look where we're shooting
				MoveFocus = None;
			}
			else if (MoveFocus == None)
			{
				// look where we're going until we get a target
				SetFocalPoint(IntermediatePoint, true);
			}
			if ( bWasInCover && MyGearPawn != None && !MyGearPawn.IsInCover() && CoverOwner != None &&
				(CoverOwner.bFailedToFireFromCover || WorldInfo.TimeSeconds - CoverOwner.LastFireFromCoverTime > 5.0) )
			{
				if (!Outer.IsTimerActive(nameof(StartFiring)))
				{
					SetTimer(1.5 + FRand(), false, nameof(StartFiring));
				}
			}
			else
			{
				StartFiring(GetNumBurstsToFireWhileMoving());
			}
		}
		else if (MoveFocus == None)
		{
			SetFocalPoint(IntermediatePoint, true);
		}
	}
	else
	{
		StopFiring();
		if (MyGearPawn != None)
		{
			MyGearPawn.SetTargetingMode(false);
		}
		if (MoveFocus == None)
		{
			SetFocalPoint(IntermediatePoint, true);
		}
	}
}

private function bool PonderWalking()
{
	local Controller Leader;
	local float DistToGoal,DistSLToGoal,TetherLeaderDist;
	local Vector IdealPos;
	local GearPawn LeaderGP;

	if (Pawn == None || WorldInfo.GRI.IsMultiplayerGame())
	{
		return FALSE;
	}

	`AILog(GetFuncName()@`showvar(bShouldRoadieRun)@ShouldAllowWalk()@`showvar(MoveAction)@`showvar(bMovingToSquadLeader)@IsInCombat()@AllowedToDoLeadInLeadOutWalk() );

	if( bShouldRoadieRun )
	{
		`AILog(">"@`showvar(bShouldRoadieRun));
		return FALSE;
	}

	if (!ShouldAllowWalk())
	{
		`AILog(">"@`showvar(ShouldAllowWalk()));
		return FALSE;
	}

	if( MoveAction != None && MoveAction.MovementStyle == EMS_SLOW )
	{
		`AILog(">"@`showvar(MoveAction));
		return TRUE;
	}

	if( !IsAlert()  )
	{
		if( bMovingToSquadLeader && !IsInCombat() )
		{
			Leader = GetSquadLeader();
			if( Leader != None && Leader.Pawn != None )
			{
				if( MovePointIsValid() )
				{
					if( !GetIdealSquadPosition(IdealPos) )
					{
						`AILog(">>"@`showvar(IdealPos)@`showvar(Leader.Pawn.Location));
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
						`AILog(">>"@`showvar(IsCloseToSquadLeader(Pawn.Location))@`showvar(DistToGoal)@`showvar(TetherLeaderDist)@`showvar(DistSLToGoal));
						return FALSE;
					}
				}
				// if our leader is walking then we have an early out
				LeaderGP = GearPawn(Leader.Pawn);
				if( Leader.Pawn.bIsWalking && (LeaderGP == None || !LeaderGP.bIsRoadieJogging) )
				{
					`AILog(">>"@`showvar(Leader.Pawn.bIsWalking));
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
				`AILog("> initial walk");
				return TRUE;
			}
			if( MovePointIsValid() && `TimeSince(LastMoveFinishTime) > 2.0f)
			{
				DistToGoal = VSize(GetMovePoint()-Pawn.Location);
				`AILog(">"@`showvar(DistToGoal));
				if (DistToGoal < 256.f)
				{
					return TRUE;
				}
			}
		}
	}
	// run like the wind!
	return FALSE;
}

final function bool ShouldWalk()
{
	if (`TimeSince(LastShouldWalkCacheTime) > 0.1)
	{
		bCachedShouldWalk = PonderWalking();
		LastShouldWalkCacheTime = WorldInfo.TimeSeconds;
	}
	return bCachedShouldWalk;
}

state MoveToValidStartLoc `DEBUGSTATE
{
	function bool GetFailsafePoint()
	{
		local vector CurLoc;

		CurLoc = Pawn.Location;

		if(!NavigationHandle.ComputeValidFinalDestination(CurLoc))
		{
			`AILog("Could not resolve failsafe starting location, bailing!"@CurLoc);
			return FALSE;
		}

		FailSafeDestination = CurLoc;
		return TRUE;
	}

Begin:

	bHasTriedToEscapeFromAnchor=true;
	bIgnoreStepAside = TRUE;
	if( !GetFailsafePoint() )
	{
		GotoState('DelayFailure');
	}
	else
	{
		MoveTo( FailSafeDestination );
		GotoState('MovingToGoal');
	}
};

state MovingToGoal `DEBUGSTATE
{
	function bool ShouldDelayMove()
	{
		//MT-TODO: combatzone-like movement delay goes here
		return false;
	}

	final function float GetMoveDestinationOffset()
	{
		// return a negative destination offset so we get closer to our points (yay)
		if( bFinalApproach )
		{
			return MoveOffset;
		}
		else
		{
			return (Outer.IntermediatePointArrivalDist - Pawn.GetCollisionRadius());
		}
	}

	simulated function bool NotifyCoverClaimViolation( Controller NewClaim, CoverLink Link, int SlotIdx )
	{
		bValidRouteCache = FALSE;
		GotoState( GetStateName(), 'Begin' );
		return FALSE;
	}
CheckMove:
	//debug
	`AILog("CHECKMOVE TAG");

	if( HasReachedGoal() )
	{
		Goto( 'ReachedGoal' );
	}

Begin:
	//debug
	`AILog( "--"@GetStateName()$":"$Class@"-- BEGIN TAG CurLoc: "@Pawn.Location@"Dest"@ BP2Vect(NavigationHandle.FinalDestination)@bValidRouteCache@NavigationHandle );

	if (NavigationHandle.PointReachable( BP2Vect(NavigationHandle.FinalDestination)))
	{
		IntermediatePoint = BP2Vect(NavigationHandle.FinalDestination);
	}
	else if( bValidRouteCache )
	{
		//debug
		`AILog( "Use existing route cache", 'Move' );
		bValidRouteCache = FALSE;
		if( !NavigationHandle.GetNextMoveLocation( IntermediatePoint, Outer.IntermediatePointArrivalDist ) )
		{
			//debug
			`LogPathFailure( MoveToActor,"Use existing route cache("$NavigationHandle.GetPathCacheLength()$") ....but couldn't retrieve next move location?" );

			Goto( 'FailedMove' );
		}
	}
	else
	{
		if (!bCanPathfind)
		{
			`LogPathFailure(MoveToActor,"Not allowed to pathfind - aborting move");

			Status = 'Failure';
			AbortCommand(self);
		}

		if (MoveToActor != None)
		{
			// update final dest in case target moved
			if (!NavigationHandle.SetFinalDestination(MoveToActor.GetDestination(outer)))
			{
				`LogPathFailure(MoveToActor,"ABORTING! Final destination"@InitialFinalDestination@"is not reachable! (SetFinalDestination returned FALSE)");
				Goto('FailedMove');
			}
			Outer.MovePosition = NavigationHandle.FinalDestination;
		}

		if( !GeneratePathToLocation( BP2Vect(NavigationHandle.FinalDestination),, bAllowPartialPath ) )
		{
			//debug
			`LogPathFailure(MoveToActor,"Couldn't generate path to location"@BP2Vect(NavigationHandle.FinalDestination)@"from"@Pawn.Location);

			// if we're in a fuxored spot, try and get back into normal space
			if(!bHasTriedToEscapeFromAnchor && NavigationHandle.IsAnchorInescapable())
			{
				GotoState('MoveToValidStartLoc');
			}
			else
			{
				`LogPathFailure(MoveToActor,"Failed to move to valid start location");
				Goto( 'FailedMove' );
			}

		}

		//debug
		`AILog( "Generated path..." );

		if( !NavigationHandle.GetNextMoveLocation( IntermediatePoint, Outer.IntermediatePointArrivalDist ) )
		{
			//debug
			`LogPathFailure(MoveToActor,"Generated path, but couldn't retrieve next move location?");

			Goto( 'FailedMove' );
		}
	}
	if (MoveToActor != None)
	{
		Vect2BP(LastMoveTargetPathLocation, MoveToActor.GetDestination(outer));
	}

	// if walking then add a bit of random delay to reduce the clone wars
	if (ShouldWalk())
	{
		Sleep(RandRange(0.1f,0.4f));
	}

	while( TRUE )
	{
		//debug
		`AILog( "Still moving to"@IntermediatePoint, 'Loop' );

		// Check for any global interrupts (enemy with melee range)
		CheckInterruptCombatTransitions();

		// check to see if we should wait for a movement delay
		while( ShouldDelayMove() )
		{
			if( Pawn != None )
			{
				Pawn.ZeroMovementVariables();
			}

			// If it's been a while since our last detour check
			if( `TimeSince( LastDetourCheckTime ) > 10.0f )
			{
				// Restart the move
				LastDetourCheckTime = WorldInfo.TimeSeconds;
				bValidRouteCache = FALSE;
				`AILog("It's been a while since we tried a detour, trying now..");
				Goto( 'CheckMove' );
			}
			`AILog("Delaying move..."@`TimeSince( LastDetourCheckTime ));
			SetFocalPoint(IntermediatePoint);
			Sleep( 0.1f );
		}

		bFinalApproach = VSizeSq(IntermediatePoint - BP2Vect(NavigationHandle.FinalDestination)) < 1.0;
		StartingMove();

		//DrawDebugLine(Pawn.Location,IntermediatePoint,255,255,0,TRUE);
		//DrawDebugLine(IntermediatePoint,IntermediatePoint+vect(0,0,10),255,0,0,TRUE);
		// suggest move preparation will return TRUE when the edge's logic is getting the bot to the edge point
		// FALSE if we should run there ourselves
		if( bFinalApproach || !NavigationHandle.SuggestMovePreparation( IntermediatePoint, Outer))
		{
			`AILog("Calling MoveTo -- "@IntermediatePoint);
			// if on our final move to an Actor, send it in directly so we account for any movement it does
			if (bFinalApproach && MoveToActor != None)
			{
				// setup move timeout timer
				SetTimer( GetMoveTimeOutDuration(MoveToActor.GetDestination(Outer),AllowedToDoLeadInLeadOutWalk()), FALSE, nameof(self.MoveToGoalTimedOut), self );

				`AILog(" - Final approach to" @ MoveToActor $ ", using MoveToward()");
				Vect2BP(LastMoveTargetPathLocation, MoveToActor.GetDestination(outer));
				NavigationHandle.SetFinalDestination(MoveToActor.GetDestination(outer));
				MoveToward(MoveToActor, MoveFocus, GetMoveDestinationOffset(),ShouldWalk());
			}
			else
			{
				// if we weren't given a focus, default to looking where we're going
				if (MoveFocus == None)
				{
					SetFocalPoint(IntermediatePoint);
				}

				// setup move timeout timer
				SetTimer( GetMoveTimeOutDuration(IntermediatePoint,AllowedToDoLeadInLeadOutWalk()), FALSE, nameof(self.MoveToGoalTimedOut), self );

				// use a negative offset so we get closer to our points!
				MoveTo(IntermediatePoint, MoveFocus, GetMoveDestinationOffset(),ShouldWalk());
			}
			`AILog("MoveTo Finished -- "@IntermediatePoint);

			if( bReevaluatePath )
			{
				ReEvaluatePath();
			}
		}

		TryToRun2Cover();


		if( HasReachedGoal() )
		{
			Goto( 'CheckMove' );
		}
		// if we are moving towards a moving target, repath every time we successfully reach the next node
		// as that Pawn's movement may cause the best path to change
		else if( MoveToActor != None &&
			VSize(MoveToActor.GetDestination(outer) - BP2Vect(LastMoveTargetPathLocation)) > 512.0 )
		{
			Vect2BP(LastMoveTargetPathLocation, MoveToActor.GetDestination(outer));
			`AILog("Repathing because target moved:" @ MoveToActor);
			Goto('CheckMove');
		}
		else if( !NavigationHandle.GetNextMoveLocation( IntermediatePoint, Outer.IntermediatePointArrivalDist ) )
		{
			`AILog( "Couldn't get next move location" );
			if (!bFinalApproach && ((MoveToActor != None) ? /*NavigationHandle.*/ActorReachable(MoveToActor) : /*NavigationHandle.*/PointReachable(BP2Vect(NavigationHandle.FinalDestination))))
			{
				`AILog("Target is directly reachable; try direct move");
				IntermediatePoint =((MoveToActor != None) ? MoveToActor.GetDestination(outer) : BP2Vect(NavigationHandle.FinalDestination));
				Sleep(RandRange(0.1,0.175));
			}
			else
			{
				Sleep(0.1f);
				`LogPathFailure(MoveToActor,"GetNextMoveLocation returned false, and finaldest is not directly reachable");

				Goto('FailedMove');
			}
		}
		else
		{
			if(VSize(IntermediatePoint-LastMovePoint) < (Pawn.GetCollisionRadius() * 0.1f) )
			{
				NumMovePointFails++;

//				DrawDebugBox(Pawn.Location, vect(2,2,2) * NumMovePointFails, 255, 255, 255, true );
				`LogPathFailure(MoveToActor,"WARNING: Got same move location... something's wrong?!"@`showvar(LastMovePoint)@`showvar(IntermediatePoint)@"Delta"@VSize(LastMovePoint-IntermediatePoint)@"ChkDist"@(Pawn.GetCollisionRadius() * 0.1f));
			}
			else
			{
				NumMovePointFails=0;
			}
			LastMovePoint = IntermediatePoint;

 			if(NumMovePointFails >= MaxMovePointFails && MaxMovePointFails >= 0)
 			{
 				`LogPathFailure(MoveToActor,"ERROR: Got same move location 5x in a row.. something's wrong! bailing from this move");
 				Goto('FailedMove');
 			}
			else
			{
				//debug
				`AILog( "NextMove"@IntermediatePoint@`showvar(NumMovePointFails) );
			}
		}
	}

	//debug
	`AILog( "Reached end of move loop??" );

	Goto( 'CheckMove' );

FailedMove:
	Status = 'Failure';
	HandleFailedPathFind(MoveToActor);
	GotoState('DelayFailure');

ReachedGoal:
	//debug
	`AILog("Reached move point:"@BP2Vect(NavigationHandle.FinalDestination)@VSize(Pawn.Location-BP2Vect(NavigationHandle.FinalDestination)));

	Status = 'Success';
	PopCommand( self );
}

event DrawDebug( HUD H, Name Category )
{
	Super.DrawDebug( H, Category );

	if(Category != 'Pathing')
	{
		return;
	}

	// BLUE
	DrawDebugLine( Pawn.Location, GetDestinationPosition(), 0, 0, 255 );
	// GREEN
	DrawDebugLine( Pawn.Location, BP2Vect(NavigationHandle.FinalDestination), 0, 255, 0 );
	// RED
	DrawDebugLine( Pawn.Location + vect(0,0,10), IntermediatePoint, 255, 0, 0 );

	NavigationHandle.DrawPathCache( vect(0,0,15) );
}


defaultproperties
{
	LastShouldWalkCacheTime=-1
	MaxMovePointFails=5
}
