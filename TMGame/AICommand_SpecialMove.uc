class AICommand_SpecialMove extends AICommand
	within TGAI;

/** GoW global macros */

/** Special move this command is monitoring */
var ESpecialMove SpecialMove;
/** Time after special move is complete that command should terminate */
var float		 TerminationTime;

/** whether we should check if the special move is valid (CanDoSpecialMove()) */
var bool bShouldCheckSpecialMove;
/** Should update Pawn's anchor when starting a special move */
var bool		 bUpdateStartAnchor;
/** Should update Pawn's anchor when popping after a successful special move */
var bool		 bUpdateAnchorOnSuccess;
/** Time in seconds we should wait before considering this special move as timed out **/
var float		 TimeOutDelaySeconds;

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
	local int Idx;
	local NavigationPoint NewAnchor;

	Super.Popped();

	UnlockAI();
	ClearTimer( 'SpecialMoveTimeout', self );

	if( bUpdateAnchorOnSuccess )
	{
		// If successful
		if( Status == 'Success' )
		{
			NewAnchor = GetUpdatedAnchor();
			if( NewAnchor != None )
			{
				// Update pawn's anchor
				Pawn.SetAnchor( NewAnchor );

				// Remove anything in the route cache up to our new movetarget
				Idx = RouteCache.Find( NewAnchor );
				if( Idx != INDEX_NONE )
				{
					RouteCache_RemoveIndex( 0, Idx + 1 );
				}
			}
		}
	}
}

function NavigationPoint GetStartAnchor()
{
	return None;
}

function NavigationPoint GetUpdatedAnchor()
{
	return None;
}

function LockdownAI()
{
	//debug
	;

	bReachedCover			= FALSE;
	bPreparingMove			= TRUE;	// Don't move until move done
	//bForceDesiredRotation	= TRUE;	// Fix pawn rotation and set the rotation

	if( MyTGPawn != None )
	{
		// Force pawn rotation dest to ours and kill movement
		//MyTGPawn.SetDesiredRotation(DesiredRotation);
		Pawn.ZeroMovementVariables();

		MyTGPawn.StopMeleeAttack();
	}
}

function UnlockAI()
{
	//debug
	;

	// Turn off flags
	bPreparingMove			= FALSE;
	bPreciseDestination		= FALSE;
	//bForceDesiredRotation	= FALSE;
	bReachedCover			= FALSE;
}

// Stub function
function SpecialMoveTimeout();



state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		if( bUpdateStartAnchor )
		{
			Pawn.SetAnchor( GetStartAnchor() );
		}
	}

	function bool AllowPushOfDefaultCommandForSpecialMove(ESpecialMove SM)
	{
		// if we're handling this special move, then NO!
		if(SM == GetSpecialMove())
		{
			return FALSE;
		}

		return Super.AllowPushOfDefaultCommandForSpecialMove(SM);
	}

	function bool ShouldFinishRotation();
	function bool ShouldFinishPostRotation();

	/** @return the Pawn the special move should interact with (if any) */
	function TGPawn	GetInteractionPawn();
	function INT		GetSpecialMoveFlags(ESpecialMove InSpecialMove);

	function bool ExecuteSpecialMove()
	{
		SpecialMove = GetSpecialMove();

		//debug
		;

		if( SpecialMove != SM_None &&
			(!bShouldCheckSpecialMove || MyTGPawn.CanDoSpecialMove( SpecialMove )) )
		{
			MyTGPawn.DoSpecialMove(SpecialMove, TRUE, GetInteractionPawn(), GetSpecialMoveFlags(SpecialMove));
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}

	function bool IsSpecialMoveComplete()
	{
		if( !bPreparingMove || MyTGPawn == None || MyTGPawn.SpecialMove == SM_None )
		{
			return TRUE;
		}
		return FALSE;
	}

	function SpecialMoveTimeout()
	{
		//debug
		;

		if( MyTGPawn.SpecialMove == SpecialMove )
		{
			MyTGPawn.EndSpecialMove();
		}

		Status = 'Failure';
		AbortCommand( self );
	}

	// Overridden in child states
	function bool SetupSpecialMove() { return TRUE; }
	function FinishedSpecialMove();
	function ESpecialMove GetSpecialMove();
	function float GetPostSpecialMoveSleepTime();
	function bool IsReady() { return TRUE; }

Begin:
	//debug
	;

	if( !SetupSpecialMove() )
	{
		//debug
		;

		Goto( 'Abort' );
	}

	if (ShouldFinishRotation() && !Pawn.ReachedDesiredRotation())
	{
		FinishRotation();
	}

	while( !IsReady() )
	{
		//debug
		;

		Sleep(0.1f);
	}

	if( ExecuteSpecialMove() )
	{
		SetTimer( TimeOutDelaySeconds, FALSE, nameof(self.SpecialMoveTimeOut), self );
		do
		{
			//debug
			;

			Sleep( 0.1f );
		} until( IsSpecialMoveComplete() );

		//debug
		;

		if( ShouldFinishPostRotation() )
		{
			FinishRotation();
		}

		FinishedSpecialMove();

		TerminationTime = WorldInfo.TimeSeconds + GetPostSpecialMoveSleepTime();
		while( TerminationTime > WorldInfo.TimeSeconds )
		{
			//debug
			;

			Sleep( 0.1f );
		}

		Status = 'Success';
	}
	else
	{
Abort:
		//debug
		;

		Status = 'Failure';
		Sleep(0.5f);
	}

	PopCommand( self );
}

state ChangeMirrorDirection 
{
	function FinishedMirroringChange()
	{
		GotoState('Command_SpecialMove');
	}
Begin:
	//debug
	;

	MyTGPawn.SetMirroredSide( !MyTGPawn.bIsMirrored );
	LastAnimTransitionTime = WorldInfo.TimeSeconds;
	do
	{
		Sleep( 0.1f );
	} until( !IsTransitioning() );

	FinishedMirroringChange();
}

