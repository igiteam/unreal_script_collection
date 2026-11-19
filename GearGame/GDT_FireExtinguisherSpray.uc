/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_FireExtinguisherSpray extends GDT_Environment
	dependson(GearSoundGroup);

/**
 * Zero out any damage done to pawns
 *
 * @param Victim - the pawn damaged by us
 *
 * @param InstigatedBy - the controller that caused the damage
 *
 * @param Damage - the damage amount to cause
 *
 * @param HitInfo - misc info about the damage incident
 *
 * @param HitLocation - where the damage occurred
 *
 * @param Momentum - how much momentum the damage is imparting to the victim
 */
static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int Damage, const out TraceHitInfo HitInfo, vector HitLocation, vector Momentum, Actor DamageCauser)
{
	Damage = 0;
	// AI teammates cringe briefly (non-blocking)
	if (GearAI(Victim.Controller) != None && GearPawn(Victim) != None)
	{
		GearPawn(Victim).PlayHeadCoverAnim(1.0, false);
	}
}

defaultproperties
{
	KillGUDEvent=GUDEvent_KilledEnemyFlamethrower
	bPlayDamagedEnemyHeavyGUD=TRUE
	bSuppressImpactFX=TRUE
	bSuppressBloodDecals=TRUE
	bEnvironmentalDamage=FALSE
	ImpactTypeBallisticID=ITB_Scorcher
	WeaponID=WC_Scorcher
	KilledByIcon=(Texture=Texture2D'Warfare_HUD.Gears3_WeaponIcons',U=144,V=378,UL=142,VL=44)
}

