/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSeqCond_DoTutorial extends SequenceCondition;

event Activated()
{
	local bool bTutorialOK;
	local WorldInfo WI;

	WI = GetWorldInfo();

	bTutorialOK = false;
	if ( WI != none && WI.GRI != none && TMGameReplicationInfo(WI.GRI) != none )
	{

		// If we are in story mode the tutorial is ok.

		bTutorialOK = TMGameReplicationInfo(WI.GRI).bStoryMode;

		if (WI.Game.NumPlayers + WI.Game.NumTravellingPlayers > 1)
		{
			bTutorialOK = false;
		}
	}


	OutputLinks[ bTutorialOK ? 0 : 1].bHasImpulse = true;
}



