/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

/** Used to allow level designers to issue achievements */
class TMSeqAct_UnlockAchievement extends SequenceAction
	dependson(TMPlayerController);

/** The achievement to unlock (should be single/coop players only)*/
var() ETMGameAchievements AchievementId;

event Activated()
{
	local WorldInfo WI;
	local TMPlayerController PC;

	WI = GetWorldInfo();

	if ( WI != none && WI.GRI != none && TMGameReplicationInfo(WI.GRI) != none )
	{
		//Currently unlock the achievement for every player
		foreach WI.AllControllers(class'TMPlayerController', PC)
		{
			PC.UpdateAchievement(AchievementId);
		}
	}
}


