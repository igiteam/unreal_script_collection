/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Berserker_HODHitReaction extends AICommand_SpecialMove;

function Popped()
{
	Super.Popped();

	CheckCombatTransition();
}

auto state Command_SpecialMove
{
	function ESpecialMove GetSpecialMove()
	{
		return SM_Berserker_HODHitReaction;
	}
}

function bool NotifyHitByVulnerableDamage();
function bool CanSeePawn( Pawn Seen );
event SeePlayer( Pawn Seen );
function bool CanHearPawn( Pawn Heard, float Loudness, Name NoiseType );

DefaultProperties
{
}
