/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class DifficultySettings_Casual extends DifficultySettings
	abstract;

static function ApplyDifficultySettings(Controller C)
{
	local TGAI AI;

	Super.ApplyDifficultySettings(C);

	// AI never does head shots in Casual
	AI = TGAI(C);
	if (AI != None)
	{
		AI.bCanHeadShot = false;
	}
}

