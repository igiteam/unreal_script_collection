/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_React_StumbleFromMantleKick extends AICommand_SpecialMove
	within GearAI;

var GearPawn KickedBy;

static function bool Stumble(GearAI AI, GearPawn InKickedBy)
{
	local AICmd_React_StumbleFromMantleKick Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_React_StumbleFromMantleKick';
		if( Cmd != None )
		{
			Cmd.KickedBy = InKickedBy;
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();

	GotoState('Command_SpecialMove');
}

state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return SM_StumbleFromMantleKick;
	}

	function GearPawn GetInteractionPawn()
	{
		return KickedBy;
	}

	function float GetPostSpecialMoveSleepTime()
	{
		return 0.25f;
	}

	function INT		GetSpecialMoveFlags(ESpecialMove InSpecialMove)
	{
		// if I am in the cover, 0, otherwise, 1
		if ( MyGearPawn!=none && MyGearPawn.CurrentLink!=none && MyGearPawn.CoverType != CT_None)
		{
			return 0;
		}

		// it will align actor, otherwise it won't
		return 1;
	}
}
