/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_GunkerStabCover extends GDT_Melee;


/** Overridden to add a special blood effect to the victim */
static function HandleDamageFX(GearPawn DamagedPawn, const out TakeHitInfo HitInfo)
{
	DamagedPawn.WorldInfo.MyEmitterPool.SpawnEmitter(DamagedPawn.PS_GiantBladeFromAboveDamageEffect, HitInfo.HitLocation, Rotator(HitInfo.HitLocation - DamagedPawn.Location), DamagedPawn);

	Super.HandleDamageFX(DamagedPawn, HitInfo);
}

defaultproperties
{
}
