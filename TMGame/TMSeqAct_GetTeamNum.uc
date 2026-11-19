/**
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */


class TMSeqAct_GetTeamNum extends SequenceAction;

var int TeamNum;

event Activated()
{
	local Actor A;

	if (Targets.length == 0)
	{
		ScriptLog("WARNING: Missing Target for Get Team Number");
	}
	else
	{
		A = Actor(Targets[0]);
	}

	TeamNum = (A != None) ? int(A.GetTeamNum()) : 255;
}

