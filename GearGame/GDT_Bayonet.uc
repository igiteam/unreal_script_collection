/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_Bayonet extends GDT_Melee;

static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return FALSE;
}

static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation,TraceHitInfo HitInfo)
{
	return FALSE;
}

defaultproperties
{
	KillGUDEvent=GUDEvent_KilledEnemyChainsaw
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.HUD.Gears_DeathIcons',U=392,V=60,UL=77,VL=29)
	WeaponID=WC_RetroLancer
	KDamageImpulse=0
	KDeathUpKick=0
	RadialDamageImpulse=0
	bForceRagdollDeath=TRUE
	bExtraMomentumZ=FALSE			// Add extra Z to momentum on walking pawns to throw them up into the air
}
