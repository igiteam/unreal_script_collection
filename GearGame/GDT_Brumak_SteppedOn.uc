/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_Brumak_SteppedOn extends GDT_Melee;


/** Should the Pawn explode into chunky bits when killed with this damage type? */
static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return true;
}

defaultproperties
{
	ImpactTypeBallisticID=ITB_BrumakSmash
}
