/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_Berserker_ImulsionTrail extends GearDamageType;


static function bool ShouldIgnoreExecutionRules( Pawn TestPawn, Pawn Instigator )
{
	return TRUE;
}

defaultproperties
{
	bSuppressImpactFX=true
}
