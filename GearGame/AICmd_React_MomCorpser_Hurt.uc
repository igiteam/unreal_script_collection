/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_React_MomCorpser_Hurt extends AICommand_SpecialMove
	within GearAI_MomCorpser;


/** Overloaded to go to the special move state */
function Pushed()
{
	Super.Pushed();
	Corpser.StopStabAttack();
	bWantsLedgeCheck = TRUE;
	GotoState( 'Command_SpecialMove' );
}

function Popped()
{
	Super.Popped();
	bWantsLedgeCheck = FALSE;
}

state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return SM_Corpser_Hurt;
	}

	function bool ShouldFinishRotation() { return FALSE; }
}

defaultproperties
{
}