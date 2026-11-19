/**
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/

class AICmd_Pause extends AICommand
	within TGAI;

var() float Delay;

static function bool Pause( TGAI AI, float InDelay )
{
	local AICmd_Pause Cmd;

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
	;
	GotoState('Wait');
}


state Wait 
{
Begin:
	Sleep(Delay);
	GotoState('DelaySuccess');
};


