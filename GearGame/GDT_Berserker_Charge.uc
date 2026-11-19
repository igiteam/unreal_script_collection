/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_Berserker_Charge extends GearDamageType;


static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return true;
}

/** Should the Pawn transition to DBNO when killed with this damage type? */
static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation,TraceHitInfo HitInfo)
{
	return (!Instigator.IsHumanControlled());
}

defaultproperties
{
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=69,V=349,UL=77,VL=29)
}
