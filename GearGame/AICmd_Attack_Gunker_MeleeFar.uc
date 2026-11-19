/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_Gunker_MeleeFar extends AICommand_SpecialMove
	within GearAI;

/** Overloaded to go to the special move state */
function Pushed()
{
	Super.Pushed();
	InvalidateCover();
	// Do not have him rotate during this SM - 
	// It will play animation that will slide if start rotating	
	// Instead of rotating here, it will make sure it's facing 
	// to target before coming in
	if (Pawn != None)
	{
		Pawn.LockDesiredRotation(TRUE);
	}

	bWantsLedgeCheck = TRUE;
	GotoState( 'Command_SpecialMove' );
}

function Popped()
{
	Super.Popped();
	bWantsLedgeCheck = FALSE;
	// Allow normal rotation again
	if (Pawn != None)
	{
		Pawn.LockDesiredRotation(FALSE);
	}
}

state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return GSM_Gunker_MeleeFar;
	}

	function bool ShouldFinishRotation() { return FALSE; }
}

defaultproperties
{
}