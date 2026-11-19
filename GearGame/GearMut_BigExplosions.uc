/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_BigExplosions extends GearMutator
	config(Game);

var config float ExplosionScale;

function bool CheckReplacement(Actor Other)
{
	if (Other.IsA('GearGRI'))
	{
		GearGRI(Other).GlobalExplosionScale = ExplosionScale;
	}

	return true;
}

function NetDamage(int OriginalDamage, out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
	// negate explosion self damage
	if (ClassIsChildOf(DamageType, class'GDT_Explosive') && Injured.Controller == InstigatedBy)
	{
		Damage = 0;
	}

	Super.NetDamage(OriginalDamage, Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}
