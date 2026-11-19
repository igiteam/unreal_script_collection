/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Move_ClimbLadder extends AICommand_SpecialMove
	within GearAI;
	
/** GoW global macros */

/** Start and End Markers */
var Trigger_LadderInteraction	Ladder;

var Vector EntryLoc;
var Rotator EntryRot;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool ClimbLadder( GearAI AI, Trigger_LadderInteraction NewLadder)
{
	local AICmd_Move_ClimbLadder Cmd;

	if( AI != None && NewLadder != None )
	{
		Cmd = new(AI) class'AICmd_Move_ClimbLadder';
		if( Cmd != None )
		{
			Cmd.Ladder = NewLadder;
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@`showvar(Ladder);
}

function Pushed()
{
	Super.Pushed();

	AIOwner.MyGearPawn.LadderTrigger = Ladder;
	if( Ladder.IsTopOfLadder() )
	{
		Ladder.GetTopEntryPoint( EntryLoc, EntryRot );
	}
	else
	{
		Ladder.GetBottomEntryPoint( EntryLoc, EntryRot );
	}

	if( !NavigationHandle.ComputeValidFinalDestination( EntryLoc ) )
	{
		`AILog( "FAILED TO FIND VALID ladder entry location" );

		Status = 'Failure';
		PopCommand( self );
	}

	GotoState( 'MoveToLadder' );
}

state MoveToLadder
{
Begin:
	//debug
	`AILog( "--"@GetStateName()$":"$class@"-- BEGIN TAG", 'State' );

	while( !Pawn.ReachedPoint( EntryLoc, None ) )
	{
		`AILog( "Moving to EntryLoc" );

		SetMovePoint( EntryLoc );

		Sleep( 0.1f );
	}
	
	GotoState( 'Command_SpecialMove' );
}

state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		if( Ladder.IsTopOfLadder() )
		{
			return SM_LadderClimbDown;
		}
		else
		{
			return SM_LadderClimbUp;
		}
	}

	function bool IsReady()
	{
		// Wait for ladder user to get off
		if( !bForceReady && !MyGearPawn.CanDoSpecialMove(GetSpecialMove()) )
		{
			return FALSE;
		}

		return Super.IsReady();
	}
}

defaultproperties
{
	bIgnoreStepAside=FALSE
}
