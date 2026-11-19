/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_GunkerStab extends GDT_Melee;


/** Overridden to add a special blood effect to the victim */
static function HandleDamageFX(GearPawn DamagedPawn, const out TakeHitInfo HitInfo)
{
	DamagedPawn.WorldInfo.MyEmitterPool.SpawnEmitter(DamagedPawn.PS_GiantBladeDamageEffect, HitInfo.HitLocation, Rotator(HitInfo.HitLocation - DamagedPawn.Location), DamagedPawn);

	Super.HandleDamageFX(DamagedPawn, HitInfo);
}

/** Should the Pawn explode into chunky bits when killed with this damage type? */
static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return TRUE;
}

/** Made player go DBNO instead of gib on lower difficulties */
static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation,TraceHitInfo HitInfo)
{
	if (GearPRI(TestPawn.PlayerReplicationInfo).Difficulty.default.bCanDBNO)
	{
		// If player can go DBNO from difficulty then don't gib them
		return TRUE;
	}
	return Super.ShouldDBNO(TestPawn,Instigator,HitLocation,HitInfo);
}

defaultproperties
{
}
