/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Tempest_Hover extends AICommand_SpecialMove;

function Popped()
{
	Super.Popped();

	ForceUpdateOfEnemies();
	CheckCombatTransition();
}

auto state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return SM_Tempest_Hover;
	}
}

DefaultProperties
{
	bIgnoreNotifies=true
}