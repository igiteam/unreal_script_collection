/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NDT_DenseDashGib extends NDT_DenseDash
    abstract;


/** Should the Pawn explode into chunky bits when killed with this damage type? */
static function bool ShouldGib( Pawn TestPawn, Pawn Instigator )
{
	return TRUE;
}


defaultproperties
{	
}