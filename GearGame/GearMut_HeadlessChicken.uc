/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMut_HeadlessChicken extends GearMutator
	config(Game);

/** amount of time headshot enemies run around headless before dying */
var config float HeadlessTime;

function NetDamage(int OriginalDamage, out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
	local GearPawn GP;
	local GearAI AI;
	local class<GearDamageType> GearDamage;

	if (Injured.GetTeamNum() == 1)
	{
		GP = GearPawn(Injured);
		if (GP != None && GP.bLastHitWasHeadShot && GP.bCanPlayHeadshotDeath && !GP.bHasPlayedHeadShotDeath && GP.Health < Damage && !GP.IsDBNO())
		{
			GearDamage = class<GearDamageType>(DamageType);
			if (GearDamage != None && GearDamage.default.bAllowHeadShotGib)
			{
				GP.bCanDBNO = false;
				GP.bForceHeadShotGib = true;
				GP.PlayHeadShotDeath();
				GP.SetTimer(HeadlessTime, false, nameof(GP.Suicide));

				AI = GearAI(GP.Controller);
				if (AI != None)
				{
					AI.BanzaiAttack();
				}

				// count as damage credit even though it will be negated to make the enemy continue on headless
				if (InstigatedBy != None && InstigatedBy.PlayerReplicationInfo != GP.PlayerReplicationInfo)
				{
					GearPRI(GP.PlayerReplicationInfo).AddPlayerDamage(GearPRI(InstigatedBy.PlayerReplicationInfo), GP.Health, class<GearDamageType>(DamageType));
				}

				Damage = 0;
			}
		}
	}

	Super.NetDamage(OriginalDamage, Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}
