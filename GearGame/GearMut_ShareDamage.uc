/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_ShareDamage extends GearMutator;

var bool bSharingDamage;

function NetDamage(int OriginalDamage, out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
	local GearPawn GP, OtherGP;
	local GearPC PC;
	local GearAI AI;
	local GearSquad Squad;
	local int i;

	if (!bSharingDamage && Damage > 0 && Injured.GetTeamNum() == 0)
	{
		GP = GearPawn(Injured);
		if (GP != None && GP.bCanRechargeHealth)
		{
			PC = GearPC(GP.Controller);
			if (PC != None)
			{
				Squad = PC.Squad;
			}
			else
			{
				AI = GearAI(GP.Controller);
				if (AI != None)
				{
					Squad = AI.Squad;
				}
			}

			if (Squad != None)
			{
				bSharingDamage = true;

				// make sure no invalid entries distort the damage values
				for (i = 0; i < Squad.SquadMembers.length; i++)
				{
					if (Squad.SquadMembers[i].Member == None)
					{
						Squad.SquadMembers.Remove(i, 1);
						i--;
					}
				}
				// need to take cover, etc into account first
				GP.AdjustPawnDamage(Damage, InstigatedBy.Pawn, HitLocation, Momentum, class<GearDamageType>(DamageType), DamageCauser);

				Damage /= Squad.SquadMembers.length;
				for (i = 0; i < Squad.SquadMembers.length; i++)
				{
					if (Squad.SquadMembers[i].Member.Pawn != None && Squad.SquadMembers[i].Member.Pawn != Injured)
					{
						OtherGP = GearPawn(Squad.SquadMembers[i].Member.Pawn);
						if (OtherGP != None)
						{
							OtherGP.SetDontModifyDamage(true);
						}
						Squad.SquadMembers[i].Member.Pawn.TakeDamage(Damage, InstigatedBy, Squad.SquadMembers[i].Member.Pawn.Location, Momentum, DamageType,, DamageCauser);
						if (OtherGP != None)
						{
							OtherGP.SetDontModifyDamage(false);
						}
					}
				}

				bSharingDamage = false;

				Damage = OriginalDamage / Squad.SquadMembers.length;
			}
		}
	}

	Super.NetDamage(OriginalDamage, Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}
