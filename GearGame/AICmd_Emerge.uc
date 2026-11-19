/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class AICmd_Emerge extends AICommand_SpecialMove
	within GearAI;


function Pushed()
{
	Super.Pushed();

	// FORCE pawn into phys none so no falling occurs just before emerge action is done
	// This is what was causing them to sometimes fall back through the emergence hole
	Pawn.SetPhysics( PHYS_None );

	MyGearPawn.bSpawning = TRUE;
	MyGearPawn.LightEnvironment.NumVolumeVisibilitySamples = 6;

	// Force our desired rotation to the pawn's rotation
	// so he doesn't rotate after spawning
	SetDesiredRotation(Pawn.Rotation);
	
	ReactionManager.SuppressAll();
	
	GotoState( 'Command_SpecialMove' );
}

function Popped()
{
	super.Popped();
	ReactionManager.UnSuppressAll();

	`AILog("Finished with emerge");
	if (Pawn != None)
	{
		Pawn.SetMovementPhysics();
		`AILog(GetFuncName()@self@"bSpawning FALSE!");
		MyGearPawn.LightEnvironment.NumVolumeVisibilitySamples = 1;
		MyGearPawn.bSpawning = FALSE;
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
		return EmergeSpecialMove;
	}
}

DefaultProperties
{
	bIgnoreNotifies=true
}