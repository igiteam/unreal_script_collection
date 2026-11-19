/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_DrudgeExecute extends GDT_Melee
	abstract;

static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return TRUE;
}

static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation, TraceHitInfo HitInfo)
{
	return FALSE;
}

defaultproperties
{
	KDamageImpulse=0
	KDeathUpKick=0
}
