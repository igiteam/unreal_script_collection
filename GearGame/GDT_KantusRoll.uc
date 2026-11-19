
/**
 * Damage type for Armored Kantus roll
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GDT_KantusRoll extends GDT_Melee;

/**
 * Gib anything the AK rolls into - Only in BEAST mode.
 * 
 * @param TestPawn - the pawn possibly gibbed by this
 * @param Instigator - the pawn causing this damage
 * @return TRUE to gib the pawn
 */
static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return ClassIsChildOf(TestPawn.WorldInfo.GRI.GameClass, class'GearGameSiege_Base');
}

defaultproperties
{
	GibExplodeSound=SoundCue'Locust_Kantus_Efforts.Armored_Body.AKantus_Body_RollGib_Cue'
	GibImpactSoundDelay=0.4
}