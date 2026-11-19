/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_Silverback_SuperCurbStomp extends GDT_Melee;

/**
 * Gib the victim
 * 
 * @param TestPawn - the pawn that might gib
 * 
 * @param Instigator - the death instigator
 * 
 * @return TRUE to always gib
 */
static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return TRUE;
}

/**
 * Play a nice gib sound and particle
 * 
 * @param DeadPawn - the pawn that died
 */
static function HandleDeathFX(GearPawn DeadPawn)
{
	local GearPawn_SilverbackBase Silverback;

	DeadPawn.PlaySound(SoundCue'Weapon_Elephant.Sounds.ElephantGun_BodyGib_Cue');
	Silverback = GearPawn_SilverbackBase(DeadPawn.KilledByPawn);
	if (Silverback != None)
	{
		Silverback.PlayStompKillFX();
	}
}

defaultproperties
{
}
