/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class AICmd_Move_JumpFromReaver extends AICommand_SpecialMove
	within GearAI;

/** Initial velocity of the jump */
var transient vector JumpVelocity;
/** Point where we should try to land */
var transient Actor LandingPoint;
/** Reaver we are jumping from */
var transient Vehicle_Reaver_Base Reaver;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool Leap( GearAI AI, vector InJumpVelocity, optional Vehicle_Reaver_Base InReaver, optional Actor InLandingPoint )
{
	local AICmd_Move_JumpFromReaver Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_Move_JumpFromReaver';
		if( Cmd != None )
		{
			Cmd.JumpVelocity = InJumpVelocity;
			Cmd.LandingPoint = InLandingPoint;
			Cmd.Reaver = InReaver;
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();
	GotoState( 'Command_SpecialMove' );
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	// If we reached the target successfully
	if( ChildStatus == 'Success' && Enemy != None )
	{	
		GotoState( 'Command_SpecialMove' );
	}
	else
	{
		// Otherwise, didn't get there so fail the command
		Status = 'Failure';
		PopCommand( self );
	}
}

function Popped()
{
	Super.Popped();

	// Allow normal rotation again
	if( Pawn != None )
	{
		UnlockAI();
	}
}

state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );
		SetDesiredRotation(Rotator(JumpVelocity), TRUE);
		LockdownAI();
	}

	function bool ExecuteSpecialMove()
	{
		local bool RetVal;
		local GSM_JumpFromReaver LeapMove;

		RetVal = Super.ExecuteSpecialMove();

		LeapMove = GSM_JumpFromReaver(MyGearPawn.SpecialMoves[SpecialMove]);
		if( LeapMove != None )
		{
			LeapMove.LandingPoint = LandingPoint;
			LeapMove.Reaver = Reaver;
		}
		else
		{
			MyGearPawn.Velocity = JumpVelocity;
		}
		return RetVal;
	}

	function ESpecialMove GetSpecialMove()
	{
		return SM_JumpFromReaver;
	}
}


defaultproperties
{
}