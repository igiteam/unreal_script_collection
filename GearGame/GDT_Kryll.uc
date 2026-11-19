/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_Kryll extends GearDamageType;

/** 
 * Kryll gib the player
 * 
 * @param TestPawn - the pawn to potentially gib
 * 
 * @param Instigator - the damage causer
 * 
 * @return TRUE to cause gibbing
 */
static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return TRUE;
}

/**
 * Kryll should only kill, no dbno
 * 
 * @param TestPawn - the pawn to test
 * 
 * @param Instigator - the pawn that instigated the damage
 * 
 * @param HitLocation - the location of the damage
 * 
 * @param HitInfo - misc information about the damage
 * 
 * @return FALSE to never go DBNO
 */
static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation, TraceHitInfo HitInfo)
{
	return FALSE;
}