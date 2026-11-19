/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_Wretch_Pounce extends AICommand_SpecialMove
	within GearAI;

/** GoW global macros */

function LockdownAI()
{
	//debug
	`AILog( GetFuncName() );

	bReachedCover			= FALSE;
	bPreparingMove			= TRUE;	// Don't move until move done

	if( MyGearPawn != None )
	{
		// Force pawn rotation dest to ours and kill movement
		Pawn.LockDesiredRotation(TRUE);
		Pawn.ZeroMovementVariables();
	}
}

function Pushed()
{
	Super.Pushed();

	InvalidateCover();
	SetDesiredRotation(Rotator(Enemy.Location - Pawn.Location), TRUE);
	bWantsLedgeCheck = TRUE;
	LockdownAI();
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
	UnlockAI();
}

state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return GSM_PounceAttack;
	}

	function bool ShouldFinishRotation() { return TRUE; }
}

defaultproperties
{
}