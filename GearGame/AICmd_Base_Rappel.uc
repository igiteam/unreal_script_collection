/**
 * AI command to run to a rappel point and then go into the special move
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AICmd_Base_Rappel extends AICommand_Base_Combat
	within GearAI_Cover;

/**
 * Disallow clearing the AI command
 *
 * @return FALSE if we're attempting to clear the AI command
 */
function bool AllowTransitionTo(class<GameAICommand> AttemptCommand)
{
	if( AttemptCommand == None )
	{
		return FALSE;
	}
	return Super.AllowTransitionTo( AttemptCommand );
}

/** Start the combat state and suppress reactions */
function Pushed()
{
	Super.Pushed();
	ReactionManager.SuppressAllChannels();
	GotoState( 'InCombat' );
}

/** Unsuppress the reactions */
function Popped()
{
	Super.Popped();
	ReactionManager.UnSuppressAllChannels();
}

state InCombat
{
	/** Leave cover */
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		InvalidateCover();
	}

Begin:

	while (!Pawn.ReachedPoint(MyGearPawn.CurrentGrapplingStartPoint, None))
	{
		`AILog( "Moving to GrappleStartPoint" );

		SetMovePoint(MyGearPawn.CurrentGrapplingStartPoint);

		// added to avoid infinite recursion
		Sleep(0.1f);
	}
	
	MyGearPawn.ServerDoSpecialMove(SM_Rappel, TRUE);
	
	// At the grapple point, pop this command off the stack
	PopCommand(Self);
}