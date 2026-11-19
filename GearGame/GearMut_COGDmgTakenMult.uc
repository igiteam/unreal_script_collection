/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearMut_COGDmgTakenMult extends GearHordeExtendedMutator;

function NetDamage(int OriginalDamage, out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
	Super.NetDamage(OriginalDamage, Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);

	if (Injured.GetTeamNum() == 0)
	{
		Damage *= Multiplier;
	}
}

defaultproperties
{
	MutatorIcon=Texture2D'Warfare_HUD.Horde_Damage'
}
