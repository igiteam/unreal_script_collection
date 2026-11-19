/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_MomCorpser_Stomp extends AICommand_SpecialMove
	within GearAI_MomCorpser;


/** Overloaded to go to the special move state */
function Pushed()
{
	Super.Pushed();
	bWantsLedgeCheck = TRUE;
	Corpser.SetDesiredRotation( Rotator(Enemy.Location-Corpser.Location) );
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
		return SM_Corpser_Stomp;
	}

	function float GetPostSpecialMoveSleepTime()
	{
		return 1.5f * FRand();
	}

	function bool ShouldFinishRotation() { return TRUE; }
}

defaultproperties
{
}