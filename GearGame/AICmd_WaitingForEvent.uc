/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class AICmd_WaitingForEvent extends AICommand
	within GearAI;

/** List of events currently pending receipt */
var Name WaitEvent;

static function bool Wait( GearAI AI, Name InEventName )
{
	local AICmd_WaitingForEvent Cmd;

	if( AI != None )
	{
		Cmd = new(AI) Default.Class;
		if( Cmd != None )
		{
			Cmd.WaitEvent = InEventName;
			AI.PushCommand(Cmd);
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	super.Pushed();
	`AILog("Waiting for event:"@WaitEvent);
	GotoState('Waiting');
}

function bool AllowTransitionTo( class<GameAICommand> AttemptCommand )
{
	return false;
}

function ReceiveEvent(Name InEventName);

state Waiting `DEBUGSTATE
{
	function ReceiveEvent(Name InEventName)
	{
		`AILog("AICmd_WaitingForEvent received event:"@InEventName);
		if( WaitEvent == InEventName )
		{
			`AILog("- no longer waiting on any events",'Misc');
			Status='Success';
			PopCommand(Self);
		}
	}

Begin:
	StopFiring();
	Pawn.ZeroMovementVariables();
};
