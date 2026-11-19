/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAICmd_Pause extends NanoAICmd within NanoAI;

var() float Delay;

static function bool Pause( NanoAI AI, float InDelay )
{
	local NanoAICmd_Pause Cmd;

	if( AI != None )
	{
		Cmd = new(AI) Default.Class;
		if( Cmd != None )
		{
			Cmd.Delay = InDelay;
			AI.PushCommand(Cmd);
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	super.Pushed();
	`AILog("Pausing for "$Delay$" second(s).");
	GotoState('Wait');
}


state Wait `DEBUGSTATE
{
Begin:
	Sleep(Delay);
	GotoState('DelaySuccess');
};


defaultproperties
{
	Delay=10.0f
}