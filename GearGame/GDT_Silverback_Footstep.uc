
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GDT_Silverback_Footstep extends GDT_Melee;

/** Only damage small enemies */
static function ModifyDamage(Pawn Victim, Controller InstigatedBy, out int Damage, const out TraceHitInfo HitInfo, vector HitLocation, vector Momentum, Actor DamageCauser)
{
	if (GearPawn_LambentPolypBase(Victim) == None)
	{
		Damage = 0;
	}
	else
	{
		Super.ModifyDamage(Victim, InstigatedBy, Damage, HitInfo, HitLocation, Momentum, DamageCauser);
	}
}

defaultproperties
{
}
