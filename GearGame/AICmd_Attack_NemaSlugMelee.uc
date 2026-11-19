/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_NemaSlugMelee extends AICommand_SpecialMove
	within GearAI;

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
	// Allow normal rotation again
	if (Pawn!=none)
	{
		Pawn.LockDesiredRotation(FALSE);
	}
}

state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		SetDesiredRotation( Rotator(Enemy.Location - Pawn.Location) );
	}

	function ESpecialMove GetSpecialMove()
	{
		return GSM_SwipeAttack;
	}

	function bool ShouldFinishRotation() { return TRUE; }
}

defaultproperties
{
}