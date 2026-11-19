/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_BumpGDO extends GDT_Melee
	config(Weapon);

static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return false;
}

static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation, TraceHitInfo HitInfo)
{
	return false;
}

defaultproperties
{
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_DeathIcons',U=156,V=60,UL=77,VL=29)
}
