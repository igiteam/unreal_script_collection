/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Berserker_SmashAttack extends AICommand_SpecialMove;

function Popped()
{
	Super.Popped();

	ForceUpdateOfEnemies();
	CheckCombatTransition();
}

auto state Command_SpecialMove
{
	event BeginState(name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		SetDesiredRotation(Rotator(Enemy.Location-Pawn.Location));
	}

	function bool ShouldFinishRotation()
	{
		return true;
	}
	function ESpecialMove GetSpecialMove()
	{
		return SM_Berserker_Smash;
	}
}


DefaultProperties
{
	bIgnoreNotifies=true
}