/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GDT_HitByRatTruck extends GDT_Environment;

static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return TRUE;
}

static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation,TraceHitInfo HitInfo)
{
	return FALSE;
}

static function bool IsScriptedDamageType()
{
	return TRUE;
}

defaultproperties
{
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_DeathIcons',U=156,V=90,UL=77,VL=29)

	KDamageImpulse=1000
	RadialDamageImpulse=400.0
	bRadialDamageVelChange=TRUE
	bSuppressImpactFX=TRUE
	bCausedByWorld=false
}


