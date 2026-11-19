/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_RoadieRunComet extends GDT_Fire
	abstract;

static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return true;
}

static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation, TraceHitInfo HitInfo)
{
	return false;
}

defaultproperties
{
	bEnvironmentalDamage=false
}
