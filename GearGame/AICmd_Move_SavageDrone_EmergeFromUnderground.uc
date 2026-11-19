/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Move_SavageDrone_EmergeFromUnderground extends AICommand_SpecialMove
	within GearAI_SavageDrone;

function Pushed()
{
	Super.Pushed();

	// FORCE pawn into phys none so no falling occurs just before emerge action is done
	// This is what was causing them to sometimes fall back through the emergence hole
	Pawn.SetPhysics( PHYS_None );

	// Force our desired rotation to the pawn's rotation
	// so he doesn't rotate after spawning
	SetDesiredRotation(Pawn.Rotation);

	ReactionManager.SuppressAll();
	LockdownAI();

	GotoState( 'Command_SpecialMove' );
}

function Popped()
{
	super.Popped();
	ReactionManager.UnSuppressAll();
	UnlockAI();

	`AILog("Finished with emerge");
	if (Pawn != None)
	{
		Pawn.SetMovementPhysics();
	}
}

function bool AllowTransitionTo( class<GameAICommand> AttemptCommand )
{
	return false;
}

state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return GSM_SavageDrone_EmergeFromUnderground;
	}
}


defaultproperties
{
	bAllowedToFireWeapon=false
}