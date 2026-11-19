/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICommand_SpecialMove extends AICommand
	within GearAI;

/** GoW global macros */

/** Special move this command is monitoring */
var ESpecialMove SpecialMove;
/** Time after special move is complete that command should terminate */
var float		TerminationTime;

/** whether we should check if the special move is valid (CanDoSpecialMove()) */
var bool bShouldCheckSpecialMove;
/** Time in seconds we should wait before considering this special move as timed out **/
var float		TimeOutDelaySeconds;
/** Time we should sleep if the special move fails */
var float       FailureSleepTimeSeconds;

/** Destination special move should end at */
var Vector EndDest;

var bool bForceReady;

function Pushed()
{
	Super.Pushed();

	LockdownAI();
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	LockdownAI();
}

function Paused( GameAICommand NewCommand )
{
	Super.Paused( NewCommand );

	UnlockAI();
}

function Popped()
{
	Super.Popped();

	UnlockAI();
	ClearTimer( nameof(self.SpecialMoveTimeout), self );
}

function LockdownAI()
{
	//debug
	`AILog( GetFuncName() );

	bReachedCover			= FALSE;
	bPreparingMove			= TRUE;	// Don't move until move done
	bUseFlockingMovement    = FALSE;

	if( MyGearPawn != None )
	{
		// Force pawn rotation dest to ours and kill movement
		MyGearPawn.ZeroMovementVariables();

		MyGearPawn.StopMeleeAttack();
	}
}

function UnlockAI()
{
	//debug
	`AILog( GetFuncName() );

	// Turn off flags
	bPreparingMove			= FALSE;
	bPreciseDestination		= FALSE;
	bUseFlockingMovement    = Outer.default.bUseFlockingMovement;
	if (Pawn!=none)
	{
		Pawn.LockDesiredRotation(FALSE);
	}

	bReachedCover			= FALSE;
}

// Stub function
function SpecialMoveTimeout();

function float GetFailSafeReadyTime()
{
	return 5.f;
}
function FailSafeReadyTriggered()
{
	//debug
	`AILog( "FAILSAFE TRIGGERED for special move action" );

	bForceReady = TRUE;
}


state Command_SpecialMove `DEBUGSTATE
{
	function BeginState( Name PreviousStateName )
	{
	}

	function bool AllowPushOfDefaultCommandForSpecialMove(ESpecialMove SM)
	{
		// if we're handling this special move, then NO!
		return (SM != GetSpecialMove());
	}

	function bool ShouldFinishRotation();
	function bool ShouldFinishPostRotation();

	/** @return the Pawn the special move should interact with (if any) */
	function GearPawn	GetInteractionPawn();
	function INT		GetSpecialMoveFlags(ESpecialMove InSpecialMove);

	function bool ExecuteSpecialMove()
	{
		SpecialMove = GetSpecialMove();

		//debug
		`AILog( GetFuncName()@SpecialMove );

		if( SpecialMove != SM_None &&
			(!bShouldCheckSpecialMove || MyGearPawn.CanDoSpecialMove( SpecialMove )) )
		{
			MyGearPawn.DoSpecialMove(SpecialMove, TRUE, GetInteractionPawn(), GetSpecialMoveFlags(SpecialMove));
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}

	function bool IsSpecialMoveComplete()
	{
		if( !bPreparingMove || MyGearPawn == None || MyGearPawn.SpecialMove == SM_None )
		{
			return TRUE;
		}
		return FALSE;
	}

	function SpecialMoveTimeout()
	{
		//debug
		`AILog( "Special move timed out" );

		if( MyGearPawn.SpecialMove == SpecialMove )
		{
			MyGearPawn.EndSpecialMove();
		}

		Status = 'Failure';
		AbortCommand( self );
	}

	function OnFailedToDoSpecialMove()
	{
		//debug
		`AILog( "Failed to do special move" );
	}

	// Overridden in child states
	function bool SetupSpecialMove() { return TRUE; }
	function FinishedSpecialMove();
	function ESpecialMove GetSpecialMove();
	function float GetPostSpecialMoveSleepTime();
	function float GetPreSpecialMoveSleepTime();
	function bool IsReady() { return TRUE; }
	function bool SetupMoveToEndDest();
	
Begin:
	//debug
	`AILog( "--"@GetStateName()$":"$class@"-- BEGIN TAG", 'State' );

	if( !SetupSpecialMove() )
	{
		//debug
		`AILog( "Setup Special Move failed" );

		Goto( 'Abort' );
	}

	if (ShouldFinishRotation() && !Pawn.ReachedDesiredRotation())
	{
		FinishRotation();
	}

	Sleep(GetPreSpecialMoveSleepTime());

	bForceReady = FALSE;
	SetTimer( GetFailSafeReadyTime(), FALSE, nameof(FailSafeReadyTriggered), self );
	while( !IsReady() && !bForceReady )
	{
		//debug
		`AILog( "Waiting for ready", 'Loop' );

		Sleep(0.1f);
	}
	ClearTimer( nameof(FailSafeReadyTriggered), self );

	if( ExecuteSpecialMove() )
	{
		SetTimer( TimeOutDelaySeconds, FALSE, nameof(self.SpecialMoveTimeOut), self );
		do
		{
			//debug
			`AILog( "Waiting for SM to end", 'Loop' );

			Sleep( 0.1f );
		} until( IsSpecialMoveComplete() );

		//debug
		`AILog( "Special move ended" );

		if( ShouldFinishPostRotation() )
		{
			FinishRotation();
		}

		if( SetupMoveToEndDest() )
		{
			MoveTo( EndDest );
		}

		FinishedSpecialMove();

		TerminationTime = WorldInfo.TimeSeconds + GetPostSpecialMoveSleepTime();
		while( TerminationTime > WorldInfo.TimeSeconds )
		{
			//debug
			`AILog( "Waiting for SM delay to end", 'Loop' );

			Sleep( 0.1f );
		}

		Status = 'Success';
	}
	else
	{
Abort:
		OnFailedToDoSpecialMove();
		Status = 'Failure';
		Sleep(FailureSleepTimeSeconds);
	}

	PopCommand( self );
}

state ChangeMirrorDirection `DEBUGSTATE
{
	function FinishedMirroringChange()
	{
		GotoState('Command_SpecialMove');
	}
Begin:
	//debug
	`AILog( "Updating Mirror Direction"@MyGearPawn.bIsMirrored@"to"@!MyGearPawn.bIsMirrored@"trans?"@IsTransitioning() );

	MyGearPawn.SetMirroredSide( !MyGearPawn.bIsMirrored );
	LastAnimTransitionTime = WorldInfo.TimeSeconds;
	do
	{
		Sleep( 0.1f );
	} until( !IsTransitioning() );

	FinishedMirroringChange();
}

defaultproperties
{
	bAllowedToFireWeapon=FALSE
	bIgnoreStepAside=TRUE
	TimeOutDelaySeconds=10.0f
	FailureSleepTimeSeconds=0.5f
}
