/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_PawnToPawnInteractionFollower extends AICommand
	within TGAI;

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
	//bForceDesiredRotation = TRUE;	// Fix pawn rotation and set the rotation

	if( MyTGPawn != None )
	{
		// Force pawn rotation dest to ours
		//MyTGPawn.DesiredRotation = DesiredRotation;
		MyTGPawn.SetDesiredRotation(MyTGPawn.DesiredRotation);

		// Kill movement
		Pawn.ZeroMovementVariables();

		MyTGPawn.StopMeleeAttack();
	}

	ReactionManager.SuppressChannel('Damage');
	bIgnoreStepAside=true;
}

function Popped()
{
	Super.Popped();

	// Turn off flags
	bPreparingMove			= FALSE;
	//bForceDesiredRotation	= FALSE;
	Pawn.ResetDesiredRotation();

	ReactionManager.UnSuppressChannel('Damage');
	bIgnoreStepAside=Outer.default.bIgnoreStepAside;
}

auto state WaitForStuff
{
Begin:
	//debug
	;

	Stop;
}
