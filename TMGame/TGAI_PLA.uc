/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class TGAI_PLA extends TGAI_COGGear;

/** GoW global macros */


var name PendingState;

state Action_Idle
{
Begin:
	if (MyTGPawn.hod != none)
	{
		if (MyTGPawn.hod.PendingState != '')
		{
			PendingState = MyTGPawn.hod.PendingState;
			MyTGPawn.hod.PendingState = '';
			MyTGPawn.hod.goto_state(PendingState);
		}
		else
			MyTGPawn.hod.goto_state('Cover');
	}
	else
		Sleep(0.05);
	goto('Begin');
}

