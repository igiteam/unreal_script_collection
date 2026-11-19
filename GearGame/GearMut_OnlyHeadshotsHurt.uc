/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_OnlyHeadshotsHurt extends GearMutator;

function ModifyPlayer(Pawn Other)
{
	Super.ModifyPlayer(Other);

	if (GearPawn(Other) != None && Other.GetTeamNum() == 1)
	{
		GearPawn(Other).bImmuneToSpecialMeleeAttacks = true;
	}
}

function NetDamage(int OriginalDamage, out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
	local GearPawn GP;

	if (Injured.GetTeamNum() == 1)
	{
		GP = GearPawn(Injured);
		if (GP != None && !GP.bLastHitWasHeadShot && GP.HeadBoneNames.length > 0)
		{
			Damage = 0;
		}
	}

	Super.NetDamage(OriginalDamage, Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}
