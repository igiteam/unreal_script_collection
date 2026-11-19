/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_Melee_BabyCorpser extends AICommand_SpecialMove
	within GearAI;


/** Overloaded to go to the special move state */
function Pushed()
{
	Super.Pushed();
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
		return GSM_CorpserLarva_Melee;
	}

	function bool ShouldFinishRotation() { return FALSE; }
}

defaultproperties
{
}