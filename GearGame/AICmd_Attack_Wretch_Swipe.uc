/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_Wretch_Swipe extends AICommand_SpecialMove
	within GearAI;

/** GoW global macros */

function Pushed()
{
	Super.Pushed();

	GotoState( 'Command_SpecialMove' );
}

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

state Command_SpecialMove
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		SetDesiredRotation(Rotator(Enemy.Location - Pawn.Location), TRUE);

		LockdownAI();

	}

	function ESpecialMove GetSpecialMove()
	{
		return GSM_SwipeAttack;
	}

	function bool ShouldFinishRotation() { return TRUE; }

	function FinishedSpecialMove()
	{
		UnlockAI();
	}
}

defaultproperties
{
}