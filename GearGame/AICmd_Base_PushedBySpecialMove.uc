
/**
 * Base class that is pushed by a special move.
 * Put AI in a state so he can be controlled by the Special Move.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_PushedBySpecialMove extends AICommand_SpecialMove
	within GearAI;

static function AICmd_Base_PushedBySpecialMove PushSpecialMoveCommand(GearAI AI)
{
	local AICmd_Base_PushedBySpecialMove Cmd;

	if( AI != None && AI.MyGearPawn != None )
	{
		Cmd = new(AI) default.class;
		if( Cmd != None )
		{
			Cmd.SpecialMove = AI.MyGearPawn.SpecialMove;
			Cmd.TimeOutDelaySeconds = AI.MyGearPawn.SpecialMoves[AI.MyGearPawn.SpecialMove].AITimeout;
			AI.PushCommand(Cmd);
			return Cmd;
		}
	}

	return None;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@"SpecialMove"@SpecialMove;
}

/** Disable transitions */
function bool AllowTransitionTo(class<GameAICommand> AttemptCommand )
{
      return FALSE;
}

function Pushed()
{
	Super.Pushed();

	`AIlog("Waiting for SM"@SpecialMove@"to finish.");
	GotoState('WaitForMove');
}

state WaitForMove `DEBUGSTATE
{
	function bool IsSpecialMoveComplete()
	{
		if( !bPreparingMove || MyGearPawn == None || MyGearPawn.SpecialMove != SpecialMove )
		{
			return TRUE;
		}
		return FALSE;
	}

	function SpecialMoveTimeout()
	{
		//debug
		`AILog( "Special move timed out" );

		if (MyGearPawn.SpecialMove == SpecialMove)
		{
			MyGearPawn.EndSpecialMove();
		}

		Status = 'Failure';
		AbortCommand(self);
	}

Begin:
	SetTimer(TimeOutDelaySeconds, FALSE, nameof(SpecialMoveTimeOut), self);
	do
	{
		Sleep(0.1f);
	} until( IsSpecialMoveComplete() );

	`AILog("bPreparingMove:" @ bPreparingMove @ "MyGearPawn:" @ MyGearPawn @ "SpecialMove:" @ MyGearPawn.SpecialMove @ SpecialMove);
	Status = 'Success';
	PopCommand( self );
}

defaultproperties
{
	bAllowNewSameClassInstance=FALSE
	bIgnoreNotifies=true
}
