/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_MustDrainHealth extends GearMutator;

/** multiplier to damage that is given as health */
var config float HealMult;

function bool AllowHealthRecharge(bool bGameResult, GearPawn Pawn)
{
	if (Pawn.GetTeamNum() == 0 && Pawn.IsHumanControlled())
	{
		bGameResult = false;
	}
	return Super.AllowHealthRecharge(bGameResult, Pawn);
}

function NetDamage(int OriginalDamage, out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
	if (PlayerController(InstigatedBy) != None && InstigatedBy.GetTeamNum() == 0)
	{
		if (Turret(InstigatedBy.Pawn) != None)
		{
			Turret(InstigatedBy.Pawn).Driver.HealDamage(Damage * HealMult, InstigatedBy, DamageType);
		}
		else if (GearPawn(InstigatedBy.Pawn) != None)
		{
			InstigatedBy.Pawn.HealDamage(Damage * HealMult, InstigatedBy, DamageType);
		}
	}

	Super.NetDamage(OriginalDamage, Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}

function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	local bool bResult;
	local GearPawn GP;

	bResult = Super.PreventDeath(Killed, Killer, DamageType, HitLocation);
	if (!bResult && Killer != None && (DamageType == class'GDT_Bayonet' || DamageType == class'GDT_Chainsaw' || ClassIsChildOf(DamageType, class'GDT_Execution_Base')))
	{
		GP = GearPawn(Killer.Pawn);
		if (GP != None)
		{
			GP.HealDamage(GP.HealthMax, Killer, DamageType);
		}
	}

	return bResult;
}
