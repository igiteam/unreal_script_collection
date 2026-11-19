/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICommand_Base_Combat extends AICommand
	within GearAI;

/** Amount of time before initial time check */
var vector2d InitialTransitionCheckTime;
/** Amount of time between timed transition checks */
var vector2d TransitionCheckTime;

function Pushed()
{
	Super.Pushed();

	SetTimer(GetInitialTransitionCheckTime(), false, nameof(CheckTimedCombatTransition));
}

function Popped()
{
	Super.Popped();

	ClearTimer('CheckInterruptCombatTransitions');
	ClearTimer('CheckTimedCombatTransition');
	ClearTimer(nameof(CombatSelectTarget), self);
}

final function float GetInitialTransitionCheckTime()
{
	return RandRange(InitialTransitionCheckTime.X, InitialTransitionCheckTime.Y);
}
final function float GetTransitionCheckTime()
{
	return RandRange(TransitionCheckTime.X, TransitionCheckTime.Y);
}

function bool TimedTransitionCheck(out class<AICommand> out_NewCommand, out string out_Reason);
function bool CheckTransition(out class<AICommand> out_NewCommand, out string out_Reason);

/** calls SelectTarget() on a random timer, then resets that timer */
final function CombatSelectTarget()
{
	SetTimer(0.5 + FRand() * 0.75, false, nameof(CombatSelectTarget), self);
	SelectTarget();
}

state InCombat `DEBUGSTATE
{
	function BeginState(name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		// Set target selection timer
		SetTimer(0.5f + FRand() * 0.75, false, nameof(CombatSelectTarget), self);
	}

	function EndState(name NextStateName)
	{
		Super.EndState(NextStateName);

		// Clear target selection timer
		ClearTimer(nameof(CombatSelectTarget), self);
	}
}


defaultproperties
{
	InitialTransitionCheckTime=(X=1.0,Y=1.0)
	TransitionCheckTime=(X=1.0,Y=1.0)
}
