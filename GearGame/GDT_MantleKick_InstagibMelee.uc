/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GDT_MantleKick_InstagibMelee extends GDT_Melee
	abstract;

static function bool ShouldGib(Pawn TestPawn, Pawn Instigator)
{
	return true;
}

static function bool ShouldDBNO(Pawn TestPawn, Pawn Instigator, vector HitLocation, TraceHitInfo HitInfo)
{
	return false;
}

static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int Damage, const out TraceHitInfo HitInfo, vector HitLocation, vector Momentum, Actor DamageCauser)
{
	if (InstigatedBy != None && InstigatedBy.IsPlayerOwned())
	{
		Damage = Max(Damage, Victim.Health);
	}
	Super.ModifyDamage(Victim, InstigatedBy, Damage, HitInfo, HitLocation, Momentum, DamageCauser);
}

