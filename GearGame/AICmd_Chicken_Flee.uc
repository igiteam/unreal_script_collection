/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Chicken_Flee extends AICommand
	within GearAI_Chicken;

static function bool Flee( GearAI_Chicken AI )
{
	local AICmd_Chicken_Flee Cmd;

	if( AI != None )
	{
		Cmd = new(AI) Default.Class;
		if( Cmd != None )
		{
			AI.PushCommand(Cmd);
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();
	GotoState('FleeFromEnemy');
}

state FleeFromEnemy `DEBUGSTATE
{
Begin:
	while( ChickenPawn.bIsPanicked )
	{
		PickFleeMoveLocation();
		if( !bReachedMoveGoal )
		{
			Sleep( 0.1f );
		}
	}

	GotoState('DelaySuccess');
}

defaultproperties
{
	bReplaceActiveSameClassInstance=TRUE
}
