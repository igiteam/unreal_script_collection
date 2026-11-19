/**
  * Cleaver weapon damage type
  *
  * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
  */
class GDT_Cleaver extends GDT_Ballistic;

static function HandleDeathFX(GearPawn DeadPawn)
{
	if (DeadPawn!=none)
	{
		DeadPawn.AddCleaverDamageEffect(300);
	}
}

/** Cleaver should not gib */
static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return FALSE;
}

/** Cleaver should DBNO unless we're over the limit. */
static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation,TraceHitInfo HitInfo)
{
	return FALSE;
}

defaultproperties
{
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_DeathIcons',U=314,V=30,UL=77,VL=29)
}
