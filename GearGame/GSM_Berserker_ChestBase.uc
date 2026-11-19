
/**
 * GSM_Berserker_Chest
 * Hit reaction when berserker takes too much damage and covers her chest
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Berserker_ChestBase extends GearSpecialMove
	DependsOn(AnimSequence)
	native(SpecialMoves);




/** Overloaded to cache the pawn */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

}

defaultproperties
{
}
