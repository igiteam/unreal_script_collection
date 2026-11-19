/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_React_StumbleFromMelee extends AICommand_SpecialMove
	within GearAI;

function Pushed()
{
	Super.Pushed();

	GotoState('Command_SpecialMove');
}

state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		// Pick one of the 2 variations.
		// humans only use type 2, so mirror that for bots
		if (GearAI_TDM(Outer) == None && FRand() < 0.5f)
		{
			return SM_StumbleFromMelee;
		}
		else
		{
			return SM_StumbleFromMelee2;
		}
	}

	function float GetPostSpecialMoveSleepTime()
	{
		return 0.25f;
	}
}

defaultproperties
{
	bShouldCheckSpecialMove=true
}
