/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_KantusKnockDownScream extends AICommand_SpecialMove
	within GearAI_Kantus;

/** GoW global macros */

function Pushed()
{
	Super.Pushed();

	InvalidateCover();

	if (Enemy != None)
	{
		// Turn towards the enemy, had to get hardcore on protecting this rotation
		Pawn.LockDesiredRotation(FALSE);
		SetDesiredRotation(Rotator(Enemy.Location - Pawn.Location), TRUE, FALSE);
	}

	bWantsLedgeCheck = TRUE;
	ReactionManager.SuppressAllChannels();

	if (GearPawn_LocustKantusArmorBase(Pawn) != None)
	{
		ReactionManager.UnSuppressChannel('Damage');
		ReactionManager.UnSuppressChannel('StumbleScream');
	}

	if (!GearPawn_LocustKantusBase(Pawn).CanDoKnockdown())
	{
		GotoState('DelayFailure');
	}
	else
	{
		GotoState( 'Command_SpecialMove' );
	}
}

function Popped()
{
	Super.Popped();
	bWantsLedgeCheck = FALSE;
	ReactionManager.UnSuppressAllChannels();

	// Allow normal rotation again
	if (Pawn!=none)
	{
		Pawn.LockDesiredRotation(FALSE);
	}
}

state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return GSM_Kantus_KnockDownScream;
	}

	function bool ShouldFinishRotation() { return TRUE; }
}

defaultproperties
{
	bShouldCheckSpecialMove=true
}
