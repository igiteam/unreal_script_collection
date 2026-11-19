/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class AICmd_Move_JumpLink extends AICommand_SpecialMove
	within GearAI;

/** Start and End for the leap */
var vector LeapStart;
var vector LeapEnd;

/** Flags to forward to the special move */
var int SpecialMoveFlags;

var JumpLink Link;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool Leap( GearAI AI, JumpLink inLink, vector Start, vector End )
{
	local AICmd_Move_JumpLink Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_Move_JumpLink';
		if( Cmd != None )
		{
			Cmd.LeapStart = Start;
			Cmd.LeapEnd = End;
			Cmd.Link = inLink;

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

		SetDesiredRotation(Rotator(LeapEnd - LeapStart), TRUE);
		LockdownAI();
	}

	function bool ExecuteSpecialMove()
	{
		local bool RetVal;
		local vector JumpVelocity;
		local GSM_Leap LeapMove;

		if( !Link.GetJumpVelocity(MyGearPawn,LeapEnd,JumpVelocity) )
		{
			`AILog("ERROR: Could not get jump velocity from jumplink!");
			return false;
		}

		// Set SpecialMoveFlags. 
		// 0 for leap down, 1 for leap up
		if( LeapEnd.Z > LeapStart.Z )
		{
			SpecialMoveFlags = 1;
		}
		else
		{
			SpecialMoveFlags = 0;
		}

		RetVal = Super.ExecuteSpecialMove();
		LeapMove = GSM_Leap(MyGearPawn.SpecialMoves[SpecialMove]);
		if( LeapMove != None )
		{
			LeapMove.SetJumpVelocity(JumpVelocity);
		}
		else
		{
			MyGearPawn.Velocity = JumpVelocity;
			MyGearPawn.SetPhysics(PHYS_Falling);
		}
		return RetVal;
	}

	function ESpecialMove GetSpecialMove()
	{
		return GSM_Leap;
	}

	function INT GetSpecialMoveFlags(ESpecialMove InSpecialMove)
	{
		if( InSpecialMove == GSM_Leap )
		{
			return SpecialMoveFlags;
		}
		return Super.GetSpecialMoveFlags(InSpecialMove);
	}

	function bool ShouldFinishRotation() { return TRUE; }
	function bool ShouldFinishPostRotation() { return TRUE; }
}


defaultproperties
{
}