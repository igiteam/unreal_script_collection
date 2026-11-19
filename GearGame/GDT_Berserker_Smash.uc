/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_Berserker_Smash extends GearDamageType;

static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return TRUE;
}

defaultproperties
{
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=69,V=349,UL=77,VL=29)
}
