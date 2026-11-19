/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_PawnToPawnInteractionFollower extends AICommand
	within GearAI;

/** GoW global macros */

/**
* Base state for Follower.
* Designed so the Special Move can take over the Pawn completely.
*/
function Pushed()
{
	Super.Pushed();

	ClearTimer('SpecialMoveTimeout');

	bReachedCover = FALSE;
	bPreparingMove = TRUE;			// Don't move until move done

	if( MyGearPawn != None )
	{

		// Kill movement
		Pawn.ZeroMovementVariables();

		MyGearPawn.StopMeleeAttack();
	}

	ReactionManager.SuppressChannel('Damage');
	bIgnoreStepAside=true;
}

function Popped()
{
	Super.Popped();

	// Turn off flags
	bPreparingMove			= FALSE;
	if (Pawn!=none)
	{
		Pawn.LockDesiredRotation(FALSE);
	}

	ReactionManager.UnSuppressChannel('Damage');
	bIgnoreStepAside=Outer.default.bIgnoreStepAside;
}

auto state WaitForStuff
{
Begin:
	//debug
	`AILog( "BEGIN TAG" @ GetStateName(), 'State' );

	Stop;
}