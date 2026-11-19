/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Ticker_Execute extends AICmd_Execute
	within GearAI;

/** Simple constructor that pushes a new instance of the command for the AI */
static function bool Execute( GearAI AI, GearPawn NewExecuteTarget )
{
	local AICmd_Execute OtherCmd, Cmd;

	if( AI != None &&
		NewExecuteTarget != None &&
		AI.CanExecutePawn( NewExecuteTarget ) )
	{
		OtherCmd = AI.FindCommandOfClass(class'AICmd_Execute');
		if (OtherCmd == None || OtherCmd.ExecuteTarget != NewExecuteTarget)
		{
			Cmd = new(AI) class'AICmd_Ticker_Execute';
			if( Cmd != None )
			{
			    Cmd.ExecuteTarget = NewExecuteTarget;
			    AI.PushCommand(Cmd);
			    return TRUE;
			}
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();
	ReactionManager.SuppressAll();
}

function Popped()
{
	Super.Popped();
	ReactionManager.UnSuppressAll();
}
