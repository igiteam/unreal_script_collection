
/**
 * Base class that is pushed by a special move.
 * Put AI in a state so he can be controlled by the Special Move.
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_PushedBySpecialMove extends AICommand_SpecialMove
	within TGAI;
	
static function AICmd_Base_PushedBySpecialMove PushSpecialMoveCommand(TGAI AI)
{
	local AICmd_Base_PushedBySpecialMove Cmd;

	if( AI != None && AI.MyTGPawn != None )
	{
		Cmd = new(AI) default.class;
		if( Cmd != None )
		{
			Cmd.SpecialMove = AI.MyTGPawn.SpecialMove;
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

	;
	GotoState('WaitForMove');
}

function Popped()
{
	ClearTimer( 'SpecialMoveTimeout', self );
	Super.Popped();
}

state WaitForMove 
{
	function bool IsSpecialMoveComplete()
	{
		if( !bPreparingMove || MyTGPawn == None || MyTGPawn.SpecialMove != SpecialMove )
		{
			return TRUE;
		}
		return FALSE;
	}
	
Begin:
	SetTimer( TimeOutDelaySeconds, FALSE, nameof(self.SpecialMoveTimeOut), self );
	do
	{
		Sleep(0.1f);
	} until( IsSpecialMoveComplete() );
	
	;
	Status = 'Success';
	PopCommand( self );
}

