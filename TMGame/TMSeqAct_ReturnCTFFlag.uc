/**
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */


class TMSeqAct_ReturnCTFFlag extends SequenceAction;

/** the team whose flag should be returned */
var() int TeamIndex;

event Activated()
{
	local TMCarriedObject Flag;
	local TMCTFGame Game;

	if (TeamIndex < ArrayCount(Game.Teams))
	{
		Game = TMCTFGame(GetWorldInfo().Game);
		Flag = Game.Teams[TeamIndex].TeamFlag;
		if (Flag != None)
		{
			Flag.KismetSendHome();
		}
	}
}

