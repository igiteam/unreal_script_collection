/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Attack_Drudge_Explode extends AICommand_Base_Combat
	within GearAI_LambentDrone;

function bool CheckTransition( out class<AICommand> out_NewCommand, out String out_Reason )
{
	return FALSE;
}

function Pushed()
{
	Super.Pushed();

	SetDesiredRotation(Rotator(Enemy.Location - Pawn.Location));
	bWantsLedgeCheck = false;
	GotoState( 'WaitForDeath' );
}

function Popped()
{
	local GearPawn_LambentDroneBase DrudgePawn;

	super.Popped();

	DrudgePawn = GearPawn_LambentDroneBase(MyGearPawn);

	// Death explosion failsafe
	if( DrudgePawn != None && !DrudgePawn.bPlayedExplosion )
	{
		DrudgePawn.Explode();
	}
}

function bool AllowTransitionTo(class<GameAICommand> AttemptCommand )
{
	return FALSE;
}
function bool ShouldIgnoreTimeTransitions()
{
	return TRUE;
}

state WaitForDeath
{
Begin:
	bReachedCover			= FALSE;
	bPreparingMove			= TRUE;	// Don't move until move done
	if (Pawn!=none)
	{
		Pawn.LockDesiredRotation(FALSE);
	}

	`AILog("Starting explosion - calling doexplosion");
	// If we aren't already dying, do a suicide explosion
	if( MyGearPawn.Health > 0 )
	{
		DoSuicideExplosion();
	}
	// failsafe timer
	Sleep(5.0);
	`AILog("Waited 5 seconds, and no explosion! tripping failsafe explosion");
	AbortCommand(self);
}

defaultproperties
{
	bIgnoreNotifies=true
}
