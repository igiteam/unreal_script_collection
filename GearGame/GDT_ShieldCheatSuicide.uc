/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
//@hack: special damagetype for shield/two handed weapon cheat detection so it shows up separately in stats
class GDT_ShieldCheatSuicide extends GDT_Melee
	abstract;

static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return true;
}

defaultproperties
{
}
