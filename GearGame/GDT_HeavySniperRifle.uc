/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_HeavySniperRifle extends GDT_Ballistic;

static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	// we're going to just destroy the Pawn with a special effect, so no gib
	return false;
}

static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation,TraceHitInfo HitInfo)
{
	return false;
}

static function HandleDeathFX(GearPawn DeadPawn)
{
	if (DeadPawn.WorldInfo.GRI.ShouldShowGore())
	{
		DeadPawn.BreakPart();
	}
}

defaultproperties
{
	MeatshieldProtecionScale=0.f
	KDamageImpulse=300
	KDeathUpKick=200
	ImpactTypeBallisticID=ITB_HeavySniperRifle
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_DeathIcons',U=392,V=30,UL=77,VL=29)
	WeaponID=WC_HeavySniperRifle

	bSuppressBloodDecals = TRUE
	bPlayDamagedEnemyHeavyGUD=FALSE
}
