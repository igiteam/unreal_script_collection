/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Move_Prowl extends AICommand_SpecialMove
	within GearAI;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool Prowl( GearAI AI )
{
	local AICmd_Move_Prowl Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_Move_Prowl';
		if( Cmd != None )
		{
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

	bReevaluatePath = TRUE;

	// Allow normal rotation again
	if( Pawn != None )
	{
		UnlockAI();
	}
}

state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return GSM_Former_Prowl;
	}

	function bool ShouldFinishRotation() { return TRUE; }
	function bool ShouldFinishPostRotation() { return TRUE; }

	function INT  GetSpecialMoveFlags(ESpecialMove InSpecialMove)
	{
		// Return the flags generated when CanDoSpecialMove was called for the prowl special move
		// Stores number of crawl loops to play
		return MyGearPawn.SpecialMoveFlags;
	}
}

defaultproperties
{
}
